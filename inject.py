#!/usr/bin/env python3
NULL_CHAR = chr(0)

def write_report(report):
    with open('/dev/hidg0', 'rb+') as fd:
        fd.write(report.encode())

def send_ch(ch):
    lower = ch.islower()
    diff = ord(ch.lower())-ord('a')
    if lower:
        write_report(NULL_CHAR*2+chr(4+diff)+NULL_CHAR*5)
    else:
        write_report(chr(32)+NULL_CHAR+chr(4+diff)+NULL_CHAR*5)
    write_report(NULL_CHAR*8)

def send_string(s):
    for ch in s:
        send_ch(ch)

send_string("hello")

# Press SPACE key
write_report(NULL_CHAR*2+chr(44)+NULL_CHAR*5)

# Press RETURN/ENTER key
write_report(NULL_CHAR*2+chr(40)+NULL_CHAR*5)

# Release all keys
write_report(NULL_CHAR*8)
