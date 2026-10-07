import 'package:flutter/material.dart';

import '../../../core/models/order_models.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';

/// Screen #16: Live Delivery Tracking
/// Upgraded with Code & Chill inspired glowing animations:
/// - Rotating & breathing GlowRing Live GPS Radar over map route
/// - Glowing driver info card with proxy call action
/// - PulseGlowDot radar indicators along the 5-stage delivery stepper
/// - Catch-weight scale settlement confirmation
class TrackingScreen extends StatelessWidget {
  const TrackingScreen({required this.order, super.key});

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: Text(
          'Live Tracking #${order.orderNumber}',
          style: const TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.4,
          ),
        ),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.help_outline_rounded),
            onPressed: () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Grocerra Melbourne Support: 1300 GROCERRA'),
                ),
              );
            },
          ),
        ],
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 40),
        children: <Widget>[
          // Map Visual Card with Animated Glowing Radar Ring
          Container(
            height: 220,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: BorderRadius.circular(22),
              image: const DecorationImage(
                image: NetworkImage(
                  'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=800&q=80',
                ),
                fit: BoxFit.cover,
              ),
              boxShadow: const <BoxShadow>[
                BoxShadow(
                  color: Color(0x14000000),
                  blurRadius: 14,
                  offset: Offset(0, 4),
                ),
              ],
            ),
            child: Stack(
              alignment: Alignment.center,
              children: <Widget>[
                // Dark Tint Gradient Overlay
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(22),
                    gradient: LinearGradient(
                      colors: <Color>[
                        Colors.black.withValues(alpha: 0.65),
                        Colors.black.withValues(alpha: 0.25),
                        Colors.black.withValues(alpha: 0.7),
                      ],
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                    ),
                  ),
                ),

                // Signature Rotating & Breathing Glowing Radar Ring on Driver Position
                Center(
                  child: GlowRing(
                    size: 80,
                    strokeWidth: 3.5,
                    glowColor: const Color(0xFF10B981),
                    secondaryColor: const Color(0xFF064E3B),
                    child: Container(
                      padding: const EdgeInsets.all(10),
                      decoration: const BoxDecoration(
                        color: Color(0xFF0F172A),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.navigation_rounded,
                        color: Color(0xFF34D399),
                        size: 26,
                      ),
                    ),
                  ),
                ),

                // Top Live Badge
                Positioned(
                  top: 14,
                  left: 14,
                  child: const GlowBadge(
                    label: 'LIVE GPS DISPATCH',
                    showPulseDot: true,
                    glowColor: Color(0xFF10B981),
                    backgroundColor: Color(0xCC0F172A),
                    textColor: Colors.white,
                  ),
                ),

                // Bottom ETA Pill with glowing neon border
                Positioned(
                  bottom: 14,
                  left: 14,
                  right: 14,
                  child: GlowCard(
                    borderRadius: 16,
                    borderWidth: 1.2,
                    glowColor: const Color(0xFF10B981),
                    backgroundColor: Colors.black.withValues(alpha: 0.85),
                    enableBorderGlow: true,
                    enableAmbientShadow: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 10,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            const Icon(
                              Icons.directions_car_filled_rounded,
                              color: Color(0xFF34D399),
                              size: 20,
                            ),
                            const SizedBox(width: 8),
                            Text(
                              'Arriving in ${order.deliveryEtaMinutes} mins',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                        Text(
                          order.courierPartner,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Courier & Driver Details Card
          GlowCard(
            borderRadius: 20,
            borderWidth: 1.0,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                Container(
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: const Color(0xFF10B981).withValues(alpha: 0.12),
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: const Color(0xFF10B981).withValues(alpha: 0.3),
                    ),
                  ),
                  child: const Center(
                    child: Icon(
                      Icons.person_rounded,
                      color: AppColors.accentDark,
                      size: 28,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        order.driverName,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.2,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Assigned Courier · ${order.courierProvider}',
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
                          'Calling driver ${order.driverPhone} via secure proxy...',
                        ),
                        duration: const Duration(seconds: 2),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: const Color(0xFF0F172A),
                      shape: BoxShape.circle,
                      boxShadow: <BoxShadow>[
                        BoxShadow(
                          color: const Color(0xFF10B981).withValues(alpha: 0.25),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.phone_rounded,
                      color: Color(0xFF34D399),
                      size: 20,
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Status Stepper Card
          GlowCard(
            borderRadius: 20,
            borderWidth: 1.0,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Order Lifecycle',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 18),
                _StepRow(
                  title: 'Order Placed & Authorized',
                  subtitle: 'Confirmed & received by store',
                  isDone: true,
                  isCurrent: false,
                ),
                _StepDivider(),
                _StepRow(
                  title: 'Store Accepted',
                  subtitle: '${order.storeName} accepted order',
                  isDone: true,
                  isCurrent: false,
                ),
                _StepDivider(),
                _StepRow(
                  title: 'Halal Preparation & Scale Weighing',
                  subtitle: 'Catch-weights recorded; precise amount captured',
                  isDone: true,
                  isCurrent: false,
                ),
                _StepDivider(),
                _StepRow(
                  title: 'Courier Dispatched & En Route',
                  subtitle: 'Driver picked up order via ${order.courierProvider}',
                  isDone: false,
                  isCurrent: true,
                ),
                _StepDivider(),
                _StepRow(
                  title: 'Delivered',
                  subtitle: order.deliveryAddress,
                  isDone: false,
                  isCurrent: false,
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Items in Order
          GlowCard(
            borderRadius: 20,
            borderWidth: 1.0,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(18),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  'Items from ${order.storeName}',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: AppColors.ink,
                    letterSpacing: -0.3,
                  ),
                ),
                const SizedBox(height: 12),
                ...order.items.map((OrderItemModel item) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 6),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                '${item.quantity}x ${item.productName}',
                                style: const TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 14,
                                  color: AppColors.ink,
                                ),
                              ),
                              Text(
                                item.variantLabel,
                                style: TextStyle(
                                  fontSize: 12,
                                  color: Colors.grey.shade600,
                                ),
                              ),
                            ],
                          ),
                        ),
                        Text(
                          item.formattedTotal,
                          style: const TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                  );
                }),
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total Paid',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      order.formattedTotal,
                      style: const TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _StepRow extends StatelessWidget {
  const _StepRow({
    required this.title,
    required this.subtitle,
    required this.isDone,
    required this.isCurrent,
  });

  final String title;
  final String subtitle;
  final bool isDone;
  final bool isCurrent;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Indicator
        if (isCurrent)
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 12),
            child: PulseGlowDot(
              color: Color(0xFF10B981),
              size: 10,
              rippleRadius: 22,
            ),
          )
        else
          Container(
            margin: const EdgeInsets.only(top: 2, right: 12),
            width: 20,
            height: 20,
            decoration: BoxDecoration(
              color: isDone ? AppColors.accentDark : const Color(0xFFE2E8F0),
              shape: BoxShape.circle,
            ),
            child: isDone
                ? const Icon(Icons.check, size: 13, color: Colors.white)
                : null,
          ),

        // Text
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: isCurrent ? FontWeight.w800 : FontWeight.w700,
                  color: isCurrent ? AppColors.accentDark : AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: TextStyle(
                  fontSize: 12,
                  color: isCurrent
                      ? const Color(0xFF047857)
                      : Colors.grey.shade600,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _StepDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(left: 9.5, top: 2, bottom: 2),
      width: 2,
      height: 22,
      color: const Color(0xFFE2E8F0),
    );
  }
}
