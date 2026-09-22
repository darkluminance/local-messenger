# Phase 0 device and host verification

Automated checks prove package integration, bounded simultaneous TCP frames, Drift persistence, and local libsodium encryption. The rows below require matching hosts or physical devices and must remain unchecked until observed.

## Build matrix

- [ ] Clean-cache Android release build with API 36, Android licenses, NDK/C toolchain, and native SQLite/libsodium assets.
- [ ] Clean-cache Windows release build with native SQLite/libsodium assets.
- [ ] Clean-cache macOS release build with native SQLite/libsodium assets.
- [ ] Clean-cache Linux release build with Avahi development/runtime dependencies and native SQLite/libsodium assets.

## Discovery and reconnect matrix

For each Android-to-desktop pair (Windows, macOS, Linux):

- [ ] Both physical devices advertise, browse, resolve, and connect within 10 seconds on a multicast-capable LAN.
- [ ] IPv4 and IPv6 candidates, including scoped link-local IPv6 when emitted, connect successfully.
- [ ] Duplicate, update, and lost events do not create duplicate peers or stale presence.
- [ ] Wi-Fi disconnect/reconnect restores discovery and an encrypted test-frame exchange.
- [ ] Stopped or missing Avahi and host firewall blocking produce actionable diagnostics rather than hangs.
- [ ] A user-started Android `connectedDevice` foreground task keeps a listening socket available and reconnects while the screen is off.

Record device models, OS versions, network equipment, timestamps, observed addresses, and logs with secrets/message bodies redacted. OEM process-killing soak behavior belongs to Phase 6, but any Phase 0 kill must be recorded here.

## Local Windows evidence (2026-09-22)

- `flutter doctor -v` passes with Flutter 3.47.5, Dart 3.13.4, Android SDK/build-tools 36, NDK 28.2.13676358, Java 22, accepted Android licenses, and Visual Studio Build Tools 2022.
- The Android release attempt compiled libsodium from source with the existing MSYS2 Bash/GNU Make and NDK. A Kotlin cross-drive incremental-cache failure was corrected by `kotlin.incremental=false`; the required clean retry is blocked until Windows Developer Mode permits Flutter plugin symlinks.
- The Windows release build is also blocked by disabled Windows Developer Mode. That system-wide setting was not changed without explicit user approval.
- macOS and Linux builds cannot run on this Windows host; the CI matrix and matching hosts must provide their evidence.
