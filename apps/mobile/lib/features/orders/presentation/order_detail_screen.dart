import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `C15.02 · Order details` (`4005:24`) - exact 390x844 frame port.
///
/// Pushed route (`/orders/detail`) with its own scaffold, so the status bar
/// is reserved via [AppInsets] and the action bar clears the home indicator.
class OrderDetailScreen extends StatelessWidget {
  const OrderDetailScreen({super.key});

  static const String routeName = '/orders/detail';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: SingleChildScrollView(
              // Content ends under the 96px pinned action bar.
              padding: EdgeInsets.only(
                top: AppInsets.statusBar(context),
                bottom: 120,
              ),
              child: const Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _Header(),
                  _StoreBlock(),
                  _ItemsSection(),
                  _FeesSection(),
                  _PaymentAddressSection(),
                ],
              ),
            ),
          ),
          const Positioned(left: 0, right: 0, bottom: 0, child: _ActionBar()),
        ],
      ),
    );
  }
}

/// `Header` (`4005:30`): plain back control + `Order details` H3.
class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Row(
        children: <Widget>[
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints.tightFor(
              width: 40,
              height: 40,
            ),
            icon: const Icon(Icons.arrow_back_rounded, size: 24),
            onPressed: () => popOrFallback(context, '/orders'),
            tooltip: 'Back',
          ),
          const SizedBox(width: 12),
          Text('Order details', style: Theme.of(context).textTheme.titleLarge),
        ],
      ),
    );
  }
}

/// `Store block` (`4005:35`): round photo, store lines and the `Delivered`
/// badge (`#f3f3f3` pill, `#047a43` 12/600 label).
class _StoreBlock extends StatelessWidget {
  const _StoreBlock();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipOval(
              child: Image.asset(
                'assets/icons/order_detail_store.png',
                width: 48,
                height: 48,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    'Madina Halal Meats',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                  const SizedBox(height: 2),
                  const Text('Order #SG-48213 · 4 items', style: unitMuted),
                  const SizedBox(height: 2),
                  const Text('Mon, 28 Sep 2026 · 6:42 PM', style: unitMuted),
                ],
              ),
            ),
            const SizedBox(width: 14),
            const TagPill(
              label: 'Delivered',
              background: AppColors.surfaceAlt,
              foreground: AppColors.accentLink,
              fontSize: 12,
              height: 27,
              radius: 14,
              padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item {
  const _Item(
    this.qty,
    this.name,
    this.subtitle,
    this.price, {
    this.subtitleStyle = unitMuted,
    this.priceStyle = priceInk,
  });

  final String qty;
  final String name;

  /// Item unit line. Figma paints the beef/chicken `1 kg` in the surface
  /// colour (invisible against the white card, nodes `4005:52` / `4005:64`);
  /// the lamb line is pure black and the naan line muted.
  final String subtitle;
  final TextStyle subtitleStyle;

  final String price;
  final TextStyle priceStyle;
}

/// `Items` (`4005:44`): hairline-topped rows with a 34px qty chip.
class _ItemsSection extends StatelessWidget {
  const _ItemsSection();

  static const List<_Item> _items = <_Item>[
    _Item(
      '1×',
      'Beef curry cut',
      '1 kg',
      r'$22.99',
      subtitleStyle: unitInvisible,
    ),
    _Item(
      '1×',
      'Chicken drumsticks',
      '1 kg',
      r'$12.49',
      subtitleStyle: unitInvisible,
    ),
    _Item('1×', 'Lamb mince', '500 g', r'$8.99', priceStyle: priceMuted),
    _Item('1×', 'Plain naan', '4 pack', r'$5.85'),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          for (final _Item item in _items) ...<Widget>[
            const Divider(),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Row(
                children: <Widget>[
                  Container(
                    width: 34,
                    height: 34,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                    child: Text(item.qty, style: qtyLabel),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          item.name,
                          style: Theme.of(context).textTheme.titleMedium,
                        ),
                        const SizedBox(height: 1),
                        Text(item.subtitle, style: item.subtitleStyle),
                      ],
                    ),
                  ),
                  Text(item.price, style: item.priceStyle),
                ],
              ),
            ),
          ],
          const Divider(),
        ],
      ),
    );
  }
}

/// `Fees` (`4005:78`): label/value rows (`#6b6b6b` labels) and the bold
/// Total pair.
class _FeesSection extends StatelessWidget {
  const _FeesSection();

  @override
  Widget build(BuildContext context) {
    final TextStyle feeLabel = Theme.of(context).textTheme.bodyLarge!
        .copyWith(color: AppColors.inkMuted);

    const List<List<String>> fees = <List<String>>[
      <String>['Subtotal', r'$50.32', 'ink'],
      <String>['Delivery fee', r'$5.99', 'muted'],
      <String>['Service fee', r'$1.89', 'ink'],
      <String>['Courier tip', r'$3.00', 'ink'],
    ];

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 10, 16, 6),
      child: Column(
        children: <Widget>[
          for (final List<String> fee in fees)
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 6),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(fee[0], style: feeLabel),
                  Text(
                    fee[1],
                    style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                      color: fee[2] == 'muted'
                          ? AppColors.inkMuted
                          : AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text('Total', style: Theme.of(context).textTheme.titleLarge),
                Text(r'$61.20', style: Theme.of(context).textTheme.titleLarge),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// `Payment & address` (`4005:101`): two 60px rows split by hairlines.
class _PaymentAddressSection extends StatelessWidget {
  const _PaymentAddressSection();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                const _RowBubble(icon: 'card', iconSize: 24),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text('Visa •••• 4242', style: mutedCardTitle),
                      const SizedBox(height: 1),
                      Text('Paid · \$61.20', style: text.bodySmall),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 10),
            child: Row(
              children: <Widget>[
                const _RowBubble(icon: 'pin', iconSize: 20),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('Delivered to Home', style: text.titleMedium),
                      const SizedBox(height: 1),
                      const Text('24 Maple Street, Apt 3B', style: addressLine),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const Divider(),
        ],
      ),
    );
  }
}

/// 40px `#f3f3f3` circle holding a row glyph (`4005:104` / `4005:113`).
class _RowBubble extends StatelessWidget {
  const _RowBubble({required this.icon, required this.iconSize});

  final String icon;
  final double iconSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        shape: BoxShape.circle,
      ),
      child: AppIcon(icon, size: iconSize, color: AppColors.ink),
    );
  }
}

/// `Order detail bar · glass` (`4005:120`): white bar with an upward
/// shadow, `Get help` (#f3f3f3, 128 wide) and the black `Reorder` CTA.
class _ActionBar extends StatelessWidget {
  const _ActionBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        28 + MediaQuery.paddingOf(context).bottom,
      ),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.topBar,
      ),
      child: Row(
        children: <Widget>[
          SizedBox(
            width: 128,
            child: _GetHelpButton(
              onTap: () => Navigator.of(context).pushNamed('/order-issue'),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: AppButton(
              label: 'Reorder',
              height: 56,
              onPressed: () => Navigator.of(context).pushNamed('/cart'),
            ),
          ),
        ],
      ),
    );
  }
}

/// `Button · Get help` (`4005:121`). `AppButton` has no `#f3f3f3` variant
/// with a black 16/600 label, so it renders directly (same precedent as the
/// tracking sheet button).
class _GetHelpButton extends StatelessWidget {
  const _GetHelpButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(28),
      child: InkWell(
        borderRadius: BorderRadius.circular(28),
        onTap: onTap,
        child: SizedBox(
          height: 56,
          child: Center(
            child: Text(
              'Get help',
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Figma text styles that have no theme token ---------------------------

/// Store lines `App / Regular / 13`, `#6b6b6b` (`4005:40` / `4005:41`).
const TextStyle unitMuted = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontWeight: FontWeight.w400,
  color: AppColors.inkMuted,
);

/// Beef / chicken unit line `App / Regular / 13` painted in the surface
/// colour in Figma (`4005:52`, `4005:64`) - kept so the row heights match.
const TextStyle unitInvisible = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontWeight: FontWeight.w400,
  color: AppColors.surface,
);

/// Qty chip label `App / Semi Bold / 13` (`4005:48`).
const TextStyle qtyLabel = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// Item price `App / Regular / 16`, black (`4005:54`).
const TextStyle priceInk = TextStyle(
  fontSize: 16,
  height: 19 / 16,
  fontWeight: FontWeight.w400,
  color: AppColors.ink,
);

/// Lamb price `App / Regular / 16`, `#6b6b6b` (`4005:70`).
const TextStyle priceMuted = TextStyle(
  fontSize: 16,
  height: 19 / 16,
  fontWeight: FontWeight.w400,
  color: AppColors.inkMuted,
);

/// `Visa •••• 4242` `App / Semi Bold / 16`, `#6b6b6b` (`4005:109`).
const TextStyle mutedCardTitle = TextStyle(
  fontSize: 16,
  height: 19 / 16,
  fontWeight: FontWeight.w600,
  color: AppColors.inkMuted,
);

/// Address second line `App / Regular / 13`, pure black (`4005:118`).
const TextStyle addressLine = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontWeight: FontWeight.w400,
  color: AppColors.ink,
);
