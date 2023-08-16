#!/bin/bash

# Add device tree overlay for broadcom OTG USB 2.0 controller
echo "dtoverlay=dwc2" | sudo tee -a /boot/config.txt
# Load dwc2 kernel modules
echo "dwc2" | sudo tee -a /etc/modules
# enable usb composite modules
sudo echo "libcomposite" | sudo tee -a /etc/modules

# Create script to configure USB OTG
sudo touch /usr/bin/isticktoit_usb #create the file
sudo chmod +x /usr/bin/isticktoit_usb #make it executable

# Populate script to run at boot
cat > /usr/bin/isticktoit_usb << EOL
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p isticktoit
cd isticktoit
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
mkdir -p strings/0x409
echo "fedcba9876543210" > strings/0x409/serialnumber
echo "Manufacturer" > strings/0x409/manufacturer
echo "USB Device" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower

# Add functions here
mkdir -p functions/hid.usb0
echo 1 > functions/hid.usb0/protocol
echo 1 > functions/hid.usb0/subclass
echo 8 > functions/hid.usb0/report_length
echo -ne \\\\x05\\\\x01\\\\x09\\\\x06\\\\xa1\\\\x01\\\\x05\\\\x07\\\\x19\\\\xe0\\\\x29\\\\xe7\\\\x15\\\\x00\\\\x25\\\\x01\\\\x75\\\\x01\\\\x95\\\\x08\\\\x81\\\\x02\\\\x95\\\\x01\\\\x75\\\\x08\\\\x81\\\\x03\\\\x95\\\\x05\\\\x75\\\\x01\\\\x05\\\\x08\\\\x19\\\\x01\\\\x29\\\\x05\\\\x91\\\\x02\\\\x95\\\\x01\\\\x75\\\\x03\\\\x91\\\\x03\\\\x95\\\\x06\\\\x75\\\\x08\\\\x15\\\\x00\\\\x25\\\\x65\\\\x05\\\\x07\\\\x19\\\\x00\\\\x29\\\\x65\\\\x81\\\\x00\\\\xc0 > functions/hid.usb0/report_desc
ln -s functions/hid.usb0 configs/c.1/
# End functions

ls /sys/class/udc > UDC
EOL

#Install file change detection program
sudo apt install inotify-tools

# Create systemd service to run USB OTG configuration and injection script
cat > /lib/systemd/system/inject.service << EOL
[Unit]
Description=usb
[Service]
ExecStart=/usr/bin/isticktoit_usb && /root/inject-on-connect.sh
[Install]
WantedBy=multi-user.target
EOL

# Enable injection service
sudo chmod +x /lib/systemd/system/inject.service
sudo systemctl start inject.service
sudo systemctl enable inject.service


