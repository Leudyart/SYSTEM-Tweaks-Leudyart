#!/system/bin/sh
# THIS SCRIPT WILL BE EXECUTED IN POST-FS-DATA MODE
# More info in the main Magisk thread
# Do NOT assume where your module will be located.
# ALWAYS use $MODDIR if you need to know where this script
# and module is placed.
# This will make sure your module will still work
# if Magisk change its mount point in the future
MODDIR=${0%/*}
# ----------------------
# Author: Leudyart@  © 2023
# ----------------------

# STOP SERVICES WITHOUT SUPERUSER PRIVILEGES
stop logd
stop traced
stop tcpdump
stop cnss_diag
stop idd-logreader
stop idd-logreadermain

# CLEAN WIFI LOG
touch /data/vendor/wlan_logs
chmod 000 /data/vendor/wlan_logs
rm -rf /data/vendor/wlan_logs

# CLEAN DIRECTORIES AND FILES,CACHE,LOG
rm -rf /data/vendor/charge_logger/
rm -rf /data/magisk_backup_*
rm -rf /data/resource-cache/*
rm -rf /data/system/package_cache/*
rm -rf /data/log/*
rm -rf /cache/*

# CLEAR THE CACHE OF ALL INSTALLED APPS ON THE ANDROID DEVICE
find /data/data -type d -name "cache" -exec rm -rf {}/* \;
find /data/data/com.whatsapp -type d -name "cache" -exec rm -rf {}/* \;
find /data/data/com.android.vending -type d -name "cache" -exec rm -rf {}/* \;
find /data/data/org.telegram.messenger -type d -name "cache" -exec rm -rf {}/* \;
find /data/data/ir.ilmili.telegraph.second -type d -name "cache" -exec rm -rf {}/* \;

find /data/data/com.android.systemui -type d -name "cache" -exec rm -rf {}/* \;
find /data/data/com.android.launcher3 -type d -name "cache" -exec rm -rf {}/* \;

# ADJUST THE VIRTUAL SPACE PAGE CLUSTER
echo "0" > /proc/sys/vm/page-cluster

# DISABLING IOSTAT FOR F2FS
echo "0" > /sys/fs/f2fs_dev/mmcblk0p79/iostat_enable

# DISABLE SCHEDULING STATISTICS
echo "0" > /proc/sys/kernel/sched_schedstats

# DISABLE DISK I/O STATISTICS (EMMC)
devices=(
  "/sys/dev/block/mmcblk0p77/statistics/enable"
  "/sys/block/mmcblk0/statistics/enable"
  "/sys/block/mmcblk0/queue/iostats"
  "/sys/block/mmcblk0rpmb/queue/iostats"
  "/sys/block/mmcblk1/queue/iostats"
  "/sys/block/loop0/queue/iostats"
  "/sys/block/loop1/queue/iostats"
  "/sys/block/loop2/queue/iostats"
  "/sys/block/loop3/queue/iostats"
  "/sys/block/loop4/queue/iostats"
  "/sys/block/loop5/queue/iostats"
  "/sys/block/loop6/queue/iostats"
  "/sys/block/loop7/queue/iostats"
  "/sys/block/loop8/queue/iostats"
  "/sys/block/loop9/queue/iostats"
  "/sys/block/loop10/queue/iostats"
  "/sys/block/loop11/queue/iostats"
  "/sys/block/loop12/queue/iostats"
  "/sys/block/loop13/queue/iostats"
  "/sys/block/loop14/queue/iostats"
  "/sys/block/loop15/queue/iostats"
  "/sys/block/sda/queue/iostats"
  "/sys/block/sde/queue/iostats"
  "/sys/block/mmcblk0/statistics_level"
)

for device in "${devices[@]}"
do
  echo "0" > "$device"
done

# DISABLE DISK I/O STATISTICS (UFS)
devices=(
  "/sys/block/sda/queue/iostats"
  "/sys/block/sdb/queue/iostats"
  "/sys/block/sdc/queue/iostats"
  "/sys/block/sdd/queue/iostats"
  "/sys/block/sde/queue/iostats"
  "/sys/block/sdf/queue/iostats"
)

for device in "${devices[@]}"
do
  echo "0" > "$device"
done

# DISABLE IO DEBUGGING
for queue in /sys/block/*/queue; do
    echo 0 > "${queue}/iostats"
    echo 0 > "${queue}/add_random"
    echo 0 > "${queue}/nomerges"
    echo 0 > "${queue}/rq_affinity"
    echo 0 > "${queue}/rotational"
done

# DISABLE A FEW MINOR AND OVERALL PRETTY USELESS MODULES FOR SLIGHTLY BETTER BATTERY LIFE & SYSTEM WIDE PERFORMANCE
echo "0" > /sys/module/battery/parameters/debug_mask
echo "0" > /sys/module/binder_alloc/parameters/debug_mask
echo "0" > /sys/module/binder/parameters/debug_mask
echo "0" > /sys/module/cam_debug_util/parameters/debug_mdl
echo "0" > /sys/module/debug/parameters/enable_event_log
echo "0" > /sys/module/glink/parameters/debug_mask
echo "0" > /sys/module/lowmemorykiller/parameters/debug_level
echo "0" > /sys/module/msm_show_resume_irq/parameters/debug_mask
echo "0" > /sys/module/msm_smd/parameters/debug_mask
echo "0" > /sys/module/msm_smem/parameters/debug_mask
echo "0" > /sys/module/mhi_qcom/parameters/debug_mode
echo "0" > /sys/module/hid_apple/parameters/fnmode
echo "0" > /sys/module/hid_magicmouse/parameters/scroll_speed
echo "0" > /sys/module/hid/parameters/debug
echo "0" > /sys/module/hid_apple/parameters/iso_layout
echo "0" > /sys/module/edac_core/parameters/edac_mc_log_ue
echo "0" > /sys/module/event_timer/parameters/debug_mask
echo "0" > /sys/module/drm/parameters/debug
echo "0" > /sys/module/ppp_generic/parameters/mp_protocol_compress
echo "0" > /sys/module/msm_vidc_dyn_gov/parameters/debug
echo "0" > /sys/module/sit/parameters/log_ecn_error
echo "0" > /sys/module/smp2p/parameters/debug_mask
echo "0" > /sys/module/msm_vidc_ar50_dyn_gov/parameters/debug
echo "0" > /sys/module/usb_bam/parameters/enable_event_log
echo "0" > /sys/module/printk/parameters/console_suspend
echo "0" > /sys/module/suspend/parameters/pm_test_delay
echo "0" > /sys/module/scsi_mod/parameters/scsi_logging_level
echo "0" > /sys/module/dns_resolver/parameters/debug
echo "0" > /proc/sys/debug/exception-trace
echo "0 0 0 0" > /proc/sys/kernel/printk
echo "0" > /sys/kernel/printk_mode/printk_mode
echo "0" > /proc/sys/kernel/compat-log
echo "0" > /sys/module/printk/parameters/time
echo "0" > /sys/module/rpm_smd/parameters/debug_mask
echo "0" > /sys/module/rmnet_data/parameters/rmnet_data_log_level
echo "0" > /sys/module/dwc3_msm/parameters/disable_host_mode
echo "0" > /sys/module/msm_smd_pkt/parameters/debug_mask
echo "0" > /sys/module/millet_core/parameters/millet_debug
echo "0" > /proc/sys/migt/migt_sched_debug
echo "Y" > /sys/module/msm_drm/parameters/backlight_dimmer
echo "0" > /sys/module/edac_core/parameters/edac_mc_log_ce

# DISABLE XIAOMI PROGRAM DEBUGGING
resetprop sys.miui.ndcd off

sleep 1
# Sync before execute to avoid crashes
sync