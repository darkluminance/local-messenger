import 'package:flutter_test/flutter_test.dart';
import 'package:local_messenger/main.dart';

void main() {
  testWidgets('renders the Phase 0 shell', (WidgetTester tester) async {
    await tester.pumpWidget(const LocalMessengerApp());

    expect(find.text('Local Messenger'), findsOneWidget);
    expect(find.text('Phase 0 feasibility shell'), findsOneWidget);
  });
}
