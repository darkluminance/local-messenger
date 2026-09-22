# Local Messenger

Local Messenger is a peer-to-peer Flutter messaging application for devices on the same LAN. It is currently at the Phase 0 feasibility gate; Phase 1 feature work has not started.

See [the architecture](docs/architecture.md), [protocol outline](docs/protocol.md), and [implementation tracker](tasks/todo.md).

## Supported targets

- Android
- Windows
- macOS
- Linux

iOS and web are not part of v1.

## Current status

The Flutter foundation, compile-checked feasibility spikes, and cross-platform CI are being established. Application features begin only after the Phase 0 evidence is reviewed and approved.

## Phase 0 checks

```sh
flutter pub get
dart run build_runner build --delete-conflicting-outputs
dart format --output=none --set-exit-if-changed .
dart run tool/check_phase0.dart
dart run tool/check_dependencies.dart
flutter analyze --fatal-infos
flutter test
```

Host and physical-device checks are tracked in [the Phase 0 device matrix](docs/testing/phase-0-device-matrix.md).
