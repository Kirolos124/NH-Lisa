# NH Lisa — NetHunter Custom Kernel for Xiaomi 11 Lite 5G NE (`lisa`)

Custom kernel for **Xiaomi 11 Lite 5G NE (`lisa`, Snapdragon 778G / SM7325)** running
**LineageOS 23.2 (build 20260922, Android 16)**, with full Kali NetHunter hardware support.

## Why this repo exists
The LineageOS kernel for `lisa` lives in `LineageOS/android_kernel_xiaomi_sm8350`
(branch `lineage-23.2`, path `kernel/xiaomi/sm8350` — **not** `sm7325`), config chain:

```
vendor/lahaina-qgki_defconfig
+ vendor/debugfs.config
+ vendor/xiaomi_QGKI.config
+ vendor/lisa_QGKI.config
+ kernel/nethunter-lisa.config   <- this repo (applied last)
```

Base already has `CFG80211` / `MAC80211` / `USB_CONFIGFS_F_HID`; this fragment adds
HID legacy, monitor-mode helpers, external Wi-Fi drivers and SysVIPC (see below).
Pinned kernel rev `7ede20c8` = running `5.4.302-qgki-g7ede20c8692e` — exact match.

## NetHunter additions (`kernel/nethunter-lisa.config`)
- **USB HID / BadUSB:** `USB_CONFIGFS` + `USB_CONFIGFS_F_HID` + `USB_G_HID`
- **Monitor mode:** `CFG80211` + `MAC80211` + `CFG80211_WEXT` + `MAC80211_LEDS` (+ `WLAN` + vendor submenus, since base disables them)
- **External Wi-Fi (modules):** `ATH9K_HTC` (AR9271) + `RT2X00`/`RT2800USB` (RT33xx/35xx/53xx) + `RTL8187` + `RTL8192CU`
- **Chroot:** `SYSVIPC` + `SYSVIPC_SYSCTL`

## Outputs (naming = LOS build + Android version)
- `NetHunter-Kernel-lisa-lineage-23.2-20260922-Android16-AnyKernel3.zip` — flash via recovery/Franco Kernel Manager (A/B slot aware, boot header v3)
- `boot-patched-lisa-lineage-23.2-20260922-Android16.img` — **mandatory**: reference `boot.img` repacked with new kernel via magiskboot (`fastboot flash boot`)
- Raw `Image.gz` + `.ko` modules included in CI artifacts

## Build (CI)
1. Go to **Actions → Build NetHunter Kernel (lisa) → Run workflow**
   - defaults already point at kernel rev `7ede20c8` and LOS zip `lineage-23.2-20260922`
2. Download the `NetHunter-Kernel-lisa-lineage-23.2-20260922-Android16` artifact

## Flash + verify (on device)
1. `fastboot flash boot boot-patched-lisa-lineage-23.2-20260922-Android16.img`
   (or flash the AnyKernel3 zip; keep a backup of stock `boot.img`!)
2. Boot check → APatch root still works → NetHunter app chroot mounts →
   HID payload over USB → external Wi-Fi card in monitor mode (`airmon-ng`)

## Local files
- `I:\Downloads\NH-Lisa\boot.img` — stock reference (192M, header v3, valid `ANDROID!`)
- `I:\Downloads\NH-Lisa\lineage-23.2-20260922-nightly-lisa-signed.zip` — source
- `I:\Downloads\NH-Lisa\build-manifest.xml` — source of truth for revs/toolchain
- `I:\Downloads\NH-Lisa\kernel\` — shallow checkout for defconfig inspection (Windows can't check out 3 `aux.*` files — irrelevant for the Linux CI build)
