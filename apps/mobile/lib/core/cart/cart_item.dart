import 'package:flutter/foundation.dart';

/// One line of the cart: the product a shopper picked plus how many.
///
/// The current slice is offline demo state, so a line carries exactly what
/// the approved cart row renders - identity, name, unit price, the photo
/// fill and the variant note - with no catalogue or backend behind it.
@immutable
class CartItem {
  const CartItem({
    required this.id,
    required this.name,
    required this.price,
    this.quantity = 1,
    this.image,
    this.emoji,
    this.detail,
  });

  /// Product identity: adding the same [id] again grows this line instead of
  /// creating a second one.
  final String id;

  /// Product name, as the cart row prints it.
  final String name;

  /// Unit price in dollars. Totals are computed from it, never hardcoded.
  final double price;

  /// Photo fill asset name under `assets/icons/` (cart thumb).
  final String? image;

  /// Catalogue emoji thumb for lines added from the catalogue, which has no
  /// photo asset; ignored when [image] is set.
  final String? emoji;

  /// Variant line under the name (`1 kg · Curry cut`).
  final String? detail;

  /// Units this entry stands for: what `add` puts in the cart and what the
  /// row's stepper holds.
  final int quantity;

  /// Row total - what the cart price cell and every subtotal are built from.
  double get lineTotal => price * quantity;

  /// Same product at a different quantity; identity fields are untouched.
  CartItem withQuantity(int quantity) => CartItem(
        id: id,
        name: name,
        price: price,
        quantity: quantity,
        image: image,
        emoji: emoji,
        detail: detail,
      );
}
