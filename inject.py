#!/usr/bin/env python3

# References:
# https://stackoverflow.com/questions/49887540/improve-python-code
# Nerd guides on RPi gadget mode as a keyboard


import string, ascii
from codes import codes

NULL_CHAR = chr(0)

# write bytes to enabled gadget mode interface 
def write_report(report):
    with open('/dev/hidg0', 'rb+') as fd:
        fd.write(report.encode())

# Send key press and release for each character to simulate typing
def send_string(s):
    for ch in s:
        write_report(codes[ch])
        write_report(NULL_CHAR*8) #Release key
    
send_string("username\tpassword\r")

