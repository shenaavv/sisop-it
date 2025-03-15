#!/bin/sh

DIR=$(realpath $(dirname $0))
BASE_DIR=$(realpath "$DIR/../logs")

if [ ! -d "$BASE_DIR" ]; then
    mkdir -p "$BASE_DIR"
fi

CPU_Usage=$(top -bn2 | grep "Cpu(s)" | sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | awk '{print 100 - $1"%"}' | awk 'NR==2 {print $0}' )
CPU_Model=$(lscpu | grep 'Model name' | awk -F': ' '{print $2}' | xargs)

echo "[$(date +'%Y-%m-%d %H:%M:%S')] - Core Usage [$CPU_Usage] - Terminal Model [$CPU_Model]" >> "$BASE_DIR/core.log"

