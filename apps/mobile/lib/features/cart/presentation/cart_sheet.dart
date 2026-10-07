import 'package:flutter/material.dart';

import '../../../core/services/cart_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import '../../checkout/presentation/checkout_screen.dart';

/// Interactive modal bottom sheet displaying the customer's current cart,
/// item counters, catch-weight pre-authorization disclosures, and checkout trigger.
class CartSheet extends StatelessWidget {
  const CartSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => const CartSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<List<CartItem>>(
      valueListenable: CartService.instance.itemsNotifier,
      builder: (BuildContext context, List<CartItem> items, Widget? child) {
        final bool isEmpty = items.isEmpty;

        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
          ),
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom + 24,
          ),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                // Handle bar
                Center(
                  child: Container(
                    margin: const EdgeInsets.only(top: 12, bottom: 8),
                    width: 44,
                    height: 5,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(2.5),
                    ),
                  ),
                ),

                // Sheet Header
                Padding(
                  padding: const EdgeInsets.fromLTRB(20, 8, 20, 16),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          const Text(
                            'Your Basket',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          if (!isEmpty) ...<Widget>[
                            const SizedBox(width: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: AppColors.accentLight,
                                borderRadius: BorderRadius.circular(12),
                              ),
                              child: Text(
                                '${CartService.instance.totalItemCount}',
                                style: const TextStyle(
                                  color: AppColors.accentDark,
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      if (!isEmpty)
                        TextButton(
                          onPressed: () => CartService.instance.clearCart(),
                          child: const Text(
                            'Clear',
                            style: TextStyle(color: Colors.red),
                          ),
                        ),
                    ],
                  ),
                ),

                if (isEmpty)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 40, horizontal: 20),
                    child: Column(
                      children: <Widget>[
                        Icon(Icons.shopping_bag_outlined,
                            size: 64, color: Colors.grey.shade400),
                        const SizedBox(height: 16),
                        const Text(
                          'Your basket is empty',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Explore stores and add fresh halal meats, spices, and groceries.',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ],
                    ),
                  )
                else ...<Widget>[
                  // Items List
                  Flexible(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      itemCount: items.length,
                      separatorBuilder: (_, _) => const Divider(height: 20),
                      itemBuilder: (BuildContext context, int index) {
                        final CartItem item = items[index];
                        return _CartItemRow(item: item);
                      },
                    ),
                  ),

                  // Catch-weight notice
                  if (CartService.instance.hasCatchWeightItems) ...<Widget>[
                    const SizedBox(height: 12),
                    Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20),
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFF8E1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: const Color(0xFFFFECB3)),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          const Icon(Icons.scale_outlined,
                              size: 20, color: Color(0xFFF57F17)),
                          const SizedBox(width: 10),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                const Text(
                                  'Weight-Priced Items (+10% hold)',
                                  style: TextStyle(
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFFF57F17),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Contains items priced by scale weight. Your card will hold 10% extra (\$${(CartService.instance.preAuthHoldBufferCents / 100).toStringAsFixed(2)}). You are only charged the exact scale weight upon butcher packing.',
                                  style: TextStyle(
                                    fontSize: 11,
                                    color: Colors.grey.shade800,
                                    height: 1.3,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 16),

                  // Subtotal & Checkout Button
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            const Text(
                              'Subtotal (incl. GST)',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              CartService.instance.formattedSubtotal,
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Delivery fee calculated at next step',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        GlowButton(
                          label: 'Review & Checkout (${CartService.instance.formattedSubtotal})',
                          icon: Icons.lock_rounded,
                          glowColor: const Color(0xFF10B981),
                          backgroundColor: const Color(0xFF0F172A),
                          textColor: Colors.white,
                          onTap: () {
                            Navigator.of(context).pop();
                            Navigator.of(context).push(
                              MaterialPageRoute<void>(
                                builder: (_) => const CheckoutScreen(),
                              ),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                ],
              ],
            ),
          ),
        );
      },
    );
  }
}

class _CartItemRow extends StatelessWidget {
  const _CartItemRow({required this.item});

  final CartItem item;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Thumbnail
        ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Image.network(
            item.product.imageUrl,
            width: 52,
            height: 52,
            fit: BoxFit.cover,
            errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
              width: 52,
              height: 52,
              color: Colors.grey.shade200,
              child: const Icon(Icons.shopping_basket, size: 24, color: Colors.grey),
            ),
          ),
        ),
        const SizedBox(width: 12),

        // Title and variant
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                item.product.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Row(
                children: <Widget>[
                  Text(
                    item.variant.label,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  if (item.variant.isPricedByWeight) ...<Widget>[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 1),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE8F5E9),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        'Scale weight',
                        style: TextStyle(fontSize: 10, color: Color(0xFF2E7D32)),
                      ),
                    ),
                  ],
                ],
              ),
              const SizedBox(height: 4),
              Text(
                item.variant.formattedPrice,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accentDark,
                ),
              ),
            ],
          ),
        ),

        // Quantity selector
        Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.remove_circle_outline, size: 22),
              color: Colors.grey.shade700,
              onPressed: () {
                CartService.instance.updateQuantity(
                  item.product.id,
                  item.variant.id,
                  item.quantity - 1,
                );
              },
            ),
            Text(
              '${item.quantity}',
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
            ),
            IconButton(
              icon: const Icon(Icons.add_circle, size: 22),
              color: AppColors.accentDark,
              onPressed: () {
                CartService.instance.updateQuantity(
                  item.product.id,
                  item.variant.id,
                  item.quantity + 1,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
