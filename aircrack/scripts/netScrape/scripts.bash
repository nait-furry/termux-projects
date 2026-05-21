ensure_wifi_on() {
    WIFI_STATE=$(termux-wifi-connectioninfo 2>/dev/null | jq -r '.supplicant_state')

    if [ "$WIFI_STATE" = "null" ] || [ -z "$WIFI_STATE" ]; then
        echo "[*] WiFi appears OFF. Enabling..."
        termux-wifi-enable true 2>/dev/null
        sleep 5
    fi
}

# Adaptive scanning;
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


#!/bin/bash

# Configuration
SCAN_INTERVAL=30  # Seconds (aligns with typical Android background scan cycle)

echo "[*] Starting adaptive WiFi scanner..."

while true; do
    # 1. Get current scan data
    SCAN_DATA=$(termux-wifi-scaninfo 2>/dev/null)
    
    # 2. (Optional) Check if data is too old by parsing timestamp if available
    # For now, we rely on the interval to ensure freshness
    
    # 3. Process data (example: count networks)
    NETWORK_COUNT=$(echo "$SCAN_DATA" | jq 'length')
    echo "[*] Found $NETWORK_COUNT networks (Last scan: $(date))"
    
    # 4. Wait for the system to naturally refresh the cache
    # This avoids the disconnection penalty of toggling
    sleep $SCAN_INTERVAL
done


#!/bin/bash

# Configuration
TOGGLE_DELAY=3  # Minimum time to ensure radio state change
SCAN_DELAY=2    # Time to wait after enabling before reading (hardware warm-up)

echo "[*] Starting aggressive real-time scan mode..."

while true; do
    # 1. Force OFF
    echo "[*] Forcing WiFi OFF..."
    termux-wifi-enable false 2>/dev/null
    
    # 2. Brief pause to ensure hardware powers down completely
    sleep $TOGGLE_DELAY
    
    # 3. Force ON
    echo "[*] Forcing WiFi ON..."
    termux-wifi-enable true 2>/dev/null
    
    # 4. Wait for radio to stabilize and initiate scan
    # 2-3 seconds is usually enough for the radio to wake and start scanning
    sleep $SCAN_DELAY
    
    # 5. Capture Data
    # We use termux-wifi-scaninfo immediately. 
    # Note: Even with this, Android might return the "last scan" if the hardware hasn't finished.
    # But this is the fastest possible bash method.
    SCAN_RESULT=$(termux-wifi-scaninfo 2>/dev/null)
    
    # 6. Process (Example: Count networks)
    if [ -n "$SCAN_RESULT" ] && [ "$SCAN_RESULT" != "[]" ]; then
        COUNT=$(echo "$SCAN_RESULT" | jq 'length')
        echo "[+] Fresh Scan: $COUNT networks found at $(date +%H:%M:%S)"
    else
        echo "[-] Scan failed or returned empty (Hardware may still be initializing)"
    fi
    
    # 7. Immediate Loop (No extra sleep)
    # The toggle itself acts as the delay. 
    # If you need a specific frequency (e.g., every 10s), add: sleep 7
done



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

# checking for null ssids:

SCAN_DATA=$(termux-wifi-scaninfo 2>/dev/null)

# Check if any network has a null or empty SSID
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


# BSSID oriented scans:

#!/bin/bash

echo "[*] Scanning for hidden networks..."
SCAN_DATA=$(termux-wifi-scaninfo 2>/dev/null)

# Check if data exists
if [ -z "$SCAN_DATA" ] || [ "$SCAN_DATA" == "[]" ]; then
    echo "[-] No scan data found."
    exit 1
fi

# Extract hidden networks (where ssid is null or empty)
# We select the BSSID and Frequency to identify them
HIDDEN_NETWORKS=$(echo "$SCAN_DATA" | jq -r '.[] | select(.ssid == null or .ssid == "") | "BSSID: \(.bssid) | Freq: \(.frequency) MHz | Signal: \(.level) dBm"')

if [ -z "$HIDDEN_NETWORKS" ]; then
    echo "[+] No hidden networks detected."
else
    echo "[!] Found Hidden Networks (Identified by BSSID):"
    echo "------------------------------------------------"
    echo "$HIDDEN_NETWORKS"
    echo "------------------------------------------------"
    
    # Count them
    COUNT=$(echo "$SCAN_DATA" | jq '[.[] | select(.ssid == null or .ssid == "")] | length')
    echo "[*] Total Hidden Networks Found: $COUNT"
    echo "    Note: To connect, you must know the SSID name for each BSSID."
fi



#