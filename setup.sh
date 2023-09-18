##########################################################################################
#
# Magisk Module Installer Script
#
##########################################################################################
##########################################################################################
#
# Instructions:
#
# 1. Place your files into system folder (delete the placeholder file)
# 2. Fill in your module's info into module.prop
# 3. Configure and implement callbacks in this file
# 4. If you need boot scripts, add them into common/post-fs-data.sh or common/service.sh
# 5. Add your additional or modified system properties into common/system.prop
#
##########################################################################################
#!/sbin/sh

# Config Vars
# Set to true if you do *NOT* want Magisk to mount
# any files for you. Most modules would NOT want
# to set this flag to true
SKIPMOUNT=false

# Set to true if you need to load system.prop
PROPFILE=true

# Set to true if you need post-fs-data script
POSTFSDATA=true

# Set to true if you need late_start service script
LATESTARTSERVICE=true

# Info Print
# Set what you want to be displayed on header of installation process

info_print() {
  awk '{print}' "$MODPATH"/smooth_banner
}

# List all directories you want to directly replace in the system
# Check the documentations for more info why you would need this

# Construct your list in the following format
# This is an example
REPLACE_EXAMPLE="
/system/app/Youtube
/system/priv-app/SystemUI
/system/priv-app/Settings
/system/framework
"

# Construct your own list here
REPLACE="
"

ui_print "----------------------------------"
ui_print "█ █▄░█ █▀ ▀█▀ ▄▀█ █░░ █░░ █ █▄░█ █▀▀ ░ ░ ░"
ui_print "█ █░▀█ ▄█ ░█░ █▀█ █▄▄ █▄▄ █ █░▀█ █▄█ ▄ ▄ ▄"
ui_print "----------------------------------"

mf=$(getprop ro.boot.hardware)
soc=$(getprop ro.board.platform)
if [[ $soc == " " ]]; then
soc=$(getprop ro.product.board)
fi
api=$(getprop ro.build.version.sdk)
aarch=$(getprop ro.product.cpu.abi | awk -F- '{print $1}')
androidRelease=$(getprop ro.build.version.release)
dm=$(getprop ro.product.model)
socet=$(getprop ro.soc.model)
device=$(getprop ro.product.vendor.device)
magisk=$(magisk -c)
percentage=$(cat /sys/class/power_supply/battery/capacity)
memTotal=$(free -m | awk '/^Mem:/{print $2}')
rom=$(getprop ro.build.display.id)
romversion=$(getprop ro.vendor.build.version.incremental)
version="17.0"

ui_print ""
ui_print "----------------------------------"
ui_print "█ █▄░█ █▀▀ █▀█ █▀█ █▀▄▀█ ▄▀█ ▀█▀ █ █▀█ █▄░█"
ui_print "█ █░▀█ █▀░ █▄█ █▀▄ █░▀░█ █▀█ ░█░ █ █▄█ █░▀█"
ui_print "----------------------------------"
ui_print " --> Kernel: `uname -a`"
sleep 0.2
ui_print " --> Rom: $rom ($romversion)"
sleep 0.2
ui_print " --> Android Version: $androidRelease"
sleep 0.2
ui_print " --> Api: $api"
sleep 0.2
ui_print " --> SOC: $mf, $soc, $socet"
sleep 0.2
ui_print " --> CPU AArch: $aarch"
sleep 0.2
ui_print " --> Device: $dm ($device)"
sleep 0.2
ui_print " --> Battery charge level: $percentage%"
sleep 0.2
ui_print " --> Device total RAM: $memTotal MB"
sleep 0.2
ui_print " --> Magisk: $magisk"
sleep 0.2
ui_print " "
ui_print " --> Version tweaks: $version"
ui_print "----------------------------------"
ui_print ""

sleep 1.25

# INIT 

init_main() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  $BOOTMODE || abort "[!] Smooth tweaks cannot be installed in recovery, flash to magisk."

  ui_print "----------------------------------"
  ui_print "█▀▀ ▀▄▀ ▀█▀ █▀█ ▄▀█ █▀▀ ▀█▀ █ █▄░█ █▀▀"
  ui_print "██▄ █░█ ░█░ █▀▄ █▀█ █▄▄ ░█░ █ █░▀█ █▄█"
  ui_print ""
  ui_print "█▀▄▀█ █▀█ █▀▄ █░█ █░░ █▀▀"
  ui_print "█░▀░█ █▄█ █▄▀ █▄█ █▄▄ ██▄"
  ui_print ""
  ui_print "█▀▀ █ █░░ █▀▀ █▀"
  ui_print "█▀░ █ █▄▄ ██▄ ▄█"
  ui_print "----------------------------------"
  
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2
  
  ui_print ""
  sleep 1.25

  ui_print "----------------------------------"
  ui_print "█▀▄ █▀█ █▄░█ █▀▀"
  ui_print "█▄▀ █▄█ █░▀█ ██▄"
  ui_print "----------------------------------"
  
  ui_print ""
  sleep 1
  
  SCRIPT_PARENT_PATH="$MODPATH/script"
  SCRIPT_NAME="MAXTweaksBattery.sh"
  SCRIPT_PATH="$SCRIPT_PARENT_PATH/$SCRIPT_NAME"

  sleep 1

  ui_print "----------------------------------"
  ui_print "█▀█ █░█ █▄░█ █▄░█ █ █▄░█ █▀▀"
  ui_print "█▀▄ █▄█ █░▀█ █░▀█ █ █░▀█ █▄█"
  ui_print ""
  ui_print "█▀▀ █▀ ▀█▀ █▀█ █ █▀▄▀█"
  ui_print "█▀░ ▄█ ░█░ █▀▄ █ █░▀░█"
  ui_print "----------------------------------"
  
  fstrim -v /data
  fstrim -v /system
  fstrim -v /cache

  ui_print "----------------------------------"
  ui_print "█▀▄ █▀█ █▄░█ █▀▀"
  ui_print "█▄▀ █▄█ █░▀█ ██▄"
  ui_print "----------------------------------"

  ui_print ""
  sleep 1.25

  ui_print "----------------------------------"
  ui_print "█▄░█ █▀█ ▀█▀ █▀▀ █▀"
  ui_print "█░▀█ █▄█ ░█░ ██▄ ▄█"
  ui_print "----------------------------------"
  ui_print ""
  ui_print "❗ Reboot is required"
  sleep 1.5

  ui_print "----------------------------------"
  ui_print "█▀█ █▀▀ █▄▄ █▀█ █▀█ ▀█▀"
  ui_print "█▀▄ ██▄ █▄█ █▄█ █▄█ ░█░"
  ui_print ""
  ui_print "▀█▀ █▀█   █▀▀ █ █▄░█ █ █▀ █░█ ░"
  ui_print "░█░ █▄█   █▀░ █ █░▀█ █ ▄█ █▀█ ▄"
  ui_print "----------------------------------"
}

# Set permissions

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0644
  set_perm_recursive $SCRIPT_PATH root root 0777 0755
  set_perm_recursive $MODPATH/script 0 0 0755 0755
  set_perm_recursive $MODPATH/bin 0 0 0755 0755
  set_perm_recursive $MODPATH/system 0 0 0755 0755
  set_perm_recursive $MODPATH/system/bin 0 0 0755 0755
  set_perm_recursive $MODPATH/system/vendor 0 0 0755 0755
  set_perm_recursive $MODPATH/system/vendor/etc 0 0 0755 0755
}

# CHANGE THE PERMISSIONS OF THE DEVFREQ FILES
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/min_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-llcc-ddr-bw/max_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/min_freq
chmod 0444 /sys/class/devfreq/soc:qcom,cpu-cpu-llcc-bw/max_freq

# Set what you want to display when installing your module

print_modname() {
  ui_print "*******************************"
  ui_print "       SQLITE3 INSTALLER       "
  ui_print "*******************************"
}

# Copy/extract your module files into $MODPATH in on_install.

on_install() {
  # The following is the default implementation: extract $ZIPFILE/system to $MODPATH
  # Extend/change the logic to whatever you want
  ui_print "- Extracting module files"
  unzip -o "$ZIPFILE" 'system/*' -d $MODPATH >&2

  set_bindir
}

# Only some special files require specific permissions
# This function will be called after on_install is done
# The default permissions should be good enough for most cases

set_permissions() {
  # The following is the default rule, DO NOT remove
  set_perm_recursive $MODPATH 0 0 0755 0755

  # Here are some examples:
  # set_perm_recursive  $MODPATH/system/lib       0     0       0755      0644
  # set_perm  $MODPATH/system/bin/app_process32   0     2000    0755      u:object_r:zygote_exec:s0
  # set_perm  $MODPATH/system/bin/dex2oat         0     2000    0755      u:object_r:dex2oat_exec:s0
  # set_perm  $MODPATH/system/lib/libart.so       0     0       0644
}

# You can add more functions to assist your custom script code
set_bindir() {
  local bindir=/system/bin
  local xbindir=/system/xbin

  # Check for existence of /system/xbin directory.
  if [ ! -d /sbin/.magisk/mirror$xbindir ]; then
    # Use /system/bin instead of /system/xbin.
    mkdir -p $MODPATH$bindir
    mv $MODPATH$xbindir/sqlite3 $MODPATH$bindir
    rmdir $MODPATH$xbindir
    xbindir=$bindir
 fi

 ui_print "- Installed to $xbindir"
}
