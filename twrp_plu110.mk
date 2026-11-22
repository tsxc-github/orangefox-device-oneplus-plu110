#
# Copyright (C) 2025 The Android Open Source Project
#
# SPDX-License-Identifier: Apache-2.0
#

DEVICE_PATH := device/oneplus/plu110

# Inherit from device.mk configuration
$(call inherit-product, $(DEVICE_PATH)/device.mk)

## Device identifier
PRODUCT_DEVICE       := plu110
PRODUCT_NAME         := twrp_plu110
PRODUCT_BRAND        := OnePlus
PRODUCT_MANUFACTURER := OnePlus
PRODUCT_MODEL        := PLU110
PRODUCT_SYSTEM_DEVICE := OP60F0L1

# Theme
TW_STATUS_ICONS_ALIGN   := center
TW_Y_OFFSET             := 111
TW_H_OFFSET             := -111
