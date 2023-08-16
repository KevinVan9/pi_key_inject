# Introduction
This project was based on a problem where lengthy login credentials had to be entered manually into a system quite frequently

# Major subproblems
- How to connect to the computer? Raspberry pi act as a USB gadget/HID. 
- How to detect USB host connection? File changes in /sys/class/udc/
- How to send keystrokes to host device? Write to /dev/hidg0 
- What to write in order for host to understand keystrokes?
Refer to USB HID Scan codes and send correct bytes


#Notes made when developing
- /sys/class/udc/devicenamehere/is_selfpowered changes not detected: https://stackoverflow.com/questions/63072846/why-doesnt-inotifywait-notice-the-change-in-sys-class-backlight-intel-backligh
keystroke injection not available immediately upon plug-in (detection of changes in /sys/class/udc/). USB protocol slow?

- How to send windows key? Windows key press is treated a virtual key. Needs more research

# How to install
1. Copy files to /root
2. Run enableKernelModules.sh
