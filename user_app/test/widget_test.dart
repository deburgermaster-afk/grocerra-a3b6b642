import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grocerra_customer/app.dart';

void main() {
  testWidgets('Grocerra app boots into the five-tab shell', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GrocerraApp());
    await tester.pump();

    expect(find.text('Groceries & Catering'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    for (final String tab in <String>[
      'Home',
      'Browse',
      'Catering',
      'Orders',
      'Profile',
    ]) {
      expect(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(tab),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('bottom tabs switch to their blueprint screen', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GrocerraApp());
    await tester.pump();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Browse'),
      ),
    );
    await tester.pump();

    expect(find.textContaining('category grid'), findsOneWidget);
    final NavigationBar bar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(bar.selectedIndex, 1);
  });
}
