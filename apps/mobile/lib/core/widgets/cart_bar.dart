import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The 358×56 black `Cart bar` shared by B1 · Home and B3 · Store:
/// r28 pill, a 28px white count circle, `View cart` and the total, all
/// 16/600 `#ffffff`.
class CartBar extends StatelessWidget {
  const CartBar({
    super.key,
    required this.itemCount,
    required this.total,
    required this.onTap,
  });

  final int itemCount;
  final String total;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(AppRadius.button),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.button),
        onTap: onTap,
        child: SizedBox(
          width: 358,
          height: 56,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            child: Row(
              children: <Widget>[
                Container(
                  width: 28,
                  height: 28,
                  alignment: Alignment.center,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: Text(
                    '$itemCount',
                    style: const TextStyle(
                      fontSize: 13,
                      height: 1,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  'View cart',
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
                const Spacer(),
                Text(
                  total,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: AppColors.surface,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
