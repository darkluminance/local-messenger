import 'dart:io';

void main() {
  final requiredPaths = <String>{
    '.fvmrc',
    '.github/workflows/ci.yml',
    'android/app/src/main/AndroidManifest.xml',
    'docs/architecture.md',
    'docs/dependency-support.md',
    'docs/protocol.md',
    'docs/research/phase-0-feasibility.md',
    'docs/testing/phase-0-device-matrix.md',
    'linux/CMakeLists.txt',
    'macos/Runner/Info.plist',
    'pubspec.lock',
    'windows/CMakeLists.txt',
  };
  for (final path in requiredPaths) {
    if (!File(path).existsSync()) {
      stderr.writeln('Missing Phase 0 artifact: $path');
      exitCode = 1;
    }
  }

  _requireText('pubspec.yaml', 'flutter: 3.47.5');
  _requireText('pubspec.yaml', "sdk: '>=3.13.4 <3.14.0'");
  _requireText(
    'android/app/build.gradle.kts',
    'applicationId = "dev.localmessenger.app"',
  );
  _requireText('android/app/build.gradle.kts', 'minSdk = 24');
  _requireText('android/app/build.gradle.kts', 'targetSdk = 36');
  _requireText(
    'android/app/src/main/AndroidManifest.xml',
    'FOREGROUND_SERVICE_CONNECTED_DEVICE',
  );
  _rejectText(
    'android/app/src/main/AndroidManifest.xml',
    'ACCESS_LOCAL_NETWORK',
  );

  if (exitCode == 0) {
    stdout.writeln('Phase 0 repository configuration verified.');
  }
}

void _requireText(String path, String expected) {
  if (!File(path).readAsStringSync().contains(expected)) {
    stderr.writeln('$path does not contain required text: $expected');
    exitCode = 1;
  }
}

void _rejectText(String path, String rejected) {
  if (File(path).readAsStringSync().contains(rejected)) {
    stderr.writeln('$path unexpectedly contains: $rejected');
    exitCode = 1;
  }
}
