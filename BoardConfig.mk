# BoardConfig.mk — 优学派 P709 / U60 (k71v1_64_bsp)
# LineageOS 20 / Android 13 ROM 设备树
# 结构参考 MT6771 公共树(Unihertz Atom LXL, lineage-20.0)，按本机**实测**参数改写：
#   - 非动态分区(无 super/product/odm)、无 AVB、system/vendor 分家、SAR(A9 设备)
#   - 内核用原厂预编译(尾部带 MTK DTB)；boot 头沿用原厂 v1(MTK lk 从内核尾部取 DTB)
# 分区尺寸来自本机 GPT 实测。

DEVICE_PATH := device/youxuepai/k71v1_64_bsp

# ---------------- Architecture ----------------
TARGET_ARCH := arm64
TARGET_ARCH_VARIANT := armv8-a
TARGET_CPU_ABI := arm64-v8a
TARGET_CPU_ABI2 :=
TARGET_CPU_VARIANT := generic
TARGET_2ND_ARCH := arm
TARGET_2ND_ARCH_VARIANT := armv7-a-neon
TARGET_2ND_CPU_ABI := armeabi-v7a
TARGET_2ND_CPU_ABI2 := armeabi
TARGET_2ND_CPU_VARIANT := generic
TARGET_USES_64_BIT_BINDER := true
TARGET_SUPPORTS_64_BIT_APPS := true

# ---------------- Platform ----------------
TARGET_BOARD_PLATFORM := mt6771
TARGET_BOOTLOADER_BOARD_NAME := mt6771
TARGET_NO_BOOTLOADER := true
BOARD_USES_MTK_HARDWARE := true
BOARD_HAS_MTK_HARDWARE := true

# ---------------- Kernel (prebuilt, MTK 尾部 DTB) ----------------
# !!! 硬约束(ROM 与 recovery 相同): MTK lk 从「内核 blob 尾部」扫描 FDT magic 取 DTB。
# 内核必须 = [gzip(Image) + 原厂 110572B DTB]，boot 头用 v1。
# prebuilt/kernel 直接取自能用的那份(9366062B)。
TARGET_PREBUILT_KERNEL := $(DEVICE_PATH)/prebuilt/kernel
BOARD_KERNEL_IMAGE_NAME := Image.gz
BOARD_KERNEL_BASE := 0x40078000
BOARD_KERNEL_PAGESIZE := 2048
BOARD_KERNEL_OFFSET := 0x00008000
BOARD_RAMDISK_OFFSET := 0x14f88000
BOARD_KERNEL_TAGS_OFFSET := 0x13f88000
BOARD_KERNEL_CMDLINE := bootopt=64S3,32N2,64N2
BOARD_BOOT_HEADER_VERSION := 1
BOARD_MKBOOTIMG_ARGS += --base $(BOARD_KERNEL_BASE)
BOARD_MKBOOTIMG_ARGS += --pagesize $(BOARD_KERNEL_PAGESIZE)
BOARD_MKBOOTIMG_ARGS += --kernel_offset $(BOARD_KERNEL_OFFSET)
BOARD_MKBOOTIMG_ARGS += --ramdisk_offset $(BOARD_RAMDISK_OFFSET)
BOARD_MKBOOTIMG_ARGS += --tags_offset $(BOARD_KERNEL_TAGS_OFFSET)
BOARD_MKBOOTIMG_ARGS += --header_version $(BOARD_BOOT_HEADER_VERSION)
# 内核已自带 DTB(尾部)，不要再单独塞 dtb
BOARD_INCLUDE_DTB_IN_BOOTIMG := false

# ---------------- Partitions (实测 GPT) ----------------
BOARD_FLASH_BLOCK_SIZE := 131072
BOARD_BOOTIMAGE_PARTITION_SIZE := 33554432
BOARD_RECOVERYIMAGE_PARTITION_SIZE := 33554432
BOARD_DTBOIMG_PARTITION_SIZE := 8388608
BOARD_SYSTEMIMAGE_PARTITION_SIZE := 6442450944
BOARD_VENDORIMAGE_PARTITION_SIZE := 897581056
BOARD_CACHEIMAGE_PARTITION_SIZE := 452984832
BOARD_USERDATAIMAGE_PARTITION_SIZE := 116506198016
BOARD_METADATAIMAGE_PARTITION_SIZE := 33554432
BOARD_SYSTEMIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_VENDORIMAGE_FILE_SYSTEM_TYPE := ext4
BOARD_CACHEIMAGE_FILE_SYSTEM_TYPE := ext4
TARGET_USERIMAGES_USE_EXT4 := true
TARGET_USERIMAGES_USE_F2FS := false
TARGET_COPY_OUT_VENDOR := vendor
TARGET_COPY_OUT_SYSTEM_EXT := system_ext
BOARD_ROOT_EXTRA_FOLDERS += metadata
TARGET_USES_MKE2FS := true

# 非动态分区 / 无 product,odm / 无 super  (device.mk 里同步 PRODUCT_USE_DYNAMIC_PARTITIONS := false)
BOARD_SUPER_PARTITION_SIZE := 0

# 无 AVB / 无 vbmeta(本机 AVB=False)
BOARD_AVB_ENABLE := false

# ---------------- Boot / Recovery ----------------
BOARD_BUILD_SYSTEM_ROOT_IMAGE := false
TARGET_NO_RECOVERY := false
BOARD_USES_RECOVERY_AS_BOOT := false
TARGET_RECOVERY_FSTAB := $(DEVICE_PATH)/rootdir/etc/fstab.mt6771
TARGET_RECOVERY_PIXEL_FORMAT := "BGRA_8888"
BOARD_INCLUDE_RECOVERY_DTBO := true
BOARD_PREBUILT_DTBOIMAGE := $(DEVICE_PATH)/prebuilt/recovery_dtbo.img

# ---------------- Sepolicy ----------------
TARGET_USES_PREBUILT_VENDOR_SEPOLICY := true
SYSTEM_EXT_PRIVATE_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/private
SYSTEM_EXT_PUBLIC_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/public
BOARD_VENDOR_SEPOLICY_DIRS += $(DEVICE_PATH)/sepolicy/vendor

# ---------------- Treble / VNDK ----------------
# 本机 vendor 是 Android 9(VNDK 28)；GSI 13 实测能跑 → 老 vendor + 新 system 可行。
# TODO(M1): 首编后按 linker/vndk 报错调整(可能需 TARGET_VNDK_USE_CORE_VARIANT / 相应 VNDK 快照)。
BOARD_VNDK_VERSION := current
BUILD_WITHOUT_VENDOR := false
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE := $(DEVICE_PATH)/device_framework_matrix.xml
# 注: 不加 DEVICE_MANIFEST_FILE / DEVICE_MATRIX_FILE —— vendor manifest 由原厂 vendor 分区提供。
#     若编译期 assemble_vintf 报缺 HAL，再在 device_framework_matrix.xml 放宽。

# ---------------- Properties ----------------
TARGET_SYSTEM_PROP += $(DEVICE_PATH)/system.prop
TARGET_PRODUCT_PROP += $(DEVICE_PATH)/product.prop
