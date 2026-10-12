"""REVIEW_LOG RV-73 (3): memory sampler, every 30 s, one line per sample, flushed and fsynced so it survives a crash.
Logs Available, commit (used/limit, %), paged/nonpaged pool, SkyrimSE private bytes + handle count, and the top 5
processes by private bytes and by handles. POOLGATE (RV-73-upd, RV-73-upd2) closes the game and blocks launches on
pool growth or commit > 85 %. Started detached by game.launch (one per machine session); stop it with taskkill.
Output: C:/nolvus-research/test_runs/mem_sampler.log"""
import os, subprocess, time
NOWIN = subprocess.CREATE_NO_WINDOW   # no console flash every sample (Shae 2026-10-11)

OUT = "C:/nolvus-research/test_runs/mem_sampler.log"
PS = r"""
$o=Get-CimInstance Win32_OperatingSystem
$m=Get-CimInstance Win32_PerfFormattedData_PerfOS_Memory
$g=Get-Process SkyrimSE -ErrorAction SilentlyContinue | Select-Object -First 1
$top=(Get-Process | Sort-Object PrivateMemorySize64 -Descending | Select-Object -First 5 | ForEach-Object { '{0}:{1:N1}' -f $_.ProcessName, ($_.PrivateMemorySize64/1GB) }) -join ' '
$th=(Get-Process | Sort-Object HandleCount -Descending | Select-Object -First 5 | ForEach-Object { '{0}:{1}' -f $_.ProcessName, $_.HandleCount }) -join ' '
$gp= if ($g) { '{0:N1}GB h={1}' -f ($g.PrivateMemorySize64/1GB), $g.HandleCount } else { '-' }
'avail={0:N1}GB commit={1:N1}/{2:N1}GB({3}%) paged={4:N0}MB nonpaged={5:N0}MB game={6} top={7} handles={8}' -f ($m.AvailableMBytes/1024), (($o.TotalVirtualMemorySize-$o.FreeVirtualMemory)/1MB), ($o.TotalVirtualMemorySize/1MB), [int](100*($o.TotalVirtualMemorySize-$o.FreeVirtualMemory)/$o.TotalVirtualMemorySize), ($m.PoolPagedBytes/1MB), ($m.PoolNonpagedBytes/1MB), $gp, $top, $th
"""


FLAG = "C:/nolvus-research/test_runs/POOLGATE_TRIPPED"
GROW_MB, CEIL_MB = 800.0, 3072.0             # REVIEW_LOG RV-73: stop on +800 MB over the pre-launch value or > 3 GB
COMMIT_TRIP_PCT = 85.0                       # REVIEW_LOG RV-73-upd2 (2): stop on system commit > 85 % of the limit


AVAIL_TRIP_GB = 1.5          # REVIEW_LOG RV-102 (1): physical memory ran out ~60 s before commit tripped (08:46:13)
_LOW = [0]


def avail_gb():
    try:
        import sys
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
        import champ_guard
        return champ_guard.avail_gb()
    except Exception:
        return None


def avail_check(f):
    """Every 5 s: available physical memory < AVAIL_TRIP_GB on 2 consecutive checks kills our build tools, then closes
    the game (if it runs) and blocks launches."""
    a = avail_gb()
    if a is None:
        return
    if a < AVAIL_TRIP_GB:
        _LOW[0] += 1
        if _LOW[0] == 2:
            log(f, "AVAILABLE TRIP: %.2f GB < %.1f GB on 2 consecutive checks" % (a, AVAIL_TRIP_GB))
            kill_runaway_tools(f)
            game_up = "SkyrimSE.exe" in subprocess.run(["tasklist"], capture_output=True, creationflags=NOWIN, text=True).stdout
            if game_up and not os.path.exists(FLAG):
                stop_game(f, "available %.2f GB < %.1f GB" % (a, AVAIL_TRIP_GB))
    else:
        _LOW[0] = 0


RUNAWAY_TOOLS = ("Champollion.exe", "Caprica.exe", "PapyrusCompiler.exe")   # our build tools only; never anything else
RUNAWAY_MB = 3072


def kill_runaway_tools(f):
    """2026-10-11 08:46-08:48: Champollion grew to 45 GB in ~90 s and Windows bugchecked. Every 5 s: any of OUR build
    tools above RUNAWAY_MB working set is force-killed (champ_guard's job cap is the first line; this is the second)."""
    for exe in RUNAWAY_TOOLS:
        try:
            out = subprocess.run(["tasklist", "/FI", "IMAGENAME eq %s" % exe, "/FO", "CSV", "/NH"], capture_output=True,
                                 creationflags=NOWIN, text=True, timeout=10).stdout
        except Exception:
            continue
        for line in out.splitlines():
            parts = [x.strip('"') for x in line.split('","')]
            if len(parts) >= 5 and parts[0].lower() == exe.lower():
                try:
                    mb = int(parts[4].replace(",", "").replace(".", "").split()[0]) // 1024
                except ValueError:
                    continue
                if mb > RUNAWAY_MB:
                    subprocess.run(["taskkill", "/F", "/PID", parts[1]], capture_output=True, creationflags=NOWIN)
                    log(f, "RUNAWAY TOOL KILLED: %s pid %s at %d MB (> %d MB)" % (exe, parts[1], mb, RUNAWAY_MB))


def stop_game(f, why):
    """Close the game cleanly (console qqq through SkyrimNet MCP), force it after 90 s, block every further launch."""
    open(FLAG, "w").write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), why))
    log(f, "POOLGATE TRIPPED: %s; closing the game, launches blocked (%s)" % (why, FLAG))
    kill_runaway_tools(f)                    # a runaway tool of ours is the faster fix than the game
    try:
        import sys
        # 2026-10-11 08:47 bug: mcp_client lives in build/tools, one level up (the import failed and the game stayed up)
        sys.path.insert(0, os.path.join(os.path.dirname(os.path.abspath(__file__)), ".."))
        from mcp_client import MCP
        MCP().request("tools/call", {"name": "execute_console_command", "arguments": {"command": "qqq"}}, timeout=10)
    except Exception as e:
        log(f, "POOLGATE: qqq failed: %s" % e)
    t0 = time.time()
    while time.time() - t0 < 90 and "SkyrimSE.exe" in subprocess.run(["tasklist"], capture_output=True, creationflags=NOWIN, text=True).stdout:
        time.sleep(3)
    if "SkyrimSE.exe" in subprocess.run(["tasklist"], capture_output=True, creationflags=NOWIN, text=True).stdout:
        subprocess.run(["taskkill", "/F", "/IM", "SkyrimSE.exe"], capture_output=True, creationflags=NOWIN)
        log(f, "POOLGATE: SkyrimSE force-killed after 90 s")
    else:
        log(f, "POOLGATE: game closed cleanly")


def log(f, line):
    f.write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), line))
    f.flush()
    os.fsync(f.fileno())


HEARTBEAT = "C:/nolvus-research/test_runs/mem_sampler.hb"


def beat():
    """REVIEW_LOG RV-180 (2): a heartbeat every 5 s; launches and blocks refuse or HALT when it is older than 30 s."""
    try:
        with open(HEARTBEAT, "w") as h:
            h.write("%d %s\n" % (os.getpid(), time.strftime("%Y-%m-%d %H:%M:%S")))
    except OSError:
        pass


LOG_CAP = 5 * 2 ** 20      # REVIEW_LOG RV-213: the sampler's own log is capped (one rotated copy, ~10 MB at most)


def main():
    if os.path.exists(OUT) and os.path.getsize(OUT) > LOG_CAP:
        os.replace(OUT, OUT + ".1")
    with open(OUT, "a", encoding="utf-8") as f:
        log(f, "SAMPLER START pid=%d" % os.getpid())
        base, peak, ingame = None, 0.0, False
        while True:
            try:
                line = subprocess.run(["powershell", "-NoProfile", "-Command", PS], capture_output=True, creationflags=NOWIN, text=True,
                                      timeout=25).stdout.strip().replace("\n", " ")
            except Exception as e:
                line = "sample failed: %s" % e
            log(f, line)
            try:
                np_ = float(line.split("nonpaged=")[1].split("MB")[0].replace(",", ""))
                game = " game=-" not in line
                cpct = float(line.split("GB(")[1].split("%")[0])
            except Exception:
                np_, game, cpct = None, False, None
            # REVIEW_LOG RV-73-upd2 (2): commit pressure trips too (the 1450 errors may have been commit, not pool)
            if game and cpct is not None and cpct > COMMIT_TRIP_PCT and not os.path.exists(FLAG):
                stop_game(f, "commit %d%% of the limit (> %d%%)" % (cpct, COMMIT_TRIP_PCT))
            if np_ is not None:
                if not game:
                    if ingame:
                        log(f, "POOL session end: before %d MB, peak %d MB, after close %d MB" % (base, peak, np_))
                    base, peak, ingame = np_, np_, False
                else:
                    if not ingame:
                        ingame, peak = True, np_
                        log(f, "POOL session start: before launch %d MB" % (base if base is not None else -1))
                    peak = max(peak, np_)
                    if base is not None and not os.path.exists(FLAG) and (np_ > base + GROW_MB or np_ > CEIL_MB):
                        stop_game(f, "nonpaged %d MB (pre-launch %d MB, limit +%d / %d MB)" % (np_, base, GROW_MB, CEIL_MB))
            for _ in range(6):                   # the runaway-tool + available checks every 5 s between samples
                kill_runaway_tools(f)
                avail_check(f)
                beat()
                time.sleep(5)


if __name__ == "__main__":
    main()
