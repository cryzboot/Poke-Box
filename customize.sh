#!/system/bin/sh

# SOURCE DIRECTORY
SOURCE_DIR="$MODPATH/root"

# REMOVE OLD MODULE VERSIONS
if [ -d "/data/adb/modules/pokebox" ]; then
  touch /data/adb/modules/pokebox/remove
fi

# VERIFY DEPENDENCIES
sh "$SOURCE_DIR/verify.sh" || abort

# PERMISSIONS
set_perm_recursive "$SOURCE_DIR" 0 0 0755 0755
set_perm "$MODPATH/action.sh" 0 0 0755

# TRIGGER ACTION SCRIPT FOR INITIAL SETUP
export IS_INSTALL=1
sh "$MODPATH/action.sh"

# CLEANING FILES
rm -f "$MODPATH/LICENSE"