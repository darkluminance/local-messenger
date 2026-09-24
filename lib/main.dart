import 'package:flutter/material.dart';
import 'package:local_messenger/application/app_controller.dart';
import 'package:local_messenger/infrastructure/discovery/bonsoir_peer_discovery.dart';
import 'package:local_messenger/infrastructure/identity/private_identity_store.dart';
import 'package:local_messenger/infrastructure/identity/sodium_identity_repository.dart';
import 'package:local_messenger/infrastructure/persistence/database_factory.dart';
import 'package:local_messenger/presentation/local_messenger_app.dart';
import 'package:sodium/sodium.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  try {
    final database = await openAppDatabase();
    final sodium = await SodiumInit.init();
    final identityRepository = SodiumIdentityRepository(
      sodium: sodium,
      database: database,
      privateStore: FlutterSecurePrivateIdentityStore(),
    );
    final controller = AppController(
      identityRepository,
      discovery: BonsoirPeerDiscovery(),
    );
    runApp(LocalMessengerApp(controller: controller));
    await controller.initialize();
  } catch (_) {
    runApp(const BootstrapFailureApp());
  }
}
