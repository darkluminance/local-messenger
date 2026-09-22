# Local Messenger implementation

## Phase 0 — Project and feasibility gates

- [x] Preserve the existing feasibility research and architecture baseline.
- [x] Initialize Flutter for Android, Windows, macOS, and Linux with application ID `dev.localmessenger.app` and product name `Local Messenger`.
- [x] Pin Flutter 3.47.5 / Dart 3.13.4, validate with `flutter doctor -v`, and commit the dependency lockfile.
- [x] Add strict linting, CI for every supported host OS, dependency/license and platform-support checks, and the missing protocol outline.
- [x] Add isolated feasibility spikes for Bonsoir discovery, simultaneous TCP peers, Drift persistence, sodium native assets, and Android foreground socket execution.
- [x] Configure Android API 36 / minSdk 24 permissions and foreground-service declarations without `ACCESS_LOCAL_NETWORK`.
- [ ] Run formatting, static analysis, unit tests, dependency/license checks, and every release build available on this host.
- [x] Record external host/device gates: all selected platform builds plus two-device discovery, encrypted frames, and Wi-Fi reconnect.
- [x] Perform a Phase 0 code review, record results below, and stop for approval before Phase 1.

## Later phases

- [ ] Phase 1 — App shell, identity, and persistence.
- [ ] Phase 2 — Discovery and presence.
- [ ] Phase 3 — Secure transport and protocol framing.
- [ ] Phase 4 — Messaging and anti-entropy sync.
- [ ] Phase 5 — User experience.
- [ ] Phase 6 — Android Online mode and desktop lifecycle.
- [ ] Phase 7 — Hardening and release.

## Phase 0 review

Review date: 2026-09-22. Status: **blocked; do not begin Phase 1**.

Verified locally:

- Flutter 3.47.5 / Dart 3.13.4 and `flutter doctor -v`: pass with no reported issues when the installed sdkmanager's documented Java-version parser bypass is scoped to the process.
- Formatting, repository configuration, dependency license/support markers, and static analysis: pass.
- Six automated tests: pass (shell render, discovery TXT contract, two simultaneous bounded TCP peers, Drift close/reopen persistence, libsodium native encryption, oversized-frame rejection).
- Android native toolchain reached successful libsodium configure/build with API 36, NDK 28.2, MSYS2 Bash, and GNU Make.

Standards review:

- Tracking and review-result omissions were corrected in this file.
- Protocol constants were centralized and a one-use generic equality helper was simplified.
- The initial Phase 0 commit records the formerly untracked lockfile and baseline.

Specification review:

- Corrected the foreground task to bind and echo on the same fixed port advertised by discovery.
- Corrected CI to use clean Flutter setup for release-build jobs and load SQLite/libsodium in tests on each desktop host.
- Expanded dependency checks and documented license identities and platform/native-hook evidence.

Open gates:

- Windows Developer Mode is disabled, so clean Windows and Android release retries cannot create Flutter plugin symlinks. Enabling it is a system-wide user decision.
- macOS and Linux clean release builds require matching hosts/CI.
- All physical-device rows in `docs/testing/phase-0-device-matrix.md` remain pending, including Android-to-desktop discovery, encrypted frame exchange, Wi-Fi reconnect, firewall/Avahi cases, and foreground-service listening.
