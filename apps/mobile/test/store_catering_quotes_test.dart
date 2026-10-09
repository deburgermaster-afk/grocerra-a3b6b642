import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/presentation/store_catering_screen.dart';

void main() {
  group('Store Manager Screen 8 - Catering Inquiries & Custom Quotes Tests (TDD First)', () {
    testWidgets('renders Catering header, 4 KPI cards, filter tabs, and Create Custom Quote button', (tester) async {
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
            body: StoreCateringScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header
      expect(find.text('Catering Inquiries & Custom Quotes'), findsOneWidget);
      expect(
        find.text('Manage bulk food orders for weddings, family events, and festivals across Melbourne'),
        findsOneWidget,
      );
      expect(find.text('+ Create Custom Quote'), findsOneWidget);

      // 2. Verify 4 KPI Summary Cards
      expect(find.text('Active Inquiries'), findsOneWidget);
      expect(find.text('3 Inquiries'), findsOneWidget);

      expect(find.text('Total Quoted Value'), findsOneWidget);
      expect(find.text(r'$8,450.00'), findsOneWidget);

      expect(find.text('Confirmed Events'), findsOneWidget);
      expect(find.text('4 Events'), findsOneWidget);

      expect(find.text('Avg Event Size'), findsOneWidget);
      expect(find.text('72 Guests'), findsOneWidget);

      // 3. Verify Filter Tabs
      expect(find.text('All Inquiries (3)'), findsOneWidget);
      expect(find.text('New / Unquoted (1)'), findsOneWidget);
      expect(find.text('Quote Sent (2)'), findsOneWidget);
      expect(find.text('Confirmed (4)'), findsOneWidget);
    });

    testWidgets('renders catering quote cards with event details, pricing, and deposit breakdown', (tester) async {
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
            body: StoreCateringScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Case 1: Tariq Mahmood (Eid Family Gathering)
      expect(find.text('Inquiry #CAT-892 · Tariq Mahmood (Eid Family Gathering)'), findsOneWidget);
      expect(find.text('65 Guests · Suburb: Coburg VIC'), findsOneWidget);
      expect(find.text(r'$1,150.00 AUD'), findsOneWidget);
      expect(find.text('Deposit: \$345.00 (30%)'), findsOneWidget);
      expect(find.text('Send Quote to App'), findsOneWidget);
      expect(find.text('Edit Package'), findsOneWidget);

      // Case 2: Zoya Ahmed (Wedding Walima Reception)
      expect(find.text('Inquiry #CAT-890 · Zoya Ahmed (Wedding Walima Reception)'), findsOneWidget);
      expect(find.text('180 Guests · Suburb: Broadmeadows VIC'), findsOneWidget);
      expect(find.text(r'$3,850.00 AUD'), findsOneWidget);
      expect(find.text('Deposit: \$1,155.00 (30%)'), findsOneWidget);
    });

    testWidgets('allows tapping Send Quote to App button to update status to Quote Sent', (tester) async {
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
            body: StoreCateringScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find and tap 'Send Quote to App'
      expect(find.text('Send Quote to App'), findsOneWidget);
      await tester.tap(find.text('Send Quote to App'));
      await tester.pumpAndSettle();

      // Verify button updates to '✓ Quote Sent ($1,150.00)'
      expect(find.text('✓ Quote Sent (\$1,150.00)'), findsOneWidget);
    });

    testWidgets('opens Create Custom Quote dialog modal on button tap cleanly', (tester) async {
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
            body: StoreCateringScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap '+ Create Custom Quote'
      await tester.tap(find.text('+ Create Custom Quote'));
      await tester.pumpAndSettle();

      // Verify Modal Dialog is open cleanly
      expect(find.text('Create Custom Catering Quote'), findsOneWidget);
      expect(find.text('Customer Name'), findsOneWidget);
      expect(find.text('Save & Send Quote'), findsOneWidget);
    });
  });
}
