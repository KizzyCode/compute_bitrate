#!/bin/bash
set -euo pipefail

# Set file
FILE="$1"

# Get width, height and bitrate
WIDTH=`ffprobe -v error -select_streams v:0 -show_entries stream=width -of default=noprint_wrappers=1:nokey=1 "$FILE"`
HEIGHT=`ffprobe -v error -select_streams v:0 -show_entries stream=height -of default=noprint_wrappers=1:nokey=1 "$FILE"`
BITRATE=`ffprobe -v error -select_streams v:0 -show_entries stream=bit_rate -of default=noprint_wrappers=1:nokey=1 "$FILE"`

# Compute target bitrate
REFERENCE_SIZE=$((4000 * 2000))  # 4K
REFERENCE_BITRATE=$((20 * 1000)) # 20 MBit/s

NEW_BITRATE_0=`echo "(($WIDTH * $HEIGHT) / $REFERENCE_SIZE) * $REFERENCE_BITRATE" | bc -l | awk '{printf "%d", $0}'`
NEW_BITRATE_1=`echo "$BITRATE / (2 * 1024)" | bc -l | awk '{printf "%d", $0}'`
NEW_BITRATE=$(($NEW_BITRATE_0 > $NEW_BITRATE_1 ? $NEW_BITRATE_1 : $NEW_BITRATE_0))

echo "The recommended bitrate is $NEW_BITRATE"