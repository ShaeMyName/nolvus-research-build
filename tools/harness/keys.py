"""Real keystrokes into the game window (TASK_C D4: keystrokes allowed for tests). Used for the F5 quicksave cell of
the REVIEW_LOG R29 save test: the real-play save route. Scancodes, because Skyrim reads DirectInput."""
import ctypes, time
from ctypes import wintypes

user32 = ctypes.WinDLL("user32", use_last_error=True)
KEYEVENTF_SCANCODE, KEYEVENTF_KEYUP = 0x0008, 0x0002
SCAN = {"F5": 0x3F, "F9": 0x43, "ESC": 0x01, "ENTER": 0x1C}


def _game_hwnd():
    found = []

    @ctypes.WINFUNCTYPE(wintypes.BOOL, wintypes.HWND, wintypes.LPARAM)
    def cb(h, _):
        n = user32.GetWindowTextLengthW(h)
        if n:
            buf = ctypes.create_unicode_buffer(n + 1)
            user32.GetWindowTextW(h, buf, n + 1)
            if buf.value.strip() == "Skyrim Special Edition" and user32.IsWindowVisible(h):
                found.append(h)
        return True
    user32.EnumWindows(cb, 0)
    return found[0] if found else None


def focus_game():
    h = _game_hwnd()
    if not h:
        return False
    user32.ShowWindow(h, 9)            # SW_RESTORE
    user32.SetForegroundWindow(h)
    time.sleep(1.0)
    return user32.GetForegroundWindow() == h


def press(key, hold=0.08):
    sc = SCAN[key]
    user32.keybd_event(0, sc, KEYEVENTF_SCANCODE, 0)
    time.sleep(hold)
    user32.keybd_event(0, sc, KEYEVENTF_SCANCODE | KEYEVENTF_KEYUP, 0)


def quicksave(log=print):
    if not focus_game():
        log("KEYS: could not focus the game window; F5 not sent")
        return False
    press("F5")
    log("KEYS: F5 sent")
    return True
