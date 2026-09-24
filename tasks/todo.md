# Local Messenger implementation

## Phase-scoped commit plan

- [x] Preserve the existing Phase 0 commit and inspect all uncommitted work.
- [x] Commit Phase 1 domain, identity, persistence, dependencies, and their tests as a self-contained foundation.
- [x] Commit Phase 2 app integration, discovery, UI, platform declarations, protocol/test guidance, and review notes.
- [x] Verify the two commit file lists, tests, and clean working tree; do not start Phase 3.

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

- [x] Phase 1 — App shell, identity, and persistence.
- [ ] Phase 2 — Discovery and presence.
- [ ] Phase 3 — Secure transport and protocol framing.
- [ ] Phase 4 — Messaging and anti-entropy sync.
- [ ] Phase 5 — User experience.
- [ ] Phase 6 — Android Online mode and desktop lifecycle.
- [ ] Phase 7 — Hardening and release.

## Phase 1 — App shell, identity, and persistence

- [x] Define Phase 1 domain models and stable repository contracts without discovery or transport implementations.
- [x] Add validated onboarding and display-name update flows with short identity fingerprints.
- [x] Generate an Ed25519 installation identity, derive `deviceId` from canonical public-key bytes, and store private material only in OS-backed secure storage.
- [x] Add Drift schema v1 for local profile metadata, pinned peers, conversations, immutable operations, feed heads, message projections, retention floors, and delivery acknowledgements.
- [x] Implement transactional operation insertion, participant/sequence/hash validation seams, and projection rebuilding from the operation log.
- [x] Add migration infrastructure and schema/projection tests.
- [x] Add the application shell and navigation for onboarding, nearby peers, conversations, settings, and diagnostics.
- [x] Verify identity persistence across repository restart, name changes preserving identity, duplicate-name fingerprints, formatting, analysis, tests, and available builds.
- [x] Perform separate standards/spec reviews, record results, and stop for approval before Phase 2.

## Phase 1 review

Review date: 2026-09-23. Status: **complete; stop for approval before Phase 2**.

Verified locally:

- Formatting, static analysis, dependency/license checks, the Phase 0 regression guard, and diff hygiene pass.
- All 29 automated tests pass, including the frozen Drift schema-v1 harness, operation transaction/rebuild cases, identity restart/reconciliation/corruption cases, and responsive shell/fingerprint widgets.
- The final Android release APK builds successfully at build/app/outputs/flutter-apk/app-release.apk.
- The Windows release build remains externally blocked because Developer Mode symlink support is disabled on this host. It was not changed without user approval.
- macOS, Linux, and real OS-backed secure-storage smoke tests remain external platform gates.

Review corrections:

- Standards findings were resolved by proving Ed25519 secret/public correspondence, defensively copying sensitive operation/envelope bytes, and testing interrupted profile-update reconciliation.
- Spec findings were resolved by persisting protocol version, freezing and validating schema v1, completing stable contract responsibilities, demonstrating duplicate-name fingerprints in widgets, and correcting the Phase 3 transport label.

## Phase 2 — Discovery and presence

- [x] Parse and bound DNS-SD TXT records and IP endpoint candidates; reject malformed or unsupported advertisements.
- [x] Aggregate unverified peer presence by advertised device ID across service records and addresses; ignore self, reconcile lost/updated records, and expire stale entries.
- [x] Implement Bonsoir advertise, browse, resolve, stop, and interface-change restart lifecycle with testable seams.
- [x] Start discovery after identity readiness and refresh the advertisement when the local profile revision changes.
- [x] Show unverified nearby peers, scanning/empty/error states, and actionable platform diagnostics without exposing a chat action.
- [x] Add the Android and macOS network declarations and record Windows Firewall/Linux Avahi checks.
- [x] Verify parser, registry, lifecycle, and UI behavior; run formatting, analysis, tests, dependency checks, and builds available on this host.
- [x] Run separate standards and plan reviews, document physical four-platform discovery/reconnect gates, and stop before Phase 3.

## Phase 2 review

Review date: 2026-09-23. Status: **implementation ready for review; physical LAN gate pending; stop before Phase 3**.

Verified locally:

- All 42 Flutter tests pass, including malformed TXT/IP handling, deduplication, stale expiry, bounded observations, native-action lifecycle, interface/probe recovery, startup/stop race, UI, and opt-in Android notification permission.
- `flutter analyze`, dependency/license checks, Dart formatting, and `git diff --check` pass.
- Android debug APK builds at `build/app/outputs/flutter-apk/app-debug.apk` when the existing `C:\msys64\usr\bin` toolchain is first on `PATH`. The native Kotlin permission bridge is included in that build.
- Developer Mode and the Visual Studio ATL component are now enabled. Windows debug and release builds succeed; the debug executable stayed running through a five-second launch smoke test and that test process was then stopped. macOS and Linux builds require their matching hosts. Existing Phase 1 research/tracking and source changes were preserved.

Review corrections:

- Shortened the DNS-SD instance label below 63 bytes; kept the full advertised device ID only in TXT.
- Replaced removed endpoints on updates, bounded untrusted observations and unresolved service cache, and cleared stale presence when interface probing fails.
- Serialized controller shutdown against in-flight startup; restart native actions on app resume even when interface addresses look unchanged.
- Added optional Android notification permission request/result UI, while keeping discovery independent of that permission. Empty-scan diagnostics now state that no peers and LAN isolation cannot be distinguished without an expected peer.

Open gate:

- [x] Add the C++ ATL component to the existing Visual Studio Build Tools installation, then rerun the Windows desktop build and launch smoke test. Completed 2026-09-23; both Windows debug and release builds pass.
- The user reported Android ↔ Windows mutual discovery within 10 seconds on fresh launch with exactly one row per peer, almost immediate disappearance on disconnect, and post-reconnect reappearance of about 3 seconds on Android and 1 second on Windows on 2026-09-23. Environment/address details, profile-update behavior, stale-expiry fallback, and blocked-network response remain unverified. Android ↔ macOS/Linux have not been tested. Keep the acceptance cells in `docs/testing/phase-2-device-matrix.md` unchecked until their evidence is recorded; do not treat Phase 2 as fully accepted or start Phase 3 yet.

## Phase 2 follow-up — advertised names (user request)

- [x] Add an optional, bounded unverified `name` TXT field while accepting older four-field advertisements.
- [x] Carry the advertised name through parsed records and deduplicated presence; reconcile rename and malformed/absent names without trusting them as authenticated identity.
- [x] Show the advertised name as the primary Nearby label with fingerprint and explicit unverified state; preserve fallback for older peers.
- [x] Update protocol/privacy and physical-test guidance for the new unverified hint.
- [x] Add parser/registry/adapter/widget regressions, run static analysis and builds available locally, and stop for review before Phase 3.

Follow-up review, 2026-09-23: 44 Flutter tests, static analysis, formatting, and dependency checks pass. Updated Windows release and Android debug builds succeed. Independent spec review found the requested UI/trust boundary met; standards review prompted shared local/advertised name validation for invisible direction controls. No physical retest of the new TXT extension has been reported yet. Both devices must update because the older four-key parser rejects the fifth key. The name is plaintext and spoofable on the LAN; fingerprint and Unverified remain visible. Stop before Phase 3.

## Phase 0 review

Review date: 2026-09-22. Status: **blocked; do not begin Phase 1**.

User override: on 2026-09-22 the user explicitly approved continuing to Phase 1. The external Phase 0 gates below remain unresolved and are not treated as passed.

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
