#!/system/bin/sh
# ----------------------
# Author: Leudyart@  © 2023
# ----------------------

# if Magisk change its mount point in the future
MODDIR=${0%/*}

# This script will be executed in late_start service mode

# Apply After Boot
wait_until_boot_complete() {
  while [[ "$(getprop sys.boot_completed)" != "1" ]]; do
    sleep 3
  done
}

wait_until_boot_complete

script_dir="$MODDIR/script"

# Make sure init is completed
sleep 10

# =========
# Apply My Tweaks
# =========
sh $script_dir/MAXTweaksBattery.sh

# Exit script
exit 0