import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/store_analytics_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';

void main() {
  group('Store Manager Screen 4 - Analytics & Performance Dashboard Tests (TDD First)', () {
    testWidgets('renders Analytics dashboard header, timeframe tabs, 4 KPI cards, and export button', (tester) async {
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
            body: StoreAnalyticsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header
      expect(find.text('Analytics & Performance'), findsOneWidget);
      expect(find.text('Real-time store metrics, fulfillment efficiency, and category sales breakdown'), findsOneWidget);

      // 2. Verify Timeframe Tabs
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('This Week'), findsOneWidget);
      expect(find.text('This Month'), findsOneWidget);
      expect(find.text('Custom'), findsOneWidget);

      // 3. Verify Export Action Button
      expect(find.text('Export CSV Report'), findsOneWidget);

      // 4. Verify 4 Core KPI Cards
      expect(find.text('Gross Sales'), findsOneWidget);
      expect(find.text(r'$1,482.50'), findsOneWidget);
      expect(find.text('+18.4% vs yesterday'), findsOneWidget);

      expect(find.text('Fulfilled Orders'), findsOneWidget);
      expect(find.text('28 Orders'), findsOneWidget);

      expect(find.text('Avg Pack Speed'), findsOneWidget);
      expect(find.text('7.2 mins'), findsOneWidget);

      expect(find.text('Courier Dispatch'), findsOneWidget);
      expect(find.text('Uber & DoorDash'), findsOneWidget);
    });

    testWidgets('renders rush hour surge chart, category sales, courier performance, and top products', (tester) async {
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
            body: StoreAnalyticsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Hourly Order Volume Area Graph (Matching Mockup Image)
      expect(find.text('Hourly Order Volume'), findsOneWidget);
      expect(find.text('12 PM - 1 PM'), findsOneWidget);
      expect(find.text('6 PM - 8 PM'), findsOneWidget);
      expect(find.text('9 AM'), findsOneWidget);
      expect(find.text('12 PM'), findsOneWidget);
      expect(find.text('3 PM'), findsOneWidget);
      expect(find.text('6 PM'), findsOneWidget);
      expect(find.text('9 PM'), findsOneWidget);

      // 2. Verify Category Donut Breakdown (Matching Mockup Image)
      expect(find.text('Sales by Category'), findsOneWidget);
      expect(find.text(r'$1,348.20'), findsOneWidget);
      expect(find.text('Revenue'), findsOneWidget);
      expect(find.text('52% Halal Butcher'), findsOneWidget);
      expect(find.text('34% South Asian Pantry'), findsOneWidget);
      expect(find.text('14% Fresh Produce'), findsOneWidget);

      // 3. Verify Courier Dispatch Performance (Strict Rule: ONLY Uber Direct & DoorDash Drive)
      expect(find.text('Courier Dispatch Performance'), findsOneWidget);
      expect(find.text('Uber Direct'), findsOneWidget);
      expect(find.text('DoorDash Drive'), findsOneWidget);
      // Guarantee NO Store Delivery exists
      expect(find.text('Store Delivery'), findsNothing);

      // 4. Verify Top Velocity Products Leaderboard
      expect(find.text('Top Velocity Products Today'), findsOneWidget);
      expect(find.text('Fresh Halal Baby Goat Curry Cut'), findsOneWidget);
      expect(find.text('Daawat Traditional Basmati Rice 5kg'), findsOneWidget);
      expect(find.text('Shan Biryani Masala 50g'), findsOneWidget);
    });

    testWidgets('allows switching timeframe tabs and exporting CSV report dialog', (tester) async {
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
            body: StoreAnalyticsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Switch timeframe to 'This Week'
      await tester.tap(find.text('This Week'));
      await tester.pumpAndSettle();

      // Verify weekly metrics updated
      expect(find.text(r'$9,840.00'), findsOneWidget);
      expect(find.text('184 Orders'), findsOneWidget);

      // 2. Tap Export CSV Report button
      await tester.tap(find.text('Export CSV Report'));
      await tester.pumpAndSettle();

      // Verify export confirmation dialog or sheet opens
      expect(find.text('Store Analytics CSV Exported'), findsOneWidget);
      expect(find.text('Download Completed'), findsOneWidget);
    });

    testWidgets('integrates with StoreShell navigation rail to route to /store/analytics', (tester) async {
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
            initialRoute: '/store/analytics',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify StoreAnalyticsScreen is rendered inside StoreShell
      expect(find.text('Analytics & Performance'), findsOneWidget);
      expect(find.text('Gross Sales'), findsOneWidget);
    });
  });
}
