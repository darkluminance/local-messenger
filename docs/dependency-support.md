# Phase 0 dependency support and licenses

Versions are exact in `pubspec.yaml` and `pubspec.lock`. `tool/check_dependencies.dart` verifies the installed package roots, expected license markers, native build hooks, and Bonsoir's federated platform implementations.

| Package | Version | License | Phase 0 support evidence |
| --- | --- | --- | --- |
| Bonsoir | 7.1.5 | MIT | Declares Android, Windows, macOS, and Linux; federated implementations are locked. Linux requires Avahi. |
| Drift | 2.32.0 | MIT | Dart VM persistence test closes and reopens a native SQLite database. |
| sqlite3 | 3.6.0 | MIT | Native-asset hook is present; loaded by the Drift persistence test on desktop hosts. |
| sodium | 4.1.0+1 | BSD-3-Clause | Native-asset hook is present; encryption/decryption test loads the built library on desktop hosts. Android cross-compilation requires non-WSL Bash, GNU Make, and the NDK. |
| flutter_foreground_task | 11.0.3 | MIT | Declares Android support; compile-checked handler binds the advertised TCP port under `connectedDevice`. Physical-device execution remains an external gate. |

This is an engineering inventory, not legal advice. Before distribution, release owners must confirm transitive notices and any organization-specific license policy.
