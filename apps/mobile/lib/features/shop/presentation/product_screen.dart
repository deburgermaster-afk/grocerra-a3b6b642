import 'package:flutter/material.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/navigation/app_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';
import '../domain/product_ref.dart';

/// Figma `B4 · Product` — exact 390×844 frame port.
///
/// Frame structure (node `1:255`): hero photo 390×380 at y0 (full bleed
/// under the status bar), white sheet from y340 with a 28 radius top that
/// overlaps the photo by 40, a transparent glass header at y52 (back /
/// store pill / close, all 40 tall), and a fixed 92-tall glass bar at y752
/// with the stepper + Add to cart. The floating tab bar is NOT part of B4.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  static const String routeName = '/product';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedCut = 'Curry cut';
  String _selectedWeight = '1 kg';
  int _quantity = 1;

  static const List<String> _cuts = <String>['Curry cut', 'Mince', 'Boneless'];
  static const List<String> _weights = <String>[
    '500 g',
    '1 kg',
    '2 kg',
    'Custom',
  ];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    // B4 renders the product its caller pushed (the B3 card, a Home tile,
    // a search row); a bare deep link keeps the approved frame's product.
    final Object? arguments = ModalRoute.of(context)?.settings.arguments;
    final ProductRef product = arguments is ProductRef
        ? arguments
        : ProductRef.frameProduct;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          // Scaffold gives its body loose constraints; this full-height
          // sizer makes the Stack fill 390×844 so the bottom bar anchors to
          // the viewport (y752) instead of wrapping to content height.
          const SizedBox.expand(),
          // Scrolling layer: photo at y0, sheet from y340, content ends y743.
          Positioned.fill(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(bottom: 92),
              child: Stack(
                children: <Widget>[
                  // Hero 390×380 at y0 (`1:256`). Photo asset when the
                  // caller has one; the app's catalogue products are emoji
                  // tiles, so they render the tinted emoji cover; a bare
                  // deep link falls back to the frame's own photo.
                  _buildHero(product),
                  // White sheet `1:257` — 390 wide, starts y340, radius 28
                  // on top, overlapping the photo by 40px.
                  Padding(
                    padding: const EdgeInsets.only(top: 340),
                    child: Container(
                      width: 390,
                      decoration: const BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.vertical(
                          top: Radius.circular(28),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            // Product name 26/700 — y364..395
                            Text(
                              product.name,
                              style: const TextStyle(
                                fontSize: 26,
                                height: 31 / 26,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            // name ends y395 → tags y402
                            const SizedBox(height: 7),
                            // Pills row: Halal certified + Chilled + In stock
                            const Row(
                              children: <Widget>[
                                // B4 chips: 26h r13, 13px side padding, 12/600.
                                TagPill(
                                  label: 'Halal certified',
                                  background: AppColors.surfaceAlt,
                                  foreground: AppColors.success,
                                  fontSize: 12,
                                  radius: 13,
                                  height: 26,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 5.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                TagPill(
                                  label: 'Chilled',
                                  background: AppColors.surfaceAlt,
                                  foreground: AppColors.ink,
                                  fontSize: 12,
                                  radius: 13,
                                  height: 26,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 5.5,
                                  ),
                                ),
                                SizedBox(width: 8),
                                TagPill(
                                  label: 'In stock',
                                  background: AppColors.surfaceAlt,
                                  // `#047A43` status/success (Figma `1:304`).
                                  foreground: AppColors.success,
                                  fontSize: 12,
                                  radius: 13,
                                  height: 26,
                                  padding: EdgeInsets.symmetric(
                                    horizontal: 13,
                                    vertical: 5.5,
                                  ),
                                ),
                              ],
                            ),
                            // tags end y428 → price y440
                            const SizedBox(height: 12),
                            // Price 22/600 — y440..467 (B3/B4 mock prices
                            // are per kg, as the frame prints them).
                            Text(
                              '\$${product.price.toStringAsFixed(2)} / kg',
                              style: const TextStyle(
                                fontSize: 22,
                                height: 27 / 22,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            // price ends y467 → description y474
                            const SizedBox(height: 7),
                            // Description 14/400 #6b6b6b — y474..508. The
                            // frame's own copy shows when the caller did not
                            // provide one.
                            Text(
                              product.description ??
                                  'Bone-in pieces from young goat, cut small '
                                      'for curries. Packed fresh and sealed '
                                      'on the day.',
                              style: const TextStyle(
                                fontSize: 14,
                                height: 17 / 14,
                                fontWeight: FontWeight.w400,
                                color: AppColors.inkMuted,
                              ),
                            ),
                            // description ends y508 → "Cut" y532
                            const SizedBox(height: 24),
                            _buildSectionLabel('Cut'),
                            // label ends y551 → pills y560
                            const SizedBox(height: 9),
                            _buildSegmentedRow(_cuts, _selectedCut, (v) {
                              setState(() => _selectedCut = v);
                            }),
                            // pills end y596 → "Weight" y608
                            const SizedBox(height: 12),
                            _buildSectionLabel('Weight'),
                            // label ends y627 → pills y636
                            const SizedBox(height: 9),
                            _buildSegmentedRow(_weights, _selectedWeight, (v) {
                              setState(() => _selectedWeight = v);
                            }),
                            // pills end y672 → instructions field y682
                            const SizedBox(height: 10),
                            // Instructions field 358×40 r12 (`1:281`)
                            Container(
                              width: 358,
                              height: 40,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 12,
                              ),
                              decoration: const BoxDecoration(
                                color: AppColors.surfaceAlt,
                                borderRadius: BorderRadius.all(
                                  Radius.circular(12),
                                ),
                              ),
                              child: TextField(
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 17 / 14,
                                  color: AppColors.ink,
                                ),
                                decoration: const InputDecoration(
                                  isDense: true,
                                  hintText:
                                      'Special instructions (e.g. small pieces)',
                                  hintStyle: TextStyle(
                                    fontSize: 14,
                                    height: 17 / 14,
                                    fontWeight: FontWeight.w400,
                                    color: AppColors.inkMuted,
                                  ),
                                  filled: false,
                                  contentPadding: EdgeInsets.zero,
                                  border: InputBorder.none,
                                ),
                              ),
                            ),
                            // field ends y722 → disclaimer y728
                            const SizedBox(height: 6),
                            // Disclaimer 12/400 — y728..743
                            const Text(
                              'Final price is set at packing, based on actual '
                              'weight.',
                              style: TextStyle(
                                fontSize: 12,
                                height: 15 / 12,
                                fontWeight: FontWeight.w400,
                                color: AppColors.inkMuted,
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
          ),
          // Transparent glass header: back x16, store pill x107, close x334,
          // all y52 (5 under the status band). On web SafeArea is a
          // no-op, so position with the app's own inset token directly.
          Padding(
            padding: EdgeInsets.only(top: topInset + 5),
            child: Row(
              children: <Widget>[
                const SizedBox(width: 16),
                // Back button 40×40 — plain control, no circle fill (the
                // app's standing back-button treatment).
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  icon: const Icon(Icons.arrow_back_rounded, size: 24),
                  onPressed: () => popOrFallback(context, '/store'),
                  tooltip: 'Back',
                ),
                const Spacer(),
                // Store name pill 176×40 glass r20 (`1:301`)
                _GlassBox(
                  width: 176,
                  height: 40,
                  radius: 20,
                  alignment: Alignment.center,
                  child: Text(
                    product.storeName ?? 'Madina Halal Meats',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 16 / 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const Spacer(),
                // Close button 40×40 — plain control, no circle fill.
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints.tightFor(
                    width: 40,
                    height: 40,
                  ),
                  icon: const Icon(Icons.close, size: 24),
                  onPressed: () => popOrFallback(context, '/store'),
                  tooltip: 'Close',
                ),
                const SizedBox(width: 16),
              ],
            ),
          ),
          // Fixed glass bottom bar 390×92 at y752 (`1:284`): white glass,
          // hairline, Elevation-2 shadow; stepper y768 (pad top 16) with 24
          // below it.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 92,
              decoration: const BoxDecoration(
                color: AppColors.glassControl,
                border: Border.fromBorderSide(
                  BorderSide(color: AppColors.glassControlStroke),
                ),
                boxShadow: AppShadows.e2,
              ),
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
              child: Row(
                children: <Widget>[
                  // Stepper 120×52 `#f3f3f3` r26 (`1:285`): minus x30,
                  // 18px gaps, plus ends x122 (14 pad both sides).
                  Container(
                    width: 120,
                    height: 52,
                    decoration: const BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.all(Radius.circular(26)),
                    ),
                    child: Row(
                      children: <Widget>[
                        const SizedBox(width: 14),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 24,
                            height: 24,
                          ),
                          icon: const AppIcon('minus', size: 24),
                          onPressed: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                        ),
                        const SizedBox(width: 18),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 19 / 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 18),
                        IconButton(
                          padding: EdgeInsets.zero,
                          constraints: const BoxConstraints.tightFor(
                            width: 24,
                            height: 24,
                          ),
                          icon: const AppIcon('plus', size: 24),
                          onPressed: () => setState(() => _quantity++),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to cart button 226×52 pill (`1:291`).
                  // Figma prototype reaction on `1:291`: NAVIGATE -> 4:16 (Cart)
                  // with SMART_ANIMATE 200ms. Match that behavior.
                  Expanded(
                    child: AppButton(
                      label:
                          'Add to cart · \$${(product.price * _quantity).toStringAsFixed(2)}',
                      height: 52,
                      onPressed: () {
                        // Real cart mutation (offline demo state): the same
                        // product merges onto its existing line, and the
                        // shared cart bar plus the C09 totals update at once.
                        CartStore.instance.add(
                          CartItem(
                            id: product.id,
                            name: product.name,
                            price: product.price,
                            image: product.image,
                            emoji: product.emoji,
                            detail: '$_selectedWeight · $_selectedCut',
                            quantity: _quantity,
                          ),
                        );
                        // Follow the prototype: go to Cart.
                        if (!context.mounted) return;
                        Navigator.of(context).pushNamed('/cart');
                      },
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Hero photo (asset), or the catalogue emoji tile when the pushed
  /// product has no photo (Home catalogue products), or the frame's photo.
  Widget _buildHero(ProductRef product) {
    if (product.image == null && product.emoji != null) {
      return Container(
        width: 390,
        height: 380,
        color: product.tint ?? AppColors.surfaceAlt,
        alignment: Alignment.center,
        child: Text(product.emoji!, style: const TextStyle(fontSize: 96)),
      );
    }
    // Container requires a `decoration` (not `color`) whenever it clips.
    return Container(
      width: 390,
      height: 380,
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(color: AppColors.surfaceAlt),
      child: Image.asset(
        // The hero shows the pushed product's own photo; the frame's photo
        // stays the default for a bare deep link.
        'assets/icons/${product.image ?? 'product_hero.png'}',
        width: 390,
        height: 380,
        fit: BoxFit.cover,
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        height: 19 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildSegmentedRow(
    List<String> options,
    String selected,
    ValueChanged<String> onSelect,
  ) {
    // Figma pills are content-width (92/72/92 and 72/64/64/80) with 8px
    // gaps, left-packed - not equal-width segments.
    return Row(
      children: <Widget>[
        for (int i = 0; i < options.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 8),
          _SegmentButton(
            label: options[i],
            selected: options[i] == selected,
            onTap: () => onSelect(options[i]),
          ),
        ],
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          // Selected = pure black, idle = `#0000000f` (B4 pills).
          color: selected ? AppColors.ink : AppColors.overlaySoft,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 16),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            height: 17 / 14,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.surface : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

/// Glass surface used by the B4 header pill: translucent white, hairline
/// stroke, Elevation-2 drop shadow (Figma `1:301`).
class _GlassBox extends StatelessWidget {
  const _GlassBox({
    required this.width,
    required this.height,
    required this.radius,
    required this.child,
    this.alignment,
  });

  final double width;
  final double height;
  final double radius;
  final Widget child;
  final Alignment? alignment;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      alignment: alignment,
      decoration: BoxDecoration(
        color: AppColors.glassControl,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.glassControlStroke),
        boxShadow: AppShadows.e2,
      ),
      child: child,
    );
  }
}
