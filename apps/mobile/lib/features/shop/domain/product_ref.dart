import 'package:flutter/material.dart';

/// The product identity a screen hands to `B4 · Product` when it opens it -
/// the `/product` route argument.
///
/// B4 renders [frameProduct] when the route is opened without an argument
/// (deep link), so the approved frame port stays intact; callers (B3 store
/// card, Home catalogue tiles, search rows) pass their own product so the
/// screen and the cart line agree.
@immutable
class ProductRef {
  const ProductRef({
    required this.id,
    required this.name,
    required this.price,
    this.image,
    this.emoji,
    this.tint,
    this.storeName,
    this.description,
  });

  /// Product identity - it becomes the cart line's `CartItem.id`, which is
  /// what makes "add the same product again" merge into one row.
  final String id;

  final String name;

  /// Unit price in dollars. The B3/B4 mock prices are all per kg, and that
  /// is what B4 prints under the name.
  final double price;

  /// Figma photo fill asset name under `assets/icons/`.
  final String? image;

  /// Catalogue emoji for products without a photo asset (Home tiles,
  /// search rows); ignored when [image] is set.
  final String? emoji;

  /// Tint behind the emoji hero (matches the Home tile tint).
  final Color? tint;

  /// Store name shown in the glass header pill; defaults to the B4 frame's
  /// store when null.
  final String? storeName;

  /// Product blurb under the price; the B4 frame copy shows when null.
  final String? description;

  /// The product the approved B4 frame shows (`1:255`) - the default when
  /// `/product` is opened without arguments.
  static const ProductRef frameProduct = ProductRef(
    id: 'goat-curry-cut',
    name: 'Goat Curry Cut',
    price: 16.99,
    image: 'product_hero.png',
    storeName: 'Madina Halal Meats',
    description:
        'Bone-in pieces from young goat, cut small for curries. '
        'Packed fresh and sealed on the day.',
  );
}
