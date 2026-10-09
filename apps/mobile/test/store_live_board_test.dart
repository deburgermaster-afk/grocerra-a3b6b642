import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import 'package:grocerra_customer/features/store/data/models/store_order.dart';
import 'package:grocerra_customer/features/store/data/repositories/store_orders_repository.dart';
import 'package:grocerra_customer/features/store/presentation/live_orders_board_screen.dart';
import 'package:grocerra_customer/features/store/presentation/store_shell.dart';
import 'package:grocerra_customer/features/store/presentation/widgets/store_header.dart';
import 'package:grocerra_customer/features/store/presentation/widgets/store_sidebar_rail.dart';

void main() {
  group('Store Manager Screen 1 - Live Orders Board Tests', () {
    testWidgets('renders StoreShell with persistent header, sidebar rail, and 3 Kanban columns', (tester) async {
      final repository = MockStoreOrdersRepository();

      await tester.binding.setSurfaceSize(const Size(1280, 800));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: StoreShell(repository: repository),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // 1. Verify Store Header elements
      expect(find.byType(StoreHeader), findsOneWidget);
      expect(find.text('STORE MANAGER'), findsOneWidget);
      expect(find.text('Madina Halal Meats & Groceries · Coburg VIC'), findsOneWidget);
      expect(find.text('Open for Orders'), findsOneWidget);
      expect(find.text('Rush Mode Off'), findsOneWidget);
      expect(find.text('Chime On'), findsOneWidget);

      // 2. Verify Persistent Sidebar Rail elements (all 8 navigation buttons)
      expect(find.byType(StoreSidebarRail), findsOneWidget);
      expect(find.text('Live'), findsOneWidget);
      expect(find.text('Orders'), findsOneWidget);
      expect(find.text('Stats'), findsOneWidget);
      expect(find.text('86 Stock'), findsOneWidget);
      expect(find.text('Payouts'), findsOneWidget);
      expect(find.text('Issues'), findsOneWidget);
      expect(find.text('Catering'), findsOneWidget);
      expect(find.text('Settings'), findsOneWidget);

      // 3. Verify 3-Column Kanban Board
      expect(find.text('Incoming Orders'), findsOneWidget);
      expect(find.text('In Packing'), findsOneWidget);
      expect(find.text('Ready for Driver'), findsOneWidget);

      // 4. Verify Active Order Cards
      expect(find.text('Order #8492'), findsOneWidget);
      expect(find.text('Accept Order'), findsOneWidget);
      expect(find.text('Order #8489'), findsOneWidget);
      expect(find.text('Order #8485'), findsOneWidget);
      expect(find.text('5821'), findsOneWidget);
      expect(find.text('Hand Over to Driver'), findsOneWidget);
    });

    testWidgets('accepting an order transitions it to In Packing', (tester) async {
      final repository = MockStoreOrdersRepository();

      await tester.binding.setSurfaceSize(const Size(1280, 800));

      await tester.pumpWidget(
        MaterialApp(
          builder: (context, child) => ShadTheme(
            data: ShadThemeData(
              colorScheme: const ShadGreenColorScheme.light(),
            ),
            child: child!,
          ),
          home: Scaffold(
            body: LiveOrdersBoardScreen(repository: repository),
          ),
        ),
      );

      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      // Order #8492 starts in Incoming
      expect(find.text('Order #8492'), findsOneWidget);
      expect(find.text('Accept Order'), findsOneWidget);

      // Tap Accept
      await tester.tap(find.text('Accept Order'));
      await tester.pump();
      await tester.pump(const Duration(milliseconds: 100));

      final orders = await repository.getOrders();
      final acceptedOrder = orders.firstWhere((o) => o.id == '8492');
      expect(acceptedOrder.status, StoreOrderStatus.inPacking);
    });
  });
}
