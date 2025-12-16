#!/system/bin/sh

echo "- Cleaning sub process..."

# Package list
PKGS="com.android.vending com.google.android.apps.walletnfcrel com.nianticlabs.pokemongo"

for pkg in $PKGS; do
    # Check if package exists
    if pm list packages | grep -q "$pkg"; then
        
        # Force Stop
        if ! am force-stop "$pkg" >/dev/null 2>&1; then
            echo "- ERROR: Failed to stop"
        fi

        # Clear Data
        if ! pm clear "$pkg" >/dev/null 2>&1; then
            echo "- ERROR: Failed to clear data"
        fi
    fi
done