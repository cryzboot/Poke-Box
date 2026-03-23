#!/system/bin/sh

if [ "$IS_INSTALL" != "1" ]; then
  echo "*******************************"
  echo "            Poke Box           "
  echo "           by cryzboot         "
  echo "*******************************"
fi

echo "- Fetching updates..."

# SET SCRIPT DIRECTORY
MODPATH="${0%/*}"
SOURCE_DIR="$MODPATH/root"

# EXECUTE SCRIPTS
for SCRIPT in \
  "verify.sh" \
  "target_list.sh" \
  "poke_cert.sh" \
  "clean.sh"
do

# PREVENT RUNNING VERIFY.SH ON INSTALL
  if [ "$SCRIPT" = "verify.sh" ] && [ "$IS_INSTALL" = "1" ]; then
    continue
  fi

  if ! sh "$SOURCE_DIR/$SCRIPT"; then
    echo "- ERROR: Abording process..."
    exit 1
  fi
done

if [ "$IS_INSTALL" != "1" ]; then
  echo "*******************************"
  echo "     Updated successfully      "
  echo "*******************************"
fi