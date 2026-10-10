import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `B5 · Cart v2` — exact 390×844 frame port.
///
/// One listener drives the whole screen: rows, the store count, the
/// checkout total and the empty state all re-read [CartStore] on every
/// mutation, so totals update immediately. The place-order bar floats over
/// the scroll content at the bottom — scroll padding clears it — and only
/// exists while the cart has items (a CTA over an empty cart would show a
/// stale total). The floating tab bar is owned by `HomeShell`.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const String routeName = '/cart';

  /// Scroll clearance for the pinned place-order bar (subtotal row + savings
  /// banner + 56px CTA + its paddings).
  static const double _barHeight = 175;

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListenableBuilder(
        listenable: CartStore.instance,
        builder: (BuildContext context, Widget? _) {
          final bool empty = CartStore.instance.isEmpty;
          return Stack(
            children: <Widget>[
              // Positioned.fill keeps the Stack full-height (the Scaffold's
              // body constraints are loose), so the pinned bar below always
              // sits at the bottom of the screen.
              Positioned.fill(
                child: SingleChildScrollView(
                  padding: EdgeInsets.fromLTRB(
                    0,
                    topInset,
                    0,
                    empty ? 32 : _barHeight + 16,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildHeader(context),
                      if (empty)
                        _buildEmptyState(context)
                      else ...<Widget>[
                        _buildStoreHeader(),
                        _buildItems(),
                        _buildAddItemsRow(context),
                        _buildGiftRow(context),
                      ],
                      _buildSectionBreak(),
                      _buildOffersSection(),
                      _buildSectionBreak(),
                      _buildOptionsSection(),
                    ],
                  ),
                ),
              ),
              if (!empty)
                Positioned(
                  left: 0,
                  right: 0,
                  bottom: 0,
                  child: _buildPlaceOrderBar(context),
                ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Row(
        children: <Widget>[
          // Plain back arrow, like the reference flow's bare glyphs.
          IconButton(
            tooltip: 'Back',
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 26,
              color: AppColors.ink,
            ),
            onPressed: () async {
              // Pushed straight into (deep link, demo entry): fall back to
              // Home so back never strands the shopper.
              final bool popped = await Navigator.of(context).maybePop();
              if (!popped && context.mounted) {
                Navigator.of(
                  context,
                ).pushNamedAndRemoveUntil('/home', (Route<dynamic> _) => false);
              }
            },
          ),
          const SizedBox(width: 4),
          const Text(
            'Your cart',
            style: TextStyle(
              fontSize: 24,
              height: 29 / 24,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  /// The count is the live unit count, not a stored figure.
  Widget _buildStoreHeader() {
    final int count = CartStore.instance.itemCount;
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: Text(
        'Madina Halal Meats · $count ${count == 1 ? 'item' : 'items'}',
        style: const TextStyle(
          fontSize: 13,
          height: 16 / 13,
          fontWeight: FontWeight.w400,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }

  /// Rows are the live cart lines: photo, variant and price come straight
  /// from [CartStore], so every add/remove and stepper tap reflects
  /// immediately. Price is the line total (unit × qty).
  Widget _buildItems() {
    final List<CartItem> items = CartStore.instance.items;
    final List<Widget> rows = <Widget>[];
    for (int i = 0; i < items.length; i++) {
      if (i > 0) {
        rows.add(_buildDivider());
      }
      final CartItem item = items[i];
      rows.add(
        _CartItem(
          image: item.image,
          emoji: item.emoji,
          name: item.name,
          detail: item.detail ?? '',
          price: '\$${item.lineTotal.toStringAsFixed(2)}',
          quantity: item.quantity,
          onQuantityChanged: (int q) =>
              CartStore.instance.setQuantity(item.id, q),
        ),
      );
    }
    return Column(children: rows);
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildAddItemsRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[_buildAddItemsPill(context)],
      ),
    );
  }

  /// The `Add items` pill 121×37 #f3f3f3 — the way out of both the filled
  /// cart and the empty state, so it is built once here.
  Widget _buildAddItemsPill(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(18.5),
      child: InkWell(
        borderRadius: BorderRadius.circular(18.5),
        onTap: () => Navigator.of(context).pushNamed('/store'),
        child: const SizedBox(
          width: 121,
          height: 37,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(Icons.add, size: 16, color: AppColors.ink),
              SizedBox(width: 6),
              Text(
                'Add items',
                style: TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// `Send as a gift` row (reference: gift glyph, title + caption, chevron),
  /// between the items block and the offers.
  Widget _buildGiftRow(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 4),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.md),
        onTap: () => ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(
            const SnackBar(
              behavior: SnackBarBehavior.floating,
              backgroundColor: AppColors.ink,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
              ),
              content: Text(
                'Gift messages are coming soon',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.surface,
                ),
              ),
            ),
          ),
        child: const Padding(
          padding: EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: <Widget>[
              Icon(Icons.card_giftcard, size: 22, color: AppColors.ink),
              SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      'Send as a gift',
                      style: TextStyle(
                        fontSize: 16,
                        height: 19 / 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'And customise a digital card',
                      style: TextStyle(
                        fontSize: 13,
                        height: 16 / 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              Icon(Icons.chevron_right, size: 20, color: AppColors.inkMuted),
            ],
          ),
        ),
      ),
    );
  }

  /// Empty cart: icon bubble, centred copy, and the frame's own `Add items`
  /// pill as the way out. The place-order bar and its stale total are gone
  /// with the rows above.
  Widget _buildEmptyState(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 40, 16, 16),
      child: Column(
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.shopping_bag_outlined,
              size: 28,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          const Text(
            'Your cart is empty',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 24),
          Center(child: _buildAddItemsPill(context)),
        ],
      ),
    );
  }

  Widget _buildSectionBreak() {
    return Container(height: 8, color: AppColors.surfaceAlt);
  }

  Widget _buildOffersSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Offers for you',
            style: TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          SizedBox(
            height: 243,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _offers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) =>
                  _OfferCard(offer: _offers[index]),
            ),
          ),
        ],
      ),
    );
  }

  /// Figma shows only the ice-pack row here; the band runs flush after the
  /// section break: row + divider.
  Widget _buildOptionsSection() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: <Widget>[
          _OptionRow(
            icon: Icons.ac_unit,
            label: 'Request ice pack for meat',
            trailing: _IcePackCheckbox(),
          ),
          // Divider x16 — the section padding already supplies the 16.
          SizedBox(height: 1, child: ColoredBox(color: AppColors.hairline)),
        ],
      ),
    );
  }

  /// Place-order bar pinned at the bottom: subtotal row, the full-width
  /// savings banner flush below it, then the 56px CTA. White with the
  /// upward `topBar` lift so content scrolls beneath it.
  Widget _buildPlaceOrderBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.topBar,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          // Subtotal row (reference: label left, live amount right).
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Subtotal',
                  style: TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w400,
                    color: AppColors.ink,
                  ),
                ),
                Text(
                  '\$${CartStore.instance.subtotal.toStringAsFixed(2)}',
                  style: const TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          // Savings banner 390×38 #f3f3f3, square corners.
          Container(
            height: 38,
            color: AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.local_offer, size: 18, color: AppColors.ink),
                SizedBox(width: 10),
                Text(
                  'Saving \$2.50 with offers',
                  style: TextStyle(
                    fontSize: 14,
                    height: 17 / 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
            // The upsell step ("People also ordered") leads into checkout,
            // as in the reference flow.
            child: FilledButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed('/checkout/upsell'),
              child: const Text('Go to checkout'),
            ),
          ),
        ],
      ),
    );
  }
}

class _CartItem extends StatelessWidget {
  const _CartItem({
    this.image,
    this.emoji,
    required this.name,
    required this.detail,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  /// Photo fill asset name under `assets/icons/`.
  final String? image;

  /// Catalogue emoji thumb for lines without a photo asset.
  final String? emoji;
  final String name;
  final String detail;
  final String price;
  final int quantity;
  final ValueChanged<int> onQuantityChanged;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: SizedBox(
        height: 88,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Thumb 64×64 r12 photo fill.
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(top: 12),
              clipBehavior: Clip.antiAlias,
              decoration: const BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.all(Radius.circular(12)),
              ),
              child: image != null
                  ? Image.asset(
                      'assets/icons/$image',
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                    )
                  : emoji != null
                  ? Center(
                      child: Text(emoji!, style: const TextStyle(fontSize: 26)),
                    )
                  : null,
            ),
            const SizedBox(width: 12),
            // Info
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(top: 12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 16,
                        height: 19 / 16,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      detail,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        height: 16 / 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(width: 12),
            // Price + stepper
            SizedBox(
              width: 84,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: <Widget>[
                  const SizedBox(height: 12),
                  Text(
                    price,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 19 / 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Stepper 84×30 #f3f3f3 r16. Visual geometry stays
                  // exactly 84×30; the whole pill is one hit target — tap
                  // the left half for minus, the right half for plus — so
                  // the control is comfortably tappable without widening
                  // the Figma cell. Minus on the last unit removes the
                  // line (there is no separate delete affordance).
                  GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTapDown: (TapDownDetails details) {
                      final RenderBox renderBox =
                          context.findRenderObject()! as RenderBox;
                      final Offset local = renderBox.globalToLocal(
                        details.globalPosition,
                      );
                      HapticFeedback.selectionClick();
                      if (local.dx < 42) {
                        onQuantityChanged(quantity - 1);
                      } else {
                        onQuantityChanged(quantity + 1);
                      }
                    },
                    child: Container(
                      width: 84,
                      height: 30,
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Row(
                        children: <Widget>[
                          const SizedBox(width: 10),
                          const Icon(
                            Icons.remove,
                            size: 16,
                            color: AppColors.ink,
                          ),
                          const SizedBox(width: 12),
                          Text(
                            '$quantity',
                            style: const TextStyle(
                              fontSize: 15,
                              height: 18 / 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(width: 12),
                          const Icon(Icons.add, size: 16, color: AppColors.ink),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IcePackCheckbox extends StatefulWidget {
  const _IcePackCheckbox();

  @override
  State<_IcePackCheckbox> createState() => _IcePackCheckboxState();
}

class _IcePackCheckboxState extends State<_IcePackCheckbox> {
  bool _on = false;

  @override
  Widget build(BuildContext context) {
    return Checkbox(
      value: _on,
      onChanged: (bool? v) => setState(() => _on = v ?? false),
      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
      visualDensity: VisualDensity.compact,
      side: const BorderSide(color: AppColors.hairline),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(6)),
    );
  }
}

class _Offer {
  const _Offer({
    required this.name,
    required this.price,
    required this.wasPrice,
    required this.image,
  });

  final String name;

  /// Current price 15/600 + struck-through original 13/400.
  final String price;
  final String wasPrice;

  /// Photo fill asset name under `assets/icons/`.
  final String image;
}

final List<_Offer> _offers = <_Offer>[
  _Offer(
    name: 'Chicken Drumsticks 1 kg',
    price: '\$11.19',
    wasPrice: '\$15.99',
    image: 'offer_drumsticks.png',
  ),
  _Offer(
    name: 'Lamb Mince 500 g',
    price: '\$9.79',
    wasPrice: '\$13.99',
    image: 'offer_lamb_mince.png',
  ),
  _Offer(
    name: 'Jasmine Rice 2 kg',
    price: '\$6.29',
    wasPrice: '\$8.99',
    image: 'offer_jasmine.png',
  ),
];

class _OfferCard extends StatelessWidget {
  const _OfferCard({required this.offer});

  final _Offer offer;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 150,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Photo 150×150 r16 with a 36px glass `Add` circle bottom-right.
          Stack(
            children: <Widget>[
              Container(
                width: 150,
                height: 150,
                clipBehavior: Clip.antiAlias,
                decoration: const BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.all(Radius.circular(16)),
                ),
                child: Image.asset(
                  'assets/icons/${offer.image}',
                  width: 150,
                  height: 150,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                right: 8,
                bottom: 8,
                child: Material(
                  color: const Color(0xF2FFFFFF),
                  shape: const CircleBorder(),
                  child: InkWell(
                    customBorder: const CircleBorder(),
                    onTap: () {},
                    child: const SizedBox(
                      width: 36,
                      height: 36,
                      child: Center(
                        child: Icon(Icons.add, size: 18, color: AppColors.ink),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Two lines of space are reserved whatever the name's length, so
          // every card is the same height and the price / tag rows line up
          // across the carousel.
          SizedBox(
            height: 36,
            child: Text(
              offer.name,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 15,
                height: 18 / 15,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: <Widget>[
              Text(
                offer.price,
                style: const TextStyle(
                  fontSize: 15,
                  height: 18 / 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                offer.wasPrice,
                style: const TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.inkMuted,
                  decoration: TextDecoration.lineThrough,
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Promo tag: black fill, white 12/500.
          TagPill(
            label: '30% off',
            background: AppColors.ink,
            foreground: AppColors.surface,
            fontSize: 12,
            radius: 6,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({required this.icon, required this.label, this.trailing});

  final IconData icon;
  final String label;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 17),
      child: Row(
        children: <Widget>[
          Icon(icon, size: 22, color: AppColors.ink),
          const SizedBox(width: 14),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 16,
                height: 19 / 16,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
          if (trailing case final w?) w,
        ],
      ),
    );
  }
}
