"""Shae 2026-10-10: "Yes: switch 'meta' to Flash on the actions key, from the next block, test setup only."
Edits ONLY the meta variant of OpenRouter.yaml in "SkyrimNet Config - Test" (the test profile's config mod):
model_name -> deepseek/deepseek-v4-flash-0731, its model_params provider_id -> openrouter-actions. Byte-safe (CRLF kept),
backup first, game and MO2 must be closed. Never prints file contents (the file holds key fields).
Usage: meta_flash.py [--check]   (--check: report the meta variant's model/provider only, no write)"""
import os, re, shutil, sys, time

sys.path.insert(0, os.path.dirname(__file__))
import game

YAML = os.path.dirname(game.HARNESS_YAML) + "/OpenRouter.yaml"
BACKUP = "C:/nolvus-research/backups/OpenRouter.yaml.pre_meta_flash_%s" % time.strftime("%Y%m%d-%H%M%S")
FLASH, PRO = b"deepseek/deepseek-v4-flash-0731", b"deepseek/deepseek-v4-pro-0813"
META = re.compile(rb"(\r\n    meta:\r\n      model_name: )(\S+)(\r\n(?:        .*\r\n|      default_params:\r\n|      model_params:\r\n)*?"
                  rb"        - provider_id: )(\S+)(\r\n)")


def state(b):
    m = META.search(b)
    return None if m is None else (m.group(2).decode(), m.group(4).decode())


def main(check):
    b = open(YAML, "rb").read()
    if len(META.findall(b)) != 1:
        print("meta variant not found exactly once; no change")
        return 1
    print("meta now: model=%s provider=%s" % state(b))
    if check:
        return 0
    if game.procs():
        print("refused: %s running" % sorted(game.procs()))
        return 1
    m = META.search(b)
    if m.group(2) not in (PRO, FLASH):
        print("unexpected meta model; no change")
        return 1
    os.makedirs(os.path.dirname(BACKUP), exist_ok=True)
    shutil.copy2(YAML, BACKUP)
    b2 = b[:m.start()] + m.group(1) + FLASH + m.group(3) + b"openrouter-actions" + m.group(5) + b[m.end():]
    diff = [i for i in range(min(len(b), len(b2))) if b[i] != b2[i]]
    open(YAML, "wb").write(b2)
    after = state(open(YAML, "rb").read())
    print("backup %s; meta now: model=%s provider=%s; bytes %d -> %d; CRLF %d -> %d"
          % (BACKUP, *(after or ("?", "?")), len(b), len(b2), b.count(b"\r\n"), b2.count(b"\r\n")))
    if after != (FLASH.decode(), "openrouter-actions"):      # RV-123 (3): read-back assert
        print("READ-BACK FAILED: meta is %s; restore from %s" % (after, BACKUP))
        return 1
    return 0


if __name__ == "__main__":
    sys.exit(main("--check" in sys.argv))
