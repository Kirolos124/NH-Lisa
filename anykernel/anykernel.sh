# AnyKernel3 configuration for Xiaomi 11 Lite 5G NE (lisa)
# A/B device, boot header v3, vendor_boot present, boot partition 192M (201326592)
# AK3 template is fetched at build time; this file is copied over it.
# See: https://github.com/osm0sis/AnyKernel3

properties() { '
kernel.string=NetHunter Kernel for lisa (LineageOS 23.2 / Android 16) by Kirolos124
do.devicecheck=1
do.modules=1
do.systemless=1
do.cleanup=1
do.cleanuponabort=0
device.name1=lisa
device.name2=lisa_global
supported.versions=16
supported.patchlevels=
supported.vendorpatchlevels=
'; }

# A/B slot handling is automatic in AK3 (boot partition, no ramdisk override).
# Kernel Image is placed by the workflow as Image.gz in the AK3 root.
block=boot;
is_slot_device=1;
ramdisk_compression=auto;
patch_vbmeta_flag=auto;

# No extra ramdisk tweaks needed for NetHunter kernel (drivers are built-in/=m in boot image modules).
# Modules (*.ko for ath9k_htc/rt2800usb/rtl8187/rtl8192cu) are shipped under modules/vendor/lib/modules
# and copied by AK3's module installer.
