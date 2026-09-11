└─$ adb shell
itel-S663L:/ $ find ./ -name 'network*' 2>/dev/null
./storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Documents/Sent/network_agent.md
./storage/emulated/0/Android/media/com.whatsapp/WhatsApp/Media/WhatsApp Documents/networking combo.pdf
./storage/emulated/0/Download/network-diag.txt
./storage/emulated/0/Documents/PDF Reader/network.md
./storage/emulated/0/Documents/network.md
./storage/emulated/0/ÀRT_ITTUDE/network-diag.txt
./storage/emulated/0/Termux/downloads/scans/networks_20260425_194011.json
./storage/emulated/0/Termux/downloads/scans/networks_20260425_195858.json
./storage/emulated/0/Termux/downloads/scans/networks_20260426_203239.json
./storage/emulated/0/Termux/networking
./sys/fs/selinux/policy_capabilities/network_peer_controls
1|itel-S663L:/ $ 


┌──(fury㉿kali)-[~]
└─$ adb shell
itel-S663L:/ $ find ./ -name '*.bash' 2>/dev/null      
./storage/emulated/0/Download/scripts/netScript.bash
./storage/emulated/0/Termux/downloads/netScript.bash
1|itel-S663L:/ $ 



s -la network*                                        <
-rw-rw---- 1 u0_a177 media_rw 7213 2026-03-27 17:04 network-diag.txt
itel-S663L:/storage/emulated/0/Download $ 

Termux/downloads/
-rw-rw---- 1 u0_a177 media_rw 21034 2026-04-25 19:39 netScript.bash

Download/scripts/
-rw-rw---- 1 u0_a177 media_rw 21034 2026-04-25 19:39 netScript.bash




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
