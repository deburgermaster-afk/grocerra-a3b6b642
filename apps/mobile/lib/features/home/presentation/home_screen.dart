import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../data/catalog.dart';

/// Home, laid out like a dense marketplace feed (reference: Uber Eats):
/// address, shopping modes, a row of categories, quick filters, then rails
/// of featured stores, groceries and caterers, and every store below.
///
/// Spacing is deliberately tight: content, not padding, fills the screen.
/// The floating tab bar is owned by `HomeShell`; the feed pads its bottom by
/// [AppInsets.tabBar].
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

enum _Filter { pickup, offers, freeDelivery, under30, topRated }

class _HomeScreenState extends State<HomeScreen> {
  String _mode = modes.first;
  final Set<_Filter> _filters = <_Filter>{};

  static const Map<String, StoreKind?> _modeKinds = <String, StoreKind?>{
    'All': null,
    'Grocery': StoreKind.grocery,
    'Meat': StoreKind.meat,
    'Catering': StoreKind.catering,
    'Sweets': StoreKind.sweets,
    'Convenience': StoreKind.grocery,
  };

  List<Store> get _visibleStores => stores.where((Store s) {
    final StoreKind? kind = _modeKinds[_mode];
    if (kind != null && s.kind != kind) return false;
    if (_filters.contains(_Filter.offers) && s.promo == null) return false;
    if (_filters.contains(_Filter.freeDelivery) && s.deliveryFee != 0) {
      return false;
    }
    if (_filters.contains(_Filter.under30) && s.minutes > 30) return false;
    if (_filters.contains(_Filter.topRated) && s.rating < 4.7) return false;
    return true;
  }).toList();

  void _toggle(_Filter f) {
    HapticFeedback.selectionClick();
    setState(() => _filters.contains(f) ? _filters.remove(f) : _filters.add(f));
  }

  void _add(Product p) {
    HapticFeedback.lightImpact();
    // Add to the shared cart so the badge, Carts list and Cart screen all
    // update together.
    CartStore.instance.add(
      CartItem(
        id: p.name.toLowerCase().replaceAll(' ', '-'),
        name: p.name,
        price: p.price / 100,
        emoji: p.emoji,
        detail: p.size,
      ),
    );
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 92),
          duration: const Duration(milliseconds: 1400),
          content: Text('${p.name} added to cart'),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final List<Store> visible = _visibleStores;
    final List<Store> catering = visible
        .where((Store s) => s.kind == StoreKind.catering)
        .toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListView(
        padding: EdgeInsets.only(
          top: AppInsets.statusBar(context),
          bottom: AppInsets.tabBar,
        ),
        children: <Widget>[
          _header(context),
          const SizedBox(height: 10),
          _modeChips(),
          const SizedBox(height: 14),
          _categoryRow(),
          const SizedBox(height: 10),
          _filterChips(),
          const SizedBox(height: 18),
          if (visible.isEmpty)
            const _Empty()
          else ...<Widget>[
            _SectionTitle(
              'Featured on Grocerra',
              onMore: () => Navigator.of(context).pushNamed('/store'),
            ),
            const SizedBox(height: 10),
            _rail(
              height: 232,
              count: visible.length,
              builder: (int i) => _StoreCard(store: visible[i]),
            ),
          ],
          const _Divider(),
          const _SectionTitle('Stock up on groceries'),
          const SizedBox(height: 10),
          _rail(
            height: 196,
            count: products.length,
            builder: (int i) => _ProductCard(product: products[i], onAdd: _add),
          ),
          if (catering.isNotEmpty) ...<Widget>[
            const _Divider(),
            const _SectionTitle('Catering for your next event'),
            const SizedBox(height: 10),
            _rail(
              height: 232,
              count: catering.length,
              builder: (int i) => _StoreCard(store: catering[i], wide: true),
            ),
          ],
          if (visible.isNotEmpty) ...<Widget>[
            const _Divider(),
            _SectionTitle('All stores (${visible.length})'),
            const SizedBox(height: 4),
            for (final Store s in visible) _StoreRow(store: s),
          ],
        ],
      ),
    );
  }

  Widget _header(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 40,
        child: Row(
          children: <Widget>[
            Expanded(
              child: InkWell(
                borderRadius: BorderRadius.circular(8),
                onTap: () {},
                child: const Row(
                  children: <Widget>[
                    Flexible(
                      child: Text(
                        '12 Queen St, Melbourne',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w600,
                          letterSpacing: -0.3,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    SizedBox(width: 4),
                    Icon(Icons.keyboard_arrow_down_rounded, size: 22),
                  ],
                ),
              ),
            ),
            IconButton(
              tooltip: 'Notifications',
              onPressed: () =>
                  Navigator.of(context).pushNamed('/notifications'),
              icon: const Badge(
                smallSize: 8,
                child: Icon(Icons.notifications_none_rounded, size: 26),
              ),
            ),
            IconButton(
              tooltip: 'Cart',
              onPressed: () => Navigator.of(context).pushNamed('/carts'),
              icon: ListenableBuilder(
                listenable: CartStore.instance,
                builder: (BuildContext context, _) => Badge.count(
                  count: CartStore.instance.itemCount,
                  backgroundColor: AppColors.accent,
                  child: const Icon(Icons.shopping_bag_outlined, size: 26),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _modeChips() {
    const Map<String, String> icons = <String, String>{
      'All': '🛍️',
      'Grocery': '🍌',
      'Meat': '🥩',
      'Catering': '🍛',
      'Sweets': '🍮',
      'Convenience': '🧃',
    };
    return _chipRow(<Widget>[
      for (final String m in modes)
        _Chip(
          label: m,
          emoji: icons[m],
          selected: m == _mode,
          onTap: () {
            HapticFeedback.selectionClick();
            setState(() => _mode = m);
          },
        ),
    ]);
  }

  Widget _categoryRow() {
    return SizedBox(
      height: 76,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        itemCount: categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 4),
        itemBuilder: (BuildContext context, int i) {
          final Category c = categories[i];
          return _Tap(
            onTap: () => Navigator.of(context).pushNamed('/store'),
            child: SizedBox(
              width: 66,
              child: Column(
                children: <Widget>[
                  Text(c.emoji, style: const TextStyle(fontSize: 38)),
                  const SizedBox(height: 4),
                  Text(
                    c.label,
                    maxLines: 1,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w500,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _filterChips() {
    return _chipRow(<Widget>[
      _Chip(
        label: 'Pickup',
        icon: Icons.directions_walk_rounded,
        selected: _filters.contains(_Filter.pickup),
        onTap: () => _toggle(_Filter.pickup),
        outlined: true,
      ),
      _Chip(
        label: 'Offers',
        icon: Icons.local_offer_outlined,
        selected: _filters.contains(_Filter.offers),
        onTap: () => _toggle(_Filter.offers),
        outlined: true,
      ),
      _Chip(
        label: r'$0 Delivery',
        selected: _filters.contains(_Filter.freeDelivery),
        onTap: () => _toggle(_Filter.freeDelivery),
        outlined: true,
      ),
      _Chip(
        label: 'Under 30 min',
        selected: _filters.contains(_Filter.under30),
        onTap: () => _toggle(_Filter.under30),
        outlined: true,
      ),
      _Chip(
        label: 'Rating 4.7+',
        icon: Icons.star_rounded,
        selected: _filters.contains(_Filter.topRated),
        onTap: () => _toggle(_Filter.topRated),
        outlined: true,
      ),
    ]);
  }

  Widget _chipRow(List<Widget> chips) {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: chips.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (_, int i) => chips[i],
      ),
    );
  }

  Widget _rail({
    required double height,
    required int count,
    required Widget Function(int) builder,
  }) {
    return SizedBox(
      height: height,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: count,
        separatorBuilder: (_, _) => const SizedBox(width: 12),
        itemBuilder: (_, int i) => builder(i),
      ),
    );
  }
}

/// Springs down a little while pressed.
class _Tap extends StatefulWidget {
  const _Tap({required this.child, required this.onTap});

  final Widget child;
  final VoidCallback onTap;

  @override
  State<_Tap> createState() => _TapState();
}

class _TapState extends State<_Tap> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _down ? 0.96 : 1,
        duration: Duration(milliseconds: _down ? 90 : 300),
        curve: _down ? Curves.easeOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.selected,
    required this.onTap,
    this.emoji,
    this.icon,
    this.outlined = false,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;
  final String? emoji;
  final IconData? icon;

  /// Filter chips sit on a grey pill and turn black when on; mode chips use
  /// an outline and fill grey when selected.
  final bool outlined;

  @override
  Widget build(BuildContext context) {
    final Color bg = outlined
        ? (selected ? AppColors.ink : AppColors.surfaceAlt)
        : (selected ? AppColors.surfaceAlt : AppColors.surface);
    final Color fg = outlined && selected ? AppColors.surface : AppColors.ink;

    return _Tap(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(horizontal: 14),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(18),
          border: outlined
              ? null
              : Border.all(
                  color: selected ? AppColors.surfaceAlt : AppColors.hairline,
                ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            if (emoji != null) ...<Widget>[
              Text(emoji!, style: const TextStyle(fontSize: 16)),
              const SizedBox(width: 6),
            ],
            if (icon != null) ...<Widget>[
              Icon(icon, size: 17, color: fg),
              const SizedBox(width: 6),
            ],
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle(this.title, {this.onMore});

  final String title;
  final VoidCallback? onMore;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 36,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 21,
                  fontWeight: FontWeight.w700,
                  letterSpacing: -0.5,
                  color: AppColors.ink,
                ),
              ),
            ),
            if (onMore != null)
              _Tap(
                onTap: onMore!,
                child: Container(
                  width: 36,
                  height: 36,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.arrow_forward_rounded, size: 20),
                ),
              ),
          ],
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 6,
      margin: const EdgeInsets.symmetric(vertical: 14),
      color: AppColors.canvas,
    );
  }
}

/// Emoji still life on a tinted ground, standing in for cover photos.
class _Cover extends StatelessWidget {
  const _Cover({required this.art, required this.tint, this.size = 46});

  final List<String> art;
  final Color tint;
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(color: tint),
      child: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          if (art.length > 1)
            Align(
              alignment: const Alignment(-0.62, 0.35),
              child: Text(art[1], style: TextStyle(fontSize: size * 0.72)),
            ),
          if (art.length > 2)
            Align(
              alignment: const Alignment(0.66, -0.4),
              child: Text(art[2], style: TextStyle(fontSize: size * 0.62)),
            ),
          Text(art.first, style: TextStyle(fontSize: size)),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store, this.wide = false});

  final Store store;
  final bool wide;

  @override
  Widget build(BuildContext context) {
    return _Tap(
      onTap: () => Navigator.of(context).pushNamed('/store'),
      child: SizedBox(
        width: wide ? 300 : 248,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: SizedBox(
                height: 128,
                width: double.infinity,
                child: _Cover(art: store.art, tint: store.tint, size: 52),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              store.name,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 2),
            _Meta(store: store),
            if (store.promo != null) ...<Widget>[
              const SizedBox(height: 6),
              _Promo(store.promo!),
            ],
          ],
        ),
      ),
    );
  }
}

class _Meta extends StatelessWidget {
  const _Meta({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    const TextStyle muted = TextStyle(
      fontSize: 13,
      color: AppColors.inkMuted,
      height: 1.3,
    );
    return Text.rich(
      TextSpan(
        style: muted,
        children: <InlineSpan>[
          TextSpan(
            text: '${store.rating}',
            style: const TextStyle(
              color: AppColors.ink,
              fontWeight: FontWeight.w600,
            ),
          ),
          const WidgetSpan(
            alignment: PlaceholderAlignment.middle,
            child: Icon(Icons.star_rounded, size: 14, color: AppColors.ink),
          ),
          TextSpan(text: ' (${store.ratings}) · ${store.minutes} min\n'),
          TextSpan(
            text: store.feeLabel,
            style: store.deliveryFee == 0
                ? const TextStyle(
                    color: AppColors.accentDark,
                    fontWeight: FontWeight.w600,
                  )
                : null,
          ),
        ],
      ),
      maxLines: 2,
    );
  }
}

class _Promo extends StatelessWidget {
  const _Promo(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
      decoration: BoxDecoration(
        color: AppColors.accent,
        borderRadius: BorderRadius.circular(4),
      ),
      child: Text(
        text,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: const TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: AppColors.surface,
        ),
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAdd});

  final Product product;
  final ValueChanged<Product> onAdd;

  @override
  Widget build(BuildContext context) {
    return _Tap(
      onTap: () => Navigator.of(context).pushNamed('/product'),
      child: SizedBox(
        width: 124,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Stack(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 124,
                    height: 112,
                    child: _Cover(
                      art: <String>[product.emoji],
                      tint: product.tint,
                      size: 54,
                    ),
                  ),
                ),
                Positioned(
                  right: 6,
                  bottom: 6,
                  child: _Tap(
                    onTap: () => onAdd(product),
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        shape: BoxShape.circle,
                        boxShadow: AppShadows.e1,
                      ),
                      child: const Icon(Icons.add_rounded, size: 22),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Text.rich(
              TextSpan(
                text: money(product.price),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: product.was != null
                      ? AppColors.accentDark
                      : AppColors.ink,
                ),
                children: <InlineSpan>[
                  if (product.was != null)
                    TextSpan(
                      text: '  ${money(product.was!)}',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                        decoration: TextDecoration.lineThrough,
                      ),
                    ),
                ],
              ),
            ),
            const SizedBox(height: 2),
            Text(
              product.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 1.25,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
            Text(
              product.size,
              style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
            ),
          ],
        ),
      ),
    );
  }
}

class _StoreRow extends StatelessWidget {
  const _StoreRow({required this.store});

  final Store store;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => Navigator.of(context).pushNamed('/store'),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: Row(
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(10),
              child: SizedBox(
                width: 64,
                height: 64,
                child: _Cover(
                  art: store.art.take(1).toList(),
                  tint: store.tint,
                  size: 32,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    store.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  _Meta(store: store),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Empty extends StatelessWidget {
  const _Empty();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: Text(
        'No stores match these filters. Try removing one.',
        style: TextStyle(fontSize: 14, color: AppColors.inkMuted),
      ),
    );
  }
}
