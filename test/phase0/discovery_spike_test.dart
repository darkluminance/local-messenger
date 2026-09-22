import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/phase0/constants.dart';
import 'package:local_messenger/phase0/discovery_spike.dart';

void main() {
  test('discovery TXT data contains only approved fields', () {
    final service = createDiscoverySpikeService(deviceId: 'abc123');

    expect(service.type, localMessengerServiceType);
    expect(service.port, localMessengerDefaultPort);
    expect(service.attributes.keys, <String>{'v', 'id', 'caps', 'profile'});
    expect(service.attributes, isNot(contains('name')));
  });
}
