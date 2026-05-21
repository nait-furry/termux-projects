#!/bin/bash

################################################################################
# WiFi Network Reconnaissance Script for Termux/Android
# Purpose: Aggressive WiFi scanning with adaptive logic for network discovery
# Modes: Foreground (resource-intensive) | Background (low-power)
################################################################################

set -o pipefail

# ============================================================================
# GLOBAL CONFIGURATION
# ============================================================================

# Timing Configuration
readonly FOREGROUND_TOGGLE_OFF=3      # Time to ensure radio fully powers down
readonly FOREGROUND_TOGGLE_ON=4       # Time to allow radio to stabilize (increased)
readonly FOREGROUND_INITIAL_SCAN=3    # Initial scan attempt interval
readonly FOREGROUND_MAX_SCAN_DELAY=12 # Maximum scan delay (adaptive ceiling)
readonly SCAN_STABILITY_WAIT=2        # Additional time for scan to populate

readonly BACKGROUND_SCAN_INTERVAL=30  # Background passive scan interval
readonly BACKGROUND_CHECK_INTERVAL=10 # Check interval during screen ON

# Adaptive Scanning Configuration
readonly SAME_DATA_THRESHOLD=3        # Increase delay after this many identical scans
readonly ADAPTIVE_INCREMENT=2         # Seconds to add per same-data iteration
readonly HIDDEN_NETWORK_PREFIX="HD"   # Prefix for hidden networks (HD001, HD002, etc)

# File Logging Configuration
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
readonly LOG_DIR="${SCRIPT_DIR}/logs"
readonly JSON_DIR="${SCRIPT_DIR}/scans"
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# State Variables
LAST_SCAN_HASH=""
SAME_DATA_COUNT=0
CURRENT_SCAN_DELAY=$FOREGROUND_INITIAL_SCAN
HIDDEN_NETWORK_INDEX=0
WAKELOCK_ACQUIRED=false
SHUTDOWN_REQUESTED=false
LOG_FILE=""
JSON_FILE=""
LOG_FD=""
SCAN_COUNT=0

# ============================================================================
# UTILITY FUNCTIONS - Module: Core Operations
# ============================================================================

# Initialize log files
init_log_files() {
    mkdir -p "$LOG_DIR" "$JSON_DIR" 2>/dev/null || true
    
    LOG_FILE="${LOG_DIR}/wifi_scan_${TIMESTAMP}.log"
    JSON_FILE="${JSON_DIR}/networks_${TIMESTAMP}.json"
    
    # Initialize log file with header
    {
        echo "================================="
        echo "WiFi Reconnaissance Log"
        echo "Started: $(date)"
        echo "================================="
        echo ""
    } >> "$LOG_FILE"
    
    log_msg "INFO" "Logging to: $LOG_FILE"
    log_msg "INFO" "JSON export to: $JSON_FILE"
    
    # Initialize JSON file as array
    echo "[]" > "$JSON_FILE"
}

# Print with timestamp
log_msg() {
    local level=$1
    shift
    local msg="$*"
    local timestamp=$(date +'%H:%M:%S')
    local log_line="[$timestamp] [$level] $msg"
    
    # Print to terminal
    echo "$log_line"
    
    # Also save to log file if initialized
    if [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ]; then
        echo "$log_line" >> "$LOG_FILE"
    fi
}

# Print error and exit
error_exit() {
    log_msg "ERROR" "$1"
    SHUTDOWN_REQUESTED=true
    cleanup
    exit 1
}

# Finalize log files
finalize_log_files() {
    if [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ]; then
        {
            echo ""
            echo "================================="
            echo "Scan Session Ended: $(date)"
            echo "Total Scans Recorded: $SCAN_COUNT"
            echo "================================="
        } >> "$LOG_FILE"
    fi
}

# Graceful shutdown handler
handle_interrupt() {
    echo ""
    log_msg "INFO" "Shutdown requested. Cleaning up..."
    SHUTDOWN_REQUESTED=true
    cleanup
    finalize_log_files
    log_msg "INFO" "Session saved to: $LOG_FILE"
    if [ -f "$JSON_FILE" ] && [ -s "$JSON_FILE" ]; then
        log_msg "INFO" "Network data saved to: $JSON_FILE"
    fi
    exit 0
}

# Cleanup on exit
cleanup() {
    if [ "$WAKELOCK_ACQUIRED" = true ]; then
        log_msg "INFO" "Releasing wake lock..."
        termux-wake-lock -r 2>/dev/null || true
    fi
}

trap handle_interrupt SIGINT SIGTERM
trap cleanup EXIT

# ============================================================================
# UTILITY FUNCTIONS - Module: WiFi Hardware Control
# ============================================================================

# Enable or disable WiFi radio
wifi_set_state() {
    local state=$1 # true/false
    local action=$([ "$state" = true ] && echo "ON" || echo "OFF")
    
    log_msg "INFO" "Forcing WiFi $action..."
    termux-wifi-enable "$state" 2>/dev/null || \
        error_exit "Failed to set WiFi state to $state"
}

# Wait for radio to stabilize
wait_radio_stabilize() {
    local wait_time=$1
    sleep "$wait_time"
}

# Force WiFi toggle and stabilize
force_fresh_scan() {
    wifi_set_state false
    log_msg "DEBUG" "Waiting ${FOREGROUND_TOGGLE_OFF}s for radio shutdown..."
    wait_radio_stabilize "$FOREGROUND_TOGGLE_OFF"
    wifi_set_state true
    log_msg "DEBUG" "Waiting ${FOREGROUND_TOGGLE_ON}s for radio initialization..."
    wait_radio_stabilize "$FOREGROUND_TOGGLE_ON"
    log_msg "DEBUG" "Waiting ${SCAN_STABILITY_WAIT}s for scan cache to populate..."
    wait_radio_stabilize "$SCAN_STABILITY_WAIT"
}

# ============================================================================
# UTILITY FUNCTIONS - Module: Data Acquisition & Processing
# ============================================================================

# Get WiFi scan data
get_scan_data() {
    local result=$(termux-wifi-scaninfo 2>/dev/null)
    if [ -z "$result" ]; then
        log_msg "DEBUG" "Scan returned empty/null"
    fi
    echo "$result"
}

# Calculate SHA1 hash of scan data
hash_scan_data() {
    local data=$1
    echo "$data" | sha1sum | awk '{print $1}'
}

# Count networks from scan data
count_networks() {
    local data=$1
    if [ -z "$data" ] || [ "$data" = "[]" ]; then
        echo 0
    else
        echo "$data" | jq 'length' 2>/dev/null || echo 0
    fi
}

# Extract hidden network BSSIDs
get_hidden_networks() {
    local data=$1
    echo "$data" | jq -r '.[] | select(.ssid == null or .ssid == "") | .bssid' 2>/dev/null
}

# Save scan data as JSON
save_scan_json() {
    local scan_data=$1
    
    if [ -z "$scan_data" ] || [ "$scan_data" = "[]" ]; then
        return
    fi
    
    # Append scan data to JSON file
    if [ -f "$JSON_FILE" ]; then
        # Read existing array
        local existing=$(cat "$JSON_FILE")
        
        # Merge with new data
        local merged=$(echo "$existing" "$scan_data" | jq -s 'add | unique_by(.bssid)')
        
        # Write back
        echo "$merged" > "$JSON_FILE"
        ((SCAN_COUNT++))
    fi
}

# Detect hidden networks and assign names
process_hidden_networks() {
    local data=$1
    local hidden_count=$(echo "$data" | jq '[.[] | select(.ssid == null or .ssid == "")] | length' 2>/dev/null)
    
    if [ "$hidden_count" -gt 0 ]; then
        log_msg "WARNING" "Detected $hidden_count hidden network(s)"
        
        local index=1
        while IFS= read -r bssid; do
            local hidden_name="${HIDDEN_NETWORK_PREFIX}$(printf "%03d" "$index")"
            log_msg "INFO" "Hidden network $index: BSSID=$bssid (Named: $hidden_name)"
            ((index++))
        done < <(get_hidden_networks "$data")
    fi
}

# ============================================================================
# UTILITY FUNCTIONS - Module: Screen State Detection
# ============================================================================

# Get device screen state (ON/OFF)
get_screen_state() {
    local screen_state=$(dumpsys power 2>/dev/null | grep "Display Power" | grep -o "state=.*")
    
    if [[ "$screen_state" == *"OFF"* ]]; then
        echo "OFF"
    else
        echo "ON"
    fi
}

# Get adaptive scan interval based on screen state
get_adaptive_interval() {
    local screen=$(get_screen_state)
    
    if [ "$screen" = "OFF" ]; then
        echo "$BACKGROUND_SCAN_INTERVAL"
    else
        echo "$BACKGROUND_CHECK_INTERVAL"
    fi
}

# ============================================================================
# SCANNING MODULE: Adaptive Scan Logic
# ============================================================================

# Check if new data has been received
check_scan_freshness() {
    local new_hash=$1
    
    if [ "$new_hash" = "$LAST_SCAN_HASH" ]; then
        ((SAME_DATA_COUNT++))
        return 1  # False: Same data
    else
        SAME_DATA_COUNT=0
        LAST_SCAN_HASH="$new_hash"
        return 0  # True: Fresh data
    fi
}

# Adaptively increase scan delay when data is static
adaptive_delay_backoff() {
    if [ "$SAME_DATA_COUNT" -ge "$SAME_DATA_THRESHOLD" ]; then
        if [ "$CURRENT_SCAN_DELAY" -lt "$FOREGROUND_MAX_SCAN_DELAY" ]; then
            CURRENT_SCAN_DELAY=$((CURRENT_SCAN_DELAY + ADAPTIVE_INCREMENT))
            
            # Cap at maximum
            if [ "$CURRENT_SCAN_DELAY" -gt "$FOREGROUND_MAX_SCAN_DELAY" ]; then
                CURRENT_SCAN_DELAY=$FOREGROUND_MAX_SCAN_DELAY
            fi
            
            log_msg "DEBUG" "Data unchanged ($SAME_DATA_COUNT times). Increasing scan delay to ${CURRENT_SCAN_DELAY}s"
        fi
    fi
}

# Reset adaptive delay (new data discovered)
reset_adaptive_delay() {
    CURRENT_SCAN_DELAY=$FOREGROUND_INITIAL_SCAN
    SAME_DATA_COUNT=0
}

# ============================================================================
# SCANNING FUNCTIONS: Foreground (Aggressive)
# ============================================================================

foreground_scan() {
    init_log_files
    log_msg "INFO" "Starting aggressive foreground scanning mode..."
    log_msg "INFO" "Keep-alive enabled to prevent WiFi radio throttling"
    log_msg "INFO" "Press Ctrl+C to stop and save results"
    
    # Step 1: Acquire wake lock to keep CPU and WiFi active
    termux-wake-lock 2>/dev/null
    WAKELOCK_ACQUIRED=true
    
    local iteration=0
    
    while [ "$SHUTDOWN_REQUESTED" = false ]; do
        ((iteration++))
        log_msg "INFO" "=== Scan Iteration $iteration ==="
        
        # Step A: Get current scan (may be cached)
        local current_scan=$(get_scan_data)
        local count=$(count_networks "$current_scan")
        
        # Step B: Check if data is empty or likely cached
        if [ "$count" -eq 0 ] || [ -z "$current_scan" ] || [ "$current_scan" = "[]" ]; then
            log_msg "WARN" "Empty scan result. Forcing fresh toggle..."
            force_fresh_scan
            current_scan=$(get_scan_data)
            count=$(count_networks "$current_scan")
        fi
        
        # Step C: Process scan data
        if [ "$count" -gt 0 ]; then
            local new_hash=$(hash_scan_data "$current_scan")
            
            if check_scan_freshness "$new_hash"; then
                # Fresh data detected
                log_msg "SUCCESS" "Fresh scan data: $count networks found"
                reset_adaptive_delay
            else
                # Same data as last scan
                log_msg "INFO" "Cached data detected (identical to previous scan, count=$SAME_DATA_COUNT)"
                adaptive_delay_backoff
            fi
            
            # Log sample networks
            echo "$current_scan" | jq -r '.[] | "\(.ssid // "HIDDEN") (\(.bssid)) - Signal: \(.level)dBm"' 2>/dev/null | head -3 | sed 's/^/  /'
            
            # Check for hidden networks
            process_hidden_networks "$current_scan"
            
            # Step E: Save scan to JSON
            save_scan_json "$current_scan"
        else
            log_msg "ERROR" "Unable to retrieve scan data after toggle"
        fi
        
        # Step F: Wait before next iteration (check for shutdown every second)
        local remaining=$CURRENT_SCAN_DELAY
        while [ "$remaining" -gt 0 ] && [ "$SHUTDOWN_REQUESTED" = false ]; do
            sleep 1
            ((remaining--))
        done
        
        # Check if shutdown was requested
        if [ "$SHUTDOWN_REQUESTED" = true ]; then
            break
        fi
    done
    
    finalize_log_files
    log_msg "INFO" "Foreground scan session ended"
}

# ============================================================================
# SCANNING FUNCTIONS: Background (Passive)
# ============================================================================

background_scan() {
    init_log_files
    log_msg "INFO" "Starting adaptive background WiFi scanner..."
    log_msg "INFO" "Passive scanning with screen-state aware intervals"
    log_msg "INFO" "Press Ctrl+C to stop and save results"
    
    local last_screen="UNKNOWN"
    
    while [ "$SHUTDOWN_REQUESTED" = false ]; do
        local current_screen=$(get_screen_state)
        local interval=$(get_adaptive_interval)
        
        # Log screen state change
        if [ "$current_screen" != "$last_screen" ]; then
            log_msg "INFO" "Screen state: $current_screen (interval: ${interval}s)"
            last_screen="$current_screen"
        fi
        
        # Get current scan data
        local scan_data=$(get_scan_data)
        local network_count=$(count_networks "$scan_data")
        
        if [ "$network_count" -gt 0 ]; then
            log_msg "INFO" "Found $network_count networks"
            
            # Log sample of visible networks
            echo "$scan_data" | jq -r '.[] | "\(.ssid // "HIDDEN") - \(.level)dBm"' 2>/dev/null | head -5 | sed 's/^/  /'
            
            # Check hidden networks periodically
            local hidden=$(echo "$scan_data" | jq '[.[] | select(.ssid == null or .ssid == "")] | length' 2>/dev/null)
            if [ "$hidden" -gt 0 ]; then
                log_msg "INFO" "Hidden networks: $hidden"
            fi
            
            # Save scan to JSON
            save_scan_json "$scan_data"
        else
            log_msg "WARN" "No scan data available (may be cached empty result)"
        fi
        
        # Wait for next check (check for shutdown every second)
        local remaining=$interval
        while [ "$remaining" -gt 0 ] && [ "$SHUTDOWN_REQUESTED" = false ]; do
            sleep 1
            ((remaining--))
        done
        
        # Check if shutdown was requested
        if [ "$SHUTDOWN_REQUESTED" = true ]; then
            break
        fi
    done
    
    finalize_log_files
    log_msg "INFO" "Background scan session ended"
}

# ============================================================================
# DIAGNOSTIC MODE
# ============================================================================

run_diagnostic() {
    echo ""
    echo "Running Termux API Diagnostic..."
    echo ""
    
    # Test 1: Check if termux-wifi-scaninfo exists
    log_msg "TEST" "Checking termux-wifi-scaninfo availability..."
    if command -v termux-wifi-scaninfo &>/dev/null; then
        log_msg "SUCCESS" "termux-wifi-scaninfo is available"
    else
        log_msg "ERROR" "termux-wifi-scaninfo not found - Termux API required"
        return 1
    fi
    
    # Test 2: Try a scan
    log_msg "TEST" "Attempting WiFi scan..."
    local scan=$(termux-wifi-scaninfo 2>&1)
    if [ -n "$scan" ] && [ "$scan" != "[]" ]; then
        log_msg "SUCCESS" "Scan returned data: $(echo "$scan" | jq 'length') networks"
    else
        log_msg "WARN" "Scan returned empty/null. This may be:"
        echo "       - WiFi is OFF (need to enable first)"
        echo "       - Termux API permissions not granted"
        echo "       - Device needs to scan first"
        echo ""
        log_msg "INFO" "Attempting to enable WiFi and retry..."
        termux-wifi-enable true 2>&1
        sleep 3
        scan=$(termux-wifi-scaninfo 2>&1)
        if [ -n "$scan" ] && [ "$scan" != "[]" ]; then
            log_msg "SUCCESS" "After enabling WiFi: $(echo "$scan" | jq 'length') networks"
        else
            log_msg "ERROR" "Still no scan data after enabling WiFi"
            echo ""
            log_msg "INFO" "Raw termux-wifi-scaninfo output:"
            echo "$scan"
            return 1
        fi
    fi
    
    # Test 3: Check wake lock
    log_msg "TEST" "Testing wake lock..."
    termux-wake-lock 2>&1 >/dev/null && log_msg "SUCCESS" "Wake lock can be acquired"
    termux-wake-lock -r 2>&1 >/dev/null && log_msg "SUCCESS" "Wake lock can be released"
    
    echo ""
    log_msg "SUCCESS" "Diagnostic complete - system appears ready"
    echo ""
}

# ============================================================================
# MAIN: Interactive Menu
# ============================================================================

show_menu() {
    clear
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║     WiFi Network Reconnaissance for Termux/Android         ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "📁 Log Directory: $LOG_DIR"
    echo "📊 JSON Export: $JSON_DIR"
    echo ""
    echo "Select scanning mode:"
    echo ""
    echo "  [1] Foreground Scanning (Aggressive - Resource Intensive)"
    echo "      • Forces WiFi toggle for fresh scans"
    echo "      • Adaptive delay when data plateaus"
    echo "      • Uses wake lock to prevent throttling"
    echo "      • ✓ Auto-saves logs + JSON data"
    echo "      • Best for: Active network discovery"
    echo ""
    echo "  [2] Background Scanning (Passive - Battery Friendly)"
    echo "      • Reads system scan cache periodically"
    echo "      • Screen-aware intervals (10s ON / 30s OFF)"
    echo "      • Minimal resource consumption"
    echo "      • ✓ Auto-saves logs + JSON data"
    echo "      • Best for: Continuous monitoring"
    echo ""
    echo "  [3] Run Diagnostic (Test Termux API)"
    echo "      • Verify termux-wifi-scaninfo works"
    echo "      • Check WiFi state and permissions"
    echo "      • Best for: Troubleshooting"
    echo ""
    echo "  [4] View Recent Scans"
    echo "      • List saved log files"
    echo "      • List saved JSON exports"
    echo ""
    echo "  [5] Exit (with graceful shutdown)"
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    printf "Enter choice [1-5]: "
}

main() {
    # Verify Termux environment
    if ! command -v termux-wifi-scaninfo &>/dev/null; then
        error_exit "Termux API not available. This script requires Termux with WiFi API."
    fi
    
    # Ensure log directories exist
    mkdir -p "$LOG_DIR" "$JSON_DIR" 2>/dev/null || true
    
    while [ "$SHUTDOWN_REQUESTED" = false ]; do
        show_menu
        read -r choice
        
        case "$choice" in
            1)
                echo ""
                foreground_scan
                SHUTDOWN_REQUESTED=false
                ;;
            2)
                echo ""
                background_scan
                SHUTDOWN_REQUESTED=false
                ;;
            3)
                run_diagnostic
                read -p "Press Enter to return to menu..."
                ;;
            4)
                echo ""
                echo "Recent Scan Logs:"
                if [ -d "$LOG_DIR" ] && [ "$(ls -1 "$LOG_DIR" 2>/dev/null | wc -l)" -gt 0 ]; then
                    ls -lh "$LOG_DIR" | tail -5 | awk '{print "  " $9 " (" $5 ")"}' | grep -v "^  $"
                else
                    echo "  (No logs found)"
                fi
                echo ""
                echo "Recent JSON Exports:"
                if [ -d "$JSON_DIR" ] && [ "$(ls -1 "$JSON_DIR" 2>/dev/null | wc -l)" -gt 0 ]; then
                    ls -lh "$JSON_DIR" | tail -5 | awk '{print "  " $9 " (" $5 ")"}' | grep -v "^  $"
                else
                    echo "  (No exports found)"
                fi
                echo ""
                read -p "Press Enter to return to menu..."
                ;;
            5)
                echo ""
                log_msg "INFO" "Exiting gracefully..."
                SHUTDOWN_REQUESTED=true
                break
                ;;
            *)
                echo ""
                log_msg "ERROR" "Invalid choice. Please enter 1, 2, 3, 4, or 5."
                sleep 2
                ;;
        esac
    done
    
    # Final message when exiting
    log_msg "INFO" "Thank you for using WiFi Reconnaissance Script."
    echo ""
}

# ============================================================================
# SCRIPT ENTRY POINT
# ============================================================================

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
