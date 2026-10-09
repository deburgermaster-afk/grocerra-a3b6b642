import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/store_issues_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';

void main() {
  group('Store Manager Screen 6 - Customer Complaints & Disputes Tests (TDD First)', () {
    testWidgets('renders Complaints header, open inquiries badge, and 4 KPI metric cards', (tester) async {
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
            body: StoreIssuesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header & Open Inquiries Badge
      expect(find.text('Order Complaints & Refund Requests'), findsOneWidget);
      expect(
        find.text('Resolve missing item claims and damaged goods with 1-tap customer refunds'),
        findsOneWidget,
      );
      expect(find.text('2 Open Customer Inquiries'), findsOneWidget);

      // 2. Verify 4 KPI Summary Cards
      expect(find.text('Open Disputes'), findsOneWidget);
      expect(find.text('2 Issues'), findsOneWidget);

      expect(find.text('Dispute Rate'), findsOneWidget);
      expect(find.text('0.28%'), findsOneWidget);

      expect(find.text('Total Refunded (MTD)'), findsOneWidget);
      expect(find.text(r'$42.50'), findsOneWidget);

      expect(find.text('Courier Liability'), findsOneWidget);
      expect(find.text('78%'), findsOneWidget);
    });

    testWidgets('renders active complaint cards with customer statements and courier details', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 950));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StoreIssuesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Case 1: Bilal T. missing item claim
      expect(find.text('Order #8476 · Bilal T.'), findsOneWidget);
      expect(find.text('Missing Item Reported'), findsOneWidget);
      expect(find.textContaining('Uber Direct'), findsWidgets);
      expect(find.textContaining('1x Shan Biryani Masala (\$2.45) was not in bag #2'), findsOneWidget);
      expect(find.text('Approve \$2.45 Refund'), findsOneWidget);
      expect(find.text('Dispute Claim'), findsOneWidget);

      // 2. Verify Case 2: Fatima S. transit damage
      expect(find.text('Order #8468 · Fatima S.'), findsOneWidget);
      expect(find.text('Bag Packaging Torn'), findsOneWidget);
      expect(find.textContaining('DoorDash Drive'), findsWidgets);
      expect(find.textContaining('Outer chilled meat bag punctured during courier transit'), findsOneWidget);
      expect(find.text('Courier Liable (Forward to DoorDash)'), findsOneWidget);
      expect(find.text('Store Credit \$10'), findsOneWidget);

      // Guarantee NO Store Delivery exists
      expect(find.text('Store Delivery'), findsNothing);
    });

    testWidgets('allows approving refund and forwarding courier liability with visual status change', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 900));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StoreIssuesScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Approve refund for Case 1
      await tester.tap(find.text('Approve \$2.45 Refund'));
      await tester.pumpAndSettle();

      expect(find.text('✓ Refund Approved (\$2.45)'), findsOneWidget);

      // 2. Forward courier liability for Case 2
      await tester.tap(find.text('Courier Liable (Forward to DoorDash)'));
      await tester.pumpAndSettle();

      expect(find.text('✓ Forwarded to DoorDash Drive'), findsOneWidget);
    });

    testWidgets('integrates with StoreShell navigation rail to route to /store/issues', (tester) async {
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
            initialRoute: '/store/issues',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify StoreIssuesScreen is rendered inside StoreShell
      expect(find.text('Order Complaints & Refund Requests'), findsOneWidget);
      expect(find.text('Open Disputes'), findsOneWidget);
    });
  });
}
