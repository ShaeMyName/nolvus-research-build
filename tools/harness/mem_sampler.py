"""REVIEW_LOG RV-73 (3): memory sampler, every 30 s, one line per sample, flushed and fsynced so it survives a crash.
Logs Available, commit (used/limit, %), paged/nonpaged pool, SkyrimSE private bytes + handle count, and the top 5
processes by private bytes. Started detached by game.launch (one per machine session); stop it with taskkill.
Output: C:/nolvus-research/test_runs/mem_sampler.log"""
import os, subprocess, time

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


def stop_game(f, why):
    """Close the game cleanly (console qqq through SkyrimNet MCP), force it after 90 s, block every further launch."""
    open(FLAG, "w").write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), why))
    log(f, "POOLGATE TRIPPED: %s; closing the game, launches blocked (%s)" % (why, FLAG))
    try:
        import sys
        sys.path.insert(0, os.path.dirname(__file__))
        from mcp_client import MCP
        MCP().request("tools/call", {"name": "execute_console_command", "arguments": {"command": "qqq"}}, timeout=10)
    except Exception as e:
        log(f, "POOLGATE: qqq failed: %s" % e)
    t0 = time.time()
    while time.time() - t0 < 90 and "SkyrimSE.exe" in subprocess.run(["tasklist"], capture_output=True, text=True).stdout:
        time.sleep(3)
    if "SkyrimSE.exe" in subprocess.run(["tasklist"], capture_output=True, text=True).stdout:
        subprocess.run(["taskkill", "/F", "/IM", "SkyrimSE.exe"], capture_output=True)
        log(f, "POOLGATE: SkyrimSE force-killed after 90 s")
    else:
        log(f, "POOLGATE: game closed cleanly")


def log(f, line):
    f.write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), line))
    f.flush()
    os.fsync(f.fileno())


def main():
    with open(OUT, "a", encoding="utf-8") as f:
        log(f, "SAMPLER START pid=%d" % os.getpid())
        base, peak, ingame = None, 0.0, False
        while True:
            try:
                line = subprocess.run(["powershell", "-NoProfile", "-Command", PS], capture_output=True, text=True,
                                      timeout=25).stdout.strip().replace("\n", " ")
            except Exception as e:
                line = "sample failed: %s" % e
            log(f, line)
            try:
                np_ = float(line.split("nonpaged=")[1].split("MB")[0].replace(",", ""))
                game = " game=-" not in line
            except Exception:
                np_, game = None, False
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
            time.sleep(30)


if __name__ == "__main__":
    main()
