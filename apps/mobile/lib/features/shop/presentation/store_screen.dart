import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/navigation/app_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/cart_bar.dart';
import '../../../core/widgets/glass_add_button.dart';
import '../../../core/widgets/glass_tab_bar.dart';
import '../../../core/widgets/tag_pill.dart';
import '../../shell/presentation/home_shell.dart';
import '../domain/product_ref.dart';

/// Figma `B3 · Store · Madina Halal Meats` — exact 390×844 frame port.
///
/// The frame is taller than 844 due to the product grid. This screen scrolls
/// under a glass header (back, title, search, store info, category chips);
/// the black cart bar floats 96px above the frame bottom and the floating
/// tab bar is rendered on top (B3 shows it).
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  static const String routeName = '/store';

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedCategory = 1; // 0=All, 1=Meat, etc.

  // Widths are Figma's `Chip · *` frame widths (`1:235`…`1:249`): the pills
  // hug their labels with 16px side padding, and Flutter's text advance
  // differs from Figma's by up to 1px per label — without pinning, each chip
  // drifts and the cumulative error pushes Dairy's label off-screen.
  static const List<_CategoryChip> _categories = <_CategoryChip>[
    _CategoryChip('All', 49),
    _CategoryChip('Meat', 67),
    _CategoryChip('Rice & Grains', 121),
    _CategoryChip('Spices', 77),
    _CategoryChip('Dairy', 68),
    _CategoryChip('Fresh Produce', 129),
    _CategoryChip('Frozen', 78),
    _CategoryChip('Sweets', 82),
  ];

  // Mock catalogue (B3): offline demo data only, no backend behind it. Each
  // card pushes its own `ProductRef` onto `/product` so B4 and the cart line
  // show the same product.
  static const List<_Product> _products = <_Product>[
    _Product(
      id: 'baby-goat-shoulder',
      name: 'Baby Goat Shoulder',
      variants: '500 g · 1 kg · 2 kg',
      price: 19.99,
      image: 'prod_goat_shoulder.png',
    ),
    _Product(
      id: 'baby-goat-leg',
      name: 'Baby Goat Leg',
      variants: '1 kg · 1.5 kg · 2 kg',
      price: 21.50,
      image: 'prod_baby_goat_leg.png',
      extraTag: 'Only 3 left',
    ),
    _Product(
      id: 'goat-curry-cut',
      name: 'Goat Curry Cut',
      variants: '500 g · 1 kg · 2 kg',
      price: 16.99,
      image: 'prod_goat_curry.png',
    ),
    _Product(
      id: 'lamb-leg',
      name: 'Lamb Leg',
      variants: 'Whole · 2 kg',
      price: 19.00,
      // Figma `1:157` carries the photo fill (the node named "Sold out
      // overlay" is the image itself; `1:156` is a hidden gradient).
      image: 'prod_lamb_leg.png',
      isSoldOut: true,
    ),
    _Product(
      id: 'goat-mince',
      name: 'Goat Mince',
      variants: '500 g · 1 kg',
      price: 15.99,
      image: 'prod_goat_mince.png',
    ),
    _Product(
      id: 'lamb-chops',
      name: 'Lamb Chops',
      variants: '1 kg · 2 kg',
      price: 24.99,
      image: 'prod_lamb_chops.png',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          // Full-height sizer: Scaffold body constraints are loose, so the
          // Stack needs a 844-tall child for `bottom: 96` and the tab bar
          // to anchor to the viewport instead of the scroll extent.
          const SizedBox.expand(),
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, 0, 0, AppInsets.tabBar),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildGlassHeader(topInset),
                _buildSectionHeader(),
                const SizedBox(height: 14),
                _buildProductGrid(),
                const SizedBox(height: 76), // cart bar clearance
              ],
            ),
          ),
          // Cart bar 358×56, 96px above the frame bottom (B3 y692). The count
          // and total come from the shared cart, so B3 and C09 agree instead
          // of carrying the frame's hardcoded figures. The handoff marks it
          // "only when cart has items" (`58212:2424`), so an empty cart shows
          // no bar.
          Positioned(
            left: 16,
            right: 16,
            bottom: 96,
            child: ListenableBuilder(
              listenable: CartStore.instance,
              builder: (BuildContext context, Widget? _) {
                if (CartStore.instance.isEmpty) {
                  return const SizedBox.shrink();
                }
                return CartBar(
                  itemCount: CartStore.instance.itemCount,
                  total: '\$${CartStore.instance.subtotal.toStringAsFixed(2)}',
                  onTap: () => Navigator.of(context).pushNamed('/cart'),
                );
              },
            ),
          ),
          // B3 shows the floating tab bar; a tab tap rebuilds the shell on
          // that tab, dropping the store page. Store is opened from Home
          // (index 0).
          GlassTabBar(
            index: 0,
            onSelect: (int value) => Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute<void>(
                builder: (_) => HomeShell(initialIndex: value),
              ),
              (_) => false,
            ),
            onSearchTap: () => Navigator.of(context).pushNamed('/search'),
          ),
        ],
      ),
    );
  }

  /// Glass header: `#ffffffad` backdrop covering the status band, back,
  /// 22/700 title, bare search glyph, store info indented to x68 and the
  /// category chips below. Height hugs its content so it works with the
  /// app's own status-bar inset instead of the frame's fixed 47px band.
  Widget _buildGlassHeader(double topInset) {
    return Container(
      // Figma glass `1:183`: `s1` fill (white 68%, = glassControl) + Elevation
      // 2's drop shadow drawn behind it.
      decoration: const BoxDecoration(
        color: AppColors.glassControl,
        boxShadow: AppShadows.e2,
      ),
      padding: EdgeInsets.fromLTRB(16, topInset + 5, 16, 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            // Figma title node y57 — align start and pad the text down to
            // the node top.
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Back: plain control, no circle fill (the app's standing
              // back-button treatment).
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 24),
                onPressed: () => popOrFallback(context, '/home'),
                tooltip: 'Back',
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: Text(
                    'Madina Halal Meats',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 27 / 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
              // Bare `icon/search` 24 glyph at (334,60) — box nudged 8 in
              // so the centered glyph lands on Figma's x334, not x342.
              Padding(
                padding: const EdgeInsets.only(right: 8),
                child: Semantics(
                  button: true,
                  label: 'Search',
                  child: InkWell(
                    onTap: () => Navigator.of(context).pushNamed('/search'),
                    child: const SizedBox(
                      width: 40,
                      height: 40,
                      child: Center(child: AppIcon('search', size: 24)),
                    ),
                  ),
                ),
              ),
            ],
          ),
          // Store info sits under the title, indented to x68 (16 + 52).
          const SizedBox(height: 3),
          const Padding(
            padding: EdgeInsets.only(left: 52),
            child: Row(
              children: <Widget>[
                AppIcon('star', size: 12),
                SizedBox(width: 4),
                Text(
                  '4.8',
                  style: TextStyle(
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                // Figma `4.8` ends x105, subtitle starts x109.
                SizedBox(width: 4),
                Expanded(
                  child: Text(
                    '(320) · About 60 min · \$5.99 delivery',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 13,
                      height: 16 / 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 13),
          // Figma's chips frame (`1:234`) is 727 wide starting at x16 and
          // the SCREEN clips it at 390. The header's 16px right padding
          // would clip the row at x374 and hide the Dairy chip's label
          // entirely, so the row is given the full 374px viewport and
          // overflows its content box by those same 16px.
          SizedBox(
            height: 36,
            child: OverflowBox(
              alignment: Alignment.topLeft,
              maxWidth: 374,
              child: _buildCategoryChips(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _categories[index];
          final isSelected = index == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              width: chip.width,
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.ink : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                chip.label,
                style: TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.surface : AppColors.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text('Goat & Lamb', style: Theme.of(context).textTheme.titleLarge),
          const Text(
            '6 items',
            style: TextStyle(
              fontSize: 13,
              height: 16 / 13,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          for (int row = 0; row < 3; row++) ...<Widget>[
            // Rows pitch 232: card 213 tall + 19 gap (Figma y222/454/686).
            if (row > 0) const SizedBox(height: 19),
            Row(
              children: <Widget>[
                Expanded(child: _ProductCard(product: _products[row * 2])),
                const SizedBox(width: 16),
                Expanded(child: _ProductCard(product: _products[row * 2 + 1])),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip {
  const _CategoryChip(this.label, this.width);
  final String label;

  /// Figma `Chip · *` frame width (see `_categories`).
  final double width;
}

class _Product {
  const _Product({
    required this.id,
    required this.name,
    required this.variants,
    required this.price,
    this.image,
    this.extraTag,
    this.isSoldOut = false,
  });

  /// Product identity (the B3 mock catalogue has no backend ids yet).
  final String id;
  final String name;
  final String variants;

  /// Unit price; the card prints `$x.xx / kg` exactly as B3 does.
  final double price;

  /// Figma photo fill asset under `assets/icons/`.
  final String? image;

  /// Second on-image pill (`Only 3 left` on Baby Goat Leg).
  final String? extraTag;
  final bool isSoldOut;

  /// The `/product` argument this card opens B4 with.
  ProductRef toRef() =>
      ProductRef(id: id, name: name, price: price, image: image);
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool soldOut = product.isSoldOut;
    // Sold-out rows use `#8a8a8a` (inkFaint); live rows `#000000`.
    final Color nameColor = soldOut ? AppColors.inkFaint : AppColors.ink;

    final Widget card = Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image 171×150 r16 with pills top-left and the glass plus bottom-right.
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 171,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(16),
              ),
              clipBehavior: Clip.antiAlias,
              child: product.image != null
                  ? Image.asset(
                      'assets/icons/${product.image}',
                      width: 171,
                      height: 150,
                      fit: BoxFit.cover,
                    )
                  : null,
            ),
            // Pills: `Halal` success-green + optional extra pill, 6px apart.
            Positioned(
              left: 8,
              top: 8,
              child: Row(
                children: <Widget>[
                  const TagPill(
                    label: 'Halal',
                    // `#047A43` (color/status/success, Figma `1:130`).
                    background: AppColors.success,
                    foreground: AppColors.surface,
                    // B3 pills are 50 wide (text 27 + 11.5 each side).
                    height: 22,
                    radius: 11,
                    padding: EdgeInsets.symmetric(horizontal: 11.5),
                  ),
                  if (product.extraTag != null) ...<Widget>[
                    const SizedBox(width: 6),
                    TagPill(
                      label: product.extraTag!,
                      height: 22,
                      radius: 11,
                      padding: const EdgeInsets.symmetric(horizontal: 11.5),
                    ),
                  ],
                ],
              ),
            ),
            if (soldOut)
              // `Sold out` pill bottom-left of the image (B3 y572). Figma
              // status/danger is `#e11900`.
              const Positioned(
                left: 8,
                bottom: 8,
                child: TagPill(
                  label: 'Sold out',
                  background: Color(0xFFE11900),
                  foreground: AppColors.surface,
                  height: 22,
                  radius: 11,
                  padding: EdgeInsets.symmetric(horizontal: 11.5),
                ),
              ),
            // Plus: 36×36 glass circle + `icon/plus` 20 (Figma `Glass`
            // nodes `1:132`+ carry a 1px inside stroke) — shared widget.
            // Adds the card's product to the demo cart; the cart bar above
            // is the feedback.
            Positioned(
              right: 8,
              bottom: 8,
              child: GlassAddButton(
                onTap: soldOut
                    ? null
                    : () {
                        HapticFeedback.selectionClick();
                        CartStore.instance.add(
                          CartItem(
                            id: product.id,
                            name: product.name,
                            price: product.price,
                            image: product.image,
                            detail: product.variants,
                          ),
                        );
                      },
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 17 / 14,
            color: nameColor,
          ),
        ),
        // Figma: name ends y397, detail starts y400.
        const SizedBox(height: 3),
        Text(
          product.variants,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 13,
            height: 16 / 13,
            fontWeight: FontWeight.w400,
            color: soldOut ? AppColors.inkFaint : AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          // B3 prints the unit price as `$x.xx / kg`.
          '\$${product.price.toStringAsFixed(2)} / kg',
          style: TextStyle(
            fontSize: 14,
            height: 17 / 14,
            fontWeight: FontWeight.w600,
            color: nameColor,
          ),
        ),
      ],
    );

    // B3's card opens B4 with the product it shows, so the screen and the
    // cart line describe the same item. A sold-out card has no approved
    // destination state, so it stays inert instead of gaining invented
    // behavior.
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: soldOut
          ? null
          : () =>
                Navigator.of(context)
                    .pushNamed('/product', arguments: product.toRef()),
      child: card,
    );
  }
}
