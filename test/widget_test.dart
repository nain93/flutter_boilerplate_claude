// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter_test/flutter_test.dart';

import 'package:flutter_boilerplate_claude/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Wait for the app to settle
    await tester.pumpAndSettle();

    // Verify that the app loads and shows the home page.
    expect(find.text('Welcome to Flutter Boilerplate'), findsOneWidget);
    expect(find.text('Clean Architecture with BLoC Pattern'), findsOneWidget);

    // Verify navigation bar is present.
    expect(find.text('Home'), findsOneWidget);
    expect(find.text('Content'), findsOneWidget);
    expect(find.text('Users'), findsOneWidget);
    expect(find.text('Profile'), findsOneWidget);
  });
}
