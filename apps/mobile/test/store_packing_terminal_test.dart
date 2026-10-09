import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/models/store_order.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/order_packing_screen.dart';

void main() {
  group('Store Manager Screen 2 - Order Packing Terminal & Scales Tests', () {
    testWidgets('renders packing checklist, digital scale terminal, bag allocation, and courier info', (tester) async {
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
            body: OrderPackingScreen(
              orderId: '8489',
              repository: repository,
              onBackToLiveBoard: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Header elements
      expect(find.text('Live Board'), findsOneWidget);
      expect(find.text('Packing Order #8489'), findsOneWidget);
      expect(find.textContaining('Prep Due:'), findsOneWidget);
      expect(find.textContaining('Tariq M.'), findsOneWidget);

      // 2. Checklist items
      expect(find.text('Items Checklist'), findsOneWidget);
      expect(find.text('Daawat Traditional Basmati Rice 5kg'), findsOneWidget);
      expect(find.text('Shan Biryani Masala 50g'), findsOneWidget);
      expect(find.text('Fresh Halal Baby Goat Curry Cut'), findsOneWidget);
      expect(find.text('Fresh Mint & Coriander Bunches'), findsOneWidget);

      // 3. Catch-Weight Butcher Scale Station
      expect(find.text('HALAL BUTCHER · CATCH WEIGHT'), findsOneWidget);
      expect(find.textContaining('1.54 kg'), findsOneWidget);
      expect(find.textContaining('Within ±10% pre-auth limit'), findsOneWidget);
      expect(find.text('+0.05 kg'), findsOneWidget);
      expect(find.text('-0.05 kg'), findsOneWidget);
      expect(find.text('Lock Weight ✓'), findsOneWidget);

      // 4. Packaging Allocation & Courier Station
      expect(find.text('Packaging Allocation'), findsOneWidget);
      expect(find.text('Chilled Bags'), findsOneWidget);
      expect(find.text('Ambient Bags'), findsOneWidget);
      expect(find.text('Courier Dispatch'), findsOneWidget);
      expect(find.text('Uber Direct'), findsOneWidget);
      expect(find.textContaining('Print Bag Slips'), findsOneWidget);
      expect(find.text('✓ Mark Packed & Ready for Courier'), findsOneWidget);
    });

    testWidgets('tapping Mark Packed updates repository status to readyForDriver', (tester) async {
      tester.view.physicalSize = const Size(1280, 800);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      final repository = MockStoreOrdersRepository();

      bool navigatedBack = false;

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: OrderPackingScreen(
              orderId: '8489',
              repository: repository,
              onBackToLiveBoard: () {
                navigatedBack = true;
              },
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Tap Mark Packed button
      await tester.tap(find.text('✓ Mark Packed & Ready for Courier'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final orders = await repository.getOrders();
      final packedOrder = orders.firstWhere((o) => o.id == '8489');
      expect(packedOrder.status, StoreOrderStatus.readyForDriver);
      expect(navigatedBack, isTrue);
    });

    testWidgets('renders cleanly on compact laptop viewport (1280x600) with zero overflow', (tester) async {
      tester.view.physicalSize = const Size(1280, 600);
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
            body: OrderPackingScreen(
              orderId: '8489',
              repository: repository,
              onBackToLiveBoard: () {},
            ),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      expect(find.text('✓ Mark Packed & Ready for Courier'), findsOneWidget);
      expect(find.text('Packaging Allocation'), findsOneWidget);
    });
  });
}
