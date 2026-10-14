#!/bin/bash
#
# extract-files.sh — 从原厂镜像/已解包目录提取 vendor blobs
# 优学派 P709 / U60 (k71v1_64_bsp)
#
# 用法:
#   ./extract-files.sh /path/to/dump      # dump 目录里应有 system/ 与 vendor/ 两棵子树
#   ./extract-files.sh                    # 或走 adb(设备上)
#
# 说明: 本机原厂镜像是 ext4(全分区回读 system.bin/vendor.bin)。
# 可先用 (sudo mount -o loop,ro system.bin sys) 或 binwalk/7z 解出 system/ 与 vendor/ 目录,
# 再用本脚本 + proprietary-files.txt 提取到 vendor/youxuepai/k71v1_64_bsp/。
#
set -e

export DEVICE=k71v1_64_bsp
export VENDOR=youxuepai

MY_DIR="${BASH_SOURCE%/*}"
if [[ ! -d "$MY_DIR" ]]; then MY_DIR="$PWD"; fi

LINEAGE_ROOT="$MY_DIR"/../../..
HELPER="$LINEAGE_ROOT"/vendor/lineage/build/tools/extract_utils.sh
if [ ! -f "$HELPER" ]; then
    echo "Unable to find helper script at $HELPER"
    exit 1
fi
. "$HELPER"

# 默认清理旧的 vendor 目录
CLEAN_VENDOR=true
SECTION=
KANG=

while [ "$1" != "" ]; do
    case "$1" in
        -n | --no-cleanup ) CLEAN_VENDOR=false ;;
        -s | --section )    shift; SECTION="$1"; CLEAN_VENDOR=false ;;
        * )                 SRC="$1" ;;
    esac
    shift
done

if [ -z "$SRC" ]; then
    SRC=adb
fi

# Initialize the helper
setup_vendor "$DEVICE" "$VENDOR" "$LINEAGE_ROOT" false "$CLEAN_VENDOR"

extract "$MY_DIR"/proprietary-files.txt "$SRC" "$SECTION"

"$MY_DIR"/setup-makefiles.sh
