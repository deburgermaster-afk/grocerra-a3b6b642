import '../../../core/cart/cart_controller.dart';

/// Demo checkout figures shared by the checkout, tip and confirmation
/// screens so the money always adds up the same way wherever it is read.
///
/// Everything derives from the live [CartStore] subtotal - change a
/// quantity in the cart and every screen down the flow recomputes. No
/// backend: the promotion, delivery and tax rates are fixed demo values.
abstract final class CheckoutTotals {
  /// Delivery speed picked on the checkout screen: priority adds its
  /// surcharge to the total. Kept here so the tip screen (pushed next)
  /// shows the same figure without route arguments.
  static bool priority = false;

  /// Fixed demo promotion (the `Saving $2.50` banner).
  static const double promo = 2.50;

  /// Madina's catalogue delivery fee, before the free-delivery promotion.
  static const double deliveryWas = 5.99;

  /// Priority surcharge shown next to the Priority option.
  static const double priorityFee = 2.99;

  static double get subtotal => CartStore.instance.subtotal;

  /// Fees & taxes at a flat demo rate, rounded to cents.
  static double get taxes =>
      double.parse((subtotal * 0.0885).toStringAsFixed(2));

  /// What the shopper pays for delivery now: free, or priority.
  static double get delivery => priority ? priorityFee : 0.0;

  /// Payable total after the promotion (before the courier tip).
  static double get total => subtotal - promo + delivery + taxes;

  /// The same total with delivery full price and no promotion - what the
  /// Total row strikes through.
  static double get wasTotal => subtotal + deliveryWas + taxes;

  /// A dollars-and-cents label, always two decimals.
  static String usd(double value) => '\$${value.toStringAsFixed(2)}';
}
