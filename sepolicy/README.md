# sepolicy/

本机 vendor 是 Android 9，system 是 Android 13，会有大量 denials。
M1 阶段建议：
1. 先让系统能起到 adb（可临时 `androidboot.selinux=permissive`）。
2. 抓 `dmesg | grep avc` / `logcat` 里的 avc denied，逐条在此补规则。
3. 稳定后再转 enforcing。

子目录：
- `private/`  -> SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS
- `public/`   -> SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS
- `vendor/`   -> BOARD_VENDOR_SEPOLICY_DIRS
(均已在 BoardConfig.mk 引用)
