import 'package:flutter/material.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/grocerra_map.dart';
import '../../home/data/catalog.dart';
import 'checkout_totals.dart';

/// Checkout step 3 — the reference `Checkout` screen.
///
/// One long scroll under a pinned action bar, in the reference order:
/// map + address, delivery options, the live order summary, the fee
/// breakdown, payment and the email-offers opt-in; the savings banner and
/// `Next` stay pinned at the bottom.
///
/// Items and money read [CartStore] through [CheckoutTotals], so a
/// quantity change in the cart or an upsell add flows straight into the
/// summary and the payable total. Offline demo state only.
class CheckoutTopScreen extends StatefulWidget {
  const CheckoutTopScreen();

  static const String routeName = '/checkout';

  @override
  State<CheckoutTopScreen> createState() => _CheckoutTopScreenState();
}

class _CheckoutTopScreenState extends State<CheckoutTopScreen> {
  /// Delivery option: 0 Priority, 1 Standard (default), 2 Schedule.
  int _selected = 1;

  bool _emailOffers = false;

  /// Section heading — `App / Bold / 20`.
  static const TextStyle _h3 = TextStyle(
    fontSize: 20,
    height: 24 / 20,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  /// Row title — `App / Semi Bold / 16`.
  static const TextStyle _rowTitle = TextStyle(
    fontSize: 16,
    height: 19 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Row caption — `App / Regular / 13`, `#6b6b6b`.
  static const TextStyle _rowCaption = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  /// Screen title — `App / Bold / 30`.
  static const TextStyle _h30 = TextStyle(
    fontSize: 30,
    height: 36 / 30,
    letterSpacing: -0.6,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  void _select(int option) {
    setState(() {
      _selected = option;
      CheckoutTotals.priority = option == 0;
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListenableBuilder(
        listenable: CartStore.instance,
        builder: (BuildContext context, Widget? _) {
          return Stack(
            children: <Widget>[
              SingleChildScrollView(
                padding: EdgeInsets.fromLTRB(0, topInset, 0, 150),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    _buildHeader(),
                    _buildMap(),
                    _buildAddress(),
                    _buildDeliveryOptions(),
                    _buildOrderSummary(),
                    _buildFees(),
                    _buildPayment(),
                    _buildEmailOffers(),
                  ],
                ),
              ),
              Positioned(
                left: 0,
                right: 0,
                bottom: 0,
                child: _buildBottomBar(context),
              ),
            ],
          );
        },
      ),
    );
  }

  /// Header — plain back arrow like the reference flow, title below.
  Widget _buildHeader() {
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text('Checkout', style: _h30),
          ),
        ],
      ),
    );
  }

  /// The demo delivery address — 12 Queen St, Melbourne (the same one the
  /// Carts card and order receipt use).
  static const double _lat = -37.8143;
  static const double _lng = 144.9553;

  /// Map card — MapLibre GL with CARTO positron (the engine and default
  /// style behind mapcn), centred on the delivery address. The pin, `Edit
  /// pin` pill and attribution render in the map's DOM layer; the strip's
  /// width stretches with the screen and the map is non-interactive so the
  /// checkout page keeps scrolling over it.
  Widget _buildMap() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: SizedBox(
        height: 127,
        width: double.infinity,
        child: buildGrocerraMap(lat: _lat, lng: _lng, zoom: 16),
      ),
    );
  }

  /// Address and dropoff rows under the map (reference: `Home`, then
  /// `Leave at reception`).
  Widget _buildAddress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        children: <Widget>[
          _DetailRow(
            icon: Icons.home,
            title: 'Home',
            subtitle: '12 Queen St, Melbourne, VIC 3000',
            onTap: () => Navigator.of(context).pushNamed('/delivery-address'),
          ),
          _buildDivider(),
          _DetailRow(
            icon: Icons.business,
            title: 'Leave at reception',
            subtitle: 'Please leave it at reception.',
            onTap: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.lg)),
                  ),
                  content: Text(
                    'Dropoff options are coming soon',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  /// `Delivery Options`: three full-width radio cards, selected one outlined
  /// in black as in the reference. Priority adds its surcharge to the total.
  Widget _buildDeliveryOptions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 20, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Delivery Options', style: _h3),
          const SizedBox(height: 12),
          _DeliveryOption(
            icon: Icons.bolt,
            iconColor: AppColors.accent,
            title: 'Priority',
            caption: '10–15 min(s) · Delivered directly to you',
            price: '+${CheckoutTotals.usd(CheckoutTotals.priorityFee)}',
            selected: _selected == 0,
            onTap: () => _select(0),
          ),
          const SizedBox(height: 8),
          _DeliveryOption(
            icon: Icons.electric_scooter,
            title: 'Standard',
            caption: '10–20 min(s)',
            selected: _selected == 1,
            onTap: () => _select(1),
          ),
          const SizedBox(height: 8),
          _DeliveryOption(
            icon: Icons.schedule,
            title: 'Schedule',
            caption: 'Select a time',
            selected: _selected == 2,
            onTap: () => _select(2),
          ),
        ],
      ),
    );
  }

  /// `Order summary`: the store row, the live cart lines, and the promotion
  /// row (reference panels 3–4).
  Widget _buildOrderSummary() {
    final Store store =
        stores.firstWhere((Store s) => s.name == 'Madina Halal Meats');
    final List<CartItem> items = CartStore.instance.items;
    final int count = CartStore.instance.itemCount;

    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text('Order summary', style: _h3),
          const SizedBox(height: 8),
          // Store row: 48 emoji circle, name + live count, collapse chevron.
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: store.tint,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: Text(store.art.first, style: const TextStyle(fontSize: 22)),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        store.name,
                        style: const TextStyle(
                          fontSize: 17,
                          height: 21 / 17,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        '$count ${count == 1 ? 'item' : 'items'}',
                        style: _rowCaption,
                      ),
                    ],
                  ),
                ),
                const Icon(
                  Icons.expand_more,
                  size: 20,
                  color: AppColors.inkMuted,
                ),
              ],
            ),
          ),
          const _FullDivider(),
          for (final CartItem item in items) _SummaryLine(item: item),
          const _FullDivider(),
          // Promotion row (reference: tag bubble + conditions caption).
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 12),
            child: Row(
              children: <Widget>[
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.surfaceAlt,
                    shape: BoxShape.circle,
                  ),
                  alignment: Alignment.center,
                  child: const Icon(
                    Icons.local_offer,
                    size: 24,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text('One promotion applied', style: _rowTitle),
                      SizedBox(height: 2),
                      Text(
                        'May exclude alcohol or other regulated items',
                        style: _rowCaption,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 14),
                const Icon(
                  Icons.chevron_right,
                  size: 20,
                  color: AppColors.inkMuted,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Subtotal / Promotion / Delivery fee / Taxes & Other Fees / Total —
  /// every figure derived from [CheckoutTotals].
  Widget _buildFees() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
      child: Column(
        children: <Widget>[
          _FeeRow(
            label: 'Subtotal',
            values: <Widget>[
              Text(CheckoutTotals.usd(CheckoutTotals.subtotal)),
            ],
          ),
          _FeeRow(
            label: 'Promotion',
            values: <Widget>[
              Text('-${CheckoutTotals.usd(CheckoutTotals.promo)}'),
            ],
          ),
          _FeeRow(
            label: 'Delivery fee',
            info: true,
            wasLabel: CheckoutTotals.usd(CheckoutTotals.deliveryWas),
            wasValue: CheckoutTotals.usd(CheckoutTotals.delivery),
          ),
          _FeeRow(
            label: 'Taxes & Other Fees',
            info: true,
            values: <Widget>[
              Text(CheckoutTotals.usd(CheckoutTotals.taxes)),
            ],
          ),
          _FeeRow(
            total: true,
            label: 'Total',
            wasLabel: CheckoutTotals.usd(CheckoutTotals.wasTotal),
            wasValue: CheckoutTotals.usd(CheckoutTotals.total),
          ),
        ],
      ),
    );
  }

  /// Payment row — reference: Mastercard with its last four, chevron right.
  Widget _buildPayment() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 0, 16, 0),
      child: Column(
        children: <Widget>[
          _buildDivider(),
          _DetailRow(
            icon: Icons.credit_card,
            title: 'Mastercard ••••4320',
            subtitle: 'Payment method',
            onTap: () => ScaffoldMessenger.of(context)
              ..hideCurrentSnackBar()
              ..showSnackBar(
                const SnackBar(
                  behavior: SnackBarBehavior.floating,
                  backgroundColor: AppColors.ink,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.all(Radius.circular(AppRadius.lg)),
                  ),
                  content: Text(
                    'Payment methods are coming soon',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                      color: AppColors.surface,
                    ),
                  ),
                ),
              ),
          ),
        ],
      ),
    );
  }

  /// Email-offers opt-in with the privacy caption (reference panel 4).
  Widget _buildEmailOffers() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const Text(
                  'Sign up to receive email offers and news from '
                  'Madina Halal Meats',
                  style: TextStyle(
                    fontSize: 15,
                    height: 18 / 15,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Privacy Notice: By checking this box, you agree to '
                  "Grocerra's Terms & Conditions and that your data may "
                  'be used as described in our Privacy Notice.',
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
          const SizedBox(width: 12),
          Checkbox(
            value: _emailOffers,
            onChanged: (bool? v) =>
                setState(() => _emailOffers = v ?? false),
            materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            visualDensity: VisualDensity.compact,
            side: const BorderSide(color: AppColors.hairline),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(6),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(height: 1, color: AppColors.hairline);
  }

  /// Pinned bar: savings banner + Total column + `Next` into the tip step.
  Widget _buildBottomBar(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        boxShadow: AppShadows.topBar,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          Container(
            height: 38,
            color: AppColors.surfaceAlt,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: const Row(
              children: <Widget>[
                Icon(Icons.local_offer, size: 18, color: AppColors.ink),
                SizedBox(width: 10),
                Text(
                  'Saving \$2.50 with promotions',
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
            child: Row(
              children: <Widget>[
                SizedBox(
                  width: 71,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Total',
                        style: TextStyle(
                          fontSize: 12,
                          height: 15 / 12,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      Text(
                        CheckoutTotals.usd(CheckoutTotals.total),
                        softWrap: false,
                        overflow: TextOverflow.visible,
                        style: const TextStyle(
                          fontSize: 20,
                          height: 24 / 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: FilledButton(
                    onPressed: () =>
                        Navigator.of(context).pushNamed('/checkout/tip'),
                    child: const Text('Next'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// 358×1 hairline between summary rows.
class _FullDivider extends StatelessWidget {
  const _FullDivider();

  @override
  Widget build(BuildContext context) =>
      Container(height: 1, color: AppColors.hairline);
}

/// One cart line in the order summary: quantity, name, variant caption and
/// the live line total on the right.
class _SummaryLine extends StatelessWidget {
  const _SummaryLine({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            width: 18,
            child: Text(
              '${item.quantity}',
              style: const TextStyle(
                fontSize: 15,
                height: 18 / 15,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  item.name,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                if (item.detail != null) ...<Widget>[
                  const SizedBox(height: 2),
                  Text(
                    item.detail!,
                    style: const TextStyle(
                      fontSize: 13,
                      height: 16 / 13,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ],
            ),
          ),
          const SizedBox(width: 12),
          Text(
            CheckoutTotals.usd(item.lineTotal),
            style: const TextStyle(
              fontSize: 15,
              height: 18 / 15,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

/// One fee line: muted label left, value(s) right. The `total` variant is
/// larger and bold; `wasLabel` draws the struck-through original before
/// the live value.
class _FeeRow extends StatelessWidget {
  const _FeeRow({
    required this.label,
    this.values = const <Widget>[],
    this.total = false,
    this.info = false,
    this.wasLabel,
    this.wasValue,
  });

  final String label;
  final List<Widget> values;
  final bool total;
  final bool info;

  /// Struck original (e.g. full-price delivery), shown before the value.
  final String? wasLabel;

  /// Value to show after the strike when [wasLabel] is set (the delivery
  /// fee reuses the row for `was → now`).
  final String? wasValue;

  @override
  Widget build(BuildContext context) {
    const TextStyle valueStyle = TextStyle(
      fontSize: 16,
      height: 19 / 16,
      fontWeight: FontWeight.w400,
      color: AppColors.ink,
    );
    const TextStyle wasStyle = TextStyle(
      fontSize: 15,
      height: 18 / 15,
      fontWeight: FontWeight.w400,
      color: AppColors.inkMuted,
      decoration: TextDecoration.lineThrough,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: <Widget>[
              Text(
                label,
                style: total
                    ? const TextStyle(
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      )
                    : const TextStyle(
                        fontSize: 16,
                        height: 19 / 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
              ),
              if (info) ...<Widget>[
                const SizedBox(width: 5),
                const Icon(
                  Icons.info_outline,
                  size: 15,
                  color: AppColors.inkMuted,
                ),
              ],
            ],
          ),
          if (wasLabel != null)
            Row(
              children: <Widget>[
                Text(wasLabel!, style: wasStyle),
                const SizedBox(width: 6),
                Text(
                  wasValue!,
                  style: total
                      ? const TextStyle(
                          fontSize: 20,
                          height: 24 / 20,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        )
                      : valueStyle,
                ),
              ],
            )
          else
            Row(children: values),
        ],
      ),
    );
  }
}

/// A delivery option card: icon, title, caption, optional surcharge, and
/// the reference's black outline when selected.
class _DeliveryOption extends StatelessWidget {
  const _DeliveryOption({
    required this.icon,
    required this.title,
    required this.caption,
    required this.selected,
    required this.onTap,
    this.iconColor,
    this.price,
  });

  final IconData icon;
  final Color? iconColor;
  final String title;
  final String caption;
  final String? price;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: selected ? AppColors.ink : AppColors.hairline,
            width: selected ? 1.5 : 1,
          ),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: iconColor ?? AppColors.ink),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      height: 19 / 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    caption,
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
            if (price != null)
              Text(
                price!,
                style: const TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
          ],
        ),
      ),
    );
  }
}

/// Icon-bubble detail row (address, dropoff, payment): 48 `#f3f3f3`
/// circle, title + caption, chevron.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Icon(icon, size: 24, color: AppColors.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
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
                  subtitle,
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
          const Icon(
            Icons.chevron_right,
            size: 20,
            color: AppColors.inkMuted,
          ),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: row);
    }
    return row;
  }
}
