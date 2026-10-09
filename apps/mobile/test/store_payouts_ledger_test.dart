import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/store_payouts_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';

void main() {
  group('Store Manager Screen 5 - Payouts & Financial Earnings Tests (TDD First)', () {
    testWidgets('renders Payouts header, tax statement CTA, and 4 financial KPI cards', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 850));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StorePayoutsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header
      expect(find.text('Payouts & Financial Earnings'), findsOneWidget);
      expect(
        find.textContaining('Automated rolling 2-day payouts via Stripe Express'),
        findsOneWidget,
      );
      expect(find.text('Download Tax Statement (CSV)'), findsOneWidget);

      // 2. Verify 4 Core Financial KPI Cards
      expect(find.text('Available Balance'), findsOneWidget);
      expect(find.text(r'$2,418.50'), findsOneWidget);
      expect(find.textContaining('Auto-transferring Tuesday'), findsOneWidget);

      expect(find.text('Pending Processing'), findsOneWidget);
      expect(find.text(r'$684.20'), findsOneWidget);
      expect(find.text("Today's unsettled orders"), findsOneWidget);

      expect(find.text('Month-to-Date Net'), findsOneWidget);
      expect(find.text(r'$18,940.00'), findsOneWidget);
      expect(find.text('+22.4% vs last month'), findsOneWidget);

      expect(find.text('Grocerra Commission'), findsOneWidget);
      expect(find.text('4.5%'), findsOneWidget);
      expect(find.text('Lowest merchant fee in AU'), findsOneWidget);
    });

    testWidgets('renders Stripe Connect account card and payout transfers ledger table', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 850));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StorePayoutsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Stripe Connect Card
      expect(find.text('Stripe Connect'), findsOneWidget);
      expect(find.textContaining('ANZ Business Classic Account'), findsOneWidget);
      expect(find.textContaining('ending in ···· 4821'), findsOneWidget);
      expect(find.textContaining('ABN 84 921 402 189'), findsOneWidget);
      expect(find.text('Connected & Healthy'), findsOneWidget);
      expect(find.text('Manage on Stripe'), findsOneWidget);

      // 2. Verify Payout Table Column Headers
      expect(find.text('Payout Date'), findsOneWidget);
      expect(find.text('Transfer Reference'), findsOneWidget);
      expect(find.text('Gross Sales'), findsOneWidget);
      expect(find.text('Commission (4.5%)'), findsOneWidget);
      expect(find.text(r'Net Paid ($ AUD)'), findsOneWidget);
      expect(find.text('Status'), findsOneWidget);

      // 3. Verify Payout Transfer Rows
      expect(find.text('Tuesday, 6 Oct 2026'), findsOneWidget);
      expect(find.text('po_1Nw82910Grocerra'), findsOneWidget);
      expect(find.text(r'$4,820.00'), findsOneWidget);
      expect(find.text(r'-$216.90'), findsOneWidget);
      expect(find.text(r'$4,603.10'), findsOneWidget);
      expect(find.text('Deposited'), findsWidgets);
    });

    testWidgets('opens tax statement download dialog on button click', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 850));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StorePayoutsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap Download Tax Statement (CSV) button
      await tester.tap(find.text('Download Tax Statement (CSV)'));
      await tester.pumpAndSettle();

      // Verify Tax Statement modal elements
      expect(find.text('Merchant Tax Statement (CSV)'), findsOneWidget);
      expect(find.text('grocerra_tax_statement_fy26.csv'), findsOneWidget);
      expect(find.text('Download Completed'), findsOneWidget);
    });

    testWidgets('integrates with StoreShell navigation rail to route to /store/payouts', (tester) async {
      final repository = MockStoreOrdersRepository();
      await tester.binding.setSurfaceSize(const Size(1280, 850));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: StoreShell(
            repository: repository,
            initialRoute: '/store/payouts',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify StorePayoutsScreen is rendered inside StoreShell
      expect(find.text('Payouts & Financial Earnings'), findsOneWidget);
      expect(find.text('Available Balance'), findsOneWidget);
    });
  });
}
