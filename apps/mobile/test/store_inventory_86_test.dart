import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/store_inventory_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';

void main() {
  group('Store Manager Screen 7 - Quick 86 Stock & Catalog Tests (TDD First)', () {
    testWidgets('renders Inventory header, 4 KPI cards, search bar, and add product button', (tester) async {
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
            body: StoreInventoryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Page Header
      expect(find.text('Quick 86 Stock & Catalog'), findsOneWidget);
      expect(
        find.text('Instant 1-tap stock-out switches and manual catalog management'),
        findsOneWidget,
      );
      expect(find.text('+ Add Custom Product'), findsOneWidget);

      // 2. Verify 4 KPI Summary Cards
      expect(find.text('Active Catalog'), findsOneWidget);
      expect(find.text('482 SKUs'), findsOneWidget);

      expect(find.text("Currently 86'd"), findsOneWidget);
      expect(find.text('8 Sold Out'), findsOneWidget);

      expect(find.text('Low Stock Alerts'), findsOneWidget);
      expect(find.text('14 SKUs'), findsOneWidget);

      expect(find.text('Inventory Sync'), findsOneWidget);
      expect(find.text('100% Live'), findsOneWidget);

      // 3. Verify Search Input Box
      expect(find.byType(TextField), findsOneWidget);
      expect(find.text('Search 482 store SKUs by name or barcode...'), findsOneWidget);
    });

    testWidgets('renders category pills and SKU table rows with 86 toggle controls', (tester) async {
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
            body: StoreInventoryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // 1. Verify Category Filter Pills
      expect(find.text('All Products (482)'), findsOneWidget);
      expect(find.text('Halal Butcher (64)'), findsOneWidget);
      expect(find.text('South Asian Pantry (240)'), findsOneWidget);
      expect(find.text('Fresh Produce (118)'), findsOneWidget);

      // 2. Verify SKU Table Column Headers
      expect(find.text('Product Name & SKU'), findsOneWidget);
      expect(find.text('Category / Department'), findsOneWidget);
      expect(find.text(r'Unit Price ($ AUD)'), findsOneWidget);
      expect(find.text('Stock Level'), findsOneWidget);
      expect(find.text('Online Availability (86 Toggle)'), findsOneWidget);

      // 3. Verify Product Rows
      expect(find.text('Fresh Halal Baby Goat Curry Cut'), findsOneWidget);
      expect(find.text('Daawat Traditional Basmati Rice 5kg'), findsOneWidget);
      expect(find.text('Shan Bombay Biryani Masala 50g'), findsOneWidget);
      expect(find.text('Fresh Mint & Coriander Bunches'), findsOneWidget);

      // 4. Verify 86 Status Badges & Switches
      expect(find.text('In Stock'), findsWidgets);
      expect(find.text("86'd (Sold Out)"), findsWidgets);
    });

    testWidgets('toggling 86 switch updates product availability status', (tester) async {
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
            body: StoreInventoryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find first switch for Fresh Halal Baby Goat
      final switchFinders = find.byType(ShadSwitch);
      expect(switchFinders, findsWidgets);

      // Tap first switch to 86 the item
      await tester.tap(switchFinders.first);
      await tester.pumpAndSettle();

      // Verify item was 86'd
      expect(find.text("86'd (Sold Out)"), findsWidgets);
    });

    testWidgets('opens add custom product dialog on button tap', (tester) async {
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
            body: StoreInventoryScreen(),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Tap + Add Custom Product
      await tester.tap(find.text('+ Add Custom Product'));
      await tester.pumpAndSettle();

      // Verify Modal Dialog
      expect(find.text('Add Custom Product SKU'), findsOneWidget);
      expect(find.text('Publish item directly to Grocerra Customer App catalog'), findsOneWidget);
      expect(find.text('Save & Publish SKU'), findsOneWidget);
    });

    testWidgets('integrates with StoreShell navigation rail to route to /store/inventory', (tester) async {
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
            initialRoute: '/store/inventory',
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify StoreInventoryScreen is rendered inside StoreShell
      expect(find.text('Quick 86 Stock & Catalog'), findsOneWidget);
      expect(find.text('Active Catalog'), findsOneWidget);
    });
  });
}
