import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:running_form_analyzer/main.dart';

void main() {
  testWidgets('App launches and shows home screen', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: RunningFormAnalyzerApp(),
      ),
    );

    // Verify that the home screen is displayed
    expect(find.text('Running Form\nAnalyzer'), findsOneWidget);
    expect(find.text('New Analysis'), findsOneWidget);
    expect(find.text('Joint Settings'), findsOneWidget);
  });
}
