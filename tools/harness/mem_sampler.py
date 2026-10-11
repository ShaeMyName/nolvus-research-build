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


def main():
    with open(OUT, "a", encoding="utf-8") as f:
        f.write("%s SAMPLER START pid=%d\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), os.getpid()))
        f.flush()
        os.fsync(f.fileno())
        while True:
            try:
                line = subprocess.run(["powershell", "-NoProfile", "-Command", PS], capture_output=True, text=True,
                                      timeout=25).stdout.strip().replace("\n", " ")
            except Exception as e:
                line = "sample failed: %s" % e
            f.write("%s %s\n" % (time.strftime("%Y-%m-%d %H:%M:%S"), line))
            f.flush()
            os.fsync(f.fileno())
            time.sleep(30)


if __name__ == "__main__":
    main()
