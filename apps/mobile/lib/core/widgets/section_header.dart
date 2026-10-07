import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Figma section heading pair: `H3` 20/700 with an optional 14/600
/// `See all` action pinned to the right (B1 y380/y384, y516/y520).
class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.actionTitle, this.onAction});

  final String title;
  final String? actionTitle;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 24,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Text(
              title,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: Theme.of(context).textTheme.titleLarge,
            ),
          ),
          if (actionTitle != null)
            GestureDetector(
              key: const ValueKey<String>('section-action'),
              onTap: onAction,
              behavior: HitTestBehavior.opaque,
              child: Padding(
                padding: const EdgeInsets.only(left: 8),
                child: Text(
                  actionTitle!,
                  style: const TextStyle(
                    fontSize: 14,
                    height: 17 / 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
