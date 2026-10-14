LOCAL_PATH := $(call my-dir)

ifneq ($(filter k71v1_64_bsp,$(TARGET_DEVICE)),)
include $(call all-makefiles-under,$(LOCAL_PATH))
endif
