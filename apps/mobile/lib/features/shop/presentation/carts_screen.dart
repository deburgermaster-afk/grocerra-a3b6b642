import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../home/data/catalog.dart';

/// `Carts` — one card per store that still holds items.
///
/// Ported from the reference board (`reference design/Carts.png`): a scroll
/// of store carts, each with a black "View cart" into that store's cart and
/// a grey "View store" back to the storefront. Store art, tint and prices
/// read the shared prototype catalogue so the cards match Home and search.
///
/// The floating tab bar stays owned by `HomeShell`, so the list pads the
/// bottom by `AppInsets.tabBar` like the other pushed screens.
class CartsScreen extends StatefulWidget {
  const CartsScreen({super.key});

  static const String routeName = '/carts';

  @override
  State<CartsScreen> createState() => _CartsScreenState();
}

class _CartsScreenState extends State<CartsScreen> {
  /// Prototype carts. The Madina line is the live store cart (count and
  /// total re-read [CartStore] on every mutation); the others are static
  /// placeholders until per-store carts exist.
  final List<_StoreCart> _carts = <_StoreCart>[
    _StoreCart(store: _store('Madina Halal Meats'), live: true),
    _StoreCart(store: _store('Dhaka Bazaar'), itemCount: 2, total: 3148),
    _StoreCart(
      store: _store('Lahore Sweets & Bakery'),
      itemCount: 1,
      total: 899,
      note: 'You seem far away from the store',
    ),
  ];

  static Store _store(String name) =>
      stores.firstWhere((Store s) => s.name == name);

  void _remove(int index) {
    final _StoreCart removed = _carts.removeAt(index);
    setState(() {});
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppRadius.lg),
          ),
          content: Text(
            '${removed.store.name} cart removed',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.surface,
            ),
          ),
          action: SnackBarAction(
            label: 'Undo',
            textColor: AppColors.accent,
            onPressed: () => setState(() => _carts.insert(index, removed)),
          ),
        ),
      );
  }

  void _showActions(_StoreCart cart) {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext ctx) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            const SizedBox(height: 8),
            ListTile(
              leading: const Icon(
                Icons.delete_outline_rounded,
                size: 22,
                color: AppColors.danger,
              ),
              title: const Text(
                'Remove cart',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.danger,
                ),
              ),
              onTap: () {
                Navigator.of(ctx).pop();
                if (cart.live) {
                  // The live card's cart is the shared one; emptying it
                  // makes the card hide itself.
                  CartStore.instance.clear();
                  ScaffoldMessenger.of(context)
                    ..hideCurrentSnackBar()
                    ..showSnackBar(
                      SnackBar(
                        behavior: SnackBarBehavior.floating,
                        backgroundColor: AppColors.ink,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        content: Text(
                          '${cart.store.name} cart cleared',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w500,
                            color: AppColors.surface,
                          ),
                        ),
                      ),
                    );
                } else {
                  _remove(_carts.indexOf(cart));
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.close_rounded, size: 22),
              title: const Text(
                'Cancel',
                style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
              ),
              onTap: () => Navigator.of(ctx).pop(),
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      // The Madina card mirrors the live cart; the whole list rebuilds on
      // every mutation so its count and total stay in step.
      body: ListenableBuilder(
        listenable: CartStore.instance,
        builder: (BuildContext context, Widget? _) {
          // The live card hides itself once the shared cart is emptied.
          final List<_StoreCart> carts = List<_StoreCart>.of(_carts)
            ..retainWhere(
              (_StoreCart c) => !c.live || CartStore.instance.isNotEmpty,
            );

          final Widget body = carts.isEmpty
              ? _EmptyState(
                  onBrowse: () =>
                      Navigator.of(context).pushNamedAndRemoveUntil(
                    '/home',
                    (Route<dynamic> _) => false,
                  ),
                )
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(context),
                    _buildTitle(),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
                      child: Column(
                        children: <Widget>[
                          for (int i = 0; i < carts.length; i++) ...<Widget>[
                            _CartCard(
                              cart: carts[i],
                              onViewCart: () =>
                                  Navigator.of(context).pushNamed('/cart'),
                              onViewStore: () =>
                                  Navigator.of(context).pushNamed('/store'),
                              onActions: () => _showActions(carts[i]),
                            ),
                            if (i != carts.length - 1)
                              const SizedBox(height: 12),
                          ],
                        ],
                      ),
                    ),
                  ],
                );

          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topInset, 0, AppInsets.tabBar),
            child: body,
          );
        },
      ),
    );
  }

  /// Back arrow, then the "Orders" pill on the right (reference: bookmark
  /// glyph in a grey pill).
  Widget _buildHeader(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: SizedBox(
        height: 52,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Back',
              onPressed: () => Navigator.of(context).maybePop(),
              icon: const Icon(
                Icons.arrow_back_rounded,
                size: 26,
                color: AppColors.ink,
              ),
            ),
            const Spacer(),
            Material(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.button),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppRadius.button),
                onTap: () => Navigator.of(context).pushNamed('/orders'),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      SvgPicture.asset(
                        'assets/icons/ic_receipt.svg',
                        width: 18,
                        height: 18,
                      ),
                      const SizedBox(width: 8),
                      const Text(
                        'Orders',
                        style: TextStyle(
                          fontSize: 16,
                          height: 19 / 16,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTitle() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 12),
      child: Text(
        'Carts',
        style: TextStyle(
          fontSize: 30,
          height: 36 / 30,
          letterSpacing: -0.6,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

/// A store cart: logo, name, item line, delivery line, overflow menu and the
/// two stacked actions.
class _CartCard extends StatelessWidget {
  const _CartCard({
    required this.cart,
    required this.onViewCart,
    required this.onViewStore,
    required this.onActions,
  });

  final _StoreCart cart;
  final VoidCallback onViewCart;
  final VoidCallback onViewStore;
  final VoidCallback onActions;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.xl),
        border: Border.all(color: AppColors.hairline),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x0A000000),
            blurRadius: 12,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          if (cart.note != null) ...<Widget>[
            // "You seem far away from the store" chip.
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.md),
              ),
              child: Text(
                cart.note!,
                style: const TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
            const SizedBox(height: 12),
          ],
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Logo: the store's emoji on its catalogue tint, as a circle.
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: cart.store.tint,
                  shape: BoxShape.circle,
                ),
                child: Center(
                  child: Text(
                    cart.store.art.first,
                    style: const TextStyle(fontSize: 30),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      cart.store.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 18,
                        height: 22 / 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 3),
                    Text(
                      '${cart.shownCount} item${cart.shownCount == 1 ? '' : 's'}'
                      ' · ${money(cart.shownTotalCents)}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 18 / 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 3),
                    const Text(
                      'Deliver to 12 Queen St, Melbourne',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 15,
                        height: 18 / 15,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              RoundIconButton(
                icon: Icons.more_horiz_rounded,
                iconSize: 22,
                onTap: onActions,
                tooltip: 'Cart options',
              ),
            ],
          ),
          const SizedBox(height: 14),
          _CartButton(
            label: 'View cart',
            background: AppColors.ink,
            foreground: AppColors.surface,
            onTap: onViewCart,
          ),
          const SizedBox(height: 10),
          _CartButton(
            label: 'View store',
            background: AppColors.surfaceAlt,
            foreground: AppColors.ink,
            onTap: onViewStore,
          ),
        ],
      ),
    );
  }
}

/// The stacked card actions — shorter than the Figma `FilledButton` (56/r28)
/// because the reference sets them at 52 with a 16 radius.
class _CartButton extends StatelessWidget {
  const _CartButton({
    required this.label,
    required this.background,
    required this.foreground,
    required this.onTap,
  });

  final String label;
  final Color background;
  final Color foreground;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.lg),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.lg),
        onTap: onTap,
        child: SizedBox(
          height: 52,
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                fontSize: 17,
                height: 20 / 17,
                fontWeight: FontWeight.w600,
                color: foreground,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Shown when every cart has been removed.
class _EmptyState extends StatelessWidget {
  const _EmptyState({required this.onBrowse});

  final VoidCallback onBrowse;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.fromLTRB(
        24,
        AppInsets.statusBar(context) + 120,
        24,
        24,
      ),
      child: Column(
        children: <Widget>[
          Container(
            width: 88,
            height: 88,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Center(
              child: Text('🛒', style: TextStyle(fontSize: 40)),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No carts yet',
            style: TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'Items you add from any store show up here,\nready when you are.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              height: 17 / 14,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: onBrowse,
            child: const Text('Browse stores'),
          ),
        ],
      ),
    );
  }
}

/// One store's cart.
class _StoreCart {
  const _StoreCart({
    required this.store,
    this.itemCount = 0,
    this.total = 0,
    this.live = false,
    this.note,
  });

  final Store store;

  /// Stale placeholder count; ignored when [live].
  final int itemCount;

  /// Stale placeholder subtotal in cents; ignored when [live].
  final int total;

  /// Mirrors the shared [CartStore] (count and total re-read on build).
  final bool live;

  /// Optional warning chip above the store name.
  final String? note;

  /// What the card prints: the live cart's figures when [live].
  int get shownCount => live ? CartStore.instance.itemCount : itemCount;

  int get shownTotalCents =>
      live ? (CartStore.instance.subtotal * 100).round() : total;
}
