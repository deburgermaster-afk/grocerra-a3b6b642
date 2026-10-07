import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:grocerra_customer/core/theme/app_theme.dart';
import 'package:grocerra_customer/features/orders/data/sample_orders.dart';
import 'package:grocerra_customer/features/orders/presentation/order_details_screen.dart';
import 'package:grocerra_customer/features/orders/presentation/order_tracking_screen.dart';
import 'package:grocerra_customer/features/orders/presentation/orders_routes.dart';
import 'package:grocerra_customer/features/orders/presentation/orders_screen.dart';

/// Hosts the Orders tab with the routes it pushes, on a phone-sized surface.
Future<void> pumpOrders(WidgetTester tester, {List<Order>? orders}) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(
    MaterialApp(
      theme: AppTheme.light(),
      home: orders == null
          ? const OrdersScreen()
          : OrdersScreen(orders: orders),
      routes: ordersRoutes,
    ),
  );
}

void main() {
  // Measure with the bundled Inter rather than the test font's square
  // glyphs, so layout overflows reflect what users actually see.
  setUpAll(() async {
    final FontLoader loader = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'));
    await loader.load();
  });

  group('Order totals', () {
    test('short-weight meat is refunded pro rata', () {
      const OrderItem goat = OrderItem(
        name: 'Goat Curry Cut',
        detail: 'Curry cut',
        quantity: 1,
        price: 1699,
        estimatedKg: 1.0,
        actualKg: 0.94,
      );
      // 6% under the estimate of $16.99.
      expect(goat.weightRefund, 102);
    });

    test('heavier-than-estimated or unweighed items are not refunded', () {
      const OrderItem heavy = OrderItem(
        name: 'Chicken',
        detail: '',
        quantity: 1,
        price: 2100,
        estimatedKg: 2.0,
        actualKg: 2.1,
      );
      const OrderItem rice = OrderItem(
        name: 'Rice',
        detail: '',
        quantity: 1,
        price: 1599,
      );
      expect(heavy.weightRefund, 0);
      expect(rice.weightRefund, 0);
    });

    test('total is subtotal plus fees minus refund', () {
      final Order order = sampleOrders.first;
      expect(
        order.total,
        order.subtotal +
            order.deliveryFee +
            order.serviceFee -
            order.weightRefund,
      );
      expect(formatPrice(order.total), r'$60.45');
    });

    test('formatPrice pads cents', () {
      expect(formatPrice(5), r'$0.05');
      expect(formatPrice(1200), r'$12.00');
    });
  });

  testWidgets('Active shows in-progress orders with Track order', (
    WidgetTester tester,
  ) async {
    await pumpOrders(tester);

    expect(find.text('Orders'), findsOneWidget);
    expect(find.text('Arriving in 14 min'), findsOneWidget);
    expect(find.text('Track order'), findsOneWidget);
    expect(find.text('Delivered'), findsNothing);
  });

  testWidgets('Past shows delivered and cancelled orders', (
    WidgetTester tester,
  ) async {
    await pumpOrders(tester);

    await tester.tap(find.text('Past'));
    await tester.pump();

    expect(find.text('Delivered'), findsOneWidget);
    expect(find.text('Cancelled'), findsOneWidget);
    expect(find.text('Reorder'), findsOneWidget);
    expect(find.text(r'1 item · $22.48'), findsOneWidget);
    expect(find.text('Track order'), findsNothing);
  });

  testWidgets('empty segment shows the empty state', (
    WidgetTester tester,
  ) async {
    await pumpOrders(tester, orders: const <Order>[]);

    expect(find.text('No active orders'), findsOneWidget);
  });

  testWidgets('tapping a card opens its details with the weight refund', (
    WidgetTester tester,
  ) async {
    await pumpOrders(tester);

    await tester.tap(find.text('Madina Halal Meats'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderDetailsScreen), findsOneWidget);
    expect(find.text('Order GR-10482'), findsOneWidget);
    expect(find.text('Est. 1.00 kg · Packed 0.94 kg'), findsOneWidget);
    expect(find.text('Weight adjustment refund'), findsOneWidget);
  });

  testWidgets('Track order opens live tracking for that order', (
    WidgetTester tester,
  ) async {
    await pumpOrders(tester);

    await tester.tap(find.text('Track order'));
    await tester.pumpAndSettle();

    expect(find.byType(OrderTrackingScreen), findsOneWidget);
    expect(find.text('Imran'), findsOneWidget);
    expect(find.text('Order GR-10482 · 3 items · \$60.45'), findsOneWidget);

    await tester.tap(find.byTooltip('Back'));
    await tester.pumpAndSettle();
    expect(find.byType(OrdersScreen), findsOneWidget);
  });
}
