import 'dart:async';
import 'dart:io';

import 'package:flutter_foreground_task/flutter_foreground_task.dart';

import 'constants.dart';

@pragma('vm:entry-point')
void foregroundSocketSpikeEntrypoint() {
  FlutterForegroundTask.setTaskHandler(ForegroundSocketTaskHandler());
}

class ForegroundSocketTaskHandler extends TaskHandler {
  ServerSocket? _server;
  StreamSubscription<Socket>? _connections;

  @override
  Future<void> onStart(DateTime timestamp, TaskStarter starter) async {
    final server = await ServerSocket.bind(
      InternetAddress.anyIPv4,
      localMessengerDefaultPort,
    );
    _connections = server.listen((Socket socket) {
      socket.listen(
        socket.add,
        onDone: socket.close,
        onError: (_) => socket.destroy(),
      );
    });
    _server = server;
  }

  @override
  void onRepeatEvent(DateTime timestamp) {}

  @override
  Future<void> onDestroy(DateTime timestamp, bool isTimeout) async {
    await _connections?.cancel();
    _connections = null;
    await _server?.close();
    _server = null;
  }
}

void configureForegroundSocketSpike() {
  FlutterForegroundTask.init(
    androidNotificationOptions: AndroidNotificationOptions(
      channelId: 'online_mode_spike',
      channelName: 'Online mode feasibility',
      channelDescription: 'Phase 0 listener feasibility test.',
      onlyAlertOnce: true,
    ),
    iosNotificationOptions: const IOSNotificationOptions(),
    foregroundTaskOptions: ForegroundTaskOptions(
      eventAction: ForegroundTaskEventAction.nothing(),
      allowWakeLock: true,
      allowWifiLock: true,
    ),
  );
}

Future<ServiceRequestResult> startForegroundSocketSpike() {
  return FlutterForegroundTask.startService(
    serviceId: foregroundSocketServiceId,
    serviceTypes: const <ForegroundServiceTypes>[
      ForegroundServiceTypes.connectedDevice,
    ],
    notificationTitle: 'Local Messenger Online mode',
    notificationText: 'Phase 0 listening-socket test is active.',
    callback: foregroundSocketSpikeEntrypoint,
  );
}
