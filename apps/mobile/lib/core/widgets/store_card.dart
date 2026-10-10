import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';
import 'tag_pill.dart';

/// The 358×112 store card shared by C04.01 `Stores near you` and C07.01
/// `Popular stores` (Figma `Store card` component: 112×112 r16 photo
/// flush left, 14px gap, info column with 5px item spacing - name 16/600,
/// description 13/400, rating meta row, 21px tag pills).
///
/// `onTap == null` renders the card inert (Figma `Bismillah` closed state
/// has no prototype reaction).
class StoreCard extends StatelessWidget {
  const StoreCard({
    super.key,
    required this.imageAsset,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.tags,
    this.onTap,
  });

  /// Rendered 112×112 card photo (`assets/icons/<imageAsset>`).
  final String imageAsset;
  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final List<String> tags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        // Figma: 358×112, image flush at the left (no card padding),
        // 14px gap to the info column.
        child: SizedBox(
          height: 112,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/icons/$imageAsset',
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 19 / 16,
                      ),
                    ),
                    // Figma Info column: uniform itemSpacing 5 (1:114).
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 16 / 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        const AppIcon('star', size: 13),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            height: 16 / 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        // Figma: `4.6` x17 w21 ends x38, meta starts x42.
                        const SizedBox(width: 4),
                        Text(
                          '($reviewCount) · $deliveryTime',
                          style: TextStyle(
                            fontSize: 13,
                            height: 16 / 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        for (int i = 0; i < tags.length; i++) ...<Widget>[
                          if (i > 0) const SizedBox(width: 6),
                          TagPill(
                            label: tags[i],
                            // Halal = color/status/success `#047A43`
                            // (Figma `1:123`), not the accent green.
                            background: i == 0
                                ? AppColors.success
                                : AppColors.surfaceAlt,
                            foreground: i == 0
                                ? AppColors.surface
                                : AppColors.ink,
                            fontSize: 11,
                            // Figma C04.01 store tags are 21 tall with 4px
                            // vertical padding (`58216:2712`), not the B3
                            // 22/4.5 default.
                            height: 21,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
