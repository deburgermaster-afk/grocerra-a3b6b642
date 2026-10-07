import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../data/sample_orders.dart';
import 'order_tracking_screen.dart';
import 'order_widgets.dart';

/// Order details, pushed from an `F1 · Orders` card.
///
/// Status timeline, items (with packed vs estimated weight for meat sold by
/// the kilo), totals including the short-weight refund, the delivery address
/// and the order actions. Takes the order id as the route argument.
class OrderDetailsScreen extends StatelessWidget {
  const OrderDetailsScreen({super.key, required this.order});

  static const String routeName = '/orders/details';

  final Order order;

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListView(
        padding: EdgeInsets.fromLTRB(0, topInset, 0, 32),
        children: <Widget>[
          OrderBackHeader(title: 'Order ${order.id}'),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
            child: Text(
              '${order.store} · ${order.placedAt}',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ),
          _buildStatus(context),
          const OrderSectionBreak(),
          _buildItems(context),
          const OrderSectionBreak(),
          _buildTotals(context),
          const OrderSectionBreak(),
          _buildAddress(context),
          _buildActions(context),
        ],
      ),
    );
  }

  Widget _buildStatus(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: Text(switch (order.status) {
                  OrderStatus.onTheWay when order.etaMinutes != null =>
                    'Arriving in ${order.etaMinutes} min',
                  _ => order.status.label,
                }, style: Theme.of(context).textTheme.titleLarge),
              ),
              OrderStatusPill(status: order.status),
            ],
          ),
          if (order.status != OrderStatus.cancelled) ...<Widget>[
            const SizedBox(height: 16),
            OrderProgressBar(status: order.status),
          ],
        ],
      ),
    );
  }

  Widget _buildItems(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
            child: Text(
              order.itemCountLabel,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          for (int i = 0; i < order.items.length; i++) ...<Widget>[
            if (i > 0) const OrderDivider(),
            _ItemRow(item: order.items[i]),
          ],
        ],
      ),
    );
  }

  Widget _buildTotals(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: <Widget>[
          _TotalRow(label: 'Subtotal', value: formatPrice(order.subtotal)),
          _TotalRow(
            label: 'Delivery fee',
            value: formatPrice(order.deliveryFee),
          ),
          _TotalRow(label: 'Service fee', value: formatPrice(order.serviceFee)),
          if (order.weightRefund > 0)
            _TotalRow(
              label: 'Weight adjustment refund',
              value: '−${formatPrice(order.weightRefund)}',
              color: AppColors.accentDark,
            ),
          const SizedBox(height: 4),
          const Divider(),
          const SizedBox(height: 12),
          _TotalRow(
            label: order.status == OrderStatus.cancelled ? 'Refunded' : 'Total',
            value: formatPrice(order.total),
            emphasised: true,
          ),
          if (order.weightRefund > 0) ...<Widget>[
            const SizedBox(height: 8),
            Text(
              'Meat is charged at its estimated weight and re-weighed when '
              'packed. Anything under the estimate goes back to your card.',
              style: Theme.of(context).textTheme.bodySmall,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildAddress(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: <Widget>[
          const Icon(
            Icons.location_on_outlined,
            size: 22,
            color: AppColors.ink,
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Delivery address',
                  style: Theme.of(context).textTheme.labelMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  order.address,
                  style: Theme.of(context).textTheme.bodyLarge,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildActions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: <Widget>[
          if (order.status.isActive) ...<Widget>[
            FilledButton(
              onPressed: () => Navigator.of(
                context,
              ).pushNamed(OrderTrackingScreen.routeName, arguments: order.id),
              child: const Text('Track order'),
            ),
            const SizedBox(height: 10),
          ] else if (order.status == OrderStatus.delivered) ...<Widget>[
            FilledButton(
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
              child: const Text('Reorder'),
            ),
            const SizedBox(height: 10),
          ],
          OutlinedButton(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              minimumSize: const Size.fromHeight(56),
              side: const BorderSide(color: AppColors.hairline),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(AppRadius.button),
              ),
              textStyle: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            // `E1 · Order issue` is not built yet; see support_routes.dart.
            onPressed: () => ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Order help is coming soon')),
            ),
            child: const Text('Get help with this order'),
          ),
        ],
      ),
    );
  }
}

/// Four-step progress bar: Order placed - Packing - On the way - Delivered.
class OrderProgressBar extends StatelessWidget {
  const OrderProgressBar({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final int current = OrderStatus.timeline.indexOf(status);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            for (int i = 0; i < OrderStatus.timeline.length; i++) ...<Widget>[
              if (i > 0) const SizedBox(width: 4),
              Expanded(
                child: Container(
                  height: 4,
                  decoration: BoxDecoration(
                    color: i <= current ? AppColors.accent : AppColors.hairline,
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
            ],
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            for (int i = 0; i < OrderStatus.timeline.length; i++)
              Expanded(
                child: Text(
                  OrderStatus.timeline[i].label,
                  textAlign: switch (i) {
                    0 => TextAlign.start,
                    3 => TextAlign.end,
                    _ => TextAlign.center,
                  },
                  style: TextStyle(
                    fontSize: 11,
                    height: 13 / 11,
                    fontWeight: i == current
                        ? FontWeight.w600
                        : FontWeight.w500,
                    color: i <= current ? AppColors.ink : AppColors.inkMuted,
                  ),
                ),
              ),
          ],
        ),
      ],
    );
  }
}

class _ItemRow extends StatelessWidget {
  const _ItemRow({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    final String detail = item.isWeighed
        ? 'Est. ${item.estimatedKg!.toStringAsFixed(2)} kg · '
              'Packed ${item.actualKg!.toStringAsFixed(2)} kg'
        : item.detail;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.md),
            ),
            alignment: Alignment.center,
            child: Text(
              '${item.quantity}×',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(detail, style: Theme.of(context).textTheme.bodySmall),
                if (item.weightRefund > 0) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    '${formatPrice(item.weightRefund)} refunded for weight',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 16 / 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.accentDark,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            formatPrice(item.price),
            style: Theme.of(context).textTheme.titleMedium,
          ),
        ],
      ),
    );
  }
}

class _TotalRow extends StatelessWidget {
  const _TotalRow({
    required this.label,
    required this.value,
    this.color = AppColors.ink,
    this.emphasised = false,
  });

  final String label;
  final String value;
  final Color color;
  final bool emphasised;

  @override
  Widget build(BuildContext context) {
    final TextStyle style = TextStyle(
      fontSize: emphasised ? 18 : 15,
      height: 1.2,
      fontWeight: emphasised ? FontWeight.w700 : FontWeight.w400,
      color: color,
    );
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: <Widget>[
          Expanded(child: Text(label, style: style)),
          Text(value, style: style),
        ],
      ),
    );
  }
}
