import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `C15.01 · Order history` (`1:825`) - exact 390x844 frame port.
///
/// In the reference the Orders tab sits inside `HomeShell` under the floating
/// glass tab bar; this app's shell has three tabs (Home/Catering/Profile), so
/// Orders is a pushed route instead and pads its bottom normally.
class OrdersScreen extends StatelessWidget {
  const OrdersScreen({super.key});

  static const String routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        // `Orders` title sits at y59 (12 below the 47px status bar); the
        // Figma content column starts at y120.
        padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Plain back control (the app's standing back-button treatment).
            // C15.01 is a tab frame with no back node; this app pushes Orders
            // from Profile, so it needs a way back.
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 40,
                height: 40,
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              onPressed: () => popOrFallback(context, '/profile'),
              tooltip: 'Back',
            ),
            const SizedBox(height: 4),
            Text(
              'Orders',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                color: AppColors.inkMuted,
              ),
            ),
            // y95 (title end) -> y120 (content start).
            const SizedBox(height: 25),
            const _ActiveSection(),
            const SizedBox(height: 20),
            const _CateringSection(),
            const SizedBox(height: 20),
            const _PreviousOrdersSection(),
          ],
        ),
      ),
    );
  }
}

/// `Active order` section (`1:834`): heading + the `#f3f3f3` card holding
/// the live order, its four-segment progress bar and the Track CTA.
class _ActiveSection extends StatelessWidget {
  const _ActiveSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeader(title: 'Active order'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Column(
            children: <Widget>[
              // Top row: 56 photo + store info + `On the way` badge.
              Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(14),
                    child: Image.asset(
                      'assets/icons/order_thumb_shop.png',
                      width: 56,
                      height: 56,
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text('Madina Halal Meats', style: rowTitle),
                        SizedBox(height: 3),
                        Text(
                          '3 items · Arriving by 6:15 PM',
                          style: captionMuted,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.ink,
                      borderRadius: BorderRadius.circular(AppRadius.full),
                    ),
                    child: const Text('On the way', style: badgeOnInk),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              // Progress bar: three filled segments + one track segment
              // (`#0000001f`), 6px apart.
              Row(
                children: <Widget>[
                  for (int i = 0; i < 4; i++) ...<Widget>[
                    if (i > 0) const SizedBox(width: 6),
                    Expanded(
                      child: Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < 3
                              ? AppColors.ink
                              : AppColors.progressTrack,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 14),
              AppButton(
                label: 'Track order',
                height: 44,
                labelStyle: badgeOnInk,
                onPressed: () =>
                    Navigator.of(context).pushNamed('/tracking'),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// `Catering requests` section (`1:854`): heading + the request card with the
/// chef-hat bubble and the `Quotes pending` badge.
class _CateringSection extends StatelessWidget {
  const _CateringSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeader(title: 'Catering requests'),
        const SizedBox(height: 10),
        Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Row(
            children: <Widget>[
              Container(
                width: 44,
                height: 44,
                alignment: Alignment.center,
                decoration: const BoxDecoration(
                  color: AppColors.ink,
                  shape: BoxShape.circle,
                ),
                child: const AppIcon(
                  'chef',
                  size: 22,
                  color: AppColors.surface,
                ),
              ),
              const SizedBox(width: 10),
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text('Wedding · 80 guests', style: rowTitle15),
                    SizedBox(height: 2),
                    Text('Sat, 24 Oct 2026', style: captionMuted),
                  ],
                ),
              ),
              const TagPill(
                label: 'Quotes pending',
                background: AppColors.hairline,
                fontSize: 12,
                height: 27,
                radius: 14,
                padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// `Previous orders` section (`1:866`): heading + three 80-tall rows split
/// by hairline dividers with 4px breathing room on each side.
class _PreviousOrdersSection extends StatelessWidget {
  const _PreviousOrdersSection();

  static const List<_PastOrder> _orders = <_PastOrder>[
    _PastOrder('order_thumb_beef.png', 'Sep 28', '4 items · \$61.20'),
    _PastOrder('order_thumb_goat.png', 'Sep 14', '2 items · \$34.47'),
    _PastOrder('order_thumb_chicken.png', 'Aug 30', '5 items · \$48.10'),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeader(title: 'Previous orders'),
        const SizedBox(height: 4),
        Column(
          children: <Widget>[
            for (int i = 0; i < _orders.length; i++) ...<Widget>[
              if (i > 0) ...<Widget>[
                const SizedBox(height: 4),
                const Divider(),
                const SizedBox(height: 4),
              ],
              _PastOrderRow(order: _orders[i]),
            ],
          ],
        ),
      ],
    );
  }
}

class _PastOrder {
  const _PastOrder(this.image, this.date, this.summary);

  final String image;
  final String date;
  final String summary;
}

/// One `Order · <date>` row (`1:868` / `1:887` / `1:906`). The row opens the
/// order detail; the nested Reorder pill goes straight to the cart.
class _PastOrderRow extends StatelessWidget {
  const _PastOrderRow({required this.order});

  final _PastOrder order;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/orders/detail'),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/icons/${order.image}',
                width: 56,
                height: 56,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text('Madina Halal Meats', style: rowTitle),
                  const SizedBox(height: 3),
                  Row(
                    children: <Widget>[
                      Text(order.date, style: captionMuted),
                      const SizedBox(width: 6),
                      const Text('Delivered', style: delivered),
                    ],
                  ),
                  const SizedBox(height: 3),
                  Text(order.summary, style: captionMuted),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Reorder pill 95x36 r18 + the row chevron (`icon/chev`).
            Row(
              children: <Widget>[
                _ReorderButton(
                  onTap: () => Navigator.of(context).pushNamed('/cart'),
                ),
                const SizedBox(width: 6),
                const AppIcon('chev', size: 20, color: AppColors.ink),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// `Button · Reorder` (`1:879`): `#f3f3f3` pill, repeat glyph + 12/600 label.
class _ReorderButton extends StatelessWidget {
  const _ReorderButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: const Padding(
          padding: EdgeInsets.symmetric(horizontal: 12),
          child: SizedBox(
            height: 36,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                AppIcon('repeat', size: 20),
                SizedBox(width: 4),
                Text('Reorder', style: reorderLabel),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Figma text styles that have no theme token ---------------------------

/// Row / card title `App / Semi Bold / 16` (`1:843`).
const TextStyle rowTitle = TextStyle(
  fontSize: 16,
  height: 19 / 16,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// `App / Semi Bold / 15` (`1:862` `Wedding · 80 guests`).
const TextStyle rowTitle15 = TextStyle(
  fontSize: 15,
  height: 18 / 15,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// `App / Medium / 12` secondary line (`1:844`, `1:863`, `1:878`).
const TextStyle captionMuted = TextStyle(
  fontSize: 12,
  height: 15 / 12,
  fontWeight: FontWeight.w500,
  color: AppColors.inkMuted,
);

/// `App / Semi Bold / 12` badge label on the black pill (`1:846`); also the
/// Track order CTA label (`1:853`) and the row `Reorder` label (`1:885`).
const TextStyle badgeOnInk = TextStyle(
  fontSize: 12,
  height: 15 / 12,
  fontWeight: FontWeight.w600,
  color: AppColors.surface,
);

/// `Delivered` status `App / Semi Bold / 12`, `#047a43` (`1:877`).
const TextStyle delivered = TextStyle(
  fontSize: 12,
  height: 15 / 12,
  fontWeight: FontWeight.w600,
  color: AppColors.accentLink,
);

/// `App / Semi Bold / 12` label inside the Reorder pill (`1:885`).
const TextStyle reorderLabel = TextStyle(
  fontSize: 12,
  height: 15 / 12,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);
