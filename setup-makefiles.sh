#!/bin/bash
#
# setup-makefiles.sh — 生成 vendor/youxuepai/k71v1_64_bsp 的 Android.mk / BoardConfigVendor.mk /
# k71v1_64_bsp-vendor.mk / AndroidProducts.mk
#
set -e

export DEVICE=k71v1_64_bsp
export VENDOR=youxuepai
export INITIAL_COPYRIGHT_YEAR=2019

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..
HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

if [ ! -z "$1" ]; then
    SRC="$1"
else
    SRC=adb
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" true "$CLEAN_VENDOR"

write_makefiles "$MY_DIR"/proprietary-files.txt true

write_product_packages "$MY_DIR"/proprietary-files.txt

finish
