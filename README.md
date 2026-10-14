# Android device tree for 优学派 P709 / U60 (k71v1_64_bsp)

**目标 ROM**：LineageOS 20 / **Android 13**（这是本机内核世代的天花板），再**魔改出 AviumUI 的功能 + MD3E 风格界面**。

> ⚠️ 这不是 recovery 设备树。recovery(TWRP/OFRP) 用另一个仓库。
> 本仓库是给 ROM 构建用的（LineageOS 20）。

---

## 一、硬件事实（权威）

| 项 | 值 |
|---|---|
| 机器 | 优学派 P709 / U60 |
| 代号 | `k71v1_64_bsp` |
| SoC | MediaTek **MT6771**（Helio P60），**Linux 4.4** 内核 |
| 原厂 | **Android 9**（API 28），SAR，treble |
| 分区 | **非动态分区**；无 `super`/`product`/`odm`；system+vendor 分家 |
| AVB | **关闭**（无 vbmeta/verity） |
| 内核 | **原厂预编译**（尾部带 MTK DTB，110572B）—— MTK lk 从内核尾部取 DTB |
| 屏幕 | 1200×2000 竖屏 |

分区实测（GPT）：system 6144MB / vendor 856MB / boot 32MB / recovery 32MB / dtbo 8MB / cache 432MB / metadata 32MB / userdata 111109MB

## 二、为什么是 Android 13（不是 AviumUI 的 A15/A16）

- AviumUI 分支 = Android 15/16/16.2/17，**最低 A15**。
- MT6771 社区天花板 = **Android 13**（Unihertz Atom XL/L 的 lineage-20.0 为证）。
- **Android 15 需要内核 5.x 特性（binderfs/eBPF/cgroup v2/GKI）**，Linux 4.4 无、且 MTK 无新内核源码 → **物理上做不到**。
- 处置：做 **A13 ROM**，再"中国厂商式魔改"出 MD3E 观感 + AviumUI 功能（改 framework/SystemUI/overlay，不是套壳）。

## 三、参考与来源

- 参考设备树（同 MT6771）：`ADeadTrousers/android_device_Unihertz_Atom_LXL` @ `lineage-20.0`
- `proprietary-files.txt` 目前**沿用 Atom LXL 的清单(405 行)作为起步**，
  必须用本机 dump 走 `extract-files.sh` 重新生成/校正。
- blobs 来源：`system.bin`(6.44GB, ext4) + `vendor.bin`(856MB, ext4)（全分区回读）

## 四、目录结构

```
├── BoardConfig.mk              # 板级配置(内核/分区/sepolicy/VNDK)
├── device.mk                   # 产品与设备配置
├── lineage_k71v1_64_bsp.mk     # LineageOS 20 产品定义
├── AndroidProducts.mk          # lunch 入口
├── extract-files.sh            # 从 dump 提取 vendor blobs
├── setup-makefiles.sh          # 生成 vendor makefiles
├── proprietary-files.txt       # blobs 清单(起步=Atom LXL，待本机重生成)
├── system.prop / product.prop  # 属性(取自原厂 prop.default 子集)
├── device_framework_matrix.xml # VNDK/framework 兼容矩阵(老 vendor)
├── rootdir/etc/fstab.mt6771    # Android 13 fstab
├── sepolicy/{private,public,vendor}/  # sepolicy 补丁(待补)
└── prebuilt/kernel             # 原厂内核(尾部带 DTB) —— ROM 必须用它
```

## 五、构建步骤（M1）

```bash
# 1) 同步 LineageOS 20 源码
repo init -u https://github.com/LineageOS/android.git -b lineage-20.0 --git-lfs
repo sync -c -j$(nproc) --force-sync --no-clone-branch --no-tags

# 2) 放入设备树
git clone <本仓库> device/youxuepai/k71v1_64_bsp

# 3) 提取 vendor blobs（把原厂 system.bin/vendor.bin 解开到 dump/{system,vendor}）
./device/youxuepai/k71v1_64_bsp/extract-files.sh /path/to/dump

# 4) 编译
source build/envsetup.sh
lunch lineage_k71v1_64_bsp-userdebug
mka bacon -j$(nproc)
```

## 六、M1 待攻关点（按经验排序）

1. **VNDK / 老 vendor**：vendor 是 Android 9(VNDK 28)，system 是 A13。GSI 13 能跑说明可行，但需要正确设置 `BOARD_VNDK_VERSION` / VNDK 快照（看 linker 报错迭代）。
2. **proprietary-files.txt 校正**：Atom 的清单不完全适用于本机（我们有 system+vendor 两分区、无 product/odm）。必须按本机 dump 重跑。
3. **sepolicy**：老 vendor + 新 system 会有大量 denials；先 permissive 起来，再逐条收紧。
4. **kernel 尾部 DTB**：已在 `prebuilt/kernel`。**务必不要换成没有尾部 DTB 的内核**（否则 lk 死循环，见 recovery 交接文档）。
5. **FBE/metadata 加密**：`fstab.mt6771` 里的加密参数需按原厂 policy 校正。
6. **HAL**：相机/音频/传感器等 MTK HAL 需确保在 vendor 里且能被 A13 调用。

## 七、M2/M3（UI 魔改）

- **M2**：MD3/MD3E 风格 —— 改 `frameworks/base`(SystemUI、Material 组件、动态色)、加 RRO overlay、主题引擎。
- **M3**：AviumUI 功能 —— 从 AviumUI 仓库挑**可独立移植**的应用/补丁（如 AviumUseful 等）。
- 结构上都在 ROM 源码里改，设备树只放 overlay/配置。

## 八、重要提醒

- 本机 `boot` 与 `recovery` 都是 32MB；ROM 的 boot 镜像 = **v1 头 + 内核(带尾部 DTB) + A13 ramdisk**。
- **没有 AVB** → 不用管 vbmeta；刷 ROM 后直接 `fastboot flash system/vendor/boot`。
- 变砖可回滚：全分区回读在 `D:\工程\镜像\全分区回读\`。
