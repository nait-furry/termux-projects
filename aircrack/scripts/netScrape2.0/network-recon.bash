#!/bin/bash
################################################################################
# network-recon.bash  -  WiFi Network Reconnaissance for Termux/Android  (v2.0)
################################################################################
#
# CHANGELOG  (v1.x throttled-environment assumptions -> v2.0 throttle-free)
# -----------------------------------------------------------------------------
# v1.x assumed Android's Wi-Fi scan throttling (~4 scans / 2 min per app) was
# ACTIVE and routed around it by toggling termux-wifi-enable OFF/ON every
# foreground iteration to force "fresh" scan results.
#
# v2.0 targets a device where Wi-Fi scan throttling is DISABLED (Android
# Developer Options). Toggling every iteration is now unnecessary and risks
# overloading the phone's radio / draining the battery, so this revision:
#
#   1. REMOVED the adaptive-backoff apparatus (SAME_DATA_THRESHOLD,
#      ADAPTIVE_INCREMENT, FOREGROUND_MAX_SCAN_DELAY and friends) that existed
#      only to cope with throttled/stale scans. Replaced by a simple staleness
#      check (STALE_SCAN_CYCLES identical hashes) with a flat scan cycle.
#   2. Foreground toggles now happen ONLY when a scan is genuinely empty or
#      presumed stale - never unconditionally every cycle.
#   3. Added a runtime throttle check ('dumpsys wifi | grep -i throttl', or a
#      manual THROTTLE_OVERRIDE). If throttling is still ACTIVE or the check
#      is INCONCLUSIVE, the script logs a WARNING and falls back to the old
#      toggle-heavy (throttle-safe) strategy - still hard-capped by the toggle
#      budget in point 5.
#   4. Added a --test "Field-Readiness" suite for pre-deployment verification:
#      controlled AP capture, ground-truth diff, hash stability, throttle-state
#      verification, failure-mode check and a documented walk-pace procedure.
#   5. Added resource_guard() safety caps at the start of every scan iteration:
#      toggles-per-minute ceiling (hard, independent of any other logic),
#      low-battery -> passive mode, high-temperature -> pause with cool-down,
#      max session runtime -> auto-stop + finalize. The wake lock is now
#      acquired only around toggle operations instead of the whole run.
#   6. Every scan log entry logs battery %, temperature and toggle count so
#      resource conditions correlate with script behavior after the fact.
#
# KEPT FROM v1.x:
#   - Radio warm-up waits (RADIO_TOGGLE_OFF_WAIT / RADIO_TOGGLE_ON_WAIT /
#     SCAN_STABILITY_WAIT). These are HARDWARE timing constraints (radio
#     power-down / stabilization), not throttling artifacts, so they remain.
#     The Controlled AP capture self-test (--test) shows how to re-confirm
#     their durations per device.
#   - Passive/background mode: reads the system scan cache, NEVER toggles.
#   - Termux:API surface: termux-wifi-enable, termux-wifi-scaninfo,
#     termux-wake-lock, termux-battery-status, jq.
#   - Screen-aware intervals, hidden-network relabeling (HD001, ...), JSON
#     export, graceful Ctrl+C shutdown and file logging.
################################################################################

# ============================================================================
# GLOBAL CONFIGURATION  (thresholds are tunable per device - see inline notes)
# ============================================================================

# --- Radio warm-up waits (hardware timing, NOT throttling artifacts) ----------
readonly RADIO_TOGGLE_OFF_WAIT=3  # seconds for the radio to fully power down
readonly RADIO_TOGGLE_ON_WAIT=4   # seconds for the radio to stabilize after ON
readonly SCAN_STABILITY_WAIT=2    # extra seconds for the scan cache to populate
#   Re-confirm these on a given device with the "Controlled AP capture" test:
#   too short -> AP changes are missed; too long -> wasteful radio-on time.

# --- Foreground scan cadence ---------------------------------------------------
readonly FOREGROUND_SCAN_CYCLE=8  # base seconds between foreground scan reads
#   With throttling disabled the OS refreshes scans on its own, so the script
#   only re-reads the cache here. Lower = fresher while walking, higher = cooler.

# --- Staleness heuristic -------------------------------------------------------
readonly STALE_SCAN_CYCLES=3      # identical hashes before data is "presumed
#   stale" and a toggle is permitted. 3 cycles ~= 3*FOREGROUND_SCAN_CYCLE.

# --- Throttle-state verification ----------------------------------------------
THROTTLE_OVERRIDE="${THROTTLE_OVERRIDE:-}"  # operator override if 'dumpsys wifi' has no
#   parseable throttling line: "disabled" | "active" | "" (auto-detect).

# --- Resource guard (hard caps, independent of all other logic) ---------------
readonly TOGGLE_RATE_LIMIT_PER_MIN=6  # MAX radio toggles in any 60 s window.
#   Enforced inside the single toggle chokepoint, so no other logic can exceed
#   it. Raise only if the radio/thermal envelope allows; watch battery temp.
readonly BATTERY_LOW_THRESHOLD=18     # battery %: below this the foreground
#   mode auto-switches to passive (no toggles) and resumes once recharged.
readonly BATTERY_EMERGENCY_PAUSE=10   # battery %: below this, scanning pauses.
readonly BATTERY_TEMP_HIGH_THRESHOLD=45  # battery temperature (deg C) above
#   which scanning pauses; resumes once it drops. Some devices don't report
#   temperature - that is treated as unknown (no pause), not a crash.
readonly PAUSE_RECHECK_INTERVAL=30    # seconds between resource re-checks while
#   paused for low battery / high temperature.
readonly MAX_SESSION_RUNTIME_SEC=1800 # 30 min hard cap: after this the script
#   auto-stops and finalizes logs even if not manually interrupted.

# --- Background / passive mode --------------------------------------------------
readonly BACKGROUND_SCAN_INTERVAL=30  # passive interval when screen is OFF
readonly BACKGROUND_CHECK_INTERVAL=10 # passive interval when screen is ON

# --- Hidden-network naming ------------------------------------------------------
readonly HIDDEN_NETWORK_PREFIX="HD"   # hidden SSIDs get sequential names HD001..

# --- Self-test timing -----------------------------------------------------------
readonly AP_DETECT_TIMEOUT=60         # seconds to wait for the test AP BSSID to
#   appear/disappear during the Controlled AP capture test.

# --- File + session locations ---------------------------------------------------
# All outputs (logs + scan JSON) go to Android shared storage so they can be
# pulled straight to a laptop: adb pull /storage/emulated/0/Termux/downloads/
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # used by --simulate stubs
readonly OUTPUT_BASE="/storage/emulated/0/Termux/downloads"
readonly LOG_DIR="${OUTPUT_BASE}/logs"    # wifi_scan_*.log session logs
readonly JSON_DIR="${OUTPUT_BASE}/scans"  # networks_*.json exports
readonly TIMESTAMP=$(date +%Y%m%d_%H%M%S)

# ============================================================================
# STATE
# ============================================================================
SESSION_START_TS=$(date +%s)
LAST_SCAN_HASH=""
SAME_DATA_COUNT=0
SHUTDOWN_REQUESTED=false
WAKELOCK_ACQUIRED=false
LOG_FILE=""
JSON_FILE=""
SCAN_COUNT=0
TOGGLE_COUNT_TOTAL=0
TOGGLE_TS=()                      # epoch timestamps of recent radio toggles
THROTTLE_STATE="INCONCLUSIVE"     # DISABLED | ACTIVE | INCONCLUSIVE
THROTTLE_SAFE_MODE=false
BATTERY_PCT="?"
BATTERY_TEMP_C="?"
RESOURCE_ACTION="RUNNING"
SIMULATE=false
SIM_SCAN_DIR=""
MAX_ITERS=0                       # 0 = unlimited (used by --simulate/--iters)
SCAN_CMD="termux-wifi-scaninfo"   # separable seam for the failure-mode test

# ============================================================================
# CORE UTILITIES - Module: Logging
# ============================================================================

# Print a timestamped, leveled log line (terminal + session log file).
log_msg() {
    local level=$1
    shift
    local msg="$*"
    local ts=$(date +'%H:%M:%S')
    local line="[$ts] [$level] $msg"
    echo "$line"
    if [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ]; then
        echo "$line" >> "$LOG_FILE"
    fi
}

# Fatal error: log, attempt graceful cleanup, exit.
error_exit() {
    log_msg "ERROR" "$1"
    SHUTDOWN_REQUESTED=true
    cleanup
    exit 1
}

# Initialize session log + JSON export files.
init_log_files() {
    mkdir -p "$LOG_DIR" "$JSON_DIR" 2>/dev/null || true
    LOG_FILE="${LOG_DIR}/wifi_scan_${TIMESTAMP}.log"
    JSON_FILE="${JSON_DIR}/networks_${TIMESTAMP}.json"
    {
        echo "================================="
        echo "WiFi Reconnaissance Log (v2.0)"
        echo "Started: $(date)"
        echo "Throttle state: $THROTTLE_STATE"
        echo "Throttle-safe fallback: $THROTTLE_SAFE_MODE"
        echo "================================="
        echo ""
    } >> "$LOG_FILE"
    log_msg "INFO" "Logging to: $LOG_FILE"
    log_msg "INFO" "JSON export to: $JSON_FILE"
    echo "[]" > "$JSON_FILE"
}

# Finalize log files with session totals.
finalize_log_files() {
    if [ -n "$LOG_FILE" ] && [ -f "$LOG_FILE" ]; then
        {
            echo ""
            echo "================================="
            echo "Scan Session Ended: $(date)"
            echo "Total Scans Recorded: $SCAN_COUNT"
            echo "Total Radio Toggles: $TOGGLE_COUNT_TOTAL"
            echo "Throttle State: $THROTTLE_STATE"
            echo "Session Duration: $(session_elapsed)s"
            echo "================================="
        } >> "$LOG_FILE"
    fi
}

# Release wake lock if held (called from EXIT trap too).
cleanup() {
    if [ "$WAKELOCK_ACQUIRED" = true ]; then
        log_msg "INFO" "Releasing wake lock..."
        termux-wake-lock -r 2>/dev/null || true
        WAKELOCK_ACQUIRED=false
    fi
}

# Graceful Ctrl+C handler: clean up, finalize, print file locations, exit.
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

trap handle_interrupt SIGINT SIGTERM
trap cleanup EXIT

# ============================================================================
# CORE UTILITIES - Module: Timing / Radio Control
# ============================================================================

# Sleep that short-circuits under NETRECON_SIMULATE=1 (off-device validation).
_sleep() {
    [ "${NETRECON_SIMULATE:-0}" = "1" ] && return 0
    sleep "$1"
}

# Shutdown-responsive sleep (checks Ctrl+C flag every second).
sleep_wait() {
    local remaining=$1
    if [ "${NETRECON_SIMULATE:-0}" = "1" ]; then
        return 0
    fi
    while [ "$remaining" -gt 0 ] && [ "$SHUTDOWN_REQUESTED" = false ]; do
        sleep 1
        ((remaining--))
    done
}

# Seconds since session start.
session_elapsed() {
    echo $(( $(date +%s) - SESSION_START_TS ))
}

# Acquire the wake lock (only around toggle windows - conservative by design).
acquire_wake_lock() {
    if [ "$WAKELOCK_ACQUIRED" = false ]; then
        termux-wake-lock 2>/dev/null || log_msg "WARN" "termux-wake-lock acquire failed"
        WAKELOCK_ACQUIRED=true
    fi
}

# Release the wake lock.
release_wake_lock() {
    if [ "$WAKELOCK_ACQUIRED" = true ]; then
        termux-wake-lock -r 2>/dev/null || true
        WAKELOCK_ACQUIRED=false
    fi
}

# Number of radio toggles recorded in the last 60 s (prunes history).
toggles_in_window() {
    local now kept=() i
    now=$(date +%s)
    for i in "${TOGGLE_TS[@]:-}"; do
        [ -z "$i" ] && continue
        if [ $(( now - i )) -lt 60 ]; then
            kept+=("$i")
        fi
    done
    TOGGLE_TS=("${kept[@]}")
    echo "${#kept[@]}"
}

# HARD toggle-budget check: independent of all scan-freshness logic.
toggle_budget_available() {
    if [ "$(toggles_in_window)" -ge "$TOGGLE_RATE_LIMIT_PER_MIN" ]; then
        return 1
    fi
    return 0
}

# SINGLE chokepoint for every radio toggle in the script.
#   - enforces the per-minute ceiling (cannot be exceeded by any caller),
#   - holds the wake lock ONLY around the radio off/on window,
#   - tolerates API failures (logs WARN, keeps running) instead of crashing.
force_toggle_cycle() {
    if ! toggle_budget_available; then
        log_msg "WARN" "Toggle budget exhausted (cap=${TOGGLE_RATE_LIMIT_PER_MIN}/min). Skipping forced refresh."
        return 1
    fi
    log_msg "INFO" "Forcing radio refresh (toggle #$((TOGGLE_COUNT_TOTAL + 1)))..."
    acquire_wake_lock
    termux-wifi-enable false 2>/dev/null || log_msg "WARN" "termux-wifi-enable false failed (permissions/airplane mode?)"
    _sleep "$RADIO_TOGGLE_OFF_WAIT"
    termux-wifi-enable true 2>/dev/null || log_msg "WARN" "termux-wifi-enable true failed (permissions/airplane mode?)"
    _sleep "$RADIO_TOGGLE_ON_WAIT"
    _sleep "$SCAN_STABILITY_WAIT"
    release_wake_lock
    ((TOGGLE_COUNT_TOTAL++))
    TOGGLE_TS+=("$(date +%s)")
    SAME_DATA_COUNT=0
    return 0
}
# ============================================================================
# MODULE: Throttle-State Verification
# ============================================================================

# Detect whether Android Wi-Fi scan throttling is disabled.
# Sets THROTTLE_STATE = DISABLED | ACTIVE | INCONCLUSIVE.
check_throttle_state() {
    local raw lc

    if [ -n "$THROTTLE_OVERRIDE" ]; then
        case "$THROTTLE_OVERRIDE" in
            disabled) THROTTLE_STATE="DISABLED" ;;
            active)   THROTTLE_STATE="ACTIVE" ;;
            *) THROTTLE_STATE="INCONCLUSIVE" ;;
        esac
        log_msg "INFO" "Throttle override in effect: $THROTTLE_STATE"
        return 0
    fi

    if ! command -v dumpsys &>/dev/null; then
        THROTTLE_STATE="INCONCLUSIVE"
        log_msg "WARN" "dumpsys not available - throttle state INCONCLUSIVE (throttle-safe fallback will engage)"
        return 1
    fi

    raw=$(timeout 3 dumpsys wifi 2>/dev/null | grep -i throttl)
    if [ -z "$raw" ]; then
        THROTTLE_STATE="INCONCLUSIVE"
        log_msg "WARN" "No throttling line found in 'dumpsys wifi' - throttle state INCONCLUSIVE (throttle-safe fallback)"
        return 1
    fi

    lc=$(echo "$raw" | head -1 | tr '[:upper:]' '[:lower:]')
    if echo "$lc" | grep -Eq 'disabled|false|off|none'; then
        THROTTLE_STATE="DISABLED"
    elif echo "$lc" | grep -Eq 'enabled|true|on|active|limit'; then
        THROTTLE_STATE="ACTIVE"
    else
        THROTTLE_STATE="INCONCLUSIVE"
    fi
    log_msg "INFO" "Throttle check: '$(echo "$raw" | head -1)' -> $THROTTLE_STATE"
}

# Apply the throttle policy: throttle-free foreground, or fall back to
# toggle-heavy (throttle-safe) behavior with a logged WARNING.
apply_throttle_policy() {
    case "$THROTTLE_STATE" in
        DISABLED)
            THROTTLE_SAFE_MODE=false
            log_msg "INFO" "Wi-Fi throttling confirmed DISABLED - using throttle-free foreground strategy."
            ;;
        ACTIVE|INCONCLUSIVE)
            THROTTLE_SAFE_MODE=true
            log_msg "WARNING" "Throttling is $THROTTLE_STATE or unverifiable. Falling back to toggle-heavy (throttle-safe) behavior - capped by TOGGLE_RATE_LIMIT_PER_MIN."
            ;;
    esac
}

# ============================================================================
# MODULE: Resource Guard (battery / temperature / runtime / toggle caps)
# ============================================================================

# Read battery % and temperature via termux-battery-status into globals.
read_battery_status() {
    local raw pct tempval
    BATTERY_PCT="?"
    BATTERY_TEMP_C="?"

    if ! command -v termux-battery-status &>/dev/null; then
        log_msg "WARN" "termux-battery-status not available - resource guard degraded (no battery/temp reads)"
        return 1
    fi
    raw=$(termux-battery-status 2>/dev/null)
    [ -z "$raw" ] && { log_msg "WARN" "termux-battery-status returned nothing - resource guard degraded"; return 1; }

    pct=$(echo "$raw" | jq -r '.percentage // .battery_level // ""' 2>/dev/null)
    case "$pct" in
        ''|*[!0-9]*) BATTERY_PCT="?" ;;
        *) BATTERY_PCT=$pct ;;
    esac

    tempval=$(echo "$raw" | jq -r '.temperature // .temp // ""' 2>/dev/null)
    if [ -n "$tempval" ] && [ "$tempval" != "null" ]; then
        BATTERY_TEMP_C=$tempval
    fi
    return 0
}

# Float-aware numeric compare (bash has no float arithmetic).
num_ge() { awk -v a="$1" -v b="$2" 'BEGIN { exit !(a + 0 >= b + 0) }'; }

# Resource guard: called at the START of every scan loop iteration.
# Echoes one of: RUNNING | LOW_BATTERY_PASSIVE | PAUSED_LOW |
#                PAUSED_HIGH_TEMP | SESSION_ENDED
resource_guard() {
    RESOURCE_ACTION="RUNNING"
    # 1) Hard maximum total session runtime -> auto-stop + finalize.
    if [ "$(session_elapsed)" -ge "$MAX_SESSION_RUNTIME_SEC" ]; then
        log_msg "WARN" "Max session runtime reached (${MAX_SESSION_RUNTIME_SEC}s). Auto-stopping."
        SHUTDOWN_REQUESTED=true
        RESOURCE_ACTION="SESSION_ENDED"
        return
    fi

    read_battery_status

    # 2) Emergency battery floor -> pause everything.
    if [ "$BATTERY_PCT" != "?" ] && [ "$BATTERY_PCT" -le "$BATTERY_EMERGENCY_PAUSE" ] 2>/dev/null; then
        log_msg "WARN" "Battery ${BATTERY_PCT}% at/below emergency floor ${BATTERY_EMERGENCY_PAUSE}%. Pausing scanning."
        RESOURCE_ACTION="PAUSED_LOW"
        return
    fi

    # 3) High battery temperature -> pause until cool-down (auto-resume).
    if [ "$BATTERY_TEMP_C" != "?" ] && num_ge "$BATTERY_TEMP_C" "$BATTERY_TEMP_HIGH_THRESHOLD"; then
        log_msg "WARN" "Battery temp ${BATTERY_TEMP_C}C >= threshold ${BATTERY_TEMP_HIGH_THRESHOLD}C. Pausing until cool-down."
        RESOURCE_ACTION="PAUSED_HIGH_TEMP"
        return
    fi

    # 4) Low battery -> switch foreground mode to passive (no toggles).
    if [ "$BATTERY_PCT" != "?" ] && [ "$BATTERY_PCT" -lt "$BATTERY_LOW_THRESHOLD" ] 2>/dev/null; then
        log_msg "WARN" "Battery ${BATTERY_PCT}% below ${BATTERY_LOW_THRESHOLD}%. Switching to passive monitoring."
        RESOURCE_ACTION="LOW_BATTERY_PASSIVE"
        return
    fi
}

# ============================================================================
# MODULE: Off-Device Simulation (--simulate) for pre-deployment validation
# ============================================================================

# Create Termux API stubs in $SCRIPT_DIR/.sim and prepend them to PATH so the
# whole script (loops, resource_guard, self-tests) can be exercised headlessly.
setup_simulation() {
    local dir
    dir="${SCRIPT_DIR}/.sim"
    mkdir -p "$dir" 2>/dev/null || true
    SIM_SCAN_DIR="$dir"

    # Canned scan payloads the sim "sees" (SIM_SCAN_FILE selects one).
    printf '%s\n' '[' \
        '  { "ssid": "SIM-NetA", "bssid": "00:11:22:33:44:01", "level": -45, "frequency": 2412 },' \
        '  { "ssid": "SIM-NetB", "bssid": "00:11:22:33:44:02", "level": -61, "frequency": 5180 },' \
        '  { "ssid": null, "bssid": "00:11:22:33:44:03", "level": -72, "frequency": 2412 }' \
        ']' > "$dir/scan_default.json"
    printf '%s\n' '[' \
        '  { "ssid": "SIM-NetA", "bssid": "00:11:22:33:44:01", "level": -45, "frequency": 2412 },' \
        '  { "ssid": "SIM-NetB", "bssid": "00:11:22:33:44:02", "level": -61, "frequency": 5180 },' \
        '  { "ssid": "SIM-TestAP", "bssid": "00:11:22:33:44:99", "level": -50, "frequency": 2437 }' \
        ']' > "$dir/scan_with_testap.json"
    printf '%s\n' '[' \
        '  { "ssid": "SIM-NetA", "bssid": "00:11:22:33:44:01", "level": -44, "frequency": 2412 },' \
        '  { "ssid": "SIM-NetB", "bssid": "00:11:22:33:44:02", "level": -62, "frequency": 5180 }' \
        ']' > "$dir/scan_changed.json"
    echo "[]" > "$dir/scan_empty.json"

    # Stub termux-wifi-scaninfo
    cat > "$dir/termux-wifi-scaninfo" <<'STUB'
#!/bin/sh
if [ -n "${SIM_SCAN_FILE:-}" ] && [ -f "$SIM_SCAN_FILE" ]; then
    cat "$SIM_SCAN_FILE"
    exit 0
fi
cat "${SIM_SCAN_DIR:-.}/scan_default.json" 2>/dev/null || echo "[]"
STUB
    chmod +x "$dir/termux-wifi-scaninfo"

    # Stub termux-wifi-enable (accepts true/false)
    cat > "$dir/termux-wifi-enable" <<'STUB'
#!/bin/sh
echo "SIM: termux-wifi-enable $*" >&2
exit 0
STUB
    chmod +x "$dir/termux-wifi-enable"

    # Stub termux-wake-lock (acquire/release no-op)
    cat > "$dir/termux-wake-lock" <<'STUB'
#!/bin/sh
echo "SIM: termux-wake-lock $*" >&2
exit 0
STUB
    chmod +x "$dir/termux-wake-lock"

    # Stub termux-battery-status
    cat > "$dir/termux-battery-status" <<'STUB'
#!/bin/sh
if [ -n "${SIM_BATTERY_FILE:-}" ] && [ -f "$SIM_BATTERY_FILE" ]; then
    cat "$SIM_BATTERY_FILE"
    exit 0
fi
printf '%s\n' '{ "percentage": 92, "status": "CHARGING", "temperature": 31.4 }'
STUB
    chmod +x "$dir/termux-battery-status"

    # Stub dumpsys wifi (throttle state line)
    cat > "$dir/dumpsys" <<'STUB'
#!/bin/sh
if [ "$1" = "wifi" ]; then
    echo "wifi_state=on wifi_scan_throttling=disabled"
fi
STUB
    chmod +x "$dir/dumpsys"

    export SIM_SCAN_DIR="$dir"
    export SIM_SCAN_FILE="$dir/scan_default.json"
    export NETRECON_SIMULATE=1
    export PATH="$dir:$PATH"
    log_msg "INFO" "SIMULATION MODE: Termux API stubbed from $dir (off-device validation only)"
}

# Point the sim at a canned payload (used by self-tests to emulate AP toggles).
sim_set_payload() {
    local name=$1
    if [ -n "$SIM_SCAN_DIR" ] && [ -f "${SIM_SCAN_DIR}/${name}.json" ]; then
        SIM_SCAN_FILE="${SIM_SCAN_DIR}/${name}.json"
        export SIM_SCAN_FILE
    fi
}

# Operator prompt that auto-answers under simulation.
prompt() {
    local msg=$1
    if [ "$SIMULATE" = true ]; then
        REPLY="${SIM_READ_ANSWER:-}"
        echo "(simulation) auto-answer"
        return 0
    fi
    printf "%s " "$msg"
    read -r REPLY || REPLY=""
}
# ============================================================================
# MODULE: Data Acquisition & Processing
# ============================================================================

# Get WiFi scan data (command overridable via SCAN_CMD for the failure-mode test).
# NOTE: the DEBUG log is sent to stderr so it is never captured by callers that
# wrap this in $(...) command substitution (which would corrupt the scan JSON).
get_scan_data() {
    local result
    result=$($SCAN_CMD 2>/dev/null)
    if [ -z "$result" ]; then
        log_msg "DEBUG" "Scan returned empty/null" >&2
    fi
    echo "$result"
}

# SHA1 hash of scan data (freshness/staleness comparison).
hash_scan_data() {
    local data=$1
    echo "$data" | sha1sum | awk '{print $1}'
}

# Count networks in scan data.
count_networks() {
    local data=$1
    if [ -z "$data" ] || [ "$data" = "[]" ]; then
        echo 0
    else
        echo "$data" | jq 'length' 2>/dev/null || echo 0
    fi
}

# Extract hidden-network BSSIDs (ssid null or empty).
get_hidden_networks() {
    local data=$1
    echo "$data" | jq -r '.[] | select(.ssid == null or .ssid == "") | .bssid' 2>/dev/null
}

# Persist scan data to the session JSON (dedup by BSSID).
save_scan_json() {
    local scan_data=$1
    if [ -z "$scan_data" ] || [ "$scan_data" = "[]" ]; then
        return
    fi
    if [ -f "$JSON_FILE" ]; then
        local existing merged
        existing=$(cat "$JSON_FILE")
        merged=$(echo "$existing" "$scan_data" | jq -s 'add | unique_by(.bssid)')
        echo "$merged" > "$JSON_FILE"
        ((SCAN_COUNT++))
    fi
}

# Label hidden networks sequentially (HD001, HD002, ...) instead of warning.
process_hidden_networks() {
    local data=$1
    local hidden_count
    hidden_count=$(echo "$data" | jq '[.[] | select(.ssid == null or .ssid == "")] | length' 2>/dev/null)
    if [ "$hidden_count" -gt 0 ]; then
        log_msg "WARN" "Detected $hidden_count hidden network(s) - labeled sequentially"
        local index=1
        while IFS= read -r bssid; do
            local hidden_name="${HIDDEN_NETWORK_PREFIX}$(printf "%03d" "$index")"
            log_msg "INFO" "Hidden network $index: BSSID=$bssid (Named: ${hidden_name})"
            ((index++))
        done < <(get_hidden_networks "$data")
    fi
}

# Detect whether a network with the given SSID is present in scan data.
scan_contains_ssid() {
    local data=$1 ssid=$2
    [ -z "$data" ] && return 1
    echo "$data" | jq -e --arg s "$ssid" '[.[] | select(.ssid == $s)] | length > 0' >/dev/null 2>&1
}

# Per-scan resource-context log line (battery %, temp, toggle counts).
log_scan_entry() {
    local count=$1 mode=$2
    local res
    if [ "$BATTERY_PCT" = "?" ]; then
        res="batt=unknown"
    else
        res="batt=${BATTERY_PCT}%"
    fi
    if [ "$BATTERY_TEMP_C" != "?" ]; then
        res="$res temp=${BATTERY_TEMP_C}C"
    else
        res="$res temp=unknown"
    fi
    log_msg "SCAN" "networks=$count $res toggles=${TOGGLE_COUNT_TOTAL}/60s=$(toggles_in_window) mode=$mode"
}

# ============================================================================
# MODULE: Screen State Detection
# ============================================================================

# Device screen state (ON/OFF) via dumpsys power.
get_screen_state() {
    local screen_state
    screen_state=$(dumpsys power 2>/dev/null | grep "Display Power" | grep -o "state=.*")
    if [[ "$screen_state" == *"OFF"* ]]; then
        echo "OFF"
    else
        echo "ON"
    fi
}

# Passive-mode interval tuned by screen state.
get_adaptive_interval() {
    if [ "$(get_screen_state)" = "OFF" ]; then
        echo "$BACKGROUND_SCAN_INTERVAL"
    else
        echo "$BACKGROUND_CHECK_INTERVAL"
    fi
}

# ============================================================================
# MODULE: Scan Freshness / Staleness (replaces the v1 adaptive backoff)
# ============================================================================

# Track consecutive identical hashes. Returns 0 on NEW data, 1 if unchanged.
check_scan_freshness() {
    local new_hash=$1
    if [ "$new_hash" = "$LAST_SCAN_HASH" ]; then
        ((SAME_DATA_COUNT++))
        return 1
    else
        SAME_DATA_COUNT=0
        LAST_SCAN_HASH="$new_hash"
        return 0
    fi
}
# ============================================================================
# SCANNING MODULES
# ============================================================================

# One foreground scan iteration. Also used by the failure-mode self-test so the
# real recovery path is what gets verified.
#   returns: 0 = continue, 1 = stop (session ended), 2 = paused (recheck later)
run_foreground_cycle() {
    local action current_scan count need_toggle scan_mode new_hash rc
    rc=0

    resource_guard
    action=$RESOURCE_ACTION
    case "$action" in
        SESSION_ENDED)
            return 1 ;;
        PAUSED_LOW|PAUSED_HIGH_TEMP)
            log_msg "INFO" "Resource guard: $action - delaying ${PAUSE_RECHECK_INTERVAL}s before recheck."
            _sleep "$PAUSE_RECHECK_INTERVAL"
            return 2 ;;
    esac

    scan_mode="foreground"
    [ "$action" = "LOW_BATTERY_PASSIVE" ] && scan_mode="passive"

    current_scan=$(get_scan_data)
    count=$(count_networks "$current_scan")
    need_toggle=false

    # Toggle WHEN: scan empty (or) throttle-safe fallback wants it (or) stale.
    if [ "$count" -eq 0 ] || [ -z "$current_scan" ] || [ "$current_scan" = "[]" ]; then
        log_msg "WARN" "Empty scan result."
        need_toggle=true
    elif [ "$THROTTLE_SAFE_MODE" = true ]; then
        # throttle-safe fallback: assume cached/stale, force refresh each cycle
        # (the per-minute toggle budget still caps this hard).
        need_toggle=true
    fi

    if [ "$count" -gt 0 ] && [ "$need_toggle" = false ]; then
        new_hash=$(hash_scan_data "$current_scan")
        if ! check_scan_freshness "$new_hash"; then
            if [ "$SAME_DATA_COUNT" -ge "$STALE_SCAN_CYCLES" ]; then
                log_msg "WARN" "Data unchanged for ${SAME_DATA_COUNT} scans - presumed stale, forcing refresh."
                need_toggle=true
            fi
        fi
    fi

    # Passive (low-battery) mode never toggles the radio.
    if [ "$need_toggle" = true ] && [ "$scan_mode" != "passive" ]; then
        if force_toggle_cycle; then
            current_scan=$(get_scan_data)
            count=$(count_networks "$current_scan")
        fi
    fi

    # Process + persist + resource-context log.
    if [ "$count" -gt 0 ]; then
        log_scan_entry "$count" "$scan_mode"
        echo "$current_scan" | jq -r '.[] | "\(.ssid // "HIDDEN") (\(.bssid)) - Signal: \(.level)dBm"' 2>/dev/null | head -3 | sed 's/^/  /'
        process_hidden_networks "$current_scan"
        save_scan_json "$current_scan"
    else
        log_msg "ERROR" "No scan data available after recovery attempts."
    fi
    return "$rc"
}

# Foreground scanning: toggles ONLY on empty/stale scans (throttle-free) or in
# throttle-safe fallback - always bounded by the toggle budget + resource guard.
foreground_scan() {
    init_log_files
    log_msg "INFO" "Starting foreground scanning mode (throttle-free strategy; safe-mode=$THROTTLE_SAFE_MODE)."
    log_msg "INFO" "Press Ctrl+C to stop and save results"

    local iteration=0
    while [ "$SHUTDOWN_REQUESTED" = false ]; do
        ((iteration++))
        if [ "$MAX_ITERS" -gt 0 ] && [ "$iteration" -gt "$MAX_ITERS" ]; then
            log_msg "INFO" "Iteration cap ($MAX_ITERS) reached - stopping."
            break
        fi
        log_msg "INFO" "=== Scan Iteration $iteration ==="
        run_foreground_cycle
        local rc=$?
        [ "$rc" -eq 1 ] && break
        sleep_wait "$FOREGROUND_SCAN_CYCLE"
    done

    finalize_log_files
    log_msg "INFO" "Foreground scan session ended (toggles=$TOGGLE_COUNT_TOTAL, scans=$SCAN_COUNT, runtime=$(session_elapsed)s)"
}

# Background / passive monitoring: reads the system scan cache, NEVER toggles
# the radio. Screen-aware intervals; resource-guarded (runtime/battery/temp).
background_scan() {
    init_log_files
    log_msg "INFO" "Starting background passive WiFi scanner (no radio toggles)."
    log_msg "INFO" "Screen-aware intervals; resource-guarded. Press Ctrl+C to stop."

    local iteration=0 last_screen="UNKNOWN" current_screen interval scan_data network_count hidden
    while [ "$SHUTDOWN_REQUESTED" = false ]; do
        ((iteration++))
        if [ "$MAX_ITERS" -gt 0 ] && [ "$iteration" -gt "$MAX_ITERS" ]; then
            log_msg "INFO" "Iteration cap ($MAX_ITERS) reached - stopping."
            break
        fi

        resource_guard
        case "$RESOURCE_ACTION" in
            SESSION_ENDED) break ;;
            PAUSED_LOW|PAUSED_HIGH_TEMP)
                log_msg "INFO" "Resource guard: $RESOURCE_ACTION - delaying ${PAUSE_RECHECK_INTERVAL}s before recheck."
                _sleep "$PAUSE_RECHECK_INTERVAL"
                continue ;;
        esac

        current_screen=$(get_screen_state)
        interval=$(get_adaptive_interval)
        if [ "$current_screen" != "$last_screen" ]; then
            log_msg "INFO" "Screen state: $current_screen (interval: ${interval}s)"
            last_screen="$current_screen"
        fi

        scan_data=$(get_scan_data)
        network_count=$(count_networks "$scan_data")
        if [ "$network_count" -gt 0 ]; then
            log_scan_entry "$network_count" "passive"
            echo "$scan_data" | jq -r '.[] | "\(.ssid // "HIDDEN") (\(.bssid)) - Signal: \(.level)dBm"' 2>/dev/null | head -3 | sed 's/^/  /'
            hidden=$(echo "$scan_data" | jq '[.[] | select(.ssid == null or .ssid == "")] | length' 2>/dev/null)
            if [ "$hidden" -gt 0 ]; then
                log_msg "INFO" "Hidden networks: $hidden"
            fi
            process_hidden_networks "$scan_data"
            save_scan_json "$scan_data"
        else
            log_msg "WARN" "No scan data available (may be a cached empty result)"
        fi

        sleep_wait "$interval"
    done

    finalize_log_files
    log_msg "INFO" "Background scan session ended (scans=$SCAN_COUNT, runtime=$(session_elapsed)s)"
}
# ============================================================================
# MODULE: Field-Readiness Self-Tests (--test)
# ============================================================================
# Run BEFORE field deployment. Every test ends in a PASS / FAIL / INCONCLUSIVE
# line; a FAIL means "do not deploy until resolved".

TEST_PASS=0
TEST_FAIL=0
TEST_INCONCLUSIVE=0
TEST_RESULTS=()

# Record one test outcome (terminal + log).
report_test() {
    local name=$1 status=$2 detail=$3
    echo "  [TEST] $name: $status${detail:+ -- }$detail"
    log_msg "TEST" "$name: $status -- $detail"
    case "$status" in
        PASS) ((TEST_PASS++)) ;;
        FAIL) ((TEST_FAIL++)) ;;
        *) ((TEST_INCONCLUSIVE++)) ;;
    esac
    TEST_RESULTS+=("$name|$status")
}

# T1 - Throttle-state verification (runs the requirement-1 check explicitly).
test_throttle_state() {
    echo ""
    echo "--- Test: Throttle-state verification ---"
    check_throttle_state
    apply_throttle_policy
    case "$THROTTLE_STATE" in
        DISABLED)   report_test "Throttle-state verification" "PASS" "throttling confirmed DISABLED; throttle-free strategy safe" ;;
        ACTIVE)     report_test "Throttle-state verification" "FAIL" "throttling still ACTIVE; device must keep throttle-safe mode" ;;
        INCONCLUSIVE) report_test "Throttle-state verification" "INCONCLUSIVE" "unverifiable via dumpsys wifi; throttle-safe fallback engaged" ;;
    esac
}

# T2 - Hash stability: back-to-back scans must hash identically (no false
#     "fresh" positives), and a real environment change must change the hash
#     (no false negatives).
test_hash_stability() {
    local s1 s2 h1 h2 s3 h3
    echo ""
    echo "--- Test: Hash stability ---"
    s1=$(get_scan_data)
    s2=$(get_scan_data)
    if [ -z "$s1" ] || [ -z "$s2" ]; then
        report_test "Hash stability (identical baseline)" "INCONCLUSIVE" "scan data unavailable (WiFi off / permissions?)"
        return
    fi
    h1=$(hash_scan_data "$s1")
    h2=$(hash_scan_data "$s2")
    if [ "$h1" = "$h2" ]; then
        report_test "Hash stability (no false 'fresh')" "PASS" "back-to-back scans produced identical hashes ($h1)"
    else
        report_test "Hash stability (no false 'fresh')" "FAIL" "hash changed with no environment change: $h1 vs $h2"
    fi

    # Second half: force an environment change, the hash MUST differ.
    if [ "$SIMULATE" = true ]; then
        sim_set_payload "scan_changed"
    else
        echo "  >>> Now force a REAL environment change (walk to a new location, or"
        echo "      toggle the test AP). Press Enter when done - the script will"
        echo "      re-scan and the hash MUST differ (no false negatives)."
        prompt "Press Enter after the environment change:"
    fi
    s3=$(get_scan_data)
    h3=$(hash_scan_data "$s3")
    if [ "$h3" != "$h1" ] && [ -n "$h3" ]; then
        report_test "Hash stability (no false negatives)" "PASS" "hash changed when the environment changed ($h1 -> $h3)"
    else
        report_test "Hash stability (no false negatives)" "FAIL" "hash did not change despite environment change"
    fi
    [ "$SIMULATE" = true ] && sim_set_payload "scan_default"
}
# Wait up to $timeout seconds for an SSID to appear (want=present) or vanish
# (want=absent). Polls every 5 s through the real get_scan_data path.
wait_for_ssid_presence() {
    local ssid=$1 want=$2 timeout=$3
    local waited=0 data
    while [ "$waited" -lt "$timeout" ]; do
        data=$(get_scan_data)
        if [ "$want" = "present" ] && scan_contains_ssid "$data" "$ssid"; then
            return 0
        fi
        if [ "$want" = "absent" ] && ! scan_contains_ssid "$data" "$ssid"; then
            return 0
        fi
        _sleep 5
        waited=$((waited + 5))
    done
    return 1
}

# T3 - Controlled AP capture: operator toggles a known AP; script must detect
#     the BSSID appearing and disappearing within the expected window.
test_controlled_ap_capture() {
    local ap_ssid
    echo ""
    echo "--- Test: Controlled AP capture ---"
    echo "Setup: you will toggle a known test AP on/off when signaled."
    ap_ssid=""
    if [ "$SIMULATE" = true ]; then
        ap_ssid="SIM-TestAP"
    else
        prompt "Enter the test AP SSID (the one you will toggle):"
        ap_ssid="$REPLY"
    fi
    if [ -z "$ap_ssid" ]; then
        report_test "Controlled AP capture" "INCONCLUSIVE" "no test AP SSID provided"
        return
    fi

    # Baseline: AP must be ABSENT.
    if scan_contains_ssid "$(get_scan_data)" "$ap_ssid"; then
        echo "  [!] Test AP '$ap_ssid' is currently VISIBLE - turn it OFF first."
        prompt "Press Enter once the AP is turned OFF:"
        [ "$SIMULATE" = true ] && sim_set_payload "scan_default"
    fi
    if wait_for_ssid_presence "$ap_ssid" absent 20; then
        report_test "Controlled AP baseline" "PASS" "test AP absent at baseline"
    else
        report_test "Controlled AP baseline" "FAIL" "test AP still visible - cannot run capture test"
        return
    fi

    # Phase 1: turn AP ON -> BSSID must appear.
    echo "  >>> SIGNAL: TURN the test AP ON now. <<<"
    if [ "$SIMULATE" = true ]; then
        sim_set_payload "scan_with_testap"
    else
        prompt "Press Enter once the AP is ON:"
    fi
    if wait_for_ssid_presence "$ap_ssid" present "$AP_DETECT_TIMEOUT"; then
        report_test "Controlled AP capture (BSSID appear)" "PASS" "detected new BSSID for '$ap_ssid' within ${AP_DETECT_TIMEOUT}s"
    else
        report_test "Controlled AP capture (BSSID appear)" "FAIL" "BSSID not detected within ${AP_DETECT_TIMEOUT}s - check radio warm-up waits"
    fi

    # Phase 2: turn AP OFF -> BSSID must disappear.
    echo "  >>> SIGNAL: TURN the test AP OFF now. <<<"
    if [ "$SIMULATE" = true ]; then
        sim_set_payload "scan_default"
    else
        prompt "Press Enter once the AP is OFF:"
    fi
    if wait_for_ssid_presence "$ap_ssid" absent "$AP_DETECT_TIMEOUT"; then
        report_test "Controlled AP capture (BSSID vanish)" "PASS" "BSSID disappeared within ${AP_DETECT_TIMEOUT}s"
    else
        report_test "Controlled AP capture (BSSID vanish)" "FAIL" "BSSID still visible after ${AP_DETECT_TIMEOUT}s"
    fi
}
# T4 - Ground-truth diff: script-side list vs Android Settings scan, compared
#     manually by the operator at the same moment. Fully automated diffing is
#     impossible (Settings' scan can't be queried), so this prints a clearly
#     formatted script-side network list for manual comparison.
test_ground_truth_diff() {
    local data missed
    echo ""
    echo "--- Test: Ground-truth diff ---"
    data=$(get_scan_data)
    if [ -z "$data" ] || [ "$data" = "[]" ]; then
        report_test "Ground-truth diff" "INCONCLUSIVE" "no scan data (WiFi off / permissions?)"
        return
    fi

    echo ""
    echo "  >>> At the SAME moment, open Android Settings > Wi-Fi and view the list."
    echo "      Compare against this script-side capture taken NOW:"
    echo ""
    echo "  Script-side network list ($(date +%H:%M:%S)):"
    echo "$data" | jq -r '.[] | "    \(.ssid // "HIDDEN")  [BSSID \(.bssid)]  \(.level)dBm  \(.frequency/1000)GHz"' 2>/dev/null
    echo ""
    echo "  If any network is visible in Settings but MISSING above (or vice versa),"
    echo "  enter its BSSID(s) now, separated by commas - otherwise press Enter."
    prompt "Missing BSSIDs (or Enter if lists match):"
    missed="$REPLY"
    if [ -n "$missed" ]; then
        echo "  Reported missing BSSIDs (manual review required):"
        echo "$missed" | tr ',' '\n' | sed 's/^/    - /'
        report_test "Ground-truth diff" "INCONCLUSIVE" "operator reported differences - review the BSSID list above"
    else
        report_test "Ground-truth diff" "PASS" "script-side list matched operator's Settings comparison"
    fi
}

# T5 - Failure-mode check: simulate a permissions/airplane-mode failure and
#     confirm the script logs it cleanly and keeps running (no crash).
test_failure_mode() {
    local stubdir saved_cmd data rc
    echo ""
    echo "--- Test: Failure-mode check ---"
    stubdir=$(mktemp -d) 2>/dev/null || {
        report_test "Failure-mode check" "INCONCLUSIVE" "cannot create temp dir"
        return
    }
    cat > "$stubdir/termux-wifi-scaninfo" <<'STUB'
#!/bin/sh
echo "SIMULATED FAILURE: WiFi permission denied (airplane mode?)" >&2
exit 1
STUB
    chmod +x "$stubdir/termux-wifi-scaninfo"

    saved_cmd=$SCAN_CMD
    SCAN_CMD="$stubdir/termux-wifi-scaninfo"

    # 1) Failing scan command returns empty; must not crash or exit.
    data=$(get_scan_data)
    if [ -z "$data" ] && [ "$SHUTDOWN_REQUESTED" = false ]; then
        report_test "Failure-mode (scan error)" "PASS" "failing scaninfo returned empty; script stayed alive"
    else
        report_test "Failure-mode (scan error)" "FAIL" "unexpected data/crash state after failing scan"
    fi

    # 2) One full cycle through the REAL recovery path (empty -> toggle -> WARN).
    run_foreground_cycle
    rc=$?
    SCAN_CMD=$saved_cmd
    if [ "$rc" -eq 1 ] && [ "$SHUTDOWN_REQUESTED" = true ]; then
        report_test "Failure-mode (recovery path)" "FAIL" "recovery path shut down the session (rc=$rc)"
    else
        report_test "Failure-mode (recovery path)" "PASS" "empty scan handled with WARN + continue; no crash (rc=$rc)"
    fi

    rm -rf "$stubdir" 2>/dev/null || true
    echo ""
    echo "  Manual on-device failure scenarios (repeat these before field use):"
    echo "    - Enable airplane mode, run --foreground: expect WARN/ERROR log lines, no crash."
    echo "    - Revoke Termux-api wifi permission, run --foreground: same behavior expected."
    echo "    - Ctrl+C mid-toggle: SIGINT trap must release wake lock and finalize logs."
}

# T6 - Mobility/walk-pace check (documented MANUAL procedure - not automatable).
test_mobility_walk_pace() {
    echo ""
    echo "--- Test: Mobility / walk-pace check (MANUAL - see below) ---"
    cat <<'EOF'
  Purpose: confirm scan-to-movement timing matches walking speed before a real
  walking deployment.

  Procedure (outdoors or a long hallway):
    1. Start this script in FOREGROUND mode:  network-recon.bash --foreground
    2. Pick two known APs ~10-20 m apart along your walking route.
    3. Walk the route at your normal reconnaissance pace.
    4. Afterwards open the session log (logs/wifi_scan_*.log) and confirm:
         - Both known AP BSSIDs appear in the log;
         - APs are visible ONLY near their physical location - no stale holdovers
           longer than ~2 scan cycles (~16 s at FOREGROUND_SCAN_CYCLE=8);
         - No gap in [SCAN] entries longer than ~2x FOREGROUND_SCAN_CYCLE.
    5. If BSSIDs lag behind your position, lower FOREGROUND_SCAN_CYCLE. If the
       phone runs hot / battery drains fast, raise it. Re-run --test after tuning.
EOF
    report_test "Mobility/walk-pace" "INCONCLUSIVE" "manual walk-through required (procedure printed above)"
}

# Run the full Field-Readiness suite and summarize.
run_field_readiness_tests() {
    echo ""
    echo "=== FIELD-READINESS SELF-TESTS ==="
    echo "Started: $(date)"
    echo ""

    init_log_files

    test_throttle_state
    test_hash_stability
    test_controlled_ap_capture
    test_ground_truth_diff
    test_failure_mode
    test_mobility_walk_pace

    echo ""
    echo "=== RESULTS SUMMARY ==="
    echo "  PASS         : $TEST_PASS"
    echo "  FAIL         : $TEST_FAIL"
    echo "  INCONCLUSIVE : $TEST_INCONCLUSIVE"
    echo ""
    for r in "${TEST_RESULTS[@]}"; do
        echo "    - $r"
    done
    echo ""
    finalize_log_files
    log_msg "INFO" "Field-readiness log saved to: $LOG_FILE"

    if [ "$TEST_FAIL" -gt 0 ]; then
        echo "  [!] ${TEST_FAIL} test(s) FAILED - RESOLVE before field deployment."
        return 1
    fi
    echo "  [OK] No FAILED tests - field-ready (review any INCONCLUSIVE items manually)."
    return 0
}
# ============================================================================
# DIAGNOSTIC MODE
# ============================================================================

run_diagnostic() {
    echo ""
    log_msg "TEST" "Running Termux API Diagnostic..."
    echo ""

    # Throttle state (explicit)
    log_msg "TEST" "Checking throttle state..."
    check_throttle_state
    apply_throttle_policy

    # scaninfo availability + a scan attempt with enable-retry.
    log_msg "TEST" "Checking termux-wifi-scaninfo availability..."
    if command -v termux-wifi-scaninfo &>/dev/null; then
        log_msg "SUCCESS" "termux-wifi-scaninfo is available"
    else
        log_msg "ERROR" "termux-wifi-scaninfo not found - Termux API required"
        return 1
    fi

    log_msg "TEST" "Attempting WiFi scan..."
    local scan
    scan=$(get_scan_data)
    if [ -n "$scan" ] && [ "$scan" != "[]" ]; then
        log_msg "SUCCESS" "Scan returned data: $(count_networks "$scan") networks"
    else
        log_msg "WARN" "Scan empty/null. Attempting to enable WiFi and retry..."
        termux-wifi-enable true 2>&1
        _sleep 5
        scan=$(get_scan_data)
        if [ -n "$scan" ] && [ "$scan" != "[]" ]; then
            log_msg "SUCCESS" "After enabling WiFi: $(count_networks "$scan") networks"
        else
            log_msg "ERROR" "Still no scan data after enabling WiFi (permissions / airplane mode?)"
            return 1
        fi
    fi

    # Wake lock acquire/release.
    log_msg "TEST" "Testing wake lock..."
    termux-wake-lock 2>/dev/null && log_msg "SUCCESS" "Wake lock can be acquired"
    termux-wake-lock -r 2>/dev/null && log_msg "SUCCESS" "Wake lock can be released"

    # Battery / temperature.
    log_msg "TEST" "Reading battery status..."
    if read_battery_status; then
        log_msg "SUCCESS" "Battery: ${BATTERY_PCT}% | Temp: ${BATTERY_TEMP_C}C"
    else
        log_msg "WARN" "Battery status unavailable"
    fi

    echo ""
    log_msg "SUCCESS" "Diagnostic complete"
    echo ""
}

# ============================================================================
# MAIN: CLI / Interactive Menu
# ============================================================================

usage() {
    cat <<EOF
Usage: $0 [options]

Options:
  --foreground          Foreground scanning (toggle radio only when empty/stale)
  --background          Background passive monitoring (never toggles radio)
  --diag                Run Termux API diagnostic
  --test                Run Field-Readiness self-tests (pre-deployment)
  --simulate            Off-device validation with simulated Termux API
  --iters N             Stop after N scan iterations (used by simulation)
  -h, --help            Show this help and exit

With no options, an interactive menu is shown.
EOF
}

show_menu() {
    clear
    echo ""
    echo "╔════════════════════════════════════════════════════════════╗"
    echo "║   WiFi Network Reconnaissance v2.0 (throttle-free edition) ║"
    echo "╚════════════════════════════════════════════════════════════╝"
    echo ""
    echo "  Throttle state : $THROTTLE_STATE (throttle-safe fallback: $THROTTLE_SAFE_MODE)"
    echo "  Log directory  : $LOG_DIR"
    echo "  JSON export    : $JSON_DIR"
    echo ""
    echo "Select mode:"
    echo ""
    echo "  [1] Foreground scanning (toggle only when empty/stale)"
    echo "      • Throttle-aware with throttle-safe fallback"
    echo "      • Resource-guarded (toggle cap, battery/temp/runtime)"
    echo ""
    echo "  [2] Background scanning (passive - never toggles radio)"
    echo ""
    echo "  [3] Field-Readiness Tests (pre-deployment verification)"
    echo ""
    echo "  [4] Run Diagnostic (Termux API + throttle + battery)"
    echo ""
    echo "  [5] View Recent Scans"
    echo ""
    echo "  [6] Exit (with graceful shutdown)"
    echo ""
    echo "─────────────────────────────────────────────────────────────"
    printf "Enter choice [1-6]: "
}
interactive_menu() {
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
                echo ""
                run_field_readiness_tests
                echo ""
                prompt "Press Enter to return to menu"
                ;;
            4)
                echo ""
                run_diagnostic
                echo ""
                prompt "Press Enter to return to menu"
                ;;
            5)
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
                prompt "Press Enter to return to menu"
                ;;
            6)
                echo ""
                log_msg "INFO" "Exiting gracefully..."
                SHUTDOWN_REQUESTED=true
                break
                ;;
            *)
                echo ""
                log_msg "ERROR" "Invalid choice. Please enter 1-6."
                sleep_wait 2
                ;;
        esac
    done
    log_msg "INFO" "Thank you for using WiFi Reconnaissance Script."
    echo ""
}

main() {
    local mode="menu" run_tests=false
    local -a args=("$@")
    local i=0

    while [ $i -lt ${#args[@]} ]; do
        case "${args[$i]}" in
            --foreground|-f) mode="foreground" ;;
            --background|-b) mode="background" ;;
            --diag|-d) mode="diag" ;;
            --test|--tests|--field-readiness) run_tests=true ;;
            --simulate) SIMULATE=true ;;
            --iters)
                i=$((i + 1))
                MAX_ITERS=${args[$i]:-0}
                ;;
            --iters=*) MAX_ITERS=${args[$i]#--iters=} ;;
            -h|--help) usage; exit 0 ;;
            *)
                echo "Unknown argument: ${args[$i]}" >&2
                usage
                exit 1
                ;;
        esac
        i=$((i + 1))
    done

    # Simulation must be set up before any Termux API command runs.
    if [ "$SIMULATE" = true ]; then
        setup_simulation
    fi

    if ! command -v termux-wifi-scaninfo &>/dev/null; then
        error_exit "Termux API not available. This script requires Termux with the WiFi API (or use --simulate for off-device validation)."
    fi
    mkdir -p "$LOG_DIR" "$JSON_DIR" 2>/dev/null || true

    check_throttle_state
    apply_throttle_policy

    if [ "$run_tests" = true ]; then
        run_field_readiness_tests
        exit $?
    fi

    case "$mode" in
        foreground) foreground_scan ;;
        background) background_scan ;;
        diag) run_diagnostic ;;
        *) interactive_menu ;;
    esac
}

# ============================================================================
# SCRIPT ENTRY POINT
# ============================================================================

if [ "${BASH_SOURCE[0]}" = "${0}" ]; then
    main "$@"
fi
