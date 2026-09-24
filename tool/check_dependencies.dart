import 'dart:convert';
import 'dart:io';

const directPackages = <String>{
  'bonsoir',
  'build_runner',
  'crypto',
  'drift',
  'drift_dev',
  'flutter_foreground_task',
  'flutter_lints',
  'flutter_secure_storage',
  'path',
  'path_provider',
  'sodium',
  'sqlite3',
};

const expectedLicenseMarkers = <String, String>{
  'bonsoir': 'MIT License',
  'drift': 'MIT License',
  'flutter_foreground_task': 'MIT License',
  'flutter_secure_storage': 'BSD 3-Clause License',
  'sodium': 'BSD 3-Clause License',
  'sqlite3': 'MIT License',
};

void main() {
  final configFile = File('.dart_tool/package_config.json');
  if (!configFile.existsSync()) {
    stderr.writeln('Run flutter pub get before checking dependencies.');
    exitCode = 1;
    return;
  }

  final config =
      jsonDecode(configFile.readAsStringSync()) as Map<String, Object?>;
  final packages = (config['packages']! as List<Object?>)
      .cast<Map<String, Object?>>()
      .where(
        (Map<String, Object?> package) =>
            directPackages.contains(package['name']),
      )
      .toList();
  final found = packages
      .map((Map<String, Object?> package) => package['name'])
      .toSet();
  final missing = directPackages.difference(found);
  if (missing.isNotEmpty) {
    stderr.writeln('Missing direct packages: ${missing.join(', ')}');
    exitCode = 1;
  }

  final configUri = configFile.absolute.uri;
  for (final package in packages) {
    final name = package['name']! as String;
    final root = Directory.fromUri(
      configUri.resolve(package['rootUri']! as String),
    );
    final licenseFiles = <String>['LICENSE', 'LICENSE.md', 'LICENSE.txt']
        .map(
          (String filename) =>
              File('${root.path}${Platform.pathSeparator}$filename'),
        )
        .where((File file) => file.existsSync())
        .toList();
    if (licenseFiles.isEmpty) {
      stderr.writeln('$name has no recognized license file at ${root.path}.');
      exitCode = 1;
      continue;
    }
    final marker = expectedLicenseMarkers[name];
    if (marker != null &&
        !licenseFiles.any(
          (File file) => file.readAsStringSync().contains(marker),
        )) {
      stderr.writeln('$name license does not contain expected marker: $marker');
      exitCode = 1;
    }
  }

  for (final nativePackage in <String>{'sodium', 'sqlite3'}) {
    final package = packages.singleWhere(
      (Map<String, Object?> value) => value['name'] == nativePackage,
    );
    final root = Directory.fromUri(
      configUri.resolve(package['rootUri']! as String),
    );
    final hook = File(
      '${root.path}${Platform.pathSeparator}hook'
      '${Platform.pathSeparator}build.dart',
    );
    if (!hook.existsSync()) {
      stderr.writeln(
        '$nativePackage does not expose its expected native-asset hook.',
      );
      exitCode = 1;
    }
  }

  final lockfile = File('pubspec.lock').readAsStringSync();
  for (final federatedPackage in <String>{
    'bonsoir_android',
    'bonsoir_darwin',
    'bonsoir_linux',
    'bonsoir_windows',
  }) {
    if (!lockfile.contains('  $federatedPackage:')) {
      stderr.writeln('Missing platform implementation: $federatedPackage');
      exitCode = 1;
    }
  }

  for (final federatedPackage in <String>{
    'flutter_secure_storage_darwin',
    'flutter_secure_storage_linux',
    'flutter_secure_storage_windows',
    'path_provider_android',
    'path_provider_foundation',
    'path_provider_linux',
    'path_provider_windows',
  }) {
    if (!lockfile.contains('  $federatedPackage:')) {
      stderr.writeln('Missing platform implementation: $federatedPackage');
      exitCode = 1;
    }
  }

  if (exitCode == 0) {
    stdout.writeln(
      'Dependency licenses and selected platform packages verified.',
    );
  }
}
