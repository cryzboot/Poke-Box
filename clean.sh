#!/system/bin/sh

# Simplemente imprimimos el mensaje de inicio
echo "- Cleaning sub process..."

# Package list
PKGS="com.android.vending com.google.android.apps.walletnfcrel com.nianticlabs.pokemongo"

for pkg in $PKGS; do
    # Check if package exists
    if pm list packages | grep -q "$pkg"; then
        
        # Force Stop (Silencioso, solo avisa si falla)
        if ! am force-stop "$pkg" >/dev/null 2>&1; then
            echo "- ERROR: Failed to stop"
        fi

        # Clear Data (Silencioso, solo avisa si falla)
        if ! pm clear "$pkg" >/dev/null 2>&1; then
            echo "- ERROR: Failed to clear data"
        fi
    fi
done

# Mensaje final
echo "- Done..."