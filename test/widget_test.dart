import 'package:flutter_test/flutter_test.dart';

import 'package:finance_hub/main.dart';

void main() {
  testWidgets('App loads smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame using the NEW class name.
    await tester.pumpWidget(const FinanceHubApp());

    // Verify that our new placeholder text is on the screen.
    expect(find.text('Database Initialized. UI Pending.'), findsOneWidget);

    // Verify that the old counter app text is gone.
    expect(find.text('0'), findsNothing);
  });
}
