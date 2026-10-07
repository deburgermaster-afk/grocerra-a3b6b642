import 'package:flutter/material.dart';

import '../../../core/models/order_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import 'tracking_screen.dart';

/// Screen #41: Orders
/// Shows active ongoing orders with glowing live radar cards, pending catering quote requests,
/// and past order history with re-order shortcuts.
class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  final List<OrderModel> _activeOrders = <OrderModel>[
    OrderModel(
      id: 'ord-9821',
      orderNumber: '9821',
      storeName: 'Madina Halal Meats',
      storeImageUrl:
          'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=600&q=80',
      status: OrderStatus.dispatched,
      placedAt: DateTime.now().subtract(const Duration(minutes: 25)),
      deliveryAddress: '24 Maple Street, Apt 3B, Coburg',
      subtotalCents: 4799,
      deliveryFeeCents: 450,
      platformFeeCents: 150,
      totalCents: 5399, // $53.99 AUD
      items: const <OrderItemModel>[
        OrderItemModel(
          productId: 'prod_1',
          name: 'Fresh Halal Baby Goat (Curry Cut)',
          variantLabel: '1 kg',
          quantity: 1,
          unitPriceCents: 2499,
          finalWeightGrams: 1040,
          isCatchWeight: true,
        ),
        OrderItemModel(
          productId: 'prod_2',
          name: 'Halal Skinless Chicken Breast Fillets',
          variantLabel: '1 kg Tray',
          quantity: 1,
          unitPriceCents: 1450,
          finalWeightGrams: 980,
          isCatchWeight: true,
        ),
      ],
      deliveryEtaMinutes: 15,
      driverName: 'Tariq M.',
      driverPhone: '+61 411 889 922',
      courierPartner: 'Uber Direct',
    ),
  ];

  final List<OrderModel> _pastOrders = <OrderModel>[
    OrderModel(
      id: 'ord-9104',
      orderNumber: '9104',
      storeName: 'Dhaka Fresh Grocers',
      storeImageUrl:
          'https://images.unsplash.com/photo-1542838132-92c53300491e?w=600&q=80',
      status: OrderStatus.delivered,
      placedAt: DateTime.now().subtract(const Duration(days: 3)),
      deliveryAddress: '24 Maple Street, Apt 3B, Coburg',
      subtotalCents: 3848,
      deliveryFeeCents: 500,
      platformFeeCents: 120,
      totalCents: 4468,
      items: const <OrderItemModel>[
        OrderItemModel(
          productId: 'prod_3',
          name: 'Daawat Ultima Extra Long Basmati Rice',
          variantLabel: '5 kg Bag',
          quantity: 1,
          unitPriceCents: 1899,
        ),
        OrderItemModel(
          productId: 'prod_4',
          name: 'Shan Special Bombay Biryani Masala',
          variantLabel: '50g Box',
          quantity: 2,
          unitPriceCents: 249,
        ),
      ],
      deliveryEtaMinutes: 0,
      driverName: 'Kamal R.',
      courierPartner: 'DoorDash Drive',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Your Orders',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: <Widget>[
          // Active Orders Section
          if (_activeOrders.isNotEmpty) ...<Widget>[
            Row(
              children: const <Widget>[
                PulseGlowDot(
                  color: Color(0xFF10B981),
                  size: 8,
                  rippleRadius: 18,
                ),
                SizedBox(width: 8),
                Text(
                  'Active Delivery en Route',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.3,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            ..._activeOrders.map((OrderModel order) {
              return _ActiveOrderCard(order: order);
            }),
            const SizedBox(height: 24),
          ],

          // Catering Inquiries Section
          Row(
            children: const <Widget>[
              Icon(
                Icons.celebration_rounded,
                size: 18,
                color: AppColors.ink,
              ),
              SizedBox(width: 8),
              Text(
                'Catering Requests',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.3,
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          _CateringRequestCard(),

          const SizedBox(height: 24),

          // Past Orders History
          const Text(
            'Order History',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 10),
          ..._pastOrders.map((OrderModel order) {
            return _PastOrderCard(order: order);
          }),
        ],
      ),
    );
  }
}

class _ActiveOrderCard extends StatelessWidget {
  const _ActiveOrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      onTap: () {
        Navigator.of(context).push(
          MaterialPageRoute<void>(
            builder: (_) => TrackingScreen(order: order),
          ),
        );
      },
      borderRadius: 22,
      borderWidth: 1.4,
      glowColor: const Color(0xFF10B981),
      backgroundColor: const Color(0xFF0F172A),
      enableBorderGlow: true,
      enableAmbientShadow: true,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Row(
                children: <Widget>[
                  const GlowRing(
                    size: 44,
                    strokeWidth: 2.8,
                    glowColor: Color(0xFF10B981),
                    secondaryColor: Color(0xFF064E3B),
                    child: Icon(
                      Icons.electric_bolt_rounded,
                      color: Color(0xFF34D399),
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        order.storeName,
                        style: const TextStyle(
                          fontWeight: FontWeight.w800,
                          fontSize: 16,
                          color: Colors.white,
                          letterSpacing: -0.3,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Order #${order.orderNumber} • ${order.courierPartner}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const GlowBadge(
                label: 'DISPATCHED',
                showPulseDot: true,
                glowColor: Color(0xFF10B981),
                backgroundColor: Color(0x3310B981),
                textColor: Color(0xFF34D399),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text(
                '${order.items.length} items • ${order.formattedTotal}',
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: Colors.white,
                ),
              ),
              Row(
                children: <Widget>[
                  const Icon(
                    Icons.access_time_filled_rounded,
                    size: 13,
                    color: Color(0xFF34D399),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'ETA: ${order.deliveryEtaMinutes} mins',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF34D399),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          GlowButton(
            label: 'Track Order in Real-Time',
            icon: Icons.navigation_rounded,
            glowColor: const Color(0xFF10B981),
            backgroundColor: const Color(0xFF10B981),
            textColor: Colors.white,
            height: 46,
            borderRadius: 14,
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute<void>(
                  builder: (_) => TrackingScreen(order: order),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

class _CateringRequestCard extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GlowCard(
      borderRadius: 18,
      borderWidth: 1.0,
      glowColor: const Color(0xFF38BDF8),
      backgroundColor: Colors.white,
      enableBorderGlow: false,
      enableAmbientShadow: true,
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const <Widget>[
              Text(
                'Eid Ul-Fitr Family Feast (40 Guests)',
                style: TextStyle(
                  fontWeight: FontWeight.w800,
                  fontSize: 14,
                  color: AppColors.ink,
                  letterSpacing: -0.2,
                ),
              ),
              SizedBox(height: 4),
              Text(
                'Date: Nov 15, 2026 • Coburg Town Hall',
                style: TextStyle(fontSize: 12, color: Color(0xFF64748B)),
              ),
            ],
          ),
          const GlowBadge(
            label: 'QUOTE SENT',
            glowColor: Color(0xFF38BDF8),
            backgroundColor: Color(0xFFE0F2FE),
            textColor: Color(0xFF0284C7),
          ),
        ],
      ),
    );
  }
}

class _PastOrderCard extends StatelessWidget {
  const _PastOrderCard({required this.order});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: GlowCard(
        borderRadius: 18,
        borderWidth: 1.0,
        glowColor: const Color(0xFF10B981),
        backgroundColor: Colors.white,
        enableBorderGlow: false,
        enableAmbientShadow: true,
        padding: const EdgeInsets.all(14),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Image.network(
                order.storeImageUrl,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) => Container(
                  width: 52,
                  height: 52,
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.receipt_long_rounded,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    order.storeName,
                    style: const TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 15,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    '${order.items.length} items • ${order.formattedTotal}',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              ),
            ),
            ScalePressable(
              onTap: () {
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                      'Reordering items from ${order.storeName}...',
                    ),
                    backgroundColor: AppColors.accentDark,
                  ),
                );
              },
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Text(
                  'Reorder',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                    fontSize: 12,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
