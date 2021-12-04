#!/bin/bash


do_edid_stuff(){
	echo "Creating /usr/lib/firmware/edid directory if not exists..."
	[ -d /usr/lib/firmware/edid ] || mkdir -p /usr/lib/firmware/edid

	echo "Copying patched EDID..."
	cp ./edid_hdmi.bin /usr/lib/firmware/edid

	echo "Appending custom EDID to cmdline..."
	# Arch Wiki says "drm_kms_helper" should be used with older kernels, but just using "drm.edid_firmware" didn't work lol, (5.15.6-xanmod-tt)
	sed -i 's+GRUB_CMDLINE_LINUX_DEFAULT="[^"]*+& amdgpu.dc=1 drm_kms_helper.edid_firmware=HDMI-A-1:edid/edid_hdmi.bin+' /etc/default/grub

	echo "Regenerating GRUB config..."
	grub-mkconfig -o /boot/grub/grub.cfg

	echo "Regenerating initramfs..."
	mkinitcpio -P

	echo "Done. Please reboot to make changes effective."
}


if [[ $EUID != 0 ]]; then
	echo "Root permissions required."
	echo "Please run this using sudo or your preferred super user tool."
	exit 1
fi


do_edid_stuff

