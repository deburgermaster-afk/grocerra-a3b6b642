import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/store_order.dart';

class InPackingCard extends StatelessWidget {
  final StoreOrder order;
  final VoidCallback onOpenPacking;

  const InPackingCard({
    super.key,
    required this.order,
    required this.onOpenPacking,
  });

  @override
  Widget build(BuildContext context) {
    final progressPercent = (order.packingProgress * 100).toInt();

    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: AppColors.hairline, width: 1),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Order #${order.id}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Due in ${order.prepDueMinutes}m · ${order.customerName}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.inkMuted,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: const Color(0xFFEFF6FF),
                    borderRadius: BorderRadius.circular(999),
                    border: Border.all(color: const Color(0xFFBFDBFE)),
                  ),
                  child: const Text(
                    'Packing',
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: Color(0xFF1D4ED8),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Packing Progress Bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: ShadProgress(
                    value: order.packingProgress,
                    minHeight: 8,
                    backgroundColor: AppColors.surfaceAlt,
                    color: AppColors.accent,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.packedCount} of ${order.items.length} items packed',
                      style: const TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.hairline),

          // Items Checklist Preview
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Column(
              children: order.items.map((item) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 4),
                  child: Row(
                    children: [
                      Icon(
                        item.isPacked
                            ? Icons.check_circle
                            : Icons.radio_button_unchecked,
                        size: 18,
                        color: item.isPacked
                            ? AppColors.accent
                            : Colors.grey.shade400,
                      ),
                      const SizedBox(width: 8),
                      Expanded(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 12.5,
                            fontWeight: FontWeight.w500,
                            color: item.isPacked
                                ? AppColors.inkMuted
                                : AppColors.ink,
                            decoration: item.isPacked
                                ? TextDecoration.lineThrough
                                : null,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (item.isCatchWeight && item.actualWeightKg != null)
                        Text(
                          '${item.actualWeightKg} kg',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: AppColors.accentDark,
                          ),
                        ),
                    ],
                  ),
                );
              }).toList(),
            ),
          ),

          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.hairline),

          // Action Button (Shadcn UI)
          Padding(
            padding: const EdgeInsets.all(16),
            child: ShadButton.outline(
              width: double.infinity,
              height: 48,
              padding: const EdgeInsets.symmetric(horizontal: 10),
              onPressed: onOpenPacking,
              backgroundColor: AppColors.surfaceAlt,
              hoverBackgroundColor: Colors.white,
              leading: const Icon(Icons.scale_outlined, size: 18, color: AppColors.ink),
              child: const Flexible(
                child: Text(
                  'Open Packing Station',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: AppColors.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
