import 'package:flutter/material.dart';

import '../../../core/models/order_models.dart';
import '../../../core/widgets/glowing_effects.dart';
import '../../orders/presentation/tracking_screen.dart';

/// Screen #15: Order Confirmation / Success
/// Celebratory screen featuring:
/// - Rotating & breathing GlowRing victory badge
/// - Pre-authorized catch-weight hold receipt disclosure
/// - Dual courier dispatch details (Uber Direct / DoorDash Drive)
/// - Direct "Track Order in Real-Time" CTA
class OrderConfirmationScreen extends StatelessWidget {
  const OrderConfirmationScreen({
    super.key,
    required this.order,
  });

  final OrderModel order;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(),

              // Signature Glowing Victory Ring
              GlowRing(
                size: 130,
                strokeWidth: 4.0,
                glowColor: const Color(0xFF10B981),
                secondaryColor: const Color(0xFF064E3B),
                child: Container(
                  width: 76,
                  height: 76,
                  decoration: const BoxDecoration(
                    color: Color(0xFF10B981),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Colors.white,
                    size: 44,
                  ),
                ),
              ),

              const SizedBox(height: 32),

              const Text(
                'Order Confirmed!',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                'Order #${order.orderNumber} sent to ${order.storeName}',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Colors.grey.shade400,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 28),

              // Glowing Summary Card
              GlowCard(
                borderRadius: 22,
                borderWidth: 1.2,
                glowColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFF1E293B),
                enableBorderGlow: true,
                enableAmbientShadow: true,
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Estimated Delivery',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            const PulseGlowDot(
                              color: Color(0xFF10B981),
                              size: 7,
                              rippleRadius: 16,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              '${order.deliveryEtaMinutes} mins',
                              style: const TextStyle(
                                color: Color(0xFF34D399),
                                fontWeight: FontWeight.w800,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    const Divider(color: Color(0xFF334155), height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Courier Dispatch',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          order.courierPartner,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w700,
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Text(
                          'Total Authorized (Hold)',
                          style: TextStyle(
                            color: Colors.grey.shade400,
                            fontSize: 14,
                          ),
                        ),
                        Text(
                          order.formattedTotal,
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 17,
                          ),
                        ),
                      ],
                    ),
                    if (order.hasCatchWeightHold) ...<Widget>[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(10),
                        decoration: BoxDecoration(
                          color: const Color(0x3310B981),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF10B981).withValues(alpha: 0.3),
                          ),
                        ),
                        child: Row(
                          children: const <Widget>[
                            Icon(
                              Icons.scale_rounded,
                              size: 16,
                              color: Color(0xFF34D399),
                            ),
                            SizedBox(width: 8),
                            Expanded(
                              child: Text(
                                '+10% pre-auth hold included. You will only be charged for actual scale weight packed.',
                                style: TextStyle(
                                  fontSize: 11,
                                  color: Color(0xFFE2E8F0),
                                  height: 1.25,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const Spacer(),

              // Primary Track Order CTA with Glow & Shimmer
              GlowButton(
                label: 'Track Order in Real-Time',
                icon: Icons.navigation_rounded,
                glowColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFF10B981),
                textColor: Colors.white,
                onTap: () {
                  Navigator.of(context).pushReplacement(
                    MaterialPageRoute<void>(
                      builder: (_) => TrackingScreen(order: order),
                    ),
                  );
                },
              ),

              const SizedBox(height: 12),

              ScalePressable(
                onTap: () {
                  Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst);
                },
                child: Container(
                  height: 48,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFF334155)),
                  ),
                  child: const Center(
                    child: Text(
                      'Back to Home',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}
