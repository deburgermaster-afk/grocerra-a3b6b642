import 'package:flutter/foundation.dart';

import 'cart_item.dart';

/// The app's single cart state.
///
/// Built on Flutter's own [ChangeNotifier]: every screen that shows the cart
/// (Carts, Cart, Home badge) listens through `ListenableBuilder`, so one
/// mutation updates the rows, the store count and the totals immediately.
///
/// Offline demo state only - nothing is persisted, synced or sent anywhere.
class CartController extends ChangeNotifier {
  CartController({Iterable<CartItem>? initialItems}) {
    if (initialItems != null) {
      _items.addAll(initialItems);
    }
  }

  final List<CartItem> _items = <CartItem>[];

  /// Lines in the order they were first added. Unmodifiable: mutate through
  /// the methods below so listeners are notified.
  List<CartItem> get items => List<CartItem>.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  /// Units in the cart - the count the cart badge and the `3 items` row
  /// report.
  int get itemCount => _items.fold<int>(
        0,
        (int sum, CartItem item) => sum + item.quantity,
      );

  /// Subtotal: every line total, computed from state - never a stored figure.
  double get subtotal => _items.fold<double>(
        0.0,
        (double sum, CartItem item) => sum + item.lineTotal,
      );

  /// Units of [id] in the cart (0 when the product is not in it).
  int quantityOf(String id) {
    final int index = _items.indexWhere((CartItem line) => line.id == id);
    return index == -1 ? 0 : _items[index].quantity;
  }

  /// Adds [item]'s quantity to the cart.
  ///
  /// A product that is already in the cart keeps its line (and its first-seen
  /// variant details) and only grows in quantity - adding twice never creates
  /// a duplicate row.
  void add(CartItem item) {
    assert(item.quantity > 0, 'Adding to the cart requires a positive quantity');
    final int index = _items.indexWhere((CartItem line) => line.id == item.id);
    if (index == -1) {
      _items.add(item);
    } else {
      _items[index] = _items[index].withQuantity(
        _items[index].quantity + item.quantity,
      );
    }
    notifyListeners();
  }

  /// Sets the quantity of [id].
  ///
  /// Zero (or less) removes the line: the stepper has no separate delete
  /// affordance, so its minus on the last unit is what deletes the item.
  void setQuantity(String id, int quantity) {
    final int index = _items.indexWhere((CartItem line) => line.id == id);
    if (index == -1) {
      return;
    }
    if (quantity <= 0) {
      _items.removeAt(index);
    } else if (_items[index].quantity == quantity) {
      return;
    } else {
      _items[index] = _items[index].withQuantity(quantity);
    }
    notifyListeners();
  }

  /// Removes [id] outright.
  void remove(String id) => setQuantity(id, 0);

  /// Empties the cart (the last line going to zero lands here too).
  void clear() {
    if (_items.isEmpty) {
      return;
    }
    _items.clear();
    notifyListeners();
  }
}

/// App-wide access to the one cart every screen shares.
abstract final class CartStore {
  /// The cart Carts, Cart and the Home badge all read and listen to.
  static final CartController instance = CartController(
    initialItems: demoItems,
  );

  /// The approved cart exactly as the frame renders it (3 lines totalling
  /// $53.98): the demo starts on the approved cart rather than an empty one,
  /// so every entry point opens on the same figures.
  static const List<CartItem> demoItems = <CartItem>[
    CartItem(
      id: 'goat-curry-cut',
      name: 'Goat Curry Cut',
      price: 16.99,
      image: 'cart_goat_curry.png',
      detail: '1 kg · Curry cut',
    ),
    CartItem(
      id: 'chicken-curry-pieces',
      name: 'Chicken Curry Pieces',
      price: 21.00,
      image: 'cart_chicken.png',
      detail: '2 kg · Est. weight',
    ),
    CartItem(
      id: 'basmati-rice',
      name: 'Basmati Rice',
      price: 15.99,
      image: 'cart_rice.png',
      detail: '5 kg bag',
    ),
  ];
}
