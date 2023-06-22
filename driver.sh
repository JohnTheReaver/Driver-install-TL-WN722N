#!/bin/bash
bfboot() {
#update & upgrade:
sudo apt-get update -y > /dev/null
sudo apt-get upgrade -y > /dev/null

#install packages:
sudo apt-get install bc build-essential libelf-dev dkms -y > /dev/null

#make driver directory & clone github repo:
mkdir ~/.772/
cd ~/.772/
git clone https://github.com/aircrack-ng/rtl8188eus > /dev/null
cd rtl8188eus

#look for device connected & remove r8188eu.ko:
while true; do
    output=$(lsusb | grep TL-WN722N)

    # Check if the output is empty
    if [ -z "$output" ]; then
        echo "Error: TP-Link TL-WN722N device not found."
        echo "Please insert your TP-Link device."
        sleep 5
    else
        echo "TP-Link is connected."
        break  # Exit the loop when the device is found
    fi
done
sudo rmmod r8188eu.ko

#enter root and add line to realtek.conf:
sudo -i
echo "blacklist r8188eu" > "/etc/modprobe.d/realtek.conf"
exit

#print device needs to reboot:
echo "Part one of the installation is complete!"
echo "Please reboot your computer."
}

afboot() {
#update after reboot:
sudo apt-get update

#make install
cd ~/772/rtl8188eus/
sudo make > /dev/null
sudo make install > /dev/null

#add driver:
sudo modprobe 8188eu

#print installation complete:
echo "Installation is complete!"
}

while true; do
	echo "1: Before reboot"
	echo "2: After reboot"
	echo "Enter q to quit"
	echo -n "Please select option: (1/2)"
	read cho

	case $cho in
	1)
		bfboot
		;;
	2)
		afboot
		;;
	q)
		echo "Exit!"
		break
		;;
	*)
		echo "Invalid choice!"
		;;
	esac
done
