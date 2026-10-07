import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/tag_pill.dart';
import '../data/sample_orders.dart';

/// Status chip for an order: green while it is moving, ink once delivered,
/// red when cancelled.
class OrderStatusPill extends StatelessWidget {
  const OrderStatusPill({super.key, required this.status});

  final OrderStatus status;

  @override
  Widget build(BuildContext context) {
    final (Color background, Color foreground) = switch (status) {
      OrderStatus.placed ||
      OrderStatus.packing ||
      OrderStatus.onTheWay => (const Color(0xFFDCFCE7), AppColors.accentDark),
      OrderStatus.delivered => (AppColors.surfaceAlt, AppColors.ink),
      OrderStatus.cancelled => (const Color(0xFFFEE2E2), AppColors.danger),
    };
    return TagPill(
      label: status.label,
      background: background,
      foreground: foreground,
    );
  }
}

/// 52px pushed-screen header: 40x40 grey back button and a 24/700 title,
/// matching `Your cart` (B5).
class OrderBackHeader extends StatelessWidget {
  const OrderBackHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              tooltip: 'Back',
              icon: const Icon(
                Icons.arrow_back,
                size: 24,
                color: AppColors.ink,
              ),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 24,
                height: 29 / 24,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          ?trailing,
        ],
      ),
    );
  }
}

/// 8px grey band between sections (B5).
class OrderSectionBreak extends StatelessWidget {
  const OrderSectionBreak({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(height: 8, color: AppColors.surfaceAlt);
  }
}

/// Hairline divider inset 16px either side.
class OrderDivider extends StatelessWidget {
  const OrderDivider({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 1,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }
}
