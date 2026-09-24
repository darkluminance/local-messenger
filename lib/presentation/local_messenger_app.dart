import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:local_messenger/application/app_controller.dart';
import 'package:local_messenger/domain/contracts.dart';
import 'package:local_messenger/domain/identity.dart';

const Color _midnight = Color(0xFF17242B);
const Color _mist = Color(0xFFF3F7F6);
const Color _signalTeal = Color(0xFF0B7A75);
const Color _linkBlue = Color(0xFF376A8A);
const Color _amber = Color(0xFFC4872B);

const String conversationRoute = '/conversation';

final class ConversationRouteArguments {
  const ConversationRouteArguments({required this.peerName, this.fingerprint});

  final String peerName;
  final String? fingerprint;
}

final class IdentityLabel extends StatelessWidget {
  const IdentityLabel({
    required this.displayName,
    required this.fingerprint,
    super.key,
  });

  final String displayName;
  final String fingerprint;

  @override
  Widget build(BuildContext context) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisSize: MainAxisSize.min,
    children: <Widget>[
      Text(
        displayName,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: Theme.of(context).textTheme.titleSmall
            ?.copyWith(fontWeight: FontWeight.w700),
      ),
      Text(
        fingerprint,
        style: Theme.of(context).textTheme.labelSmall
            ?.copyWith(color: _linkBlue, letterSpacing: 1),
      ),
    ],
  );
}

class LocalMessengerApp extends StatefulWidget {
  const LocalMessengerApp({required this.controller, super.key});

  final AppController controller;

  @override
  State<LocalMessengerApp> createState() => _LocalMessengerAppState();
}

class _LocalMessengerAppState extends State<LocalMessengerApp>
    with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      unawaited(widget.controller.refreshDiscoveryAfterResume());
    }
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Local Messenger',
      theme: _theme(),
      onGenerateRoute: (settings) {
        if (settings.name == conversationRoute) {
          final arguments = settings.arguments;
          return MaterialPageRoute<void>(
            settings: settings,
            builder: (_) => ConversationScreen(
              arguments: arguments is ConversationRouteArguments
                  ? arguments
                  : const ConversationRouteArguments(peerName: 'Conversation'),
            ),
          );
        }
        return null;
      },
      home: AnimatedBuilder(
        animation: widget.controller,
        builder: (context, _) => switch (widget.controller.stage) {
          AppStage.loading => const _LoadingScreen(),
          AppStage.onboarding => _OnboardingScreen(
            controller: widget.controller,
          ),
          AppStage.ready => _ReadyShell(controller: widget.controller),
          AppStage.identityFailure => _IdentityFailureScreen(
            message:
                widget.controller.identityFailureMessage ??
                'Local identity storage is unavailable.',
            onRetry: widget.controller.initialize,
          ),
        },
      ),
    );
  }
}

ThemeData _theme() {
  final scheme =
      ColorScheme.fromSeed(
        seedColor: _signalTeal,
        brightness: Brightness.light,
        surface: _mist,
      ).copyWith(
        primary: _signalTeal,
        secondary: _linkBlue,
        tertiary: _amber,
        onSurface: _midnight,
        outline: const Color(0xFF6D7C80),
      );
  return ThemeData(
    useMaterial3: true,
    colorScheme: scheme,
    scaffoldBackgroundColor: _mist,
    appBarTheme: const AppBarTheme(
      backgroundColor: _mist,
      foregroundColor: _midnight,
      centerTitle: false,
      elevation: 0,
      scrolledUnderElevation: 1,
    ),
    navigationBarTheme: NavigationBarThemeData(
      backgroundColor: Colors.white,
      indicatorColor: _signalTeal.withValues(alpha: 0.14),
      labelTextStyle: WidgetStateProperty.resolveWith(
        (states) => TextStyle(
          color: states.contains(WidgetState.selected)
              ? _signalTeal
              : _midnight,
          fontWeight: states.contains(WidgetState.selected)
              ? FontWeight.w700
              : FontWeight.w500,
        ),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB9C8C7)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: const BorderSide(color: Color(0xFFB9C8C7)),
      ),
    ),
  );
}

class _LoadingScreen extends StatelessWidget {
  const _LoadingScreen();

  @override
  Widget build(BuildContext context) => Scaffold(
    body: Center(
      child: Semantics(
        label: 'Loading local identity',
        child: const CircularProgressIndicator(),
      ),
    ),
  );
}

class _OnboardingScreen extends StatefulWidget {
  const _OnboardingScreen({required this.controller});

  final AppController controller;

  @override
  State<_OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<_OnboardingScreen> {
  final _nameController = TextEditingController();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(24),
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const Align(child: _LanSignalMotif(size: 116)),
                  const SizedBox(height: 30),
                  Text(
                    'Your corner of the local network',
                    style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                      color: _midnight,
                      fontWeight: FontWeight.w800,
                      height: 1.08,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'Choose the name nearby devices will see. Your private identity stays in secure storage on this device.',
                    style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                      color: _midnight.withValues(alpha: 0.72),
                      height: 1.45,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 30),
                  TextField(
                    controller: _nameController,
                    autofocus: true,
                    enabled: !widget.controller.isWorking,
                    textInputAction: TextInputAction.done,
                    maxLength: maximumDisplayNameBytes,
                    decoration: InputDecoration(
                      labelText: 'Display name',
                      hintText: 'How should nearby people know you?',
                      errorText: widget.controller.onboardingError,
                    ),
                    onSubmitted: (_) => _submit(),
                  ),
                  const SizedBox(height: 10),
                  FilledButton.icon(
                    onPressed: widget.controller.isWorking ? null : _submit,
                    icon: widget.controller.isWorking
                        ? const SizedBox.square(
                            dimension: 18,
                            child: CircularProgressIndicator(strokeWidth: 2),
                          )
                        : const Icon(Icons.arrow_forward_rounded),
                    label: const Text('Create local identity'),
                  ),
                  const SizedBox(height: 12),
                  Text(
                    'No account, cloud service, or internet connection is required.',
                    style: Theme.of(context).textTheme.bodySmall,
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _submit() =>
      widget.controller.createIdentity(_nameController.text);
}

class _IdentityFailureScreen extends StatelessWidget {
  const _IdentityFailureScreen({required this.message, required this.onRetry});

  final String message;
  final Future<void> Function()? onRetry;

  @override
  Widget build(BuildContext context) => Scaffold(
    body: SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 520),
          child: Padding(
            padding: const EdgeInsets.all(28),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.key_off_rounded, color: _amber, size: 48),
                const SizedBox(height: 20),
                Text(
                  'Identity needs attention',
                  style: Theme.of(context).textTheme.headlineSmall
                      ?.copyWith(fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(message, textAlign: TextAlign.center),
                const SizedBox(height: 10),
                const Text(
                  'Messaging remains disabled to avoid using an incomplete or mismatched identity.',
                  textAlign: TextAlign.center,
                ),
                if (onRetry != null) ...[
                  const SizedBox(height: 24),
                  OutlinedButton.icon(
                    onPressed: onRetry,
                    icon: const Icon(Icons.refresh_rounded),
                    label: const Text('Try again'),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    ),
  );
}

class _ReadyShell extends StatefulWidget {
  const _ReadyShell({required this.controller});

  final AppController controller;

  @override
  State<_ReadyShell> createState() => _ReadyShellState();
}

class _ReadyShellState extends State<_ReadyShell> {
  int _selectedIndex = 0;

  static const _destinations = <NavigationDestination>[
    NavigationDestination(icon: Icon(Icons.radar_rounded), label: 'Nearby'),
    NavigationDestination(
      icon: Icon(Icons.forum_outlined),
      selectedIcon: Icon(Icons.forum_rounded),
      label: 'Conversations',
    ),
    NavigationDestination(
      icon: Icon(Icons.tune_outlined),
      selectedIcon: Icon(Icons.tune_rounded),
      label: 'Settings',
    ),
    NavigationDestination(
      icon: Icon(Icons.monitor_heart_outlined),
      selectedIcon: Icon(Icons.monitor_heart_rounded),
      label: 'Diagnostics',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final identity = widget.controller.identity!;
    final pages = <Widget>[
      _NearbyScreen(controller: widget.controller),
      const _ConversationsScreen(),
      _SettingsScreen(controller: widget.controller, identity: identity),
      _DiagnosticsScreen(controller: widget.controller, identity: identity),
    ];
    return LayoutBuilder(
      builder: (context, constraints) {
        final usesRail = constraints.maxWidth >= 720;
        final content = IndexedStack(index: _selectedIndex, children: pages);
        if (!usesRail) {
          return Scaffold(
            body: content,
            bottomNavigationBar: NavigationBar(
              selectedIndex: _selectedIndex,
              destinations: _destinations,
              onDestinationSelected: _select,
            ),
          );
        }
        return Scaffold(
          body: SafeArea(
            child: Row(
              children: [
                NavigationRail(
                  backgroundColor: Colors.white,
                  selectedIndex: _selectedIndex,
                  labelType: NavigationRailLabelType.all,
                  leading: const Padding(
                    padding: EdgeInsets.only(bottom: 18),
                    child: _LanSignalMotif(size: 42),
                  ),
                  destinations: _destinations
                      .map(
                        (destination) => NavigationRailDestination(
                          icon: destination.icon,
                          selectedIcon: destination.selectedIcon,
                          label: Text(destination.label),
                        ),
                      )
                      .toList(),
                  onDestinationSelected: _select,
                ),
                const VerticalDivider(width: 1),
                Expanded(child: content),
              ],
            ),
          ),
        );
      },
    );
  }

  void _select(int index) => setState(() => _selectedIndex = index);
}

class _NearbyScreen extends StatelessWidget {
  const _NearbyScreen({required this.controller});

  final AppController controller;

  @override
  Widget build(BuildContext context) {
    final status = controller.discoveryStatus;
    final peers = controller.nearbyPeers;
    if (peers.isEmpty) {
      final title = switch (status.issue) {
        DiscoveryIssue.noNetwork => 'Connect to a local network',
        DiscoveryIssue.permissionDenied => 'Allow local network access',
        DiscoveryIssue.serviceUnavailable => 'Discovery could not start',
        DiscoveryIssue.resolveFailed => 'Devices could not be resolved',
        DiscoveryIssue.interrupted => 'Discovery was interrupted',
        DiscoveryIssue.none when status.browsing =>
          'Looking for nearby devices',
        DiscoveryIssue.none => 'Local discovery is not running',
      };
      final explanation = switch (status.issue) {
        DiscoveryIssue.noNetwork =>
          'Connect to Wi-Fi or Ethernet, then keep this app open.',
        DiscoveryIssue.permissionDenied =>
          'Check this app’s local network permission in system settings.',
        DiscoveryIssue.serviceUnavailable => 'Check the Diagnostics tab for network service and firewall guidance.',
        DiscoveryIssue.resolveFailed => 'Discovery found a service but could not obtain an IP address. Try reconnecting to the network.',
        DiscoveryIssue.interrupted => 'Reconnect to the network and keep both devices on the same local segment.',
        DiscoveryIssue.none when status.browsing => 'No peer advertisement has arrived. Keep this app open on both devices and use the same Wi-Fi or Ethernet network. This device cannot distinguish no online peers from Wi-Fi isolation; if the other app is open, check guest-network or client-isolation settings.',
        DiscoveryIssue.none =>
          'Discovery starts after your local identity is ready.',
      };
      return _SectionPage(
        title: 'Nearby',
        child: _EmptyState(
          motif: true,
          title: title,
          body: explanation,
          status: status.browsing ? 'Scanning' : 'Local network',
        ),
      );
    }
    return _SectionPage(
      title: 'Nearby',
      child: ListView(
        padding: const EdgeInsets.fromLTRB(24, 14, 24, 32),
        children: <Widget>[
          Text(
            peers.length == 1
                ? '1 device advertised nearby'
                : 'Devices advertised nearby',
            style: Theme.of(context).textTheme.titleLarge
                ?.copyWith(fontWeight: FontWeight.w800),
          ),
          const SizedBox(height: 8),
          const Text(
            'These identities are unverified. A secure connection will verify them before messaging.',
          ),
          const SizedBox(height: 18),
          for (final peer in peers) _NearbyPeerRow(peer: peer),
        ],
      ),
    );
  }
}

class _NearbyPeerRow extends StatelessWidget {
  const _NearbyPeerRow({required this.peer});

  final PeerPresence peer;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 16),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFDCE5E3))),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Padding(
          padding: EdgeInsets.only(top: 2, right: 16),
          child: Icon(Icons.devices_rounded, color: _signalTeal),
        ),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              IdentityLabel(
                displayName: peer.advertisedName ?? 'Nearby device',
                fingerprint: peer.advertisedFingerprint,
              ),
              const SizedBox(height: 8),
              Text(
                peer.endpoints.length == 1
                    ? '1 local address'
                    : '${peer.endpoints.length} local addresses',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        const Text('Unverified', style: TextStyle(color: _amber)),
      ],
    ),
  );
}

class _ConversationsScreen extends StatelessWidget {
  const _ConversationsScreen();

  @override
  Widget build(BuildContext context) => const _SectionPage(
    title: 'Conversations',
    child: _EmptyState(
      title: 'No local conversations',
      body: 'Once a nearby peer is discovered and trusted, direct conversations will appear here.',
      status: 'LOCAL ONLY',
    ),
  );
}

class _SettingsScreen extends StatefulWidget {
  const _SettingsScreen({required this.controller, required this.identity});

  final AppController controller;
  final LocalIdentity identity;

  @override
  State<_SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<_SettingsScreen> {
  late final TextEditingController _nameController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(
      text: widget.identity.displayName.value,
    );
  }

  @override
  void didUpdateWidget(covariant _SettingsScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    final currentName = widget.identity.displayName.value;
    if (oldWidget.identity.displayName != widget.identity.displayName &&
        _nameController.text != currentName) {
      _nameController.text = currentName;
    }
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => _SectionPage(
    title: 'Settings',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      children: [
        Text(
          'Local identity',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(
          'Your name can change. The fingerprint stays tied to this installation key.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
        const SizedBox(height: 24),
        TextField(
          controller: _nameController,
          enabled: !widget.controller.isWorking,
          maxLength: maximumDisplayNameBytes,
          decoration: InputDecoration(
            labelText: 'Display name',
            errorText: widget.controller.settingsError,
          ),
          onSubmitted: (_) => _save(),
        ),
        const SizedBox(height: 6),
        Align(
          alignment: Alignment.centerLeft,
          child: FilledButton.icon(
            onPressed: widget.controller.isWorking ? null : _save,
            icon: const Icon(Icons.save_outlined),
            label: const Text('Save name'),
          ),
        ),
        const SizedBox(height: 32),
        const Divider(),
        const SizedBox(height: 22),
        Text('Fingerprint', style: Theme.of(context).textTheme.labelLarge),
        const SizedBox(height: 8),
        SelectableText(
          widget.identity.shortFingerprint,
          style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            color: _linkBlue,
            fontWeight: FontWeight.w800,
            letterSpacing: 2,
          ),
        ),
        const SizedBox(height: 8),
        const Text(
          'Compare this short code when two nearby people use the same display name.',
        ),
      ],
    ),
  );

  Future<void> _save() async {
    final saved = await widget.controller.updateDisplayName(
      _nameController.text,
    );
    if (saved && mounted) {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('Display name updated.')));
    }
  }
}

class _DiagnosticsScreen extends StatefulWidget {
  const _DiagnosticsScreen({required this.controller, required this.identity});

  final AppController controller;
  final LocalIdentity identity;

  @override
  State<_DiagnosticsScreen> createState() => _DiagnosticsScreenState();
}

class _DiagnosticsScreenState extends State<_DiagnosticsScreen> {
  static const _permissions = MethodChannel(
    'dev.localmessenger.app/permissions',
  );
  bool? _notificationsAllowed;

  @override
  void initState() {
    super.initState();
    if (defaultTargetPlatform == TargetPlatform.android) {
      unawaited(_readNotificationStatus());
    }
  }

  Future<void> _readNotificationStatus() async {
    try {
      final allowed = await _permissions.invokeMethod<bool>(
        'notificationStatus',
      );
      if (mounted) setState(() => _notificationsAllowed = allowed);
    } on PlatformException {
      // The native permission bridge may be unavailable on this build.
    } on MissingPluginException {
      // Widget tests and non-Android hosts do not register the native bridge.
    }
  }

  Future<void> _requestNotifications() async {
    try {
      final allowed = await _permissions.invokeMethod<bool>(
        'requestNotifications',
      );
      if (mounted) setState(() => _notificationsAllowed = allowed);
    } on PlatformException {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text(
              'Could not open notification permission. Check Android app settings.',
            ),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) => _SectionPage(
    title: 'Diagnostics',
    child: ListView(
      padding: const EdgeInsets.fromLTRB(24, 12, 24, 32),
      children: [
        Text(
          'Local network status',
          style: Theme.of(context).textTheme.titleLarge
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 16),
        _DiagnosticRow(
          label: 'Installation identity',
          value: 'Ready · revision ${widget.identity.revision}',
          tone: _signalTeal,
        ),
        const _DiagnosticRow(
          label: 'Local database',
          value: 'Ready · schema v1',
          tone: _signalTeal,
        ),
        _DiagnosticRow(
          label: 'Peer discovery',
          value: _discoverySummary(widget.controller.discoveryStatus),
          tone: widget.controller.discoveryStatus.isActive
              ? _signalTeal
              : _amber,
        ),
        _DiagnosticRow(
          label: 'Network interfaces',
          value:
              '${widget.controller.discoveryStatus.activeInterfaceCount} active',
          tone: widget.controller.discoveryStatus.activeInterfaceCount > 0
              ? _signalTeal
              : _amber,
        ),
        _DiagnosticRow(
          label: 'Nearby advertisements',
          value: '${widget.controller.nearbyPeers.length} unverified',
          tone: _linkBlue,
        ),
        if (defaultTargetPlatform == TargetPlatform.android) ...[
          _DiagnosticRow(
            label: 'Notifications',
            value: switch (_notificationsAllowed) {
              true => 'Allowed',
              false => 'Not allowed',
              null => 'Checking',
            },
            tone: _notificationsAllowed == true ? _signalTeal : _amber,
          ),
          if (_notificationsAllowed == false) ...[
            const Text(
              'Optional for future incoming-message alerts. Discovery works without it.',
            ),
            const SizedBox(height: 8),
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton(
                onPressed: _requestNotifications,
                child: const Text('Allow notifications'),
              ),
            ),
          ],
        ],
        const _DiagnosticRow(
          label: 'Secure transport',
          value: 'Available in Phase 3',
          tone: _amber,
        ),
        const _DiagnosticRow(
          label: 'Internet dependency',
          value: 'None',
          tone: _linkBlue,
        ),
        const SizedBox(height: 26),
        Text(
          'If no devices appear',
          style: Theme.of(context).textTheme.titleMedium
              ?.copyWith(fontWeight: FontWeight.w800),
        ),
        const SizedBox(height: 8),
        Text(_platformDiscoveryGuidance()),
      ],
    ),
  );
}

String _discoverySummary(DiscoveryStatus status) => switch (status.issue) {
  DiscoveryIssue.noNetwork => 'No active local network',
  DiscoveryIssue.permissionDenied => 'Permission denied',
  DiscoveryIssue.serviceUnavailable => 'Service unavailable',
  DiscoveryIssue.resolveFailed => 'Address resolution failed',
  DiscoveryIssue.interrupted => 'Interrupted',
  DiscoveryIssue.none when status.isActive => 'Advertising and scanning',
  DiscoveryIssue.none when status.browsing => 'Scanning',
  DiscoveryIssue.none => 'Stopped',
};

String _platformDiscoveryGuidance() => switch (defaultTargetPlatform) {
  TargetPlatform.android => 'Keep both devices on the same Wi-Fi. Check local network and notification settings if prompted. Guest Wi-Fi can isolate devices.',
  TargetPlatform.macOS => 'Allow Local Network access in macOS settings. Check that both devices are on the same LAN and that the firewall permits Local Messenger.',
  TargetPlatform.windows => 'Allow Local Messenger on private networks in Windows Firewall. Confirm the network is marked Private and multicast traffic is permitted.',
  TargetPlatform.linux => 'Check that Avahi is running and the firewall permits mDNS on UDP port 5353. Both devices must share a multicast-capable LAN.',
  _ => 'Use the same multicast-capable local network on both devices. Guest networks can block peer discovery.',
};

class _DiagnosticRow extends StatelessWidget {
  const _DiagnosticRow({
    required this.label,
    required this.value,
    required this.tone,
  });

  final String label;
  final String value;
  final Color tone;

  @override
  Widget build(BuildContext context) => Container(
    padding: const EdgeInsets.symmetric(vertical: 18),
    decoration: const BoxDecoration(
      border: Border(bottom: BorderSide(color: Color(0xFFDCE5E3))),
    ),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          width: 9,
          height: 9,
          margin: const EdgeInsets.only(top: 5, right: 12),
          decoration: BoxDecoration(color: tone, shape: BoxShape.circle),
        ),
        Expanded(child: Text(label)),
        const SizedBox(width: 16),
        Flexible(
          child: Text(
            value,
            textAlign: TextAlign.end,
            style: const TextStyle(fontWeight: FontWeight.w700),
          ),
        ),
      ],
    ),
  );
}

class ConversationScreen extends StatelessWidget {
  const ConversationScreen({required this.arguments, super.key});

  final ConversationRouteArguments arguments;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: IdentityLabel(
        displayName: arguments.peerName,
        fingerprint: arguments.fingerprint ?? 'IDENTITY UNAVAILABLE',
      ),
    ),
    body: const _EmptyState(
      title: 'Conversation ready',
      body: 'Message transport is intentionally unavailable until the authenticated Phase 3 channel is implemented.',
      status: 'NO NETWORK TRAFFIC',
    ),
  );
}

class _SectionPage extends StatelessWidget {
  const _SectionPage({required this.title, required this.child});

  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(
      title: Text(title, style: const TextStyle(fontWeight: FontWeight.w800)),
    ),
    body: child,
  );
}

class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.title,
    required this.body,
    required this.status,
    this.motif = false,
  });

  final String title;
  final String body;
  final String status;
  final bool motif;

  @override
  Widget build(BuildContext context) => Center(
    child: SingleChildScrollView(
      padding: const EdgeInsets.all(28),
      child: ConstrainedBox(
        constraints: const BoxConstraints(maxWidth: 500),
        child: Column(
          children: [
            if (motif) ...[
              const _LanSignalMotif(size: 92),
              const SizedBox(height: 26),
            ],
            Text(
              status,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: _signalTeal,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.5,
              ),
            ),
            const SizedBox(height: 10),
            Text(
              title,
              style: Theme.of(context).textTheme.headlineSmall
                  ?.copyWith(fontWeight: FontWeight.w800),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 10),
            Text(
              body,
              style: Theme.of(context).textTheme.bodyLarge
                  ?.copyWith(height: 1.5),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    ),
  );
}

class _LanSignalMotif extends StatelessWidget {
  const _LanSignalMotif({required this.size});

  final double size;

  @override
  Widget build(BuildContext context) => Semantics(
    label: 'Local network signal',
    child: SizedBox.square(
      dimension: size,
      child: CustomPaint(painter: const _LanSignalPainter()),
    ),
  );
}

class _LanSignalPainter extends CustomPainter {
  const _LanSignalPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final center = size.center(Offset.zero);
    final radius = size.shortestSide / 2;
    final ringPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = size.shortestSide * 0.055
      ..color = _signalTeal.withValues(alpha: 0.2);
    for (final fraction in <double>[0.38, 0.66, 0.94]) {
      canvas.drawCircle(center, radius * fraction, ringPaint);
    }
    canvas.drawCircle(center, radius * 0.16, Paint()..color = _signalTeal);
    canvas.drawCircle(
      Offset(center.dx + radius * 0.56, center.dy - radius * 0.22),
      radius * 0.09,
      Paint()..color = _amber,
    );
  }

  @override
  bool shouldRepaint(covariant _LanSignalPainter oldDelegate) => false;
}

class BootstrapFailureApp extends StatelessWidget {
  const BootstrapFailureApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    debugShowCheckedModeBanner: false,
    title: 'Local Messenger',
    theme: _theme(),
    home: const _IdentityFailureScreen(
      message: 'The local application database or cryptography runtime could not be opened.',
      onRetry: null,
    ),
  );
}
