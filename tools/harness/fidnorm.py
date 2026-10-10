"""The one FormID normaliser for host-side log parsers (REVIEW_LOG R48, 2026-10-10). No dependencies: imported by
runner.py (re-exported there), tests_*.py, burst_b22.py and selftest.py.

Printed forms of one FormID seen in our logs (investigation/round10/formid_normalise.md):
  hex, 0x-prefixed, no leading zeros, upper case    PO3_SKSEFunctions.IntToString(id, True) / IEB_Watcher.Hex():
                                                    "0xE1BA9", "0xFE499A4B" (VERIFIED Papyrus.0.log 2026-10-10:
                                                    "UUID 0xE1BA9 Jenassa", "CampMember 0xFE499A4B ...": a negative
                                                    Papyrus Int prints as its unsigned bits, not "-0x...")
  hex, zero-padded to 8, no prefix                  SeverActions DLL "{:08X}" ("000E1BA9", "FE499A4B")
  signed decimal                                    a Papyrus Int concatenated into a string ("... " + a.GetFormID()):
                                                    0xFE499A4B -> "-28730805"
  unsigned decimal                                  JSON / C++ uint32 ("4266236491")
fid_norm() maps any of these (or an int, signed or not) to 0..0xFFFFFFFF; fid_any_rx() builds a regex fragment that
matches one FormID in every form, as a whole token.
"""
import re

_HEX_TOKEN = re.compile(r"^(?:0[xX])?[0-9A-Fa-f]{1,8}$")
_DEC_TOKEN = re.compile(r"^[-+]?\d{1,10}$")


def fid_norm(v, base=None):
    """FormID -> int in 0..0xFFFFFFFF, or None if v is not a FormID.

    int: masked to 32 bits (negative Papyrus Ints included). str: stripped, then
      '0x...'                        -> hex
      '-123' / '+123'                -> signed decimal
      contains A-F                   -> hex ('FE499A4B', 'e1ba9')
      zero-padded ('000E1BA9', '00091918', any length > 1 with a leading 0) -> hex (SA {:08X}; Papyrus never pads
                                        decimals)
      other digits only              -> decimal ('4266236491', '924585')
    base=16 forces hex for prefix-less digit strings (callers that know the field is hex, e.g. a CLI 'child=1A66B')."""
    if isinstance(v, bool) or v is None:
        return None
    if isinstance(v, int):
        return v & 0xFFFFFFFF
    s = str(v).strip()
    if not s:
        return None
    try:
        if s[:2].lower() == "0x":
            n = int(s[2:], 16) if _HEX_TOKEN.match(s) else None
        elif base == 16:
            n = int(s, 16) if _HEX_TOKEN.match(s) else None
        elif s[0] in "+-":
            n = int(s, 10) if _DEC_TOKEN.match(s) else None
        elif re.search(r"[A-Fa-f]", s) or (len(s) > 1 and s[0] == "0"):
            n = int(s, 16) if _HEX_TOKEN.match(s) else None
        else:
            n = int(s, 10) if _DEC_TOKEN.match(s) else None
    except ValueError:
        return None
    if n is None or n < -(1 << 31) or n > 0xFFFFFFFF:
        return None
    return n & 0xFFFFFFFF


def fid_s32(v):
    """FormID -> signed 32-bit Int (what a Papyrus Int argument needs)."""
    n = fid_norm(v)
    return None if n is None else (n - (1 << 32) if n >= (1 << 31) else n)


def fid_hex8(v):
    """'%08X' of the normalised id ('FE499A4B', '000E1BA9'): console commands, report text."""
    return "%08X" % fid_norm(v)


# Decimal forms are only matched when they cannot be an ordinary small number in the same line (dPlayer=20 must not
# match the player 0x14): an unsigned decimal needs >= 6 digits (watcher coordinates and distances stay below
# 1,000,000 units: the worldspace is about +-262,144), a signed one only exists for ids >= 0x80000000.
_DEC_MIN_LEN = 6


def fid_any_rx(v):
    """Regex fragment (no capture groups, case-insensitive for hex) matching FormID v as a whole token in any printed
    form: 0x-hex with or without leading zeros, bare hex zero-padded or containing a letter, unsigned decimal (>= 6
    digits), signed decimal (ids >= 0x80000000). A token boundary is any character outside [0-9A-Za-z_] (and, for
    decimals, outside '.', '-', '+')."""
    n = fid_norm(v)
    if n is None:
        raise ValueError("fid_any_rx: not a FormID: %r" % (v,))
    h = "%X" % n
    hexci = "".join("[%s%s]" % (c, c.lower()) if c.isalpha() else c for c in h)
    alts = [r"0[xX]0*" + hexci]
    if re.search(r"[A-F]", h):
        alts.append("0*" + hexci)               # bare hex: unambiguous (has a letter)
    else:
        alts.append("0{%d}" % (8 - len(h)) + h if len(h) < 8 else h)   # bare all-digit hex only in the padded {:08X} form
    hexpart = r"(?<![0-9A-Za-z_])(?:%s)(?![0-9A-Za-z_])" % "|".join(alts)
    decs = []
    if len(str(n)) >= _DEC_MIN_LEN:
        decs.append(str(n))
    if n >= (1 << 31):
        decs.append(re.escape(str(n - (1 << 32))))
    if not decs:
        return "(?:%s)" % hexpart
    decpart = r"(?<![0-9A-Za-z_.+-])(?:%s)(?![0-9A-Za-z_.])" % "|".join(decs)
    return "(?:%s|%s)" % (hexpart, decpart)
