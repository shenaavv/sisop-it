#!/bin/sh

DIR=$(realpath $(dirname $0))
BASE_DIR=$(realpath "$DIR/../logs")

if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

echo "[$(date "+%Y-%m-%d %H:%M:%S")] - Fragment Usage [$(awk '/MemFree/ {free=$2} /MemTotal/ {total=$2} END {print (1 - free/total) * 100}' /proc/meminfo)%] - Fragment Count [$(awk '/SReclaimable/ {print $2/1024}' /proc/meminfo) MB] - Details [Total: $(free -m | awk '/Mem:/ {print $2}') MB, Available: $(free -m | awk '/Mem:/ {print $7}') MB]" >> "$BASE_DIR/fragment.log"
