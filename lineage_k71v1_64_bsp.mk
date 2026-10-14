# lineage_k71v1_64_bsp.mk — LineageOS 20 产品定义
$(call inherit-product, $(SRC_TARGET_DIR)/product/core_64_bit.mk)
$(call inherit-product, $(SRC_TARGET_DIR)/product/full_base_telephony.mk)

$(call inherit-product, device/youxuepai/k71v1_64_bsp/device.mk)
$(call inherit-product-if-exists, vendor/youxuepai/k71v1_64_bsp/k71v1_64_bsp-vendor.mk)

# LineageOS 定制(去掉/LINEAGE 视需求保留)
$(call inherit-product, vendor/lineage/config/common_full_phone.mk)

PRODUCT_NAME := lineage_k71v1_64_bsp
PRODUCT_DEVICE := k71v1_64_bsp
PRODUCT_BRAND := YOUXUEPAI
PRODUCT_MODEL := P709
PRODUCT_MANUFACTURER := YOUXUEPAI
PRODUCT_RELEASE_NAME := P709

PRODUCT_GMS_CLIENTID_BASE := android-youxuepai
