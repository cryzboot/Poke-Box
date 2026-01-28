#!/system/bin/sh

ui_print "*******************************"
ui_print "             Poke Box          "
ui_print "           By: cryzboot        "
ui_print "*******************************"

# SOURCE DIRECTORY
SOURCE_DIR="$MODPATH/root"

# TRICKY STORE & PLAY INTEGRITY FIX VERIFICATION
if [ ! -d "/data/adb/tricky_store" ]; then
  ui_print "- ERROR: Install Tricky Store before continuing..."
  abort
fi

if [ ! -d "/data/adb/modules/playintegrityfix" ]; then
  ui_print "- ERROR: Install Play Integrity Fix before continuing..."
  abort
fi

# DELETE OLD FILES
ui_print "- Cleaning up old files..."
rm -f /data/adb/tricky_store/target.txt
rm -f /data/adb/tricky_store/keybox.xml

# NEW FILES
ui_print "- Updating new files..."

# TARGET LIST
if [ -f "$SOURCE_DIR/target.txt" ]; then
    cp "$SOURCE_DIR/target.txt" "/data/adb/tricky_store/target.txt"
fi

# KEY CERTIFICATION
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
    rm -f "$MODPATH/clean.sh"
else
    ui_print "- WARNING: clean.sh not found."
fi

# CLEAR MAIN FOLDER
rm -rf "$SOURCE_DIR"

ui_print "*******************************"
ui_print "    Installation Finished      "
ui_print "*******************************"