while inotifywait -q -e modify /sys/class/udc/20980000.usb/is_selfpowered > /dev/null; do
    echo "injected" >> /root/inject.log
    python3 /root/inject.py
done
