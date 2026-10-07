import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

/// Placeholder for the blueprint screens *Orders*, *Order details* and
/// *Delivery Tracking Screen*.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Orders',
      blueprintScreen: 'Orders / Order details / Delivery tracking',
      wiringNote:
          'Order list with status chips, order detail (items, weights, '
          'totals, refunds) and live courier tracking. Backend: edge fn: '
          'merchant (orders, packing), edge fn: dispatch & failover, '
          'Supabase Realtime.',
    );
  }
}
