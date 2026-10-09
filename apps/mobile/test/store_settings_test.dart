import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/store_settings_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';

void main() {
  group('Store Manager Screen 9 - Operating Controls & Settings Tests (TDD First)', () {
    testWidgets('renders Settings header, Emergency Rush Pause, Prep Buffer, and Courier Partners', (tester) async {
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
            body: StoreSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header
      expect(find.text('Store Operating Controls & Settings'), findsOneWidget);
      expect(
        find.text('Emergency rush pauses, kitchen buffer times, dispatch partners, and thermal printer setup'),
        findsOneWidget,
      );
      expect(find.text('● Store Open for Online Orders'), findsOneWidget);

      // 2. Verify Emergency Rush Pause Card
      expect(find.text('Emergency Rush Mode Pause'), findsOneWidget);
      expect(
        find.text('Temporarily pause incoming customer orders during overwhelming counter rushes'),
        findsOneWidget,
      );
      expect(find.text('Pause 15 Mins'), findsOneWidget);
      expect(find.text('Pause 30 Mins'), findsOneWidget);
      expect(find.text('Pause 60 Mins'), findsOneWidget);

      // 3. Verify Preparation Time Buffer
      expect(find.text('Kitchen & Butcher Prep Buffer'), findsOneWidget);
      expect(find.text('Normal (+0 mins)'), findsOneWidget);
      expect(find.text('+5 mins (Rainy Rush)'), findsOneWidget);
      expect(find.text('+10 mins (Peak Butcher)'), findsOneWidget);
      expect(find.text('+15 mins (Heavy Rush)'), findsOneWidget);

      // 4. Verify Delivery Partners (Strictly Uber Direct and DoorDash Drive only)
      expect(find.text('On-Demand Delivery Fleet Partners'), findsOneWidget);
      expect(find.text('Uber Direct Courier Dispatch'), findsOneWidget);
      expect(find.text('DoorDash Drive Courier Dispatch'), findsOneWidget);
      // Strictly zero "Store Delivery"
      expect(find.text('Store Delivery'), findsNothing);
      expect(find.text('Own Driver'), findsNothing);

      // 5. Verify Thermal Receipt Printer Section
      expect(find.text('Thermal ESC/POS Hardware'), findsOneWidget);
      expect(find.text('Epson TM-T88VI (LAN Connected · 192.168.1.140)'), findsOneWidget);
      expect(find.text('Auto-print incoming orders on tablet chime'), findsOneWidget);
      expect(find.text('Print dual bag slips with catch-weight audit'), findsOneWidget);
      expect(find.text('Test Print Slip'), findsOneWidget);

      // 6. Verify Trading Hours
      expect(find.text('Weekly Trading Hours & Operating Schedule'), findsOneWidget);
      expect(find.text('Monday – Friday'), findsOneWidget);
      expect(find.text('08:00 AM – 09:00 PM'), findsWidgets);
    });

    testWidgets('allows activating emergency rush pause and updating prep buffer', (tester) async {
      await tester.binding.setSurfaceSize(const Size(1280, 1200));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: const Scaffold(
            body: StoreSettingsScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Tap Pause 30 Mins
      await tester.tap(find.text('Pause 30 Mins'));
      await tester.pumpAndSettle();

      expect(find.text('Active: 30m Rush Pause Active'), findsOneWidget);

      // 2. Select Prep Buffer +10 mins
      await tester.tap(find.text('+10 mins (Peak Butcher)'));
      await tester.pumpAndSettle();

      expect(find.text('+10 min Buffer Active'), findsOneWidget);

      // 3. Tap Test Print Slip
      await tester.ensureVisible(find.text('Test Print Slip'));
      await tester.tap(find.text('Test Print Slip'));
      await tester.pumpAndSettle();

      expect(find.text('✓ Test Slip Sent to TM-T88VI'), findsOneWidget);
    });

    testWidgets('integrates with StoreShell navigation rail to route to /store/settings', (tester) async {
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
            initialRoute: '/store/settings',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify StoreSettingsScreen is rendered inside StoreShell
      expect(find.text('Store Operating Controls & Settings'), findsOneWidget);
      expect(find.text('Emergency Rush Mode Pause'), findsOneWidget);
    });
  });
}
