#!/usr/bin/env python3

import re

DB = "/usr/share/arp-scan/ieee-oui.txt"

def vendor(mac):
    prefix = re.sub(r"[^0-9A-Fa-f]", "", mac)[:6].upper()

    with open(DB, errors="ignore") as f:
        for line in f:
            if line.upper().startswith(prefix):
                return line.split(None, 1)[1].strip()

    return "Unknown"

with open("macs.txt") as f:
    for mac in f:
        mac = mac.strip()
        if mac:
            print(f"{mac} -> {vendor(mac)}")
