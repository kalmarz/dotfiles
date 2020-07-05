#!/bin/bash

echo updating /boot/config.txt
cp -p /boot/config.txt /boot/config-pre-usbc-networking.txt
echo dtoverlay=dwc2 >> /boot/config.txt

echo updating /boot/cmdline.txt
cp -p /boot/cmdline.txt /boot/cmdline-pre-usbc-networking.txt
# fixme - how to add to the same line?
echo modules-load=dwc2 >> /boot/cmdline.txt

echo updating /etc/modules
echo libcomposite >> /etc/modules

echo creating /etc/dnsmasq.d/usb
cat > /etc/dnsmasq.d/usb << EOL
interface=usb0
dhcp-range=10.55.0.2,10.55.0.6,255.255.255.248,1h
dhcp-option=3
leasefile-ro
EOL

echo creating /etc/network/interfaces.d/usb0
cat > /etc/network/interfaces.d/usb0 <<EOL 
auto usb0
allow-hotplug usb0
iface usb0 inet static
  address 10.55.0.1
  netmask 255.255.255.248
EOL

echo creating /root/usb.sh
cat > /root/usb.sh <<'EOL'
#!/bin/bash
cd /sys/kernel/config/usb_gadget/
mkdir -p pi4
cd pi4
echo 0x1d6b > idVendor # Linux Foundation
echo 0x0104 > idProduct # Multifunction Composite Gadget
echo 0x0100 > bcdDevice # v1.0.0
echo 0x0200 > bcdUSB # USB2
echo 0xEF > bDeviceClass
echo 0x02 > bDeviceSubClass
echo 0x01 > bDeviceProtocol
mkdir -p strings/0x409
echo "fedcba9876543211" > strings/0x409/serialnumber
echo "Ben Hardill" > strings/0x409/manufacturer
echo "PI4 USB Device" > strings/0x409/product
mkdir -p configs/c.1/strings/0x409
echo "Config 1: ECM network" > configs/c.1/strings/0x409/configuration
echo 250 > configs/c.1/MaxPower
# Add functions here
# see gadget configurations below
# End functions
mkdir -p functions/ecm.usb0
HOST="00:dc:c8:f7:75:14" # "HostPC"
SELF="00:dd:dc:eb:6d:a1" # "BadUSB"
echo $HOST > functions/ecm.usb0/host_addr
echo $SELF > functions/ecm.usb0/dev_addr
ln -s functions/ecm.usb0 configs/c.1/
udevadm settle -t 5 || :
ls /sys/class/udc > UDC
ifup usb0
service dnsmasq restart
EOL

chmod +x /root/usb.sh

echo updating /etc/rc.local
cp -p /etc/rc.local /etc/rc.local-pre-usbc-networking
cat /etc/rc.local | sed -e s/exit\ 0//g >> /tmp/rc.local
cat >> /tmp/rc.local <<EOL
/root/usb.sh
exit 0
EOL

mv /tmp/rc.local /etc/rc.local

echo done
