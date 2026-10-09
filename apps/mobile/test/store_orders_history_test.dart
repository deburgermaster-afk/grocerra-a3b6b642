import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/order_history_screen.dart';

void main() {
  group('Store Manager Screen 3 - All Orders History & Receipts Tests', () {
    testWidgets('renders order history table, search, status tabs, and action buttons', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = MockStoreOrdersRepository();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: OrderHistoryScreen(
              repository: repository,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Header elements
      expect(find.text('All Orders History'), findsOneWidget);
      expect(find.textContaining('Today · Oct 9, 2026'), findsOneWidget);
      expect(find.text('Export'), findsOneWidget);

      // 2. Filter tabs
      expect(find.text('All Orders'), findsOneWidget);
      expect(find.text('Completed'), findsOneWidget);
      expect(find.text('Cancelled'), findsOneWidget);
      expect(find.text('Refunded / Disputed'), findsOneWidget);
      expect(find.text('Catering'), findsOneWidget);

      // 3. Table Column Headers
      expect(find.text('ORDER ID'), findsOneWidget);
      expect(find.text('CUSTOMER'), findsOneWidget);
      expect(find.text('ITEMS'), findsOneWidget);
      expect(find.text('COURIER'), findsOneWidget);
      expect(find.text('TOTAL AMOUNT'), findsOneWidget);
      expect(find.text('STATUS'), findsOneWidget);
      expect(find.text('ACTIONS'), findsOneWidget);

      // 4. Historical Orders visible
      expect(find.text('#8480'), findsOneWidget);
      expect(find.text('Zainab R.'), findsOneWidget);
      expect(find.text('#8476'), findsOneWidget);
      expect(find.text('Bilal T.'), findsOneWidget);
      expect(find.text('#8471'), findsOneWidget);
      expect(find.text('S. Ahmed'), findsOneWidget);

      // 5. Action buttons visible
      expect(find.text('View Receipt'), findsWidgets);
      expect(find.text('GST Invoice PDF'), findsWidgets);
      expect(find.text('Dispute Details'), findsOneWidget);
    });

    testWidgets('status filter tab filters orders accurately', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = MockStoreOrdersRepository();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: OrderHistoryScreen(
              repository: repository,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap 'Catering' tab
      await tester.tap(find.text('Catering'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Only catering orders #8471 and #8460 should be shown
      expect(find.text('#8471'), findsOneWidget);
      expect(find.text('S. Ahmed'), findsOneWidget);
      expect(find.text('#8460'), findsOneWidget);
      expect(find.text('Hassan D.'), findsOneWidget);
      // Non-catering orders should not be in the list
      expect(find.text('#8476'), findsNothing);
    });

    testWidgets('view receipt and GST invoice modals open cleanly', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = MockStoreOrdersRepository();

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: OrderHistoryScreen(
              repository: repository,
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap first 'View Receipt' button
      await tester.tap(find.text('View Receipt').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify Receipt dialog content
      expect(find.textContaining('Digital Receipt'), findsOneWidget);
      expect(find.text('Madina Halal Meats & Groceries'), findsOneWidget);
      expect(find.text('Print Thermal Receipt'), findsOneWidget);

      // Close dialog
      await tester.tap(find.text('Close'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap 'GST Invoice PDF' button
      await tester.tap(find.text('GST Invoice PDF').first);
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Verify Tax Invoice dialog
      expect(find.text('TAX INVOICE'), findsOneWidget);
      expect(find.text('ABN: 45 123 456 789'), findsOneWidget);
      expect(find.text('PAID IN FULL'), findsOneWidget);
      expect(find.text('Download PDF'), findsOneWidget);
    });
  });
}
