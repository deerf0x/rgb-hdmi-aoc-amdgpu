#!/bin/bash


do_edid_stuff(){
	echo "Creating /usr/lib/firmware/edid directory if not exists..."
	[ -d /usr/lib/firmware/edid ] || mkdir -p /usr/lib/firmware/edid

	echo "Copying patched EDID..."
	cp ./edid_hdmi.bin /usr/lib/firmware/edid

	echo "Appending custom EDID to cmdline..."

	sed -i 's+GRUB_CMDLINE_LINUX_DEFAULT="[^"]*+& amdgpu.dc=1 drm.edid_firmware=HDMI-A-1:edid/edid_hdmi.bin+' /etc/default/grub

	echo "Regenerating GRUB config..."
	grub-mkconfig -o /boot/grub/grub.cfg

	echo "Regenerating initramfs..."
	
	if [[ "$(command -v update-initramfs)" ]]; then
    		echo "update-initramfs detected."
    		echo "Creating backup of initramfs-tools hook functions file..."
    		cp /usr/share/initramfs-tools/hook-functions /usr/share/initramfs-tools/hook-functions.bak
    		echo "Appending EDID copy hook..."
    		sed -i 's/.*local prefix kmod options firmware.*/&\n\tcopy_exec \/lib\/firmware\/edid\/edid_hdmi.bin/' /usr/share/initramfs-tools/hook-functions
    		echo "Running update-initramfs -u"
    		update-initramfs -u
	fi
	
	if [[ "$(command -v dracut)" ]]; then
    		echo "dracut detected."
    		dracut --regenerate-all
	fi
	
	if [[ "$(command -v mkinitcpio)" ]]; then
    		echo "mkinitcpio detected."
    		mkinitcpio -P
	fi

	echo "Done. Please reboot to make changes effective."
}


if [[ $EUID != 0 ]]; then
	echo "Root permissions required."
	echo "Please run this using sudo or your preferred super user tool."
	exit 1
fi


do_edid_stuff

