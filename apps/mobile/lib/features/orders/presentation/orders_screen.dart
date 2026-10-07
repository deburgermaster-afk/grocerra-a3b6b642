import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../data/sample_orders.dart';
import 'order_details_screen.dart';
import 'order_tracking_screen.dart';
import 'order_widgets.dart';

/// Figma `F1 · Orders` — the Orders shell tab.
///
/// `Active` / `Past` segmented control over a list of order cards. Active
/// cards carry a live ETA and a `Track order` button into tracking (`B9`);
/// every card opens order details. The floating tab bar is owned by
/// `HomeShell`, so the list pads its bottom by `AppInsets.tabBar`.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key, this.orders = sampleOrders});

  final List<Order> orders;

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  bool _showActive = true;

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final List<Order> visible = widget.orders
        .where((Order order) => order.status.isActive == _showActive)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListView(
        padding: EdgeInsets.fromLTRB(16, topInset, 16, AppInsets.tabBar),
        children: <Widget>[
          Text('Orders', style: Theme.of(context).textTheme.headlineMedium),
          const SizedBox(height: 17),
          _buildSegments(),
          const SizedBox(height: 20),
          if (visible.isEmpty)
            _EmptyOrders(active: _showActive)
          else
            for (final Order order in visible) ...<Widget>[
              _OrderCard(order: order),
              const SizedBox(height: 12),
            ],
        ],
      ),
    );
  }

  Widget _buildSegments() {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _Segment(
              label: 'Active',
              selected: _showActive,
              onTap: () => setState(() => _showActive = true),
            ),
          ),
          Expanded(
            child: _Segment(
              label: 'Past',
              selected: !_showActive,
              onTap: () => setState(() => _showActive = false),
            ),
          ),
        ],
      ),
    );
  }
}

class _Segment extends StatelessWidget {
  const _Segment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            height: 18 / 15,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.ink : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.order});

  final Order order;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        side: const BorderSide(color: AppColors.hairline),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () =>
            Navigator.of(context)
                .pushNamed(OrderDetailsScreen.routeName, arguments: order.id),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                children: <Widget>[
                  // Store thumb 48x48
                  Container(
                    width: 48,
                    height: 48,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: const Icon(
                      Icons.storefront,
                      size: 24,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          order.store,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          order.placedAt,
                          style: Theme.of(context).textTheme.bodySmall,
                        ),
                      ],
                    ),
                  ),
                  OrderStatusPill(status: order.status),
                ],
              ),
              const SizedBox(height: 12),
              Text(
                order.itemSummary,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 12),
              // Wraps the ETA under the total at large text sizes.
              SizedBox(
                width: double.infinity,
                child: Wrap(
                  alignment: WrapAlignment.spaceBetween,
                  runSpacing: 4,
                  children: <Widget>[
                    Text(
                      '${order.itemCountLabel} · ${formatPrice(order.total)}',
                      style: const TextStyle(
                        fontSize: 14,
                        height: 17 / 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    if (order.status.isActive && order.etaMinutes != null)
                      Text(
                        'Arriving in ${order.etaMinutes} min',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 17 / 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentDark,
                        ),
                      ),
                  ],
                ),
              ),
              if (order.status.isActive) ...<Widget>[
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: FilledButton(
                    style: FilledButton.styleFrom(
                      minimumSize: const Size.fromHeight(44),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed(
                      OrderTrackingScreen.routeName,
                      arguments: order.id,
                    ),
                    child: const Text('Track order'),
                  ),
                ),
              ] else if (order.status == OrderStatus.delivered) ...<Widget>[
                const SizedBox(height: 12),
                SizedBox(
                  height: 44,
                  width: double.infinity,
                  child: OutlinedButton(
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.ink,
                      side: const BorderSide(color: AppColors.hairline),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(22),
                      ),
                      textStyle: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    onPressed: () => Navigator.of(context).pushNamed('/cart'),
                    child: const Text('Reorder'),
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _EmptyOrders extends StatelessWidget {
  const _EmptyOrders({required this.active});

  final bool active;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 64),
      child: Column(
        children: <Widget>[
          Container(
            width: 72,
            height: 72,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.receipt_long_outlined,
              size: 32,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            active ? 'No active orders' : 'No past orders yet',
            style: Theme.of(context).textTheme.titleLarge,
          ),
          const SizedBox(height: 8),
          Text(
            active
                ? 'Orders you place will show up here while they are on the way.'
                : 'Your delivered and cancelled orders will appear here.',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
