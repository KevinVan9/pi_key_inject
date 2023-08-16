#!/usr/bin/env python3

# References:
# Python implementation of USB HID byte codes: https://stackoverflow.com/questions/49887540/improve-python-code
# Configuration of Pi Zero system as USB HID:  https://randomnerdtutorials.com/raspberry-pi-zero-usb-keyboard-hid/

from codes import codes, NULL_CHAR
from time import sleep

# write bytes to enabled gadget mode interface
def write_report(report):
    with open('/dev/hidg0', 'rb+') as fd:
        fd.write(report.encode())

# Send key press and release for each character to simulate typing
def send_string(s):
    for ch in s:
        send_key(ch)

# I thought this would be faster but apparently not
def send_string_faster(s):
    last_ch=None
    for ch in s:
        if last_ch==ch:
            release_key()
        press_key(ch)
        last_ch = ch
    release_key()

# Press key
def press_key(ch):
    write_report(codes[ch])

# Release keys
def release_key():
    write_report(NULL_CHAR*8)

# Send keystroke
def send_key(ch):
    press_key(ch)
    release_key()

# The initial goal of the project
# Send a username, tab, password and then return
def send_creds(username=None,password=None):
    if not username or not password:
    	f = input()
    	with open(f) as creds:
            username = creds.readline()
            password = creds.readline()
    send_string(f'{username}\t{password}\r')

def rick_roll0():
    send_key('run')
    sleep(0.1)
    send_string('%programfiles(x86)%\\Microsoft\\Edge\\Application\\msedge.exe "https://www.youtube.com/watch?v=dQw4w9WgXcQ"\r')

#sleep(2)
#send_string('0123456789)!@#$%^&*(abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-=[]\\;\',./_+{}|:"<>?')

rick_roll0()

#send_creds("username", "password")
