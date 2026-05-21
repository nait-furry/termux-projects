

# Foreground scanning:

#!/bin/bash

# Configuration
TOGGLE_DELAY=3  # Minimum time to ensure radio state change
SCAN_DELAY=2    # Time to wait after enabling before reading (hardware warm-up)

echo "[*] Starting aggressive real-time scan mode..."

while true; do
    # 0. Use as is
    echo "Pre-active-throttle scan:"
    # Capture data

    # 1. Force OFF
    echo "[*] Forcing WiFi OFF..."
    termux-wifi-enable false 2>/dev/null
    
    # 2. Brief pause to ensure hardware powers down completely
    sleep $TOGGLE_DELAY
    
    # 3. Force ON
    echo "[*] Forcing WiFi ON..."
    termux-wifi-enable true 2>/dev/null
    
    # 4. Wait for radio to stabilize and initiate scan
    sleep $SCAN_DELAY
    
    # 5. Capture Data
    SCAN_RESULT=$(termux-wifi-scaninfo 2>/dev/null)
    
    # 6. Process
    if [ -n "$SCAN_RESULT" ] && [ "$SCAN_RESULT" != "[]" ]; then
        COUNT=$(echo "$SCAN_RESULT" | jq 'length')
        echo "[+] Fresh Scan: $COUNT networks found at $(date +%H:%M:%S)"
    else
        echo "[-] Scan failed or returned empty (Hardware may still be initializing)"
    fi
    
done



# Background scanning:

#!/bin/bash

# Configuration
SCAN_INTERVAL=30  # Seconds (aligns with typical Android background scan cycle)

echo "[*] Starting adaptive WiFi scanner..."

while true; do
    # 1. Get current scan data
    SCAN_DATA=$(termux-wifi-scaninfo 2>/dev/null)
    
    # 2. implement the # Adaptive scanning:
    
    # 3. Process data (example: count networks)
    NETWORK_COUNT=$(echo "$SCAN_DATA" | jq 'length')
    echo "[*] Found $NETWORK_COUNT networks (Last scan: $(date))"
    
    # 4. Wait for the system to naturally refresh the cache
    # This avoids the disconnection penalty of toggling
    sleep $SCAN_INTERVAL
done


# General techniques:

# Adaptive scanning:

LAST_HASH=""

scan_wifi() {
    CURRENT=$(termux-wifi-scaninfo)

    HASH=$(echo "$CURRENT" | sha1sum)

    if [ "$HASH" != "$LAST_HASH" ]; then
        echo "[*] New scan data detected"
        LAST_HASH="$HASH"
        echo "$CURRENT"
    else
        echo "[*] No change (likely cached)"
    fi
}

# Screen-state conscious scan:

SCREEN=$(dumpsys power | grep "Display Power" | grep -o "state=.*")

if [[ "$SCREEN" == *"OFF"* ]]; then
    SCAN_INTERVAL=30
else
    SCAN_INTERVAL=10
fi


# checking for null ssids:

SCAN_DATA=$(termux-wifi-scaninfo 2>/dev/null)

HIDDEN_COUNT=$(echo "$SCAN_DATA" | jq '[.[] | select(.ssid == null or .ssid == "")] | length')

if [ "$HIDDEN_COUNT" -gt 0 ]; then
    echo "[!] WARNING: $HIDDEN_COUNT hidden networks detected (SSID unknown)."
    echo "    To identify them, you must know the SSID name and add it to Android settings."
    
    # Optional: List their BSSIDs (MAC addresses)
    echo "    Detected BSSIDs:"
    echo "$SCAN_DATA" | jq -r '.[] | select(.ssid == null or .ssid == "") | .bssid'
else
    echo "[+] No hidden networks detected."
fi

// instead of warnings, just name the hidden networks SSID sequencially ie HD001, and so forth; 


# Hybrid: walking, smart-check, toggling,  

#!/bin/bash

# Configuration
TOGGLE_OFF_TIME=3   # Ensure radio fully resets
TOGGLE_ON_WAIT=2    # Wait for radio to stabilize
MOTION_THRESHOLD=0.5 # Placeholder for motion logic

echo "[*] Starting Smart Adaptive Scanner..."

# 1. Keep CPU awake to prevent OS from sleeping the WiFi radio
termux-wake-lock

while true; do
    # A. Check for Movement (Optional but recommended)
    # In a real script, you would parse termux-sensor output here.
    # For this example, we assume we scan every loop or on a timer if no sensor data.
    
    # B. Get Current Data
    CURRENT_SCAN=$(termux-wifi-scaninfo 2>/dev/null)
    
    # C. Check if we have data (if empty, we MUST scan)
    if [ -z "$CURRENT_SCAN" ] || [ "$CURRENT_SCAN" == "[]" ]; then
        echo "[*] No data found. Forcing fresh scan..."
        # FORCE TOGGLE
        termux-wifi-enable false 2>/dev/null
        sleep $TOGGLE_OFF_TIME
        termux-wifi-enable true 2>/dev/null
        sleep $TOGGLE_ON_WAIT
        
        # Re-read
        CURRENT_SCAN=$(termux-wifi-scaninfo 2>/dev/null)
    else
        # D. If we have data, check if it's "too old" based on your loop time
        # Since we can't get timestamp from JSON, we rely on loop frequency.
        # If you are looping every 10s, and the OS allows 4 scans/2min, 
        # you might get cached data.
        
        # HEURISTIC: If the loop runs too fast, force a toggle.
        # If you are walking, the OS might auto-scan. 
        # To be safe, we toggle every N cycles if we suspect caching.
        echo "[*] Data present. Checking freshness..."
        # (In a real script, you'd compare the RSSI of a known network here)
        # If RSSI hasn't changed in 3 loops, force toggle.
    fi

    # Process Data
    if [ -n "$CURRENT_SCAN" ] && [ "$CURRENT_SCAN" != "[]" ]; then
        COUNT=$(echo "$CURRENT_SCAN" | jq 'length')
        echo "[+] Found $COUNT networks at $(date +%H:%M:%S)"
    fi

    # E. Wait before next check
    # If walking, you might want to wait for motion. 
    # If stationary, wait 5s to avoid throttling.
    sleep 5 
done
```
