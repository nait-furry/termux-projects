

# Test logs

╔════════════════════════════════════════════════════════════╗                                      ║   WiFi Network Reconnaissance v2.0 (throttle-free edition) ║                                      ╚════════════════════════════════════════════════════════════╝                                      
  Throttle state : INCONCLUSIVE (throttle-safe fallback: true)
  Log directory  : /data/data/com.termux/files/home/logs
  JSON export    : /data/data/com.termux/files/home/scans

Select mode:                                                                                          
[1] Foreground scanning (toggle only when empty/stale)
• Throttle-aware with throttle-safe fallback
• Resource-guarded (toggle cap, battery/temp/runtime)
[2] Background scanning (passive - never toggles radio)                                                                                               
[3] Field-Readiness Tests (pre-deployment verification)                                                                                               
[4] Run Diagnostic (Termux API + throttle + battery)                                              
[5] View Recent Scans                           
[6] Exit (with graceful shutdown)

─────────────────────────────────────────────────────────────
Enter choice [1-6]: 1
[15:24:41] [INFO] Logging to: /data/data/com.termux/files/home/logs/wifi_scan_20260911_152409.log   
[15:24:41] [INFO] JSON export to: /data/data/com.termux/files/home/scans/networks_20260911_152409.json
[15:24:41] [INFO] Starting foreground scanning mode (throttle-free strategy; safe-mode=true).
[15:24:41] [INFO] Press Ctrl+C to stop and save results
[15:24:41] [INFO] === Scan Iteration 1 ===
[15:24:42] [INFO] Forcing radio refresh (toggle #1)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:24:54] [SCAN] networks=3 batt=62% temp=36.8C toggles=1/60s=1 mode=foreground
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
  aOn (b4:0f:3b:0b:85:98) - Signal: nulldBm
  Meshy (40:ee:dd:24:e5:38) - Signal: nulldBm
[15:25:02] [INFO] === Scan Iteration 2 ===
[15:25:02] [INFO] Forcing radio refresh (toggle #2)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:25:13] [SCAN] networks=3 batt=62% temp=36.8C toggles=2/60s=2 mode=foreground
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
  aOn (b4:0f:3b:0b:85:98) - Signal: nulldBm
  Meshy (40:ee:dd:24:e5:38) - Signal: nulldBm
[15:25:22] [INFO] === Scan Iteration 3 ===
[15:25:22] [INFO] Forcing radio refresh (toggle #3)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:25:33] [SCAN] networks=3 batt=62% temp=36.8C toggles=3/60s=3 mode=foreground
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
  aOn (b4:0f:3b:0b:85:98) - Signal: nulldBm
  Meshy (40:ee:dd:24:e5:38) - Signal: nulldBm
[15:25:41] [INFO] === Scan Iteration 4 ===
[15:25:55] [INFO] Forcing radio refresh (toggle #4)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:26:22] [SCAN] networks=5 batt=62% temp=36.9C toggles=4/60s=2 mode=foreground
  wavex 88 (24:16:6d:1d:3d:14) - Signal: nulldBm
  Joyce (e8:65:d4:c9:57:50) - Signal: nulldBm
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
[15:26:31] [INFO] === Scan Iteration 5 ===
[15:26:40] [INFO] Forcing radio refresh (toggle #5)...


^[[23~^[[23~^[[23~^[[23~^[[23~^[[23~usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:27:05] [SCAN] networks=9 batt=62% temp=36.4C toggles=5/60s=2 mode=foreground
  Hans Von (28:de:e5:3a:30:d0) - Signal: nulldBm
  wavex 88 (24:16:6d:1d:3d:14) - Signal: nulldBm
  Tenda_E089A8 (b4:0f:3b:e0:89:a8) - Signal: nulldBm
[15:27:13] [INFO] === Scan Iteration 6 ===
[15:27:13] [INFO] Forcing radio refresh (toggle #6)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:27:23] [SCAN] networks=4 batt=62% temp=36.4C toggles=6/60s=2 mode=foreground
  Hans Von (28:de:e5:3a:30:d0) - Signal: nulldBm
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
  Meshy (40:ee:dd:24:e5:38) - Signal: nulldBm
[15:27:32] [INFO] === Scan Iteration 7 ===
[15:27:32] [INFO] Forcing radio refresh (toggle #7)...


usage: termux-wake-lock
Acquire the Termux wake lock to prevent the CPU from sleeping.
[15:27:44] [SCAN] networks=6 batt=62% temp=36.4C toggles=7/60s=3 mode=foreground
  Joyce (e8:65:d4:c9:57:50) - Signal: nulldBm
  Littlefinger (5c:09:79:ab:ed:6c) - Signal: nulldBm
  aOn (b4:0f:3b:0b:85:98) - Signal: nulldBm
^C
[15:27:50] [INFO] Shutdown requested. Cleaning up...
[15:27:50] [INFO] Session saved to: /data/data/com.termux/files/home/logs/wifi_scan_20260911_152409.log
[15:27:50] [INFO] Network data saved to: /data/data/com.termux/files/home/scans/networks_20260911_152409.json
~ $



/data/data/com.termux/files/home
/storage/emulated/0/Termux/downloads/logs/wifi_scan_20260911_152409.log



All outputs (logs + scan JSON) go to Android shared storage so they can be pulled straight to a laptop: adb pull /storage/emulated/0/Termux/downloads/
readonly SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"  # used by --simulate stubs
readonly OUTPUT_BASE="/storage/emulated/0/Termux/downloads"
readonly LOG_DIR="${OUTPUT_BASE}/logs"    # wifi_scan_*.log session logs
readonly JSON_DIR="${OUTPUT_BASE}/scans"  # networks_*.json exports
Since every part of the script (init_log_files, save_scan_json, menu "View Recent Scans", tests, resource guard) already referenced $LOG_DIR/$JSON_DIR, all outputs follow the new base automatically — no other lines were touched. SCRIPT_DIR stays for --simulate, and the existing mkdir -p calls will create /storage/emulated/0/Termux/downloads/{logs,scans} on the phone on first run.
On-device layout:
/storage/emulated/0/Termux/downloads/
├── logs/wifi_scan_YYYYMMDD_HHMMSS.log
└── scans/networks_YYYYMMDD_HHMMSS.json
Validation performed
- bash -n → syntax clean
- --simulate --iters 2 --foreground → startup now prints Logging to: /storage/emulated/0/Termux/downloads/logs/wifi_scan_*.log and JSON export to: /storage/emulated/0/Termux/downloads/scans/networks_*.json
- --simulate --iters 2 --background → same new paths; hidden-network HD001 naming still works (untouched)
- grep → zero leftover ${SCRIPT_DIR}/logs / ${SCRIPT_DIR}/scans references
- logs/, scans/, .sim/ are already gitignored; the test-time .sim/ stub dir was cleaned up
Two notes
1. Path case: used Termux capitalized, matching every device-side path in your doc.md (e.g. /storage/emulated/0/Termux/downloads/scans/...). Android shared storage is case-sensitive, so if the folder on your phone is actually lowercase termux, change that one word in OUTPUT_BASE.
2. Dev-box limitation: this machine has no /storage/emulated/0, so files can't literally be created here during validation — on the phone the script's mkdir -p handles it. The path wiring is confirmed end-to-end via the sim runs.
You can now pull everything from your laptop with e.g. adb pull /storage/emulated/0/Termux/downloads/.
