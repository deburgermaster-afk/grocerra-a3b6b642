import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `B5 · Cart v2` — exact 390×844 frame port.
///
/// The frame is taller than 844 with all content; this screen scrolls with
/// a fixed glass header (back, title) and the cart content below. The floating
/// tab bar is owned by `HomeShell`; we pad the bottom by `AppInsets.tabBar`.
class CartScreen extends StatelessWidget {
  const CartScreen({super.key});

  static const String routeName = '/cart';

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, topInset, 0, AppInsets.tabBar),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(context),
            _buildStoreHeader(),
            _buildItems(),
            _buildAddItemsRow(context),
            _buildSectionBreak(),
            _buildOffersSection(),
            _buildSectionBreak(),
            _buildOptionsSection(),
            _buildPlaceOrderBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          // Back button 40×40 #f3f3f3
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(20),
            ),
            child: IconButton(
              padding: EdgeInsets.zero,
              icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.ink),
              onPressed: () => Navigator.of(context).maybePop(),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Your cart',
            style: const TextStyle(
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

  Widget _buildStoreHeader() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 0, 16, 8),
      child: Text(
        'Madina Halal Meats · 3 items',
        style: TextStyle(
          fontSize: 13,
          height: 16 / 13,
          fontWeight: FontWeight.w400,
          color: AppColors.inkMuted,
        ),
      ),
    );
  }

  Widget _buildItems() {
    return Column(
      children: <Widget>[
        _CartItem(
          image: null,
          name: 'Goat Curry Cut',
          detail: '1 kg · Curry cut',
          price: '\$16.99',
          quantity: 1,
          onQuantityChanged: (int q) {},
        ),
        _buildDivider(),
        _CartItem(
          image: null,
          name: 'Chicken Curry Pieces',
          detail: '2 kg · Est. weight',
          price: '\$21.00',
          quantity: 1,
          onQuantityChanged: (int q) {},
        ),
        _buildDivider(),
        _CartItem(
          image: null,
          name: 'Basmati Rice',
          detail: '5 kg bag',
          price: '\$15.99',
          quantity: 1,
          onQuantityChanged: (int q) {},
        ),
      ],
    );
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
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: <Widget>[
          // "Add items" pill 121×37 #f3f3f3
          Material(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(18.5),
            child: InkWell(
              borderRadius: BorderRadius.circular(18.5),
              onTap: () => Navigator.of(context).pushNamed('/store'),
              child: SizedBox(
                width: 121,
                height: 37,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Icon(Icons.add, size: 16, color: AppColors.ink),
                    const SizedBox(width: 6),
                    const Text(
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
          ),
        ],
      ),
    );
  }

  Widget _buildSectionBreak() {
    return Container(
      height: 8,
      color: AppColors.surfaceAlt,
    );
  }

  Widget _buildOffersSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            'Offers for you',
            style: const TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 243,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: EdgeInsets.zero,
              itemCount: _offers.length,
              separatorBuilder: (_, _) => const SizedBox(width: 12),
              itemBuilder: (context, index) => _OfferCard(offer: _offers[index]),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildOptionsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        children: <Widget>[
          _OptionRow(
            icon: Icons.ac_unit,
            label: 'Request ice pack for meat',
            trailing: Checkbox(
              value: false,
              onChanged: (bool? v) {},
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              visualDensity: VisualDensity.compact,
              side: const BorderSide(color: AppColors.hairline),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(4)),
            ),
          ),
          _buildDivider(),
          _OptionRow(
            icon: Icons.note_alt,
            label: 'Add a note for the butcher',
            trailing: const Icon(Icons.chevron_right, size: 20, color: AppColors.ink),
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceOrderBar(BuildContext context) {
    return Container(
      width: 390,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: <Widget>[
          // Savings banner 390×38 #f3f3f3
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(19),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                const Icon(Icons.local_offer, size: 18, color: AppColors.ink),
                const SizedBox(width: 12),
                const Text(
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
          const SizedBox(height: 10),
          // Go to checkout button 358×56 black
          FilledButton(
            onPressed: () => Navigator.of(context).pushNamed('/checkout'),
            child: const Text(
              'Go to checkout · \$53.98',
              style: TextStyle(
                fontSize: 16,
                height: 19 / 16,
                fontWeight: FontWeight.w600,
              ),
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
    required this.name,
    required this.detail,
    required this.price,
    required this.quantity,
    required this.onQuantityChanged,
  });

  final Widget? image;
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
            // Thumb 64×64
            Container(
              width: 64,
              height: 64,
              margin: const EdgeInsets.only(top: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.xl),
              ),
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
                  // Stepper 84×30 #f3f3f3
                  Container(
                    height: 30,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Row(
                      children: <Widget>[
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.remove, size: 18, color: AppColors.ink),
                          onPressed: quantity > 1 ? () => onQuantityChanged(quantity - 1) : null,
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '$quantity',
                          style: const TextStyle(
                            fontSize: 14,
                            height: 17 / 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        IconButton(
                          padding: EdgeInsets.zero,
                          icon: const Icon(Icons.add, size: 18, color: AppColors.ink),
                          onPressed: () => onQuantityChanged(quantity + 1),
                          constraints: const BoxConstraints(minWidth: 28, minHeight: 28),
                        ),
                      ],
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

class _Offer {
  const _Offer({
    required this.name,
    required this.price,
    required this.tag,
  });

  final String name;
  final String price;
  final String tag;
}

final List<_Offer> _offers = <_Offer>[
  _Offer(name: 'Chicken Drumsticks 1 kg', price: '\$8.99', tag: 'Offer'),
  _Offer(name: 'Lamb Mince 500 g', price: '\$12.99', tag: 'Offer'),
  _Offer(name: 'Jasmine Rice 2 kg', price: '\$14.99', tag: 'Offer'),
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
          // Photo 150×150
          Container(
            width: 150,
            height: 150,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(AppRadius.xl),
            ),
          ),
          const SizedBox(height: 6),
          Text(
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
          const SizedBox(height: 4),
          Text(
            offer.price,
            style: const TextStyle(
              fontSize: 15,
              height: 18 / 15,
              fontWeight: FontWeight.w500,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 6),
          TagPill(
            label: offer.tag,
            background: AppColors.surfaceAlt,
            foreground: AppColors.ink,
            fontSize: 11,
          ),
        ],
      ),
    );
  }
}

class _OptionRow extends StatelessWidget {
  const _OptionRow({
    required this.icon,
    required this.label,
    this.trailing,
    this.onTap,
  });

  final IconData icon;
  final String label;
  final Widget? trailing;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 16),
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

    if (onTap != null) {
      return InkWell(
        onTap: onTap,
        child: row,
      );
    }
    return row;
  }
}