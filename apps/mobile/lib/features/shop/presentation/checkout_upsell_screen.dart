import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../home/data/catalog.dart';

/// Checkout step 2 — `People also ordered`.
///
/// The upsell the reference flow shows between the cart and checkout: two
/// catalogue picks as cards (emoji tile, name, size, price) with a grey
/// action pill, and a pinned `No, thanks` that continues to checkout.
/// Adds go to the shared [CartStore], so the checkout step that follows
/// tallies them into its summary.
class CheckoutUpsellScreen extends StatefulWidget {
  const CheckoutUpsellScreen({super.key});

  static const String routeName = '/checkout/upsell';

  @override
  State<CheckoutUpsellScreen> createState() => _CheckoutUpsellScreenState();
}

class _CheckoutUpsellScreenState extends State<CheckoutUpsellScreen> {
  /// Catalogue picks, same ones the reference offers (a side and a main).
  static const Product _first = Product(
    name: 'Chicken drumsticks',
    size: '1 kg',
    price: 899,
    emoji: '🍗',
    store: 'Madina Halal Meats',
    tint: Color(0xFFFFEFD9),
  );

  static const Product _second = Product(
    name: 'Lamb mince',
    size: '500 g',
    price: 1299,
    emoji: '🍖',
    store: 'Al-Noor Butchery',
    tint: Color(0xFFF3E6E6),
  );

  /// Lines the shopper already dropped in the basket from this screen.
  final Set<String> _added = <String>{};

  void _addToBasket(Product product) {
    HapticFeedback.lightImpact();
    CartStore.instance.add(
      CartItem(
        id: product.name.toLowerCase().replaceAll(' ', '-'),
        name: product.name,
        price: product.price / 100,
        emoji: product.emoji,
        detail: product.size,
      ),
    );
    setState(() => _added.add(product.name));
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          content: Text(
            '${product.name} added to basket',
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.surface,
            ),
          ),
        ),
      );
  }

  void _continue() => Navigator.of(context).pushReplacementNamed('/checkout');

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topInset, 0, 116),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
                  child: Column(
                    children: <Widget>[
                      _ProductCard(
                        product: _first,
                        added: _added.contains(_first.name),
                        actionLabel: 'Add to basket',
                        onAction: () => _addToBasket(_first),
                      ),
                      const SizedBox(height: 12),
                      _ProductCard(
                        product: _second,
                        added: _added.contains(_second.name),
                        actionLabel: 'Choose',
                        onAction: () => _addToBasket(_second),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Pinned `No, thanks` - the reference's exit from the upsell.
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.topBar,
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: FilledButton(
                onPressed: _continue,
                child: const Text('No, thanks'),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 52,
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
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
          const SizedBox(width: 4),
          const Text(
            'People also ordered',
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
}

/// One upsell pick: emoji tile, name / size / price, and the action pill
/// tucked at the bottom-right as in the reference.
class _ProductCard extends StatelessWidget {
  const _ProductCard({
    required this.product,
    required this.added,
    required this.actionLabel,
    required this.onAction,
  });

  final Product product;
  final bool added;
  final String actionLabel;
  final VoidCallback onAction;

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
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: <Widget>[
          // Catalogue emoji on its tint — the prototype's product art.
          Container(
            width: 88,
            height: 88,
            decoration: BoxDecoration(
              color: product.tint,
              borderRadius: BorderRadius.circular(AppRadius.lg),
            ),
            alignment: Alignment.center,
            child: Text(product.emoji, style: const TextStyle(fontSize: 40)),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  product.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  product.size,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkMuted,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  money(product.price),
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
          const SizedBox(width: 12),
          Material(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.button),
            child: InkWell(
              borderRadius: BorderRadius.circular(AppRadius.button),
              onTap: added ? null : onAction,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 10,
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    if (added) ...<Widget>[
                      const Icon(
                        Icons.check_rounded,
                        size: 16,
                        color: AppColors.ink,
                      ),
                      const SizedBox(width: 6),
                    ],
                    Text(
                      added ? 'Added' : actionLabel,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 18 / 15,
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
}
