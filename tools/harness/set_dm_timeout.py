"""REVIEW_LOG RV-108-dec (Shae 2026-10-11: "yes, 60 seconds is fine"): give the intel_story_dm variant its own
'timeout: 60' in the TEST config's OpenRouter.yaml (it inherited the global 30 s; observed DM latency p95 ~46 s).
Game and MO2 closed; backup first; byte-safe (line endings kept); only the one line is added (after model_name, the
position gamemaster_evaluation uses); asserted by re-reading; logged. Never prints or reads key lines.
Usage: set_dm_timeout.py [seconds=60]"""
import os, re, shutil, subprocess, sys, time

CFG = ("C:/Nolvus/Instances/Nolvus Awakening/MODS/mods/SkyrimNet Config - Test/SKSE/Plugins/SkyrimNet/config/"
       "OpenRouter.yaml")
BACKUP = "C:/nolvus-research/backups/OpenRouter.yaml.pre_dm_timeout_%s" % time.strftime("%Y%m%d-%H%M%S")


def dm_timeout(text):
    """The timeout value inside the intel_story_dm block, or None (structure lines only)."""
    m = re.search(r"\n    intel_story_dm:\r?\n((?:      .*\r?\n)+)", text)
    if not m:
        return "missing-variant"
    t = re.search(r"^      timeout:\s*(\d+)", m.group(1), re.M)
    return int(t.group(1)) if t else None


def main():
    secs = int(sys.argv[1]) if len(sys.argv) > 1 else 60
    out = subprocess.run(["tasklist"], capture_output=True, text=True).stdout.lower()
    if "skyrimse.exe" in out or "modorganizer.exe" in out:
        sys.exit("ABORT: game or MO2 running")
    raw = open(CFG, "rb").read()
    text = raw.decode("utf-8")
    nl = "\r\n" if "\r\n" in text else "\n"
    cur = dm_timeout(text)
    if cur == secs:
        print("DM TIMEOUT already %d s (no change)" % secs)
        return
    if cur == "missing-variant":
        sys.exit("ABORT: intel_story_dm variant not found")
    shutil.copyfile(CFG, BACKUP)
    if cur is None:
        a = "    intel_story_dm:" + nl
        i = text.index(a) + len(a)
        j = text.index(nl, i) + len(nl)                  # after the variant's first line (model_name)
        text = text[:j] + "      timeout: %d" % secs + nl + text[j:]
    else:
        text = re.sub(r"(\n    intel_story_dm:\r?\n(?:      .*\r?\n)*?      timeout:\s*)\d+", r"\g<1>%d" % secs, text, 1)
    open(CFG, "wb").write(text.encode("utf-8"))
    after = dm_timeout(open(CFG, "rb").read().decode("utf-8"))
    if after != secs:
        shutil.copyfile(BACKUP, CFG)
        sys.exit("ABORT: read-back gave %s; backup restored" % after)
    print("DM TIMEOUT intel_story_dm: %s -> %d s (backup %s)" % ("inherited 30" if cur is None else cur, secs, BACKUP))


if __name__ == "__main__":
    main()
