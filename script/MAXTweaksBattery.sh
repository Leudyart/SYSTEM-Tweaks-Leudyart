#!/system/bin/sh
# This script will be executed in late_start service mode
# IMPROVES THE ABILITY TO CONTROL PROCESSOR PERFORMANCE TO FACILITATE THE USE OF CUSTOM SCHEDULING STRATEGIES.
# TwMaxU.SmartBattery17.sh
# Author: Leudyart@  © 2023
# Pause script execution a little for Magisk Boot Service
sleep 5

# Maximum unsigned integer size in C
UINT_MAX="4294967295"

# Get total size memory
memTotal=$(free -m | awk '/^Mem:/{print $2}')

# Duration in nanoseconds of one scheduling period
SCHED_PERIOD=$((4*1000*1000))

# How many tasks should we have at a maximum in one scheduling period
SCHED_TASKS="8"

# ---------------------- 
# Basic tool functions
# ---------------------- 
# Safely write value to file
write() {
	# Bail out if file does not exist
	if [[ ! -f "$1" ]]
	then
		echo "Failed $1 does not exist"
		return 1
	fi
	
	local current=$(cat "$1")

	# Bail out if value is already set
	if [[ "$current" == "$2" ]]
	then
		echo "Success $1: $current --> $2"
		return 0
	fi

	# Write the new value
	echo "$2" > "$1"

	# Bail out if write fails
	if [[ $? -ne 0 ]]
	then
		err "Failed to write $2 to $1"
		return 1
	fi

	echo "Success $1: $current --> $2"
}
# -----------------------------------------

# SET WINDOW ANIMATION SCALE TO 0.0X
#su -c "settings put global window_animation_scale 0.0"

# SET TRANSITION ANIMATION SCALE TO 0.0X
#su -c "settings put global transition_animation_scale 0.0"

# SET ENTERTAINER DURATION SCALE TO 0.1X
#su -c "settings put global animator_duration_scale 0.1"

# RESTRICT A SPECIFIC APPLICATION IN THE BACKGROUND
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.facebook.katana 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.google.android.apps.maps 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.alibaba.aliexpresshd 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.google.android.gm 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.facebook.orca 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED video.player.videoplayer 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.instagram.android 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED net.fast_notepad_notes_app.fastnotepad 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED eu.thedarken.sdm 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED pl.solidexplorer2 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED sinet.startup.inDriver 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.ubercab 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED com.adobe.reader 0"
su -c "settings put global RUN_IN_BACKGROUND_ALLOWED flar2.devcheck 0"

su -c "settings put global BACKGROUND_START_ENABLED com.facebook.katana 0"
su -c "settings put global BACKGROUND_START_ENABLED com.google.android.apps.maps 0"
su -c "settings put global BACKGROUND_START_ENABLED com.alibaba.aliexpresshd 0"
su -c "settings put global BACKGROUND_START_ENABLED com.google.android.gm 0"
su -c "settings put global BACKGROUND_START_ENABLED com.facebook.orca 0"
su -c "settings put global BACKGROUND_START_ENABLED video.player.videoplayer 0"
su -c "settings put global BACKGROUND_START_ENABLED com.instagram.android 0"
su -c "settings put global BACKGROUND_START_ENABLED net.fast_notepad_notes_app.fastnotepad 0"
su -c "settings put global BACKGROUND_START_ENABLED eu.thedarken.sdm 0"
su -c "settings put global BACKGROUND_START_ENABLED pl.solidexplorer2 0"
su -c "settings put global BACKGROUND_START_ENABLED sinet.startup.inDriver 0"
su -c "settings put global BACKGROUND_START_ENABLED com.ubercab 0"
su -c "settings put global BACKGROUND_START_ENABLED com.adobe.reader 0"
su -c "settings put global BACKGROUND_START_ENABLED flar2.devcheck 0"

# ARRAY WITH PACKAGE NAMES OF THE APPLICATIONS TO KEEP RUNNING IN THE BACKGROUND
package_names=(
    "com.omarea.vtools"
    "com.mgoogle.android.gms"
    "com.dolby.daxappui"
    "com.dolby.daxservice"
    "com.whatsapp"
    "com.google.android.inputmethod.latin"
    "com.android.systemui"
)

# ITERATE THROUGH THE ARRAY AND DISABLE POWER OPTIMIZATIONS FOR EACH APPLICATION
for package_name in "${package_names[@]}"; do
    su -c "dumpsys deviceidle whitelist +$package_name"
    echo "Power optimizations disabled for the application $package_name."

# ANDROID PARAMETER TCP OPTIMIZATION TO IMPROVE NETWORK STABILITY AND LOAD CAPACITY
#It will scan which TCP congestion control algorithms in Android the kernel supports and of those compatible. Only one TCP congestion control algorithm will be applied, in this order as priority #1.BBR2 algorithm, #2.BBR algorithm, #3.CUBIC algorithm, #4. westwood algorithm
# Define the priority list of congestion control algorithms
algorithms=(bbr2 bbr cubic westwood)

for algorithm in "${algorithms[@]}"; do
  if grep -q "$algorithm" /proc/sys/net/ipv4/tcp_available_congestion_control; then
    echo "$algorithm" > /proc/sys/net/ipv4/tcp_congestion_control && break
  fi
done  

# WILL ENABLE ECN TRADING ON YOUR SYSTEM, CONGESTION CONTROL MECHANISM THAT ALLOWS ROUTERS TO SIGNAL CONGESTION TO END HOSTS WITHOUT DROPPING PACKETS
echo "1" > /proc/sys/net/ipv4/tcp_ecn
# TCP FAST OPEN IS ENABLED FOR CLIENT AND SERVER CONNECTIONS..TCP FAST OPEN IS A PERFORMANCE OPTIMIZATION THAT ALLOWS FOR FASTER CONNECTION ESTABLISHMENT.
echo "3" > /proc/sys/net/ipv4/tcp_fastopen
# DISABLE CONNECTION DUPLICATE DETECTION
echo "0" > /proc/sys/net/ipv4/tcp_syncookies

# DEFINE TCP BUFFER SIZES FOR VARIOUS NETWORKS
resetprop net.tcp.buffersize.default "6144,87380,1048576,6144,87380,524288"
resetprop net.tcp.buffersize.wifi "524288,1048576,2097152,524288,1048576,2097152"
resetprop net.tcp.buffersize.umts "6144,87380,1048576,6144,87380,524288"
resetprop net.tcp.buffersize.gprs "6144,87380,1048576,6144,87380,524288"
resetprop net.tcp.buffersize.edge "6144,87380,524288,6144,16384,262144"
resetprop net.tcp.buffersize.hspa "6144,87380,524288,6144,16384,262144"
resetprop net.tcp.buffersize.lte "524288,1048576,2097152,524288,1048576,2097152"
resetprop net.tcp.buffersize.hsdpa "6144,87380,1048576,6144,87380,1048576"
resetprop net.tcp.buffersize.evdo_b "6144,87380,1048576,6144,87380,1048576"
resetprop net.udp.buffersize.lte "524288,1048576,2097152,524288,1048576,2097152"

sleep 1
# Sync before execute to avoid crashes
sync

# THIS WILL DETECT ALL APPLICATIONS INSTALLED ON YOUR ANDROID SYSTEM THAT ARE NOT COMPATIBLE WITH ART AND INSTRUCT THESE APPLICATIONS TO USE DALVIK TO RUN AND COMPILE. FOR APPLICATIONS THAT SUPPORT ART, THE SCRIPT WILL SET THE RUNTIME TO ART. FOR APPLICATIONS THAT SUPPORT BOTH ART AND DALVIK, THE SCRIPT WILL PRIORITIZE ART AS THE FIRST OPTION TO USE.FORCE THE ANDROID RUNTIME (ART) TO COMPILE MORE BYTECODE INTO MACHINE CODE
# CHECK IF THE DEVICE IS USING ART
is_art=$(getprop ro.runtime.type)
if [[ "$is_art" != "art" ]]; then
   echo "Device is not using ART. Enabling ART..."
   setprop persist.sys.dalvik.vm.lib libart.so
fi

# GET THE LIST OF INSTALLED APPLICATIONS
apps=$(pm list packages -f | awk '{print $2}')

# ITERATE OVER EACH APPLICATION
for app in $apps; do
   
# GET THE INSTALLATION LOCATION AND OPTIMIZATION STATUS OF THE APPLICATION
   compatibility=$(pm get-install-location "$app")
   dexoptStatus=$(pm get-dexopt-status "$app")

# SET THE INSTALLATION LOCATION OF THE APPLICATION
   if [[ "$compatibility" != "auto" ]]; then
# IF THE INSTALL LOCATION IS NOT AUTO, SET IT TO INTERNAL MEMORY
      pm set-install-location "$app" 0
   elif [[ "$dexoptStatus" =~ "art" ]]; then
# IF THE OPTIMIZATION STATUS INDICATES THAT ART IS BEING USED, SET THE LOCATION TO INTERNAL MEMORY
      pm set-install-location "$app" 1
   else
# IN ANY OTHER CASE, SET THE LOCATION TO INTERNAL MEMORY
      pm set-install-location "$app" 1
   fi

# COMPILE ALL BYTECODE INTO MACHINE CODE
find /data/app/ -type f -name '*.apk' -exec sh -c 'java -Xmx2g -jar /system/framework/art/dex2oat.jar -o /data/art/bytecode -j 4 "{}"' ;
done

sleep 2
# MSM_THERMAL AND CORE_CONTROL
if [ -d /sys/module/msm_thermal ]; then
     echo "1" > /sys/module/msm_thermal/parameters/enabled
     echo "1" > /sys/module/msm_thermal/core_control/enabled
     echo "0" > /sys/module/msm_thermal/vdd_restriction/enabled
fi

# GPU FREQUENCY GOVERNOR TYPE
#echo "performance" > /sys/kernel/gpu/gpu_governor
echo "msm-adreno-tz" > /sys/class/kgsl/kgsl-3d0/devfreq/governor
echo "msm-adreno-tz" > /sys/kernel/gpu/gpu_governor

# GPU TWEAKS ADRENO(POWER SAVING)
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/throttling
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/force_clk_on
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/force_bus_on
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/force_rail_on
sudo echo "1" > /sys/class/kgsl/kgsl-3d0/bus_split
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/devfreq/adrenoboost
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/force_no_nap
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/force_bus_on
sudo echo "3" > /sys/class/kgsl/kgsl-3d0/min_pwrlevel
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/max_pwrlevel
sudo echo "1" > /sys/class/kgsl/kgsl-3d0/pwrnap
sudo echo "0" > /sys/class/kgsl/kgsl-3d0/popp
sudo echo "1" > /proc/gpufreq/gpufreq_limited_low_batt_volt_ignore
sudo echo "1" > /proc/gpufreq/gpufreq_limited_thermal_ignore

# DISABLE ADRENO SNAPSHOT CRASHDUMPER
echo "0" > /sys/class/kgsl/kgsl-3d0/snapshot/snapshot_crashdumper

# GPU BOOST GPU FREQUENCY POWER SAVING
sudo echo "160000000" > /sys/class/kgsl/kgsl-3d0/devfreq/min_freq

# MODULE ADRENO IDLER
sudo echo "1" > /sys/module/adreno_idler/parameters/adreno_idler_active

# ENABLE THE AGILE EXECUTION ALGORITHM
echo "sched_enable_agile_execution=1" >> /etc/sysctl.conf

# ENABLE THE POWERHAL ALGORITHM
echo "powerhal.enable=1" >> /etc/sysctl.conf

# ENABLE THE PROCESS FREEZING ALGORITHM
echo "process_freezing.enable=1" >> /etc/sysctl.conf

# CPUSET SETTINGS (POWER SAVING)
echo "0-1" > /dev/cpuset/background/cpus
echo "0-1" > /dev/cpuset/background/effective_cpus
echo "0-3" > /dev/cpuset/system-background/cpus
echo "0-3" > /dev/cpuset/system-background/effective_cpus
echo "0-4" > /dev/cpuset/camera-daemon/cpus
echo "0-4" > /dev/cpuset/camera-daemon/effective_cpus
echo "0-4" > /dev/cpuset/camera-daemon-dedicated/cpus
echo "0-4" > /dev/cpuset/camera-daemon-dedicated/effective_cpus
echo "0-2" > /dev/cpuset/audio-app/cpus
echo "0-1,6-7" > /dev/cpuset/foreground/cpus
echo "0-1,6-7" > /dev/cpuset/foreground/effective_cpus
echo "0-7" > /dev/cpuset/top-app/cpus
echo "0-7" > /dev/cpuset/top-app/effective_cpus
echo "5-7" > /dev/cpuset/foreground/boost/cpus

# DEV STUNE BOOST (POWER SAVING)
# Foreground
echo "0" > /dev/stune/foreground/schedtune.boost
echo "0" > /dev/stune/foreground/schedtune.sched_boost
echo "0" > /dev/stune/foreground/schedtune.sched_boost_no_override
echo "0" > /dev/stune/foreground/schedtune.prefer_idle
echo "0" > /dev/stune/foreground/schedtune.colocate
echo "0" > /dev/stune/foreground/cgroup.clone_children
# Background
echo "0" > /dev/stune/background/schedtune.boost
echo "0" > /dev/stune/background/schedtune.colocate
echo "0" > /dev/stune/background/schedtune.sched_boost_enabled
echo "0" > /dev/stune/background/schedtune.prefer_idle
echo "0" > /dev/stune/background/schedtune.colocate
echo "0" > /dev/stune/background/cgroup.clone_children
# Stune Boost
echo "0" > /dev/stune/schedtune.boost
echo "0" > /dev/stune/schedtune.sched_boost
echo "0" > /dev/stune/schedtune.sched_boost_no_override
echo "0" > /dev/stune/schedtune.prefer_idle
echo "0" > /dev/stune/schedtune.colocate
echo "0" > /dev/stune/cgroup.clone_children
# Top app
echo "0" > /dev/stune/top-app/schedtune.boost
echo "0" > /dev/stune/top-app/schedtune.sched_boost
echo "0" > /dev/stune/top-app/schedtune.sched_boost_no_override
echo "0" > /dev/stune/top-app/schedtune.prefer_idle
echo "0" > /dev/stune/top-app/schedtune.colocate
echo "0" > /dev/stune/top-app/cgroup.clone_children
# Real time
echo "0" > /dev/stune/rt/schedtune.boost
echo "0" > /dev/stune/rt/schedtune.sched_boost
echo "0" > /dev/stune/rt/schedtune.sched_boost_no_override
echo "0" > /dev/stune/rt/schedtune.prefer_idle
echo "0" > /dev/stune/rt/schedtune.colocate
echo "0" > /dev/stune/rt/cgroup.clone_children
echo "0" > /dev/stune/nnapi-hal/schedtune.prefer_idle

# KERNEL PANIC OFF
echo "0" > /proc/sys/kernel/panic
echo "0" > /proc/sys/kernel/panic_on_oops
echo "0" > /proc/sys/kernel/panic_on_warn
echo "0" > /sys/module/kernel/parameters/panic
echo "0" > /sys/module/kernel/parameters/panic_on_warn
echo "0" > /sys/module/kernel/parameters/pause_on_oops
echo "0" > /proc/sys/kernel/softlockup_panic
echo "0" > /proc/sys/kernel/nmi_watchdog

# GROUPING TASKS TWEAK
echo 1 > /proc/sys/kernel/sched_autogroup_enabled

# DISABLE KERNEL SIDE NPU SYS_CACHE
echo "Y" > /sys/kernel/debug/npu/sys_cache_disable

# DISABLE SDE_ROTATOR0 KERNEL SYS_CACHE
if [ -d /sys/kernel/debug ]; then
    echo "1" > /sys/kernel/debug/sde_rotator0/disable_syscache
    echo "0" > /sys/kernel/debug/WMI0/wmi_enable
    echo "N" > /sys/kernel/debug/debug_enabled
    echo "N" > /sys/kernel/debug/sched_debug
fi

# RAM TWEAK ,ZRAM OPTIMIZATION (6GB of Ram or more)
su -c 'echo 0 > /sys/module/lowmemorykiller/parameters/enable_lmk'
su -c 'echo 30 > /proc/sys/vm/swappiness'
su -c 'echo 40 > /proc/sys/vm/vfs_cache_pressure'
su -c 'echo 8924 > /proc/sys/vm/extra_free_kbytes'
su -c 'echo 35 > /proc/sys/vm/watermark_scale_factor'
su -c 'echo 10 > /proc/sys/vm/stat_interval'
su -c 'echo lz4 > /sys/block/zram0/comp_algorithm'
su -c 'echo 0 > /proc/sys/vm/page-cluster'

# ZSWAP TWEAK
# Check if the kernel supports zswap
if [ -d /sys/module/zswap ]; then

    # Set the compressor to lz4
    echo lz4 > /sys/module/zswap/parameters/compressor
	
    # Set the zpool compressor to zsmalloc
    echo zsmalloc > /sys/module/zswap/parameters/zpool
else
    echo "Your kernel doesn't support zswap."
fi

# A MEDIUM VALUE THAT MAY PROVIDE A GOOD BALANCE BETWEEN PERFORMANCE AND FRAGMENTATION
su -c 'echo 50 > /proc/sys/vm/compaction_proactiveness'

swapoff /dev/block/zram0
su -c 'echo "3" > /proc/sys/vm/drop_caches'

# KERNEL WRITEBACK (6GB of Ram or more)
su -c 'echo "3000" > /proc/sys/vm/dirty_expire_centisecs'
su -c 'echo "1000" > /proc/sys/vm/dirty_writeback_centisecs'
su -c 'echo "4096" > /proc/sys/vm/min_free_kbytes'
su -c 'echo "20" > /proc/sys/vm/dirty_ratio'
su -c 'echo "20" > /proc/sys/vm/dirty_background_ratio'
su -c 'echo "75" > /proc/sys/vm/overcommit_ratio
su -c 'echo "700" > /proc/sys/vm/extfrag_threshold'
su -c 'echo "0" > /proc/sys/vm/compact_unevictable_allowed'
su -c 'echo "0" > /proc/sys/vm/compact_memory'

# DEFINES THE L1 AND L2 CACHE SIZES IN KB
L1_CACHE_SIZE=64
L2_CACHE_SIZE=1024

# Get the list of CPU cores
cores=$(seq 0 7)

for core in $cores; do
# Set the L1 cache size for the current core
  echo "$L1_CACHE_SIZE" > /sys/devices/system/cpu/cpu$core/cache/index0/size

# Set the L2 cache size for the current core
  echo "$L2_CACHE_SIZE" > /sys/devices/system/cpu/cpu$core/cache/index2/size

# Activate the "keep" option for L1 and L2
  echo 1 > /sys/devices/system/cpu/cpu$core/cache/index0/keep
  echo 1 > /sys/devices/system/cpu/cpu$core/cache/index2/keep
done

# LMK (LOW MEMORY KILLER) OPTIMIZATION ON AN ANDROID SYSTEM WITH 6GB OF RAM
#echo "18432,23040,27648,32256,36864,55296" > /sys/module/lowmemorykiller/parameters/minfree

# ZRAM PARTITION PARAMETER ADJUSTMENT
echo "128" > /sys/block/zram0/queue/read_ahead_kb
echo "32" > /sys/block/zram0/queue/nr_requests

# DISABLE MEMPLUS PREFETCHER
echo "false" > /prop persist.vendor.sys.memplus.enable
echo "0" > /sys/module/memplus_core/parameters/memory_plus_enabled
echo "0" > /proc/sys/vm/memory_plus

# MODIFY THE VALUE OF (READ_AHEAD_KB) TO IMPROVE SYSTEM PERFORMANCE
while read dev; do
   echo "128" > /sys/devices/virtual/block/$dev/queue/read_ahead_kb
done < <(echo "ram0 ram1 ram2 ... ram15")

if [ -d /sys/devices/virtual/block/zram0 ]; then
   echo "128" > /sys/devices/virtual/block/zram0/queue/read_ahead_kb
fi

# EMMC TURBO WRITE TWEAK
if [ -e /sys/devices/platform/soc/$BT/emmc_tw_enable ]; then
  echo 1 > /sys/devices/platform/soc/$BT/emmc_tw_enable
else
  echo "Your kernel doesn't have EMMC Turbo Write Support."
fi

# UFS TURBO WRITE TWEAK
if [ -e /sys/devices/platform/soc/$BT/ufstw_lu0/tw_enable ]; then
  echo 1 > /sys/devices/platform/soc/$BT/ufstw_lu0/tw_enable
else
  echo "Your kernel doesn't have UFS Turbo Write Support."
fi
sleep 2
# CHECKPOINT INTERVAL CONFIGURATION FOR F2FS
echo "30" > /sys/fs/f2fs_dev/mmcblk0p79/cp_interval
echo "30" > /sys/fs/f2fs/dm-0/cp_interval

# DATA PARTITION I/O CONTROLLER OPTIMIZATION
echo "128" > /sys/block/mmcblk0/queue/read_ahead_kb
echo "128" > /sys/block/mmcblk1/queue/read_ahead_kb
echo "128" > /sys/block/sda/queue/read_ahead_kb
echo "128" > /sys/block/sde/queue/read_ahead_kb
echo "128" > /sys/block/sdb/queue/read_ahead_kb
echo "32" > /sys/block/sda/queue/nr_requests
echo "32" > /sys/block/sde/queue/nr_requests
echo "64" > /sys/block/mmcblk0/queue/nr_requests
echo "64" > /sys/block/mmcblk1/queue/nr_requests
echo "64" > /sys/block/mmcblk0rpmb/queue/nr_requests
echo "128" > /sys/block/mmcblk0/queue/max_sectors_kb
echo "128" > /sys/block/mmcblk1/queue/max_sectors_kb
echo "128" > /sys/block/mmcblk0rpmb/queue/max_sectors_kb
echo "134217728" > /sys/block/mmcblk0/queue/discard_max_bytes
echo "134217728" > /sys/block/mmcblk1/queue/discard_max_bytes
echo "134217728" > /sys/block/mmcblk0rpmb/queue/discard_max_bytes

# DISABLE UNNECESSARY RAMDUMPS
if [ -d "/sys/module/subsystem_restart/parameters" ]; then
   echo "0" > /sys/module/subsystem_restart/parameters/enable_ramdumps
   echo "0" > /sys/module/subsystem_restart/parameters/enable_mini_ramdumps
fi

# OOM KILLER DUMP TASK
echo "0" > /proc/sys/vm/oom_dump_tasks
echo "0" > /proc/sys/vm/panic_on_oom
echo "0" > /proc/sys/vm/oom_kill_allocating_task
echo "0" > /proc/sys/vm/reap_mem_on_sigkill

# DISABLE SPI CRC
if [ -d $MC ]; then
     echo "[$(date "+%H:%M:%S")] Disabling Spi CRC" >> $LOG
     echo 0 > $MC/parameters/use_spi_crc
fi

# USE DEEP FOR ADDITIONAL POWER SAVINGS DURING IDLE
echo "deep" > /sys/power/mem_sleep

# ENABLE FAST CHARGE FOR SLIGHTLY FASTER BATTERY CHARGING WHEN BEING CONNECTED TO A USB 3.1 PORT
if [ -d /sys/kernel/fast_charge ]; then
echo "1" > /sys/kernel/fast_charge/force_fast_charge
fi

# DISABLE TOUCHBOOST
echo "0" > /sys/module/msm_performance/parameters/touchboost
echo "0" > /sys/power/pnpmgr/touch_boost

sleep 2
# KERNEL SOUND SETTINGS ADJUST (GAIN)
# Function to adjust the gain for a specific sound control directory
adjust_gain() {
  local directory="$1"
  echo "14 14" > "$directory/headphone_gain"
  echo "17" > "$directory/mic_gain"
  echo "12" > "$directory/earpiece_gain"
}

# Find all of the sound control directories
sound_control_directories=$(find /sys/kernel/sound_control -type d)

# Check if the /sys/kernel/sound_control directory exists
if [ -d /sys/kernel/sound_control ]; then
  # Iterate over each sound control directory and adjust the gain
  for directory in $sound_control_directories; do
    adjust_gain "$directory"
else
  echo "The /sys/kernel/sound_control directory does not exist."
fi

# PROGRAMMER DEBUGGING FUNCTIONS (SCHEDULER FEATURES) TWEAK THE KERNEL TASK SCHEDULER FOR IMPROVED OVERALL SYSTEM PERFORMANCE AND USER INTERFACE RESPONSIVNESS DURING ALL KIND OF POSSIBLE WORKLOAD BASED SCENARIOS
# Check if the /sys/kernel/debug directory exists
if [ -d "/sys/kernel/debug" ]; then
  # Enable the following features in the kernel scheduler
  echo "NEXT_BUDDY" > /sys/kernel/debug/sched_features
  echo "ARCH_POWER" > /sys/kernel/debug/sched_features
  echo "UTIL_EST" > /sys/kernel/debug/sched_features
  echo "ENERGY_AWARE" > /sys/kernel/debug/sched_features
  echo "NO_DOUBLE_TICK" > /sys/kernel/debug/sched_features
  echo "RT_RUNTIME_SHARE" > /sys/kernel/debug/sched_features
  echo "TTWU_QUEUE" > /sys/kernel/debug/sched_features
fi

# GOOGLE "SCHEDUTIL" FREQUENCY RATE LIMITS IN THE "SCHEDUTIL" FREQUENCY GOVERNOR PIXEL 3 RATE-LIMITS
# Find all of the CPU cores
cpus=$(find /sys/devices/system/cpu -type d)

# Check if the kernel supports schedutil scheduler
for cpu in $cpus; do
   if grep -q "schedutil" /sys/$cpu/cpufreq/scaling_governor; then
     # Set the up_rate_limit_us and down_rate_limit_us parameters
     echo 500 > /sys/$cpu/cpufreq/schedutil/up_rate_limit_us
     echo 20000 > /sys/$cpu/cpufreq/schedutil/down_rate_limit_us
     echo "Applied schedutil rate-limits from Pixel 3 to $cpu" >> /tmp/schedutil_limits.log
   else
     echo "You are not using schedutil governor on $cpu" >> /tmp/schedutil_limits.log
   fi
done

sleep 3
# FIX GMS DISABLE...
su -c pm disable com.google.android.gms/.chimera.GmsIntentOperationService
su -c pm disable com.google.android.apps.messaging/.shared.analytics.recurringmetrics..AnalyticsAlarmReceiver
su -c pm disable com.google.android.location.internal.UPLOAD_ANALYTICS
su -c pm disable com.facebook.orca/com.facebook.analytics.apptatelogger.AppStateIntentService
su -c pm disable com.facebook.orca/com.facebook.analytics2.Logger.LollipopUploadService
su -c pm disable com.google.android.gms/com.google.android.gms.nearby.bootstrap.service.NearbyBootstrapService
su -c pm disable com.google.android.gms/NearbyMessagesService
su -c pm disable com.google.android.gms/com.google.android.gms.nearby.connection.service.NearbyConnectionsAndroidService
su -c pm disable com.google.android.gms/com.google.location.nearby.direct.service.NearbyDirectService
su -c pm disable com.google.android.gms/com.google.android.gms.lockbox.LockboxService
su -c pm disable com.google.android.gms/.measurement.PackageMeasurementTaskService
su -c pm disable com.google.android.gms/com.google.android.gms.auth.trustagent.GoogleTrustAgent
su -c pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsTaskService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.cache.CacheBrokerService
su -c pm disable com.google.android.gms/com.android.billingclient.api.ProxyBillingActivity
su -c pm disable com.google.android.gms/com.google.android.gms.ads.measurement.GmpConversionTrackingBrokerService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.config.FlagsReceiver
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.service.MeasurementBrokerService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.adinfo.AdvertisinglnfoContentProvider
su -c pm disable com.google.android.gms/com.google.android.gms.ads.AdRequestBrokerService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.jams.NegotiationService
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.social.GcmSchedulerWakeupService
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementTaskService
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.PackageMeasurementReceiver
su -c pm disable com.google.android.gms/com.google.android.gms.ads.identifier.service.AdvertisingldService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.GservicesValueBrokerService
su -c pm disable com.google.android.gms/com.google.android.gms.ads.settings.AdsSettingsActivity
su -c pm disable com.google.android.gms/com.google.android.gms.ads.identifier.service.AdvertisingldNotificationService

sleep 3
# DISABLE ANALYTICS SERVICE
su -c pm disable com.android.statementservice/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.maps/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.messaging/com.google.android.apps.messaging.shared.analytics.recurringmetrics.AnalyticsAlarmReceiver
su -c pm disable com.google.android.apps.messaging/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.photos/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.restore/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.as/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.contacts/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.dialer/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.gm/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.google.android.gms/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.google.android.gms/com.google.android.gms.analytics.internal.PlayLogReportingService
su -c pm disable com.google.android.gms/com.google.android.gms.analytics.service.AnalyticsService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.AnalyticsTaskService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.ar.core.services.AnalyticsService 
su -c pm disable com.google.android.apps.messaging.shared.analytics.recurringmetrics.AnalyticsAlarmReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics2.logger.AlarmBasedUploadService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics2.logger.LollipopUploadService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics2.logger.GooglePlayUploadService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics2.logger.HighPriUploadRetryReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics.appstatelogger.AppStateBroadcastReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.analytics.appstatelogger.AppStateIntentService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.adspayments.analytics.ExperimentExposeService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.internal.GServicesChangedReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.AnalyticsService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.internal.PlayLogReportingService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.service.AnalyticsService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.service.PlayLogMonitorIntervalService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.analytics.service.RefreshEnabledStateService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.common.analytics.CoreAnalyticsIntentService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.policy_sidecar_aps.common.analytics.CoreAnalyticsReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.gameanalytics.sdk.errorreporter.GameAnalyticsExceptionReportService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.samsung.android.hmt.vrsvc.receiver.AnalyticsLogReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.projection.gearhead/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.settings.intelligence/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.vanced.android.youtube/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.android.vending/com.google.android.gms.measurement.AppMeasurementJobService
su -c pm disable com.android.vending/com.google.android.gms.measurement.AppMeasurementReceiver
su -c pm disable com.android.vending/com.google.android.gms.measurement.AppMeasurementService
su -c pm disable com.google.android.apps.photos/com.google.android.gms.measurement.AppMeasurementJobService
su -c pm disable com.google.android.apps.photos/com.google.android.gms.measurement.AppMeasurementReceiver
su -c pm disable com.google.android.apps.photos/com.google.android.gms.measurement.AppMeasurementService
su -c pm disable com.google.android.calculator/com.google.android.gms.measurement.AppMeasurementJobService
su -c pm disable com.google.android.calculator/com.google.android.gms.measurement.AppMeasurementReceiver
su -c pm disable com.google.android.calculator/com.google.android.gms.measurement.AppMeasurementService
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementJobService
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementReceiver
su -c pm disable com.google.android.gms/com.google.android.gms.measurement.AppMeasurementService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.measurement.AppMeasurementInstallReferrerReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.measurement.AppMeasurementJobService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.measurement.AppMeasurementReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.measurement.AppMeasurementContentProvider
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.measurement.AppMeasurementService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gearhead.telemetry.InstallReferrerReceiver
su -c pm disable com.google.android.projection.gearhead/com.google.android.gearhead.telemetry.InstallReferrerReceiver
su -c pm disable com.google.android.syncadapters.contacts/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.xiaomi.misettings/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.cameralite/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.gcs/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.helprtc/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.nbu.files/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.recorder/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.safetyhub/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.security.securityhub/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.wearables.maestro.companion/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.work.clouddpc/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.calendar/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.googlequicksearchbox/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.odad/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.tts/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.ar.core/com.google.ar.core.services.AnalyticsService
su -c pm disable com.google.ar.core/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.motorola.dolby.dolbyui/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.GoogleCameraEng/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.google.android.GoogleCameraEng/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.google.android.GoogleCameraEng/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.analytics.tracking.android.CampaignTrackingReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.analytics.tracking.android.CampaignTrackingService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.CampaignTrackingService
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.gms.analytics.CampaignTrackingReceiver
su -c pm disable com.google.android.projection.gearhead/com.google.android.gms.analytics.CampaignTrackingService
su -c pm disable com.google.android.apps.docs/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.google.android.apps.messaging.shared.analytics.recurringmetrics.AnalyticsAlarmReceiver
su -c pm disable com.google.android.ims/androidx.work.impl.diagnostics.DiagnosticsReceiver

# ANALYTIC & MEASUREMENT & TRACKING SERVICE FOR USER APPS
su -c pm disable com.whatsapp/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.whatsapp/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.whatsapp/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.whatsapp/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.facebook.katana/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.facebook.katana/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.facebook.katana/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.facebook.katana/com.facebook.analytics2.logger.AlarmBasedUploadService
su -c pm disable com.facebook.katana/com.facebook.analytics2.logger.LollipopUploadService
su -c pm disable com.facebook.katana/com.facebook.analytics2.logger.GooglePlayUploadService
su -c pm disable com.facebook.katana/com.facebook.analytics2.logger.HighPriUploadRetryReceiver
su -c pm disable com.facebook.katana/com.facebook.analytics.appstatelogger.AppStateBroadcastReceiver
su -c pm disable com.facebook.katana/com.facebook.analytics.appstatelogger.AppStateIntentService
su -c pm disable com.facebook.katana/com.facebook.adspayments.analytics.ExperimentExposeService
su -c pm disable com.instagram.android/com.instagram.common.analytics.phoneid.InstagramPhoneIdRequestReceiver
su -c pm disable com.instagram.android/com.instagram.analytics.uploadscheduler.AnalyticsUploadAlarmReceiver
su -c pm disable com.instagram.android/com.facebook.analytics2.logger.AlarmBasedUploadService
su -c pm disable com.instagram.android/com.facebook.analytics2.logger.LollipopUploadService
su -c pm disable com.instagram.android/com.facebook.analytics2.logger.GooglePlayUploadService
su -c pm disable com.instagram.android/com.facebook.analytics2.logger.HighPriUploadRetryReceiver
su -c pm disable com.instagram.android/com.facebook.analytics.appstatelogger.AppStateBroadcastReceiver
su -c pm disable com.instagram.android/com.facebook.analytics.appstatelogger.AppStateIntentService
su -c pm disable com.adobe.lrmobile/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.adobe.reader/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.adobe.scan.android/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.coolapk.market/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.digipom.easyvoicerecorder.pro/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.handmark.expressweather/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.instagram.android/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.mcdo.mcdonalds/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.mcdo.mcdonalds/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.mcdo.mcdonalds/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.mcdo.mcdonalds/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.mcdo.mcdonalds/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.mcdo.mcdonalds/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.microsoft.office.word/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.microsoft.teams/com.firebase.jobdispatcher.GooglePlayReceiver
su -c pm disable com.microsoft.teams/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.miui.gallery/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.miui.mediaeditor/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.yahoo.mobile.client.android.mail/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.yahoo.mobile.client.android.mail/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.yahoo.mobile.client.android.mail/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.yahoo.mobile.client.android.mail/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.yahoo.mobile.client.android.mail/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.yahoo.mobile.client.android.mail/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable ir.ilmili.telegraph/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable mx.com.miapp/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable org.zwanoo.android.speedtest/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable org.zwanoo.android.speedtest/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable org.zwanoo.android.speedtest/com.google.android.gms.analytics.AnalyticsService
su -c pm disable org.zwanoo.android.speedtest/com.google.android.gms.analytics.AnalyticsService
su -c pm disable pl.solidexplorer2/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.magazines/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.google.android.apps.magazines/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.google.android.apps.magazines/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.google.android.apps.magazines/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.google.android.apps.magazines/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.alibaba.analytics.AnalyticsService
su -c pm disable com.facebook.analytics2.logger.service.LollipopUploadSafeService
su -c pm disable com.vanced.android.youtube/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.alibaba.aliexpresshd/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.amazon.mShop.android.shopping/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.cris87.miui/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.speedymovil.wire/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable qrcodereader.barcodescanner.scan.qrscanner/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable video.player.videoplayer/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.facebook.orca/com.facebook.messaging.internalprefs.MessengerAnalyticsActivity
su -c pm disable com.facebook.orca/com.google.android.gms.analytics.AnalyticsService
su -c pm disable com.facebook.orca/com.google.android.gms.analytics.AnalyticsReceiver
su -c pm disable com.facebook.orca/com.google.android.gms.analytics.AnalyticsJobService
su -c pm disable com.facebook.katana/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.ubercab/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.ubercab/com.braintreepayments.api.internal.AnalyticsIntentService
su -c pm disable app.revanced.android.youtube/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.disruptorbeam.StarTrekTimelines/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.facebook.orca/com.facebook.analytics2.logger.AlarmBasedUploadService
su -c pm disable com.facebook.orca/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.translate/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.miui.videoplayer/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable sinet.startup.inDriver/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.apps.wellbeing/androidx.work.impl.diagnostics.DiagnosticsReceiver
su -c pm disable com.google.android.gms.policy_sidecar_aps/com.facebook.bugreporter.scheduler.AlarmsBroadcastReceiver
su -c pm disable com.google.android.keep/androidx.work.impl.diagnostics.DiagnosticsReceiver

# SET DEXOPT TO OPTIMIZE EVERYTHING
run_as_root "settings put global persist.bg.dexopt.enable true"
run_as_root "settings put global pm.dexopt.bg-dexopt everything"
run_as_root "settings put global pm.dexopt.forced-dexopt everything"
run_as_root "settings put global pm.dexopt.core-app everything"
run_as_root "settings put global pm.dexopt.install everything"
run_as_root "settings put global pm.dexopt.nsys-library everything"
run_as_root "settings put global pm.dexopt.shared-apk everything"
run_as_root "settings put global dalvik.vm.bg-dex2oat-threads 8"

# FORCE OPTIMIZATION OF ALL ANDROID SYSTEM APPS IN THE BACKGROUND
run_as_root "cmd package bg-dexopt-job"

# ENABLE DEX2OAT OPTIMIZATION
run_as_root "settings put global dex2oat-filter everything"

# START DEX2OAT OPTIMIZATION
run_as_root "cmd package compile-all -m speed"

# COMPILE THE APP'S LAYOUTS
run_as_root "pm compile --compile-layouts -a"

sleep 1
# DISABLING UNNECESSARY APPS ON ANDROID (AOSP)
su -c "pm disable com.google.android.as.oss"
su -c "pm disable com.google.android.apps.turbo"
su -c "pm disable com.google.android.projection.gearhead"
su -c "pm disable com.stevesoltys.seedvault"
su -c "pm disable com.android.emergency"
su -c "pm disable com.android.bips"
su -c "pm disable com.android.printspooler"
su -c "pm disable com.android.cellbroadcastreceiver.module"
su -c "pm disable com.google.audio.hearing.visualization.accessibility.scribe"
su -c "pm disable com.google.android.apps.safetyhub"
su -c "pm disable com.google.android.marvin.talkback"
su -c "pm disable com.google.android.apps.helprtc"
su -c "pm disable com.google.android.apps.work.clouddpc"
su -c "pm disable com.google.android.printservice.recommendation"
su -c "pm disable com.google.android.as"
su -c "pm disable oneos.logcat"
su -c "pm disable com.android.printspooler"
su -c "pm disable com.google.android.ambientcompute"
su -c "pm disable org.lineageos.profiles"
su -c "pm disable com.android.cellbroadcastreceiver.module"
su -c "pm disable com.android.emergency"
su -c "pm disable io.chaldeaprjkt.gamespace"
su -c "pm disable com.caf.fmradio"
su -c "pm disable org.lineageos.recorder"
su -c "pm disable com.crdroid.updater"

# DISABLING UNNECESSARY APPS ON ANDROID (AOSP)
# List of package names for the apps you want to freeze
apps_to_freeze=(
    "com.android.cellbroadcastservice"
    "com.android.companiondevicemanager"
    "com.android.cellbroadcastservice"
    "com.android.companiondevicemanager"
    "com.android.simappdialog"
    "org.lineageos.profiles"
    "com.android.ons"
    "com.android.stk"
    "com.crdroid.updater"
    "com.android.printspooler"
    "com.android.beeps"
    "com.android.cellbroadcastservice"
    "com.android.printservice.recommendation"
    "com.android.carrierdefaultapp"
    "org.lineageos.jelly"
    "com.android.dreams.phototable"
    "com.android.cellbroadcastreceiver.module"
    "com.android.bookmarkprovider"
    "com.caf.fmradio"
    "com.android.emergency"
    "org.omnirom.logcat"
    "com.google.android.onetimeinitializer"
    "com.google.android.apps.wellbeing"
    "com.google.android.as"
    "com.google.android.as.oss"
    "com.google.android.apps.turbo"
)

for app in "${apps_to_freeze[@]}"; do
    # Disable the app using pm command
    su -c "pm disable $app"
done

# UNINSTALL BLOATWARE
su -c "pm uninstall -k --user 0 com.google.android.settings.intelligence"
su -c "pm uninstall -k --user 0 com.android.providers.calendar"
su -c "pm uninstall -k --user 0 com.google.android.printservice.recommendation"
su -c "pm uninstall -k --user 0 com.google.android.apps.wellbeing"
su -c "pm uninstall -k --user 0 com.android.bips"
su -c "pm uninstall -k --user 0 com.android.printspooler"
su -c "pm uninstall -k --user 0 com.google.android.apps.turbo"

# FORCE CLOSE A PARTICULAR APP IN THE BACKGROUND
su -c "am force-stop com.facebook.katana"
su -c "am force-stop com.instagram.android"
su -c "am force-stop com.google.android.gm"

sleep 1
# MIUI BLOATWARE APPS (DISABLE)
su -c pm disable com.xiaomi.ab
su -c pm disable com.xiaomi.aiasst.service
su -c pm disable com.xiaomi.gamecenter.sdk.service
su -c pm disable com.xiaomi.joyose
su -c pm disable com.xiaomi.mi_connect_service
su -c pm disable com.xiaomi.micloud.sdk
su -c pm disable com.xiaomi.migameservice
su -c pm disable com.xiaomi.miplay_client
su -c pm disable com.xiaomi.mircs
su -c pm disable com.xiaomi.mirror
su -c pm disable com.xiaomi.payment
su -c pm disable com.xiaomi.powerchecker
su -c pm disable com.xiaomi.simactivate.service
su -c pm disable com.xiaomi.xmsf
su -c pm disable com.xiaomi.xmsfkeeper
su -c pm disable com.milink.service
su -c pm disable com.miui.analytics
su -c pm disable com.miui.audioeffect
su -c pm disable com.miui.audiomonitor
su -c pm disable com.miui.bugreport
su -c pm disable com.miui.cit
su -c pm disable com.miui.cloudbackup
su -c pm disable com.miui.cloudservice
su -c pm disable com.miui.cloudservice.sysbase
su -c pm disable com.miui.contentcatcher
su -c pm disable com.miui.daemon
su -c pm disable com.miui.hybrid
su -c pm disable com.miui.hybrid.accessory
su -c pm disable com.miui.maintenancemode
su -c pm disable com.miui.micloudsync
su -c pm disable com.miui.miservice
su -c pm disable com.miui.mishare.connectivity
su -c pm disable com.miui.misound
su -c pm disable com.miui.nextpay
su -c pm disable com.miui.personalassistant
su -c pm disable com.miui.phrase
su -c pm disable com.miui.smsextra
su -c pm disable com.miui.systemAdSolution
su -c pm disable com.miui.touchassistant
su -c pm disable com.miui.translation.kingsoft
su -c pm disable com.miui.translation.xmcloud
su -c pm disable com.miui.translation.youdao
su -c pm disable com.miui.translationservice
su -c pm disable com.miui.voiceassist
su -c pm disable com.miui.voicetrigger
su -c pm disable com.miui.vsimcore
su -c pm disable com.miui.wmsvc
su -c pm disable com.mobiletools.systemhelper
su -c pm disable com.android.browser
su -c pm disable com.android.carrierdefaultapp
su -c pm disable com.android.cellbroadcastservice
su -c pm disable com.android.companiondevicemanager
su -c pm disable com.android.dreams.basic
su -c pm disable com.android.dreams.phototable
su -c pm disable com.android.htmlviewer
su -c pm disable com.android.ons
su -c pm disable com.android.printspooler
su -c pm disable com.android.quicksearchbox
su -c pm disable com.android.simappdialog
su -c pm disable com.android.stk
su -c pm disable com.android.traceur
su -c pm disable com.bsp.catchlog
su -c pm disable com.google.android.configupdater
su -c pm disable com.google.android.marvin.talkback
su -c pm disable com.google.android.printservice.recommendation
su -c pm disable com.miui.msa.global
su -c pm disable com.google.android.feedback
su -c pm disable com.mfashiongallery.emag
su -c pm disable com.miui.huanji
su -c pm disable com.miui.newmidrive

sleep 2
# DISABLE FIRMWARE APPS
su -c pm disable com.qti.confuridialer
su -c pm disable com.qti.qualcomm.datastatusnotification
su -c pm disable com.qti.snapdragon.qdcm_ff
su -c pm disable com.qti.xdivert
su -c pm disable com.qualcomm.atfwd
su -c pm disable com.qualcomm.embms
su -c pm disable com.qualcomm.qcrilmsgtunnel
su -c pm disable com.qualcomm.qti.autoregistration
su -c pm disable com.qualcomm.qti.dynamicddsservice
su -c pm disable com.qualcomm.qti.lpa
su -c pm disable com.qualcomm.qti.remoteSimlockAuth
su -c pm disable com.qualcomm.qti.uim
su -c pm disable com.qualcomm.wfd.service
su -c pm disable com.wapi.wapicertmanage

# ENABLE WRITE-AHEAD LOGGING (WAL)
echo "PRAGMA journal_mode=WAL;" | sqlite3 database.db

# RELAX THE SYNCHRONIZATION MODE
echo "PRAGMA synchronous=OFF;" | sqlite3 database.db

# CREATE AN INDEX ON THE COLUMNS THAT ARE FREQUENTLY USED IN QUERIES
echo "CREATE INDEX index_name ON table_name (column_name);" | sqlite3 database.db

# COMPACT THE DATABASE
echo "VACUUM;" | sqlite3 database.db

# DELETE UNUSED TABLES AND INDEXES
echo "DROP TABLE table_name;" | sqlite3 database.db
echo "DROP INDEX index_name;" | sqlite3 database.db

# USE DISTINCT FOR UNIQUE VALUES
SELECT DISTINCT column_name FROM table_name;

# USE AGGREGATE FUNCTIONS WHENEVER POSSIBLE
SELECT COUNT(*) FROM table_name;

# USE COUNT() INSTEAD OF CURSOR.GETCOUNT()
int count = database.rawQuery("SELECT COUNT(*) FROM table_name", null).getCount();

# USE PREPARED STATEMENTS
String sql = "SELECT * FROM table_name WHERE column_name = ?";
SQLiteStatement statement = database.compileStatement(sql);
statement.bindString(1, "value");
ResultSet rs = statement.executeQuery();

# USE TROUBLESHOOTING TOOLS
sqlite3 database.db
.mode explain
.explain query

sleep 1
# Sync before execute to avoid crashes
sync

sleep 1
# ***** READ AND WRITE SPEED OPTIMIZATION ***** #
# Check if Magisk is installed
if [ -f /sbin/.magisk/busybox ]; then
   fstrim_command="/sbin/.magisk/busybox fstrim"
else
   fstrim_command="fstrim"
fi

# TRIM PARTITIONS
for point in /data /cache /system /vendor /preload /product; do
   $fstrim_command -v "$point"
   sync
done

# MODIFY THE BLKIO SCHEDULER TO IMPROVE PERFORMANCE
# Get the current blkio weights
foreground_weight=$(cat $BL/blkio.weight)
background_weight=$(cat $BL/background/blkio.weight)

# Get the current blkio group idle timeouts
foreground_group_idle=$(cat $BL/blkio.group_idle)
background_group_idle=$(cat $BL/background/blkio.group_idle)

# Set the new blkio weights
echo 1000 > $BL/blkio.weight
echo 200 > $BL/background/blkio.weight

# Set the new blkio group idle timeouts
echo 2000 > $BL/blkio.group_idle
echo 0 > $BL/background/blkio.group_idle

# Write a message to the log file
echo "[$(date "+%H:%M:%S")] Tweaked blkio..." >> $LOG

# Check if the blkio tweaking was successful
if [ "$foreground_weight" -eq 1000 ] && \
   [ "$background_weight" -eq 200 ] && \
   [ "$foreground_group_idle" -eq 2000 ] && \
   [ "$background_group_idle" -eq 0 ]; then
  echo "The blkio tweaking was successful."
else
  echo "The blkio tweaking was unsuccessful."
fi

# SET THE MAXIMUM RAM BUS FREQUENCY AS THE ONLY OPTION
# DETECT THE MAXIMUM FREQUENCY OF THE RAM MEMORY BUS
max_ram_freq=$(cat /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/available_frequencies | awk '{print $NF}' | sort -n | tail -n 1)

# Set maximum frequency as the only option
echo "$max_ram_freq" > /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/min_freq
echo "$max_ram_freq" > /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/max_freq

# Change file permissions related to ram frequency
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/min_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/max_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/min_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/max_freq

# Verify that the ram frequency has been set correctly
current_ram_freq=$(cat /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/cur_freq)

if [ "$current_ram_freq" != "$max_ram_freq" ]; then
  echo "Error: RAM frequency not set correctly."
  exit 1
fi

echo "The RAM memory frequency has been correctly set to $max_ram_freq MHz."
exit 0

# Exit script
exit 0

