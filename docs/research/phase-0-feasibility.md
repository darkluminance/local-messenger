# Phase 0 feasibility: Flutter LAN messenger

Research date: 2026-09-22. Sources are official platform documentation or package-owner documentation. This establishes feasibility and constraints; real-device spikes remain necessary.

## Verdict

The design is feasible on Android, Windows, macOS, and Linux, with three corrections:

1. Pin **Flutter 3.47.5 / Dart 3.13.4**, not Flutter 3.41.4. Flutter's official release feed identifies this as the current stable Windows bundle. Current `sodium` needs Dart 3.13, while current `flutter_foreground_task` needs Flutter 3.44/Dart 3.12 ([Flutter release feed](https://storage.googleapis.com/flutter_infra_release/releases/releases_windows.json), [sodium versions](https://pub.dev/packages/sodium/versions), [foreground-task package](https://pub.dev/packages/flutter_foreground_task)).
2. Add Windows, macOS, and Linux CI/build hosts. Flutter documents each desktop target as requiring its corresponding development OS, so this Windows host cannot prove macOS or Linux builds ([Flutter platform integration](https://docs.flutter.dev/platform-integration)).
3. Do not add `ACCESS_LOCAL_NETWORK` while targeting API 36. Android says targets at or below 36 retain implicit LAN access through `INTERNET`; add the new runtime permission when moving to target API 37 ([Android local-network permission](https://developer.android.com/privacy-and-security/local-network-permission)).

Flutter's current support matrix covers Android 24-37, Windows 10-11, macOS 12-27, Debian 10-13, and Ubuntu 20.04-24.04, so the proposed targets and `minSdk 24` are supported ([Flutter supported platforms](https://docs.flutter.dev/reference/supported-platforms)).

## Dependency findings

### Bonsoir 7.1.5

- Declares Android, Linux, macOS, and Windows support and exposes advertise, browse, resolve, update, and lost-service behavior ([package page](https://pub.dev/packages/bonsoir)). Its Dart floor is 3.8 ([version table](https://pub.dev/packages/bonsoir/versions)).
- Requirements are Android API 21+, Windows 10 1903+, macOS 10.15+, and a running Avahi daemon on Linux. Android emulator discovery is restricted to services within the emulator, so the gate must use physical Android hardware ([Bonsoir installation](https://bonsoir.skyost.eu/docs/)).
- Resolved addresses may be IPv4, IPv6, or Linux link-local IPv6. Event order/timing is platform-dependent, and `.local` hostname resolution is not guaranteed for sockets. Connect with `hostAddresses`, deduplicate events, and handle IPv6 scope correctly ([Bonsoir notes](https://bonsoir.skyost.eu/docs/)).
- Bonsoir says TXT attributes do not work on Android 6 and earlier. `minSdk 24` therefore avoids that limitation. Linux distribution must document/provide Avahi and UDP 5353 firewall requirements ([Bonsoir requirements](https://bonsoir.skyost.eu/docs/)).

### Drift 2.32+ / sqlite3 3.x

- Drift recommends `package:drift/native.dart` for new native apps. From Drift 2.32.0 with sqlite3 3.x, all required native targets bundle SQLite through Dart build hooks and no longer require `sqlite3_flutter_libs` ([Drift native](https://drift.simonbinder.eu/platforms/vm/), [Drift platforms](https://drift.simonbinder.eu/platforms/)).
- `sqlite3` lists Android, macOS, Linux, and Windows native architectures. Use `NativeDatabase.createInBackground` so catch-up and projection rebuilding do not block the UI isolate ([sqlite3 package](https://pub.dev/packages/sqlite3), [Drift native](https://drift.simonbinder.eu/platforms/vm/)).

### sodium 4.1.x

- Sodium 4 builds and bundles libsodium using native-asset hooks; initialize with `SodiumInit.init()`. The former `sodium_libs` Flutter wrapper is deprecated ([sodium 4.1](https://pub.dev/packages/sodium/versions/4.1.0), [migration notice](https://pub.dev/documentation/sodium_libs/latest/)).
- Current 4.1.0+1 requires Dart 3.13, which makes Flutter 3.47.x the correct SDK baseline ([sodium versions](https://pub.dev/packages/sodium/versions)).
- Android cross-compilation on Windows requires usable **non-WSL Bash**. Phase 0 must also verify Android NDK/C and Windows C++ toolchains on clean runners, not only a warm developer cache ([sodium documentation](https://pub.dev/packages/sodium/versions/4.1.0)).

### flutter_foreground_task 11.0.3

- Supports Flutter 3.44+, Dart 3.12+, Android API 21+, and requires Kotlin 2.2.20+ and Gradle 8.11.1+ ([package documentation](https://pub.dev/packages/flutter_foreground_task)).
- Android 14+ requires a declared foreground-service type plus matching permission. For `connectedDevice`, declare `FOREGROUND_SERVICE`, `FOREGROUND_SERVICE_CONNECTED_DEVICE`, and satisfy a prerequisite such as declaring `CHANGE_NETWORK_STATE`, `CHANGE_WIFI_STATE`, or `CHANGE_WIFI_MULTICAST_STATE`. Android includes network-connected external-device interaction in this type ([service types](https://developer.android.com/develop/background-work/services/fgs/service-types), [declaration rules](https://developer.android.com/develop/background-work/services/fgs/declare)).
- Android also says a remote-messaging operation should use `remoteMessaging`, which it describes as transferring text messages for continuity when a user switches devices. This product communicates between different users and maintains LAN discovery/listening, so `connectedDevice` is defensible, but the final classification is a Play-policy judgment to revalidate before store distribution ([service types](https://developer.android.com/develop/background-work/services/fgs/service-types)).
- The service must start from an explicit user action while eligible; Android 12+ restricts background starts. Do not rely on unrestricted boot resurrection ([foreground-service changes](https://developer.android.com/develop/background-work/services/fgs/changes)).

## Android API 37 preparation

Android 17 blocks LAN access by default for apps targeting API 37. Such apps must request `ACCESS_LOCAL_NETWORK` or use the API 37 NSD picker. Because this product needs continuous automatic discovery of up to ten peers plus direct TCP, the broad runtime permission is the practical fit; the picker selects at most one service per interaction and changes the intended UX ([Android local-network permission](https://developer.android.com/privacy-and-security/local-network-permission), [NsdManager](https://developer.android.com/reference/android/net/nsd/NsdManager)).

## Phase 0 gates

1. Pin Flutter 3.47.5/Dart 3.13.4 and a tested set containing Bonsoir 7.1.5, Drift 2.32+, sqlite3 3.x, sodium 4.1.x, and flutter_foreground_task 11.0.3. Commit the lockfile.
2. Run clean-cache release builds on matching Windows, macOS, and Linux hosts. On Windows-to-Android runners install non-WSL Bash and the Android NDK. Verify the SQLite/libsodium assets load in release builds.
3. Test discovery on physical Android hardware against each desktop OS, both IP families, Wi-Fi reconnect, duplicate/update/lost events, stopped/missing Avahi, and host firewalls.
4. For target API 36, configure `INTERNET`, notification, foreground-service, and connected-device network/multicast prerequisites; do not request `ACCESS_LOCAL_NETWORK` yet.
5. Prove that a user-started foreground task can keep the listener alive and reconnect. Treat OEM process killing and long-term delivery as later real-device soak tests, not guaranteed behavior.

## External blockers

- macOS and Linux build hosts are required for their artifacts.
- Physical Android, Windows, macOS, and Linux peers are required to prove cross-platform mDNS interoperability.
- Foreground-service type selection must be rechecked against current Play policy before a store release; it does not block direct/internal builds.
