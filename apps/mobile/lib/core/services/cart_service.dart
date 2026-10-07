import 'package:flutter/foundation.dart';
import '../models/catalog_models.dart';

class CartItem {
  const CartItem({
    required this.product,
    required this.variant,
    required this.quantity,
  });

  final Product product;
  final ProductVariant variant;
  final int quantity;

  int get itemTotalCents => variant.priceCents * quantity;

  CartItem copyWith({int? quantity}) {
    return CartItem(
      product: product,
      variant: variant,
      quantity: quantity ?? this.quantity,
    );
  }
}

/// Global reactive cart manager for the Grocerra customer app.
class CartService {
  CartService._();
  static final CartService instance = CartService._();

  final ValueNotifier<List<CartItem>> itemsNotifier =
      ValueNotifier<List<CartItem>>(<CartItem>[]);

  String? _activeStoreId;
  String? get activeStoreId => _activeStoreId;

  List<CartItem> get items => itemsNotifier.value;

  int get totalItemCount =>
      items.fold<int>(0, (int sum, CartItem i) => sum + i.quantity);

  int get subtotalCents =>
      items.fold<int>(0, (int sum, CartItem i) => sum + i.itemTotalCents);

  /// Catch-weight check: true if ANY item in cart is priced by weight.
  /// Used to display the +10% pre-authorization note at checkout.
  bool get hasCatchWeightItems =>
      items.any((CartItem i) => i.variant.isPricedByWeight);

  /// 10% buffer on catch-weight items for pre-authorization.
  int get preAuthHoldBufferCents {
    if (!hasCatchWeightItems) return 0;
    final int weightSubtotal = items
        .where((CartItem i) => i.variant.isPricedByWeight)
        .fold<int>(0, (int sum, CartItem i) => sum + i.itemTotalCents);
    return (weightSubtotal * 0.10).round();
  }

  int get estimatedPreAuthHoldCents => preAuthHoldBufferCents;

  String get formattedSubtotal => '\$${(subtotalCents / 100).toStringAsFixed(2)}';

  /// Adds a product variant to the cart. If from a different store, clears existing cart.
  void addItem({
    required Product product,
    required ProductVariant variant,
    int quantity = 1,
  }) {
    if (_activeStoreId != null && _activeStoreId != product.storeId) {
      // Single-store checkout constraint for MVP
      itemsNotifier.value = <CartItem>[];
    }
    _activeStoreId = product.storeId;

    final List<CartItem> current = List<CartItem>.from(itemsNotifier.value);
    final int existingIndex = current.indexWhere(
      (CartItem i) => i.product.id == product.id && i.variant.id == variant.id,
    );

    if (existingIndex >= 0) {
      current[existingIndex] = current[existingIndex].copyWith(
        quantity: current[existingIndex].quantity + quantity,
      );
    } else {
      current.add(CartItem(
        product: product,
        variant: variant,
        quantity: quantity,
      ));
    }
    itemsNotifier.value = current;
  }

  void updateQuantity(String productId, String variantId, int newQuantity) {
    final List<CartItem> current = List<CartItem>.from(itemsNotifier.value);
    final int index = current.indexWhere(
      (CartItem i) => i.product.id == productId && i.variant.id == variantId,
    );
    if (index >= 0) {
      if (newQuantity <= 0) {
        current.removeAt(index);
        if (current.isEmpty) _activeStoreId = null;
      } else {
        current[index] = current[index].copyWith(quantity: newQuantity);
      }
      itemsNotifier.value = current;
    }
  }

  void clearCart() {
    _activeStoreId = null;
    itemsNotifier.value = <CartItem>[];
  }
}
