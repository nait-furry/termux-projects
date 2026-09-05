# Prompt: Update `network-recon.bash` for Disabled Wi-Fi Scan Throttling

## Context

`network-recon.bash` is a set of Termux/Android Wi-Fi scanning prototype snippets (foreground aggressive scan, background passive scan, adaptive/hashing logic, hidden-network detection, and a walking/hybrid mode). It was originally written assuming Android's default Wi-Fi scan throttling (~4 scans per 2 minutes per app) was active, so it routes around that limit by aggressively toggling `termux-wifi-enable` off/on every iteration to force fresh scan results.

**Wi-Fi scan throttling has now been disabled** via Android Developer Options on the target device. The script needs to be updated to reflect this changed environment, to be verifiable before field deployment, and to avoid overloading the phone's hardware.

## Task

Revise `network-recon.bash` to satisfy the three requirement groups below. Keep the script's existing structure and Termux:API commands (`termux-wifi-enable`, `termux-wifi-scaninfo`, `termux-wake-lock`, `jq`); refactor rather than rewrite from scratch where possible.

### 1. Adapt scanning logic to disabled throttling

- Remove or simplify the adaptive-backoff apparatus (`SAME_DATA_THRESHOLD`, `ADAPTIVE_INCREMENT`, `FOREGROUND_MAX_SCAN_DELAY`) that exists specifically to work around throttled/stale scan results — it should no longer be needed as the primary mechanism.
- Reduce toggle frequency in the foreground/aggressive loop: toggle `termux-wifi-enable` only when a scan is genuinely empty or presumed stale, not on every iteration.
- Keep the radio warm-up waits (post-enable stabilization delay) since these are hardware timing constraints, not throttling artifacts, and confirm their durations are still appropriate.
- Add a runtime check that verifies throttling is actually disabled before relying on that assumption (e.g. shell out to `dumpsys wifi | grep -i throttl` or equivalent) and fall back to the throttle-safe (toggle-heavy) behavior with a logged warning if it detects throttling is still active or the check is inconclusive.
- Preserve a background/passive mode option that never toggles the radio, for comparison and for low-impact continuous monitoring.

### 2. Add pre-deployment self-tests

Add a `--test` (or menu-driven "Run Field-Readiness Tests") mode that performs, and clearly reports pass/fail for, each of:

- **Controlled AP capture test**: prompts the operator to toggle a known test AP on/off at a signaled moment, then confirms the script detects the change (new BSSID appears / disappears) within an expected time window.
- **Ground-truth diff**: captures one scan via the script and instructs the operator to compare it against Android's own Wi-Fi settings scan at the same moment; report should list any BSSIDs present in one but not the other for manual review (fully automated diffing isn't possible since Settings' scan can't be queried directly, so this test should produce a clearly formatted script-side network list for manual comparison).
- **Hash stability check**: runs two scans back-to-back with no environment change and confirms identical hashes (no false "fresh" positives); documents how to force an intentional environment change to also confirm the hash changes when it should (no false negatives).
- **Throttle-state verification**: runs the throttle check from requirement 1 and reports its result explicitly.
- **Mobility/walk-pace check**: a documented manual procedure (can be a comment block or README section rather than automatable) describing how to validate scan-to-movement timing before a real walking deployment.
- **Failure-mode check**: simulates a permissions/airplane-mode failure (or documents how to) and confirms the script logs the failure cleanly rather than crashing.

Each test should log a clear PASS/FAIL/INCONCLUSIVE line so results can be reviewed before field use.

### 3. Add resource safety caps

Implement a `resource_guard` check called at the start of each scan loop iteration that:

- Enforces a **hard ceiling on radio toggles per minute**, independent of any other logic, that cannot be exceeded regardless of scan-freshness decisions.
- Reads battery percentage via `termux-battery-status` and pauses/switches to passive mode below a configurable threshold (e.g. 15–20%).
- Reads battery temperature via the same command and pauses scanning above a configurable safe threshold, resuming once temperature drops.
- Enforces a **maximum total session runtime**, after which the script auto-stops and finalizes logs even if not manually interrupted.
- Manages the wake lock conservatively — acquire it only around toggle operations rather than holding it for the entire run, where feasible.
- Logs battery %, temperature, and toggle count alongside each scan entry so resource conditions can be correlated with script behavior after the fact.

## Deliverable

- The revised `network-recon.bash` (or a cleaned-up consolidated script, since the original is a loose collection of snippets), with the toggle-frequency, self-test, and resource-guard logic integrated.
- A short changelog/comment block at the top of the file summarizing what changed from the throttled-environment assumptions to the new ones.
- Inline comments on any new configurable thresholds (toggle rate cap, battery/temperature thresholds, session runtime cap) so they're easy to tune per device.
