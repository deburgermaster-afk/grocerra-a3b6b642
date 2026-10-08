/// Prototype catalogue behind Home and search.
///
/// Melbourne halal grocers, butchers, sweet shops and caterers with a few
/// of their items. Swap for Supabase queries (stores, products) when the
/// catalogue tables land; widgets only read these classes.
library;

import 'package:flutter/painting.dart';

enum StoreKind { grocery, meat, sweets, catering }

class Store {
  const Store({
    required this.name,
    required this.kind,
    required this.tagline,
    required this.deliveryFee,
    required this.rating,
    required this.ratings,
    required this.minutes,
    required this.art,
    required this.tint,
    this.promo,
  });

  final String name;
  final StoreKind kind;
  final String tagline;

  /// In cents; 0 is free delivery.
  final int deliveryFee;
  final double rating;
  final String ratings;
  final int minutes;

  /// Emoji composing the card's cover, largest first.
  final List<String> art;
  final Color tint;
  final String? promo;

  String get feeLabel => deliveryFee == 0
      ? r'$0 Delivery Fee'
      : '${money(deliveryFee)} Delivery Fee';
}

class Product {
  const Product({
    required this.name,
    required this.size,
    required this.price,
    required this.emoji,
    required this.store,
    required this.tint,
    this.was,
  });

  final String name;
  final String size;
  final int price;
  final String emoji;
  final String store;
  final Color tint;

  /// Pre-offer price, in cents, when on special.
  final int? was;
}

class Category {
  const Category(this.label, this.emoji);

  final String label;
  final String emoji;
}

String money(int cents) =>
    '\$${cents ~/ 100}.${(cents % 100).toString().padLeft(2, '0')}';

const List<String> modes = <String>[
  'All',
  'Grocery',
  'Halal meat',
  'Catering',
  'Sweets',
  'Convenience',
];

const List<Category> categories = <Category>[
  Category('Deals', '🏷️'),
  Category('Meat', '🥩'),
  Category('Rice', '🍚'),
  Category('Spices', '🌶️'),
  Category('Produce', '🥬'),
  Category('Dairy', '🥛'),
  Category('Biryani', '🍛'),
  Category('Sweets', '🍮'),
  Category('Frozen', '🧊'),
  Category('Bakery', '🫓'),
];

const List<Store> stores = <Store>[
  Store(
    name: 'Madina Halal Meats',
    kind: StoreKind.meat,
    tagline: 'Butcher · Halal certified',
    deliveryFee: 599,
    rating: 4.8,
    ratings: '320+',
    minutes: 25,
    art: <String>['🥩', '🍗', '🧅'],
    tint: Color(0xFFFDE8E4),
    promo: '10% off \$50+',
  ),
  Store(
    name: 'Dhaka Bazaar',
    kind: StoreKind.grocery,
    tagline: 'Groceries · Bangladeshi',
    deliveryFee: 0,
    rating: 4.6,
    ratings: '1,200+',
    minutes: 30,
    art: <String>['🍚', '🌶️', '🧄'],
    tint: Color(0xFFE8F5E4),
    promo: '750+ items on special',
  ),
  Store(
    name: 'Lahore Sweets & Bakery',
    kind: StoreKind.sweets,
    tagline: 'Sweets · Bakery',
    deliveryFee: 349,
    rating: 4.7,
    ratings: '640+',
    minutes: 20,
    art: <String>['🍮', '🫓', '🍩'],
    tint: Color(0xFFFFF3D6),
  ),
  Store(
    name: 'Biryani House Catering',
    kind: StoreKind.catering,
    tagline: 'Catering · Events from 20 guests',
    deliveryFee: 0,
    rating: 4.9,
    ratings: '210+',
    minutes: 45,
    art: <String>['🍛', '🥘', '🥗'],
    tint: Color(0xFFFFE9D2),
    promo: 'Free delivery over 40 guests',
  ),
  Store(
    name: 'Spice World Grocers',
    kind: StoreKind.grocery,
    tagline: 'Spices · Indian & Pakistani',
    deliveryFee: 499,
    rating: 4.5,
    ratings: '900+',
    minutes: 35,
    art: <String>['🌶️', '🫚', '🧂'],
    tint: Color(0xFFFBE7DA),
    promo: '\$5 off first order',
  ),
  Store(
    name: 'Al-Noor Butchery',
    kind: StoreKind.meat,
    tagline: 'Butcher · Goat & lamb',
    deliveryFee: 699,
    rating: 4.4,
    ratings: '180+',
    minutes: 30,
    art: <String>['🍖', '🥩', '🌿'],
    tint: Color(0xFFF3E6E6),
  ),
  Store(
    name: 'Royal Feast Caterers',
    kind: StoreKind.catering,
    tagline: 'Catering · Weddings & Eid',
    deliveryFee: 0,
    rating: 4.7,
    ratings: '95+',
    minutes: 60,
    art: <String>['🥘', '🍢', '🍚'],
    tint: Color(0xFFEDE7F6),
  ),
];

const List<Product> products = <Product>[
  Product(
    name: 'Goat curry cut',
    size: '1 kg',
    price: 1699,
    emoji: '🥩',
    store: 'Madina Halal Meats',
    tint: Color(0xFFFDE8E4),
  ),
  Product(
    name: 'Basmati rice',
    size: '5 kg',
    price: 1599,
    was: 1899,
    emoji: '🍚',
    store: 'Dhaka Bazaar',
    tint: Color(0xFFF4F1EA),
  ),
  Product(
    name: 'Chicken drumsticks',
    size: '1 kg',
    price: 899,
    emoji: '🍗',
    store: 'Madina Halal Meats',
    tint: Color(0xFFFFEFD9),
  ),
  Product(
    name: 'Shan biryani masala',
    size: '50 g',
    price: 199,
    was: 249,
    emoji: '🌶️',
    store: 'Spice World Grocers',
    tint: Color(0xFFFBE7DA),
  ),
  Product(
    name: 'Fresh paneer',
    size: '400 g',
    price: 749,
    emoji: '🧀',
    store: 'Dhaka Bazaar',
    tint: Color(0xFFFFF7E0),
  ),
  Product(
    name: 'Gulab jamun',
    size: '1 kg tin',
    price: 899,
    emoji: '🍮',
    store: 'Lahore Sweets & Bakery',
    tint: Color(0xFFFFF3D6),
  ),
  Product(
    name: 'Lamb mince',
    size: '500 g',
    price: 1299,
    emoji: '🍖',
    store: 'Al-Noor Butchery',
    tint: Color(0xFFF3E6E6),
  ),
  Product(
    name: 'Red lentils (masoor)',
    size: '2 kg',
    price: 699,
    emoji: '🫘',
    store: 'Dhaka Bazaar',
    tint: Color(0xFFFBEAE0),
  ),
  Product(
    name: 'Coriander bunch',
    size: 'each',
    price: 249,
    emoji: '🌿',
    store: 'Spice World Grocers',
    tint: Color(0xFFE8F5E4),
  ),
  Product(
    name: 'Mango lassi',
    size: '1 L',
    price: 549,
    emoji: '🥭',
    store: 'Lahore Sweets & Bakery',
    tint: Color(0xFFFFF1D0),
  ),
];
