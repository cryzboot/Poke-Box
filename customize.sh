#!/system/bin/sh

# Prevent Magisk from automatically unzipping everything
SKIPUNZIP=1

# Define source directory (Now using 'root' instead of 'files')
SOURCE_DIR="$MODPATH/root"

ui_print "*******************************"
ui_print "             Poke Box          "
ui_print "           By: cryzboot        "
ui_print "*******************************"

# 1. VERIFICATION: Check if tricky_store exists
# If the folder does not exist, cancel installation
if [ ! -d "/data/adb/tricky_store" ]; then
  ui_print "! CRITICAL ERROR:"
  ui_print "! Directory /data/adb/tricky_store NOT found."
  ui_print "! Installation aborted."
  abort
fi

# Extract module files to temporary directory
unzip -o "$ZIPFILE" 'root/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'module.prop' -d $MODPATH >&2

# 2. CLEANUP: Delete old files (No backups)
ui_print "- Cleaning up old files..."

rm -f /data/adb/pif.json
rm -f /data/adb/pif.prop
rm -f /data/adb/tricky_store/security_patch.txt
rm -f /data/adb/tricky_store/target.txt
rm -f /data/adb/tricky_store/keybox.xml
rm -f /data/adb/modules/playintegrityfix/pif.prop


# 3. INSTALLATION: Copy new files
ui_print "- Updating new files..."

# Copy pif.json
if [ -f "$SOURCE_DIR/pif.json" ]; then
    cp "$SOURCE_DIR/pif.json" "/data/adb/pif.json"
    ui_print "  >pif.json"
fi

# Copy pif.prop to adb root
if [ -f "$SOURCE_DIR/pif.prop" ]; then
    cp "$SOURCE_DIR/pif.prop" "/data/adb/pif.prop"
    ui_print "  >pif.prop"
fi

# Copy security_patch
if [ -f "$SOURCE_DIR/security_patch.txt" ]; then
    cp "$SOURCE_DIR/security_patch.txt" "/data/adb/tricky_store/security_patch.txt"
    ui_print "  >security_patch.txt"
fi

# Copy target.txt
if [ -f "$SOURCE_DIR/target.txt" ]; then
    cp "$SOURCE_DIR/target.txt" "/data/adb/tricky_store/target.txt"
    ui_print "  >target.txt"
fi

# Copy 3 certificates from obfuscated files
random_keybox=$(find "$SOURCE_DIR" -type f -name "*@pokezone" | head -n 1)

if [ -n "$random_keybox" ]; then
    cp "$random_keybox" "/data/adb/tricky_store/keybox.xml"
    ui_print "  >keybox.xml"
else
    ui_print "ERROR: No keybox file found"
fi

# Copy pif.prop to Play Integrity Fix module folder
if [ -d "/data/adb/modules/playintegrityfix" ]; then
    cp "$SOURCE_DIR/pif.prop" "/data/adb/modules/playintegrityfix/pif.prop"
    ui_print "  >pif.prop"
else
    ui_print "! WARNING: Play Integrity Fix module folder not found."
    ui_print "! Skipping copy to /data/adb/modules/playintegrityfix/"
fi

# 4. PERMISSIONS
set_perm /data/adb/pif.json 0 0 0644
set_perm /data/adb/pif.prop 0 0 0644
set_perm /data/adb/tricky_store/security_patch.txt 0 0 0644
set_perm /data/adb/tricky_store/target.txt 0 0 0644
set_perm /data/adb/tricky_store/keybox.xml 0 0 0644

if [ -f "/data/adb/modules/playintegrityfix/pif.prop" ]; then
    set_perm /data/adb/modules/playintegrityfix/pif.prop 0 0 0644
fi

# Kill GMS processes
su -c killall com.google.android.gms >/dev/null 2>&1
su -c killall com.google.android.gms.unstable >/dev/null 2>&1
su -c killall com.android.vending >/dev/null 2>&1

ui_print "*******************************"
ui_print "   Installation Finished       "
ui_print "*******************************"