import 'package:flutter/material.dart';

import '../../../core/models/catalog_models.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/theme/app_theme.dart';
import 'cart_sheet.dart';

/// Animated modal screen sliding smoothly from the bottom when a user adds an item
/// to their basket, featuring item thumbnail, live quantity adjuster, and basket summary.
class AddedToBasketSheet extends StatefulWidget {
  const AddedToBasketSheet({
    super.key,
    required this.product,
    required this.variant,
  });

  final Product product;
  final ProductVariant variant;

  static Future<void> show(
    BuildContext context, {
    required Product product,
    required ProductVariant variant,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      transitionAnimationController: AnimationController(
        vsync: Navigator.of(context),
        duration: const Duration(milliseconds: 360),
        reverseDuration: const Duration(milliseconds: 240),
      ),
      builder: (BuildContext ctx) => AddedToBasketSheet(
        product: product,
        variant: variant,
      ),
    );
  }

  @override
  State<AddedToBasketSheet> createState() => _AddedToBasketSheetState();
}

class _AddedToBasketSheetState extends State<AddedToBasketSheet> {
  int _quantity = 1;

  @override
  void initState() {
    super.initState();
    final CartItem? existing = CartService.instance.items.cast<CartItem?>().firstWhere(
          (CartItem? i) =>
              i?.product.id == widget.product.id &&
              i?.variant.id == widget.variant.id,
          orElse: () => null,
        );
    if (existing != null) {
      _quantity = existing.quantity;
    }
  }

  void _increment() {
    setState(() => _quantity++);
    CartService.instance.updateQuantity(
      widget.product.id,
      widget.variant.id,
      _quantity,
    );
  }

  void _decrement() {
    if (_quantity > 1) {
      setState(() => _quantity--);
      CartService.instance.updateQuantity(
        widget.product.id,
        widget.variant.id,
        _quantity,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final int itemTotalCents = widget.variant.priceCents * _quantity;
    final String formattedItemTotal =
        '\$${(itemTotalCents / 100).toStringAsFixed(2)}';

    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Color(0x1F000000),
            blurRadius: 20,
            offset: Offset(0, -4),
          ),
        ],
      ),
      padding: EdgeInsets.only(
        top: 14,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Handle pill
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Success Header Row
            Row(
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFDCFCE7),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check_rounded,
                    color: Color(0xFF16A34A),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        'Added to your basket',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.4,
                        ),
                      ),
                      Text(
                        widget.product.storeName,
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, size: 20),
                  color: Colors.grey.shade600,
                  onPressed: () => Navigator.of(context).pop(),
                ),
              ],
            ),

            const SizedBox(height: 16),

            // Product Detail Card
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFF8FAFC),
                borderRadius: BorderRadius.circular(18),
                border: Border.all(color: const Color(0xFFE2E8F0)),
              ),
              child: Row(
                children: <Widget>[
                  ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: Image.network(
                      widget.product.imageUrl,
                      width: 64,
                      height: 64,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        BuildContext context,
                        Object error,
                        StackTrace? stackTrace,
                      ) => Container(
                        width: 64,
                        height: 64,
                        color: Colors.grey.shade200,
                        child: const Icon(
                          Icons.shopping_basket_rounded,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          widget.product.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          widget.variant.label,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: <Widget>[
                            Text(
                              formattedItemTotal,
                              style: const TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w800,
                                color: AppColors.accentDark,
                              ),
                            ),
                            if (widget.variant.isPricedByWeight) ...<Widget>[
                              const SizedBox(width: 6),
                              Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 6,
                                  vertical: 2,
                                ),
                                decoration: BoxDecoration(
                                  color: const Color(0xFFDCFCE7),
                                  borderRadius: BorderRadius.circular(6),
                                ),
                                child: const Text(
                                  'By weight',
                                  style: TextStyle(
                                    fontSize: 10,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF065F46),
                                  ),
                                ),
                              ),
                            ],
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Quantity Controls
                  Row(
                    children: <Widget>[
                      IconButton(
                        icon: const Icon(Icons.remove_circle_outline_rounded),
                        iconSize: 24,
                        color: Colors.grey.shade700,
                        onPressed: _decrement,
                      ),
                      Text(
                        '$_quantity',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add_circle_rounded),
                        iconSize: 24,
                        color: AppColors.accentDark,
                        onPressed: _increment,
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 16),

            // Basket Summary Row
            ValueListenableBuilder<List<CartItem>>(
              valueListenable: CartService.instance.itemsNotifier,
              builder: (BuildContext context, List<CartItem> items, _) {
                final int totalCount = CartService.instance.totalItemCount;
                final String subtotal = CartService.instance.formattedSubtotal;

                return Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF1F5F9),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        'Basket Total ($totalCount ${totalCount == 1 ? "item" : "items"})',
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      Text(
                        subtotal,
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 18),

            // Action Buttons (Continue Shopping vs View Basket)
            Row(
              children: <Widget>[
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    style: OutlinedButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      foregroundColor: AppColors.ink,
                      side: const BorderSide(color: Color(0xFFCBD5E1)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'Keep Shopping',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FilledButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                      CartSheet.show(context);
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(16),
                      ),
                    ),
                    child: const Text(
                      'View Basket',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
