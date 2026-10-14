# sepolicy/

本机 vendor 是 **Android 9**、system 是 **Android 13**，必然有大量 denials。

## 目录（BoardConfig.mk 已引用）
- `private/` → `SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS`
- `public/`  → `SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS`
- `vendor/`  → `BOARD_VENDOR_SEPOLICY_DIRS`
- `reference/` → **不参与编译**，只放参考（见其 README）

## M1 策略（不要一上来就塞满）

1. **先 permissive 起来**：首次构建/开机能把系统拉起来、能 adb 就行。
2. **抓 denials**：
   ```bash
   adb shell dmesg | grep avc
   adb logcat | grep avc
   ```
3. **逐条补**：把 high 的 denial 落到 `private/` 或 `vendor/` 的 `.te`，
   路径/属性分别在 `file_contexts` / `property_contexts` 里声明。
4. 稳定后 → 去掉 permissive，转 **enforcing**。

> 本目录当前为**空起步**（只有 README）——这是故意的：
> 塞没有类型定义的 `file_contexts` 会直接**编译失败**。
> MTK 相关的现成条目见 `reference/`。
