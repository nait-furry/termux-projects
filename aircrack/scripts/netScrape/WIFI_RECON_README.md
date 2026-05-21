# WiFi Network Reconnaissance Script for Termux/Android

## Overview

**netScript.bash** is a comprehensive WiFi network scanning and reconnaissance tool designed for Termux on Android devices. It provides both aggressive foreground scanning for active network discovery and passive background monitoring for continuous WiFi surveillance.

### Key Features

- 🎯 **Dual-Mode Operation**: Toggle between aggressive and passive scanning
- 🔄 **Adaptive Scanning**: Intelligently adjusts refresh intervals based on data freshness
- 📊 **Hidden Network Detection**: Identifies and names hidden SSIDs sequentially
- 📱 **Screen-Aware Monitoring**: Optimizes battery usage based on device screen state
- 🔒 **Wake Lock Management**: Prevents WiFi radio throttling during scans
- 🛠️ **Diagnostic Tools**: Built-in troubleshooting to verify Termux API setup
- 📝 **Modular Architecture**: Well-organized functions for easy maintenance and customization

---

## Requirements

### System Requirements
- **Termux** application installed on Android device
- **Termux:API** plugin installed
- **Android 5.0+**

### Dependencies
- `bash` (default shell in Termux)
- `jq` (JSON query tool)
- Termux API permissions granted

### Installation of Dependencies

```bash
# Install jq if not already installed
apt update
apt install jq

# Verify bash is available
which bash
```

---

## Installation

### 1. Copy Script to Termux

```bash
# Navigate to where you want to store the script
cd ~/scripts
# or in $HOME/.local/bin for system-wide access
cp /path/to/netScript.bash .
```

### 2. Make Executable

```bash
chmod +x netScript.bash
```

### 3. Grant Termux:API Permissions

On your Android device:
1. Go to **Settings** → **Apps** → **Termux**
2. **Permissions** → Enable:
   - Location (for network scanning)
   - Device Info (for system queries)
   - Sensors (optional, for motion detection enhancement)

⚠️ **Important**: Without these permissions, the script will fail. Run option 3 (Diagnostic) to verify.

---

## Quick Start

### Basic Usage

```bash
# Run the script
./netScript.bash

# Select option from interactive menu:
# [1] Foreground Scanning (Aggressive)
# [2] Background Scanning (Passive)
# [3] Run Diagnostic
# [4] Exit
```

### Example Session

```bash
$ ./netScript.bash

╔════════════════════════════════════════════════════════════╗
║     WiFi Network Reconnaissance for Termux/Android         ║
╚════════════════════════════════════════════════════════════╝

Select scanning mode:

  [1] Foreground Scanning (Aggressive - Resource Intensive)
  [2] Background Scanning (Passive - Battery Friendly)
  [3] Run Diagnostic (Test Termux API)
  [4] Exit

Enter choice [1-4]: 1

[19:30:45] [INFO] Starting aggressive foreground scanning mode...
[19:30:45] [INFO] Keep-alive enabled to prevent WiFi radio throttling
[19:30:46] [INFO] === Scan Iteration 1 ===
[19:30:48] [SUCCESS] Fresh scan data: 12 networks found
  Network1 (AA:BB:CC:DD:EE:FF) - Signal: -45dBm
  Network2 (11:22:33:44:55:66) - Signal: -62dBm
  Network3 (99:88:77:66:55:44) - Signal: -78dBm
[19:30:48] [INFO] Next scan in 3s...
```

---

## Operating Modes

### Mode 1: Foreground Scanning (Aggressive)

**Purpose**: Active, resource-intensive network discovery

**How It Works**:
1. Acquires CPU wake lock to prevent radio sleep
2. Toggles WiFi OFF/ON to force fresh scans
3. Waits for radio stabilization (4 seconds)
4. Reads scan data and compares to previous result
5. If data unchanged after 3 scans, increases delay (adaptive backoff)
6. Maximum delay caps at 30 seconds to avoid excessive delays

**Best For**:
- 🏃 Active wardriving/site surveys
- 🔍 Discovering new networks in area
- 📊 Comprehensive network mapping
- ⚡ When AC power is available

**Resource Usage**:
- CPU: High (wake lock active)
- Battery: Significant drain
- WiFi Radio: Continuously active
- Network Updates: Every 3-30 seconds

**Configuration**:
```bash
# In script (lines 13-17)
readonly FOREGROUND_TOGGLE_OFF=3
readonly FOREGROUND_TOGGLE_ON=4
readonly FOREGROUND_INITIAL_SCAN=3
readonly FOREGROUND_MAX_SCAN_DELAY=12
readonly SCAN_STABILITY_WAIT=2
```

---

### Mode 2: Background Scanning (Passive)

**Purpose**: Low-power continuous network monitoring

**How It Works**:
1. Reads WiFi scan cache without forcing toggles
2. Adapts intervals based on screen state:
   - Screen ON: Checks every 10 seconds
   - Screen OFF: Checks every 30 seconds
3. Minimal CPU and radio activity
4. Detects hidden networks periodically

**Best For**:
- 🔋 Battery-limited scenarios
- 📍 Long-term location tracking
- 🌐 Continuous background monitoring
- 🪫 Overnight passive surveillance

**Resource Usage**:
- CPU: Minimal
- Battery: Small drain (periodic reads only)
- WiFi Radio: Minimal activity (uses cached Android scans)
- Network Updates: Every 10-30 seconds

**Configuration**:
```bash
# In script (lines 18-19)
readonly BACKGROUND_SCAN_INTERVAL=30
readonly BACKGROUND_CHECK_INTERVAL=10
```

---

### Mode 3: Diagnostic Mode

**Purpose**: Troubleshoot Termux API setup and permissions

**Tests**:
- ✓ Availability of `termux-wifi-scaninfo`
- ✓ Ability to retrieve scan data
- ✓ WiFi enable/disable functionality
- ✓ Wake lock acquisition/release
- ✓ Detailed error messages

**Usage**:
1. Select option 3 from main menu
2. Script will run all diagnostic tests
3. Reports success/failure for each test
4. Suggests solutions for failed tests

**Example Output**:
```
Running Termux API Diagnostic...

[19:35:10] [TEST] Checking termux-wifi-scaninfo availability...
[19:35:10] [SUCCESS] termux-wifi-scaninfo is available
[19:35:10] [TEST] Attempting WiFi scan...
[19:35:15] [SUCCESS] Scan returned data: 14 networks
[19:35:15] [TEST] Testing wake lock...
[19:35:15] [SUCCESS] Wake lock can be acquired
[19:35:15] [SUCCESS] Wake lock can be released

[19:35:15] [SUCCESS] Diagnostic complete - system appears ready
```

---

## Understanding Output

### Log Levels

| Level | Color | Meaning | Action |
|-------|-------|---------|--------|
| **INFO** | Blue | Informational message | Normal operation |
| **SUCCESS** | Green | Operation completed | Data acquired |
| **WARN** | Yellow | Warning condition | May retry automatically |
| **ERROR** | Red | Critical failure | Review logs/permissions |
| **DEBUG** | Cyan | Detailed debugging info | For troubleshooting |
| **TEST** | Magenta | Diagnostic test running | In diagnostic mode |

### Sample Network Entry

```
Network1 (AA:BB:CC:DD:EE:FF) - Signal: -45dBm
└─ SSID (friendly name or "HIDDEN")
└─ BSSID (MAC address)
└─ Signal strength (RF power in dBm, -30 to -90 range)
```

### Hidden Networks

```
[WARNING] Detected 2 hidden network(s)
[INFO] Hidden network 1: BSSID=AA:BB:CC:DD:EE:01 (Named: HD001)
[INFO] Hidden network 2: BSSID=AA:BB:CC:DD:EE:02 (Named: HD002)
```

---

## Adaptive Scanning Logic

### How Adaptive Delay Works

The foreground scanning mode intelligently adjusts scan intervals:

```
Iteration 1: Scan → [New Data] → Delay = 3s
Iteration 2: Scan → [Same Data #1] → Delay = 3s
Iteration 3: Scan → [Same Data #2] → Delay = 3s
Iteration 4: Scan → [Same Data #3] → (Threshold reached) → Delay = 5s
Iteration 5: Scan → [Same Data #4] → Delay = 7s
Iteration 6: Scan → [Same Data #5] → Delay = 9s
...continuing until...
Iteration N: Scan → [Same Data #X] → Delay = 30s (max cap)

Until...
Iteration N+1: Scan → [New Data] → Delay RESET to 3s
```

**Benefits**:
- Reduces CPU/battery waste when no new networks appear
- Quickly resumes aggressive scanning when movement detected
- Prevents infinite delays with configurable ceiling

---

## Configuration & Customization

### Edit Timing Parameters

Edit these values in the script (lines 13-29):

```bash
# How long to wait for radio shutdown (preventing incomplete toggle)
FOREGROUND_TOGGLE_OFF=3

# How long to allow radio to come back online
FOREGROUND_TOGGLE_ON=4

# Initial scan delay in foreground mode
FOREGROUND_INITIAL_SCAN=3

# Maximum scan delay before capping
FOREGROUND_MAX_SCAN_DELAY=12

# How many identical scans trigger delay increase
SAME_DATA_THRESHOLD=3

# Seconds to add per same-data iteration
ADAPTIVE_INCREMENT=2

# Background mode intervals
BACKGROUND_SCAN_INTERVAL=30
BACKGROUND_CHECK_INTERVAL=10
```

### Example: Speed Up Discovery

For faster network discovery (more aggressive):

```bash
FOREGROUND_INITIAL_SCAN=1          # Check more frequently
FOREGROUND_MAX_SCAN_DELAY=6        # Lower ceiling
ADAPTIVE_INCREMENT=1               # Slower backoff
```

### Example: Battery Conservative Mode

For maximum battery efficiency:

```bash
FOREGROUND_TOGGLE_OFF=2            # Faster toggle
FOREGROUND_TOGGLE_ON=3
FOREGROUND_MAX_SCAN_DELAY=20       # Higher ceiling
ADAPTIVE_INCREMENT=3               # Faster backoff
BACKGROUND_CHECK_INTERVAL=20       # Less frequent background checks
```

---

## Troubleshooting

### Issue: "Termux API not available"

**Cause**: Termux:API plugin not installed or commands not in PATH

**Solutions**:
```bash
# 1. Install termux-api package
apt install termux-api

# 2. Verify installation
which termux-wifi-scaninfo

# 3. If not found, update Termux
apt update && apt upgrade
```

### Issue: Empty Scan Results

**Cause**: Permissions not granted or WiFi not enabled

**Solutions**:
1. Go to **Settings** → **Apps** → **Termux** → **Permissions**
2. Enable **Location** permission (required for WiFi scanning)
3. Enable WiFi on device before running script
4. Run diagnostic mode to verify

### Issue: Wake Lock Release Error

**Cause**: Wake lock already released or invalid state

**Solution**: This is non-critical. The script will continue normally. If persistent:
```bash
# Check wake lock status manually
termux-wake-lock -r  # Release all wake locks
```

### Issue: Script Takes Too Long Between Scans

**Cause**: Adaptive delay has increased due to static network data

**Solution**: 
- Move to different location to discover new networks (triggers reset)
- Or manually restart script to reset delay
- Or edit `FOREGROUND_MAX_SCAN_DELAY` to lower value

### Issue: High Battery Drain

**Cause**: Using foreground mode or screen always on

**Solutions**:
1. Use **Background Mode** (option 2) instead
2. Screen OFF reduces background check frequency (30s vs 10s)
3. Add delay between iterations in config
4. Use on AC power if possible

---

## Data Collection & Analysis

### Network Information Captured

Each network entry includes:
- **SSID**: Network name (or "HIDDEN" if not broadcast)
- **BSSID**: MAC address (unique identifier)
- **Level**: Signal strength in dBm (decibels relative to 1 milliwatt)
- **Frequency**: Radio frequency (2.4GHz or 5GHz typically)
- **Capabilities**: Security type (WPA2, WPA3, etc)

### Export Scan Data

To save results:

```bash
# Run script and redirect output
./netScript.bash 2>&1 | tee wifi_scan_$(date +%Y%m%d_%H%M%S).log

# Later, filter for specific networks
grep "Network1" wifi_scan_*.log
```

### Parse Raw JSON

The script captures raw JSON from `termux-wifi-scaninfo`. To analyze:

```bash
# Get current scan as JSON
termux-wifi-scaninfo > networks.json

# Count networks
jq 'length' networks.json

# List all BSSIDs
jq -r '.[].bssid' networks.json

# Find strongest signal
jq -r '.[] | select(.level == max)' networks.json
```

---

## Advanced Usage

### Run as Background Service

For continuous monitoring on startup:

```bash
# Create launcher script
cat > ~/start_wifi_recon.sh << 'EOF'
#!/bin/bash
nohup ~/scripts/netScript.bash > ~/wifi_recon.log 2>&1 &
echo "WiFi reconnaissance started in background"
EOF

chmod +x ~/start_wifi_recon.sh
```

### Combine with Other Tools

```bash
# Pipe to grep for specific networks
./netScript.bash | grep "Network1"

# Capture strong signals only
./netScript.bash | grep "\-[0-5][0-9]dBm"

# Monitor specific BSSID
./netScript.bash | grep "AA:BB:CC"
```

### Cron-Based Scanning (Foreground)

```bash
# Add to crontab for hourly scans
0 * * * * /home/user/scripts/netScript.bash << 'EOF'
1
EOF
# (Sends option 1 automatically)
```

---

## Script Architecture

### Modular Organization

```
netScript.bash
├── GLOBAL CONFIGURATION
│   └── Timing, thresholds, state variables
├── UTILITY FUNCTIONS - Core Operations
│   └── Logging, error handling, cleanup
├── UTILITY FUNCTIONS - WiFi Hardware Control
│   └── Radio toggling, state management
├── UTILITY FUNCTIONS - Data Acquisition & Processing
│   └── Scanning, JSON parsing, hashing
├── UTILITY FUNCTIONS - Screen State Detection
│   └── Device state awareness
├── SCANNING MODULE - Adaptive Scan Logic
│   └── Freshness checking, intelligent backoff
├── SCANNING FUNCTIONS - Foreground
│   └── Aggressive scanning loop
├── SCANNING FUNCTIONS - Background
│   └── Passive monitoring loop
├── DIAGNOSTIC MODE
│   └── API verification and troubleshooting
└── MAIN - Interactive Menu
    └── User interface and mode selection
```

### Key Functions

| Function | Module | Purpose |
|----------|--------|---------|
| `log_msg()` | Core Ops | Timestamped logging |
| `wifi_set_state()` | WiFi Control | Enable/disable radio |
| `force_fresh_scan()` | WiFi Control | Toggle sequence |
| `get_scan_data()` | Data Acq | Retrieve WiFi info |
| `hash_scan_data()` | Data Acq | Compare scan results |
| `check_scan_freshness()` | Adaptive | Detect new data |
| `adaptive_delay_backoff()` | Adaptive | Increase delay on plateau |
| `foreground_scan()` | Scanning | Main aggressive loop |
| `background_scan()` | Scanning | Main passive loop |
| `run_diagnostic()` | Diagnostic | Verify Termux API |

---

## Performance Characteristics

### Foreground Mode (Active Scanning)

| Metric | Value | Notes |
|--------|-------|-------|
| CPU Usage | 15-30% | Wake lock keeps CPU active |
| WiFi Radio | Always ON | Continuous transmit/receive |
| Battery Drain | ~5-8% per hour | Depends on device |
| Scan Interval | 3-30s | Adaptive based on data |
| Memory | ~5-10 MB | Minimal overhead |
| Network Discovery | Fastest | Forces fresh scans |

### Background Mode (Passive Scanning)

| Metric | Value | Notes |
|--------|-------|-------|
| CPU Usage | <1% | Only when checking |
| WiFi Radio | System managed | OS controls power state |
| Battery Drain | <1% per hour | Minimal impact |
| Scan Interval | 10-30s | Based on screen state |
| Memory | ~3-5 MB | Lighter footprint |
| Network Discovery | Slower | Relies on OS cache |

---

## Security & Privacy Considerations

### What This Script Does
- ✅ Reads publicly broadcast WiFi networks (SSID)
- ✅ Captures MAC addresses (BSSID) - standard for WiFi
- ✅ Measures signal strength - used for location approximation
- ✅ Detects hidden networks by their presence
- ❌ DOES NOT crack passwords
- ❌ DOES NOT connect to networks
- ❌ DOES NOT capture traffic

### Ethical Use
- **Legal Wardriving**: This script performs passive network enumeration only
- **Personal Use**: Monitor your own WiFi environment
- **Site Survey**: Professional network assessments with authorization
- **Research**: Academic WiFi propagation studies

⚠️ **Disclaimer**: Unauthorized network scanning may violate local laws. Always have permission before scanning networks you don't own.

---

## Examples & Use Cases

### Use Case 1: Site Survey for WiFi Deployment

```bash
# Navigate to proposed access point location
./netScript.bash
# Select mode 1 (Foreground)
# Walk area for 5-10 minutes
# Note signal strengths and coverage gaps
# Results inform AP placement
```

### Use Case 2: Wardriving Documentation

```bash
# Log all networks while traveling
./netScript.bash | tee wardriving_$(date +%Y%m%d).log
# Later analyze with:
grep "Network" wardriving_*.log | sort | uniq -c
```

### Use Case 3: Hidden Network Discovery

```bash
# Run foreground scan targeting hidden networks
./netScript.bash
# [Option 1]
# Watch for HD001, HD002 etc entries
# Note their BSSIDs and power levels
```

### Use Case 4: Device Location Tracking

```bash
# Run background mode continuously
./netScript.bash
# [Option 2]
# Device logs nearby networks without draining battery
# Can be combined with location services for WiFi-based positioning
```

---

## Logs & Output Files

### Terminal Output Format

```
[19:30:45] [INFO] Message here
[19:30:46] [SUCCESS] Operation successful
[19:30:47] [WARN] Warning message
[19:30:48] [ERROR] Error occurred
[19:30:49] [DEBUG] Detailed debug info
```

### Saving Output to File

```bash
# Log to file with timestamp
./netScript.bash 2>&1 | tee logs/scan_$(date +%Y%m%d_%H%M%S).log

# Background logging
./netScript.bash > scan.log 2>&1 &
tail -f scan.log  # Monitor in another terminal
```

---

## FAQ

**Q: Can this script crack WiFi passwords?**
A: No. This script only reads publicly broadcast network information and signal strength. It never transmits probe requests or processes encrypted data.

**Q: Will using this script disconnect my internet?**
A: In foreground mode, yes - the script toggles WiFi to force fresh scans. You may lose connectivity during the toggle (3-4 seconds). Use background mode to avoid disconnections.

**Q: How accurate is the signal strength?**
A: Signal strength (dBm) is reliable for relative comparison. Closer networks show higher values (less negative). Absolute accuracy depends on device antenna and environment.

**Q: Can I use this on non-Termux Android apps?**
A: No. This script requires Termux and the Termux:API plugin. It won't work in standard Android CLI or other terminals.

**Q: Why does background mode show fewer networks?**
A: Background mode reads Android's cached scan data. Android doesn't continuously scan when screen is OFF. Foreground mode forces active scans, discovering networks faster.

**Q: Can I customize the hidden network prefixes?**
A: Yes. Edit line 24: `readonly HIDDEN_NETWORK_PREFIX="HD"`

**Q: What if I need to stop the script?**
A: Press `Ctrl+C`. The script will clean up wake locks automatically before exiting.

---

## Support & Troubleshooting Checklist

Before reporting issues, verify:

- [ ] Termux:API is installed (`apt list --installed | grep termux-api`)
- [ ] Location permission is granted to Termux
- [ ] WiFi is enabled on the device
- [ ] Device isn't in airplane mode
- [ ] `jq` is installed (`apt list --installed | grep jq`)
- [ ] Run diagnostic mode (option 3) successfully
- [ ] Script is executable (`ls -l netScript.bash` shows `x`)

If issues persist, enable debug output:

```bash
# Edit script and change this line:
# set -o pipefail
# To:
set -x  # Enables verbose debug output
./netScript.bash
```

---

## Changelog

### Version 1.0
- ✅ Initial release
- ✅ Foreground scanning with adaptive delays
- ✅ Background passive monitoring
- ✅ Hidden network detection
- ✅ Screen-aware intervals
- ✅ Wake lock management
- ✅ Diagnostic mode
- ✅ Comprehensive documentation

---

## License & Attribution

This script is provided as-is for educational and authorized security testing purposes. Use responsibly and legally.

**Created for**: Termux WiFi reconnaissance
**Compatibility**: Termux on Android 5.0+
**Shell**: bash 4.0+

---

## Getting Help

If you encounter issues:

1. **Run Diagnostic**: Option 3 in main menu
2. **Check Permissions**: Settings → Termux → Permissions
3. **Review Logs**: Check script output for error messages
4. **Try Foreground Mode First**: Easier to debug than background mode
5. **Restart Termux**: Close and reopen the app to reset state

---

Last Updated: 2026-04-25
