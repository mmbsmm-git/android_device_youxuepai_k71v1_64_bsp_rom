# device.mk — P709 / k71v1_64_bsp  (LineageOS 20)
DEVICE_PATH := device/youxuepai/k71v1_64_bsp

# ---------------- 分区方案(非动态/无 product/无 super) ----------------
# 本机是 Android 9 世代的老式 treble 设备: system + vendor 分家, 没有 product/odm/super。
PRODUCT_USE_DYNAMIC_PARTITIONS := false
PRODUCT_BUILD_SUPER_PARTITION := false
PRODUCT_BUILD_PRODUCT_IMAGE := false
PRODUCT_BUILD_SYSTEM_EXT_IMAGE := false
# --- 关键: 设备出厂是 Android 9(API 28) ---
PRODUCT_SHIPPING_API_LEVEL := 28
# 老 vendor 需要兼容 VNDK 28
PRODUCT_EXTRA_VNDK_VERSIONS += 28

# ---------------- API/设备特征 ----------------
PRODUCT_CHARACTERISTICS := tablet
PRODUCT_AAPT_CONFIG := normal hdpi xhdpi xxhdpi
PRODUCT_AAPT_PREF_CONFIG := xhdpi
PRODUCT_LOCALES := zh_CN en_US

# ---------------- APEX ----------------
$(call inherit-product, $(SRC_TARGET_DIR)/product/updatable_apex.mk)

# ---------------- 兼容矩阵 ----------------
DEVICE_FRAMEWORK_COMPATIBILITY_MATRIX_FILE += $(DEVICE_PATH)/device_framework_matrix.xml

# ---------------- fstab ----------------
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6771:$(TARGET_COPY_OUT_RAMDISK)/fstab.mt6771 \
    $(DEVICE_PATH)/rootdir/etc/fstab.mt6771:$(TARGET_COPY_OUT_VENDOR)/etc/fstab.mt6771

# ---------------- 属性 ----------------
PRODUCT_PROPERTY_OVERRIDES += \
    ro.sf.hwrotation=0

# ---------------- HAL / 厂商组件 ----------------
# 本机 HAL 由原厂 vendor 分区(Android 9)提供；用 extract-files.sh 从 system.bin/vendor.bin 提取。
# TODO(M1): 首次编译/开机后按 log 补充缺失的 HAL 包装/权限。

# ---------------- 语言 ----------------
PRODUCT_DEFAULT_LOCALE := zh_CN

# ---------------- Rootdir / Init / Configs ----------------
PRODUCT_COPY_FILES += \
    $(DEVICE_PATH)/rootdir/etc/init.mt6771.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.mt6771.rc \
    $(DEVICE_PATH)/rootdir/etc/init.project.rc:$(TARGET_COPY_OUT_VENDOR)/etc/init/hw/init.project.rc \
    $(DEVICE_PATH)/rootdir/etc/ueventd.mt6771.rc:$(TARGET_COPY_OUT_VENDOR)/ueventd.rc \
    $(DEVICE_PATH)/configs/audio/audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/audio/a2dp_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/a2dp_audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/audio/r_submix_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/r_submix_audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/audio/usb_audio_policy_configuration.xml:$(TARGET_COPY_OUT_VENDOR)/etc/usb_audio_policy_configuration.xml \
    $(DEVICE_PATH)/configs/media/media_codecs.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs.xml \
    $(DEVICE_PATH)/configs/media/media_codecs_performance.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_codecs_performance.xml \
    $(DEVICE_PATH)/configs/media/media_profiles_V1_0.xml:$(TARGET_COPY_OUT_VENDOR)/etc/media_profiles_V1_0.xml

# ---------------- 调试默认开启 ADB (M1 抓 log 必备) ----------------
PRODUCT_SYSTEM_DEFAULT_PROPERTIES += \
    ro.adb.secure=0 \
    ro.secure=0 \
    ro.debuggable=1 \
    persist.sys.usb.config=mtp,adb
