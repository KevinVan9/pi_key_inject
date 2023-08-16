#!/bin/bash

# Look at USB host directory for changes (connections) and run python inject script
while inotifywait -q -r -e modify /sys/class/udc/*.usb > /dev/null; do
    sleep 0.3 # Wait for usb connection to fully negotiate?
    echo "injecting"
    python3 /root/inject.py
done
