import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../data/sample_orders.dart';
import 'order_details_screen.dart';

/// Figma `B9 · Tracking` — live delivery tracking for an active order.
///
/// A route map fills the top of the screen with the courier between the
/// store and the drop-off; the sheet below carries the ETA, progress, the
/// courier and a link to order details. The map is a drawn placeholder
/// until the maps SDK and dispatch Realtime feed are wired in.
class OrderTrackingScreen extends StatelessWidget {
  const OrderTrackingScreen({super.key, required this.order});

  static const String routeName = '/orders/tracking';

  final Order order;

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: <Widget>[
          Expanded(
            child: Stack(
              children: <Widget>[
                const Positioned.fill(child: _RouteMap()),
                Positioned(
                  top: topInset + 6,
                  left: 16,
                  child: DecoratedBox(
                    decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: AppShadows.e1,
                    ),
                    child: Material(
                      color: AppColors.surface,
                      shape: const CircleBorder(),
                      child: IconButton(
                        tooltip: 'Back',
                        icon: const Icon(
                          Icons.arrow_back,
                          color: AppColors.ink,
                        ),
                        onPressed: () => Navigator.of(context).maybePop(),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          _buildSheet(context),
        ],
      ),
    );
  }

  Widget _buildSheet(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(AppRadius.xxl),
        ),
        boxShadow: AppShadows.e2,
      ),
      padding: EdgeInsets.fromLTRB(
        16,
        20,
        16,
        16 + MediaQuery.of(context).padding.bottom,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            order.status == OrderStatus.delivered
                ? 'Delivered'
                : order.etaMinutes != null
                ? 'Arriving in ${order.etaMinutes} min'
                : order.status.label,
            style: text.headlineSmall,
          ),
          const SizedBox(height: 4),
          Text(switch (order.status) {
            OrderStatus.placed => '${order.store} has your order',
            OrderStatus.packing => '${order.store} is packing your order',
            OrderStatus.onTheWay => 'On the way from ${order.store}',
            OrderStatus.delivered => 'Left at ${order.address}',
            OrderStatus.cancelled => 'This order was cancelled',
          }, style: text.bodySmall),
          if (order.status != OrderStatus.cancelled) ...<Widget>[
            const SizedBox(height: 16),
            OrderProgressBar(status: order.status),
          ],
          if (order.courierName case final String courier) ...<Widget>[
            const SizedBox(height: 20),
            _buildCourier(context, courier),
          ],
          const SizedBox(height: 12),
          const Divider(),
          InkWell(
            onTap: () => Navigator.of(context)
                .pushNamed(OrderDetailsScreen.routeName, arguments: order.id),
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 14),
              child: Row(
                children: <Widget>[
                  const Icon(
                    Icons.receipt_long_outlined,
                    size: 22,
                    color: AppColors.ink,
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Text(
                      'Order ${order.id} · ${order.itemCountLabel} · '
                      '${formatPrice(order.total)}',
                      style: const TextStyle(
                        fontSize: 15,
                        height: 18 / 15,
                        fontWeight: FontWeight.w500,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.chevron_right,
                    size: 20,
                    color: AppColors.ink,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCourier(BuildContext context, String courier) {
    void comingSoon(String what) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('$what your courier is coming soon')),
      );
    }

    return Row(
      children: <Widget>[
        Container(
          width: 48,
          height: 48,
          decoration: const BoxDecoration(
            color: AppColors.surfaceAlt,
            shape: BoxShape.circle,
          ),
          alignment: Alignment.center,
          child: Text(
            courier.characters.first,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(courier, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(height: 2),
              Text(
                'Your courier',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
        ),
        RoundIconButton(
          icon: Icons.chat_bubble_outline,
          iconSize: 20,
          tooltip: 'Message courier',
          onTap: () => comingSoon('Messaging'),
        ),
        const SizedBox(width: 8),
        RoundIconButton(
          icon: Icons.call_outlined,
          iconSize: 20,
          filled: true,
          tooltip: 'Call courier',
          onTap: () => comingSoon('Calling'),
        ),
      ],
    );
  }
}

/// Stylised map: street grid, the route from store to home and the courier
/// part-way along it.
class _RouteMap extends StatelessWidget {
  const _RouteMap();

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints constraints) {
        final Size size = constraints.biggest;
        final Offset store = Offset(size.width * 0.2, size.height * 0.78);
        final Offset home = Offset(size.width * 0.8, size.height * 0.3);
        final Offset courier = Offset(size.width * 0.5, size.height * 0.52);

        return Stack(
          children: <Widget>[
            Positioned.fill(
              child: CustomPaint(
                painter: _MapPainter(
                  store: store,
                  courier: courier,
                  home: home,
                ),
              ),
            ),
            _pin(store, Icons.storefront, AppColors.ink, 'Store'),
            _pin(home, Icons.home_rounded, AppColors.ink, 'Home'),
            _pin(courier, Icons.delivery_dining, AppColors.accent, 'Courier'),
          ],
        );
      },
    );
  }

  Widget _pin(Offset at, IconData icon, Color color, String label) {
    const double size = 40;
    return Positioned(
      left: at.dx - size / 2,
      top: at.dy - size / 2,
      child: Semantics(
        label: label,
        child: Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            border: Border.all(color: AppColors.surface, width: 3),
            boxShadow: AppShadows.e1,
          ),
          child: Icon(icon, size: 20, color: AppColors.surface),
        ),
      ),
    );
  }
}

class _MapPainter extends CustomPainter {
  const _MapPainter({
    required this.store,
    required this.courier,
    required this.home,
  });

  final Offset store;
  final Offset courier;
  final Offset home;

  @override
  void paint(Canvas canvas, Size size) {
    canvas.drawRect(
      Offset.zero & size,
      Paint()..color = const Color(0xFFEFEFEC),
    );

    final Paint street = Paint()
      ..color = AppColors.surface
      ..strokeWidth = 10;
    for (double x = 30; x < size.width; x += 90) {
      canvas.drawLine(Offset(x, 0), Offset(x + 40, size.height), street);
    }
    for (double y = 40; y < size.height; y += 80) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y - 20), street);
    }

    // The leg already driven is muted; the remaining leg is the accent.
    final Path driven = Path()
      ..moveTo(store.dx, store.dy)
      ..lineTo(store.dx, courier.dy)
      ..lineTo(courier.dx, courier.dy);
    final Path remaining = Path()
      ..moveTo(courier.dx, courier.dy)
      ..lineTo(home.dx, courier.dy)
      ..lineTo(home.dx, home.dy);
    final Paint route = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 5
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(driven, route..color = const Color(0xFFB5B5B5));
    canvas.drawPath(remaining, route..color = AppColors.accent);
  }

  @override
  bool shouldRepaint(_MapPainter oldDelegate) =>
      oldDelegate.store != store ||
      oldDelegate.courier != courier ||
      oldDelegate.home != home;
}
