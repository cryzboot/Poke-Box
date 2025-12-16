#!/system/bin/sh

# Prevent Magisk from automatically unzipping everything
SKIPUNZIP=1

# Define source directory (Now using 'root' instead of 'files')
SOURCE_DIR="$MODPATH/root"

ui_print "*******************************"
ui_print "             Poke Box          "
ui_print "           By: cryzboot        "
ui_print "*******************************"

# VERIFICATION: Check if tricky store and PlayIntegrityFix exists
# If the folder does not exist, cancel installation
if [ ! -d "/data/adb/tricky_store" ]; then
  ui_print "- ERROR: Install Tricky Store before continuing..."
  abort
fi

if [ ! -d "/data/adb/modules/playintegrityfix" ]; then
  ui_print "- ERROR: Install Play Integrity Fix before continuing..."
  abort
fi

# Extract module files to temporary directory
unzip -o "$ZIPFILE" 'root/*' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'module.prop' -d $MODPATH >&2
unzip -o "$ZIPFILE" 'clean.sh' -d $MODPATH >&2

# CLEANUP: Delete old files (No backups)
ui_print "- Cleaning up old files..."

rm -f /data/adb/tricky_store/security_patch.txt
rm -f /data/adb/tricky_store/target.txt
rm -f /data/adb/tricky_store/keybox.xml


# INSTALLATION: Copy new files
ui_print "- Updating new files..."

# Copy target.txt
if [ -f "$SOURCE_DIR/target.txt" ]; then
    cp "$SOURCE_DIR/target.txt" "/data/adb/tricky_store/target.txt"
fi

# Copy 3 certificates from obfuscated file
random_keybox=$(find "$SOURCE_DIR" -type f -name "*@pokezone" | head -n 1)

if [ -n "$random_keybox" ]; then
    cp "$random_keybox" "/data/adb/tricky_store/keybox.xml"
else
    ui_print "- ERROR: No keybox file found"
fi

#PERMISSIONS
set_perm /data/adb/tricky_store/target.txt 0 0 0644
set_perm /data/adb/tricky_store/keybox.xml 0 0 0644

# CLEANING PROCESS
if [ -f "$MODPATH/clean.sh" ]; then
    set_perm "$MODPATH/clean.sh" 0 0 0755
    sh "$MODPATH/clean.sh"
else
    ui_print "- WARNING: clean.sh not found."
fi

ui_print "*******************************"
ui_print "    Installation Finished      "
ui_print "*******************************"