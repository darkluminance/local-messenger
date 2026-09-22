import 'dart:io';

import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/phase0/drift_spike.dart';

void main() {
  test('Drift persists through database reopen', () async {
    final directory = await Directory.systemTemp.createTemp(
      'local-messenger-drift-',
    );
    addTearDown(() => directory.delete(recursive: true));

    expect(
      await runDriftPersistenceSpike(File('${directory.path}/spike.db')),
      isTrue,
    );
  });
}
