import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/models/store_order.dart';
import '../data/repositories/store_orders_repository.dart';
import 'widgets/incoming_order_card.dart';
import 'widgets/in_packing_card.dart';
import 'widgets/ready_for_driver_card.dart';

class LiveOrdersBoardScreen extends StatefulWidget {
  final StoreOrdersRepository repository;
  final VoidCallback? onOpenPackingStation;

  const LiveOrdersBoardScreen({
    super.key,
    required this.repository,
    this.onOpenPackingStation,
  });

  @override
  State<LiveOrdersBoardScreen> createState() => _LiveOrdersBoardScreenState();
}

class _LiveOrdersBoardScreenState extends State<LiveOrdersBoardScreen> {
  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StoreOrder>>(
      stream: widget.repository.watchOrders(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? [];
        final incomingOrders = orders
            .where((o) => o.status == StoreOrderStatus.incoming)
            .toList();
        final inPackingOrders = orders
            .where((o) => o.status == StoreOrderStatus.inPacking)
            .toList();
        final readyOrders = orders
            .where((o) => o.status == StoreOrderStatus.readyForDriver)
            .toList();

        return LayoutBuilder(
          builder: (context, constraints) {
            final isTablet = constraints.maxWidth >= 900;

            if (isTablet) {
              return Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Column 1: Incoming
                  Expanded(
                    child: _buildColumn(
                      title: 'Incoming Orders',
                      count: incomingOrders.length,
                      badgeColor: const Color(0xFFDC2626),
                      orders: incomingOrders,
                      childBuilder: (order) => IncomingOrderCard(
                        order: order,
                        onAccept: () async {
                          await widget.repository.acceptOrder(order.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${order.id} accepted! Moved to Packing.'),
                                backgroundColor: AppColors.accent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        onDecline: (reason) async {
                          await widget.repository.declineOrder(order.id, reason);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${order.id} declined ($reason).'),
                                backgroundColor: AppColors.danger,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        onAddBuffer: () async {
                          await widget.repository.acceptOrder(order.id, prepBufferMinutes: 10);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${order.id} accepted with +10m prep buffer.'),
                                backgroundColor: const Color(0xFFD97706),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                      emptyText: 'No incoming orders right now',
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Column 2: In Packing
                  Expanded(
                    child: _buildColumn(
                      title: 'In Packing',
                      count: inPackingOrders.length,
                      badgeColor: const Color(0xFF2563EB),
                      orders: inPackingOrders,
                      childBuilder: (order) => InPackingCard(
                        order: order,
                        onOpenPacking: () {
                          if (widget.onOpenPackingStation != null) {
                            widget.onOpenPackingStation!();
                          } else {
                            Navigator.of(context).pushNamed('/store/packing', arguments: order.id);
                          }
                        },
                      ),
                      emptyText: 'No orders currently being packed',
                    ),
                  ),
                  const SizedBox(width: 16),

                  // Column 3: Ready for Driver
                  Expanded(
                    child: _buildColumn(
                      title: 'Ready for Driver',
                      count: readyOrders.length,
                      badgeColor: const Color(0xFF059669),
                      orders: readyOrders,
                      childBuilder: (order) => ReadyForDriverCard(
                        order: order,
                        onHandover: () async {
                          await widget.repository.handoverToCourier(order.id);
                          if (context.mounted) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Order #${order.id} handed over to courier. Order complete!'),
                                backgroundColor: AppColors.accent,
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                      ),
                      emptyText: 'No bags waiting for driver pickup',
                    ),
                  ),
                ],
              );
            } else {
              // Narrow/mobile fallback: tab or vertical scroll
              return ListView(
                padding: const EdgeInsets.only(bottom: 24),
                children: [
                  _buildSectionHeader('Incoming Orders', incomingOrders.length, const Color(0xFFDC2626)),
                  ...incomingOrders.map((o) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: IncomingOrderCard(
                          order: o,
                          onAccept: () => widget.repository.acceptOrder(o.id),
                          onDecline: (r) => widget.repository.declineOrder(o.id, r),
                          onAddBuffer: () => widget.repository.acceptOrder(o.id, prepBufferMinutes: 10),
                        ),
                      )),
                  const SizedBox(height: 16),
                  _buildSectionHeader('In Packing', inPackingOrders.length, const Color(0xFF2563EB)),
                  ...inPackingOrders.map((o) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: InPackingCard(
                          order: o,
                          onOpenPacking: () => Navigator.of(context).pushNamed('/store/packing'),
                        ),
                      )),
                  const SizedBox(height: 16),
                  _buildSectionHeader('Ready for Driver', readyOrders.length, const Color(0xFF059669)),
                  ...readyOrders.map((o) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: ReadyForDriverCard(
                          order: o,
                          onHandover: () => widget.repository.handoverToCourier(o.id),
                        ),
                      )),
                ],
              );
            }
          },
        );
      },
    );
  }

  Widget _buildColumn({
    required String title,
    required int count,
    required Color badgeColor,
    required List<StoreOrder> orders,
    required Widget Function(StoreOrder) childBuilder,
    required String emptyText,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF1F2F4),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Column Header
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                    decoration: BoxDecoration(
                      color: badgeColor.withValues(alpha: 0.12),
                      borderRadius: BorderRadius.circular(999),
                    ),
                    child: Text(
                      '$count',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: badgeColor,
                      ),
                    ),
                  ),
                ],
              ),
              const Icon(Icons.more_horiz, size: 20, color: AppColors.inkMuted),
            ],
          ),
          const SizedBox(height: 14),

          // Cards list
          Expanded(
            child: orders.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.inbox_outlined, size: 40, color: Colors.grey.shade400),
                          const SizedBox(height: 10),
                          Text(
                            emptyText,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 12.5,
                              fontWeight: FontWeight.w500,
                              color: Colors.grey.shade600,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    itemCount: orders.length,
                    separatorBuilder: (_, _) => const SizedBox(height: 14),
                    itemBuilder: (context, index) => childBuilder(orders[index]),
                  ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, int count, Color badgeColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Text(title, style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          const SizedBox(width: 8),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: badgeColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text('$count', style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: badgeColor)),
          ),
        ],
      ),
    );
  }
}
