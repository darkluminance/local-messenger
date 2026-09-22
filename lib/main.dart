import 'package:flutter/material.dart';

void main() => runApp(const LocalMessengerApp());

class LocalMessengerApp extends StatelessWidget {
  const LocalMessengerApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        appBar: AppBar(title: const Text('Local Messenger')),
        body: const Center(child: Text('Phase 0 feasibility shell')),
      ),
      title: 'Local Messenger',
    );
  }
}
