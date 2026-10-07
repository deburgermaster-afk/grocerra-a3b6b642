/// Order model and prototype data for the Orders tab.
///
/// Mirrors the prototype store (Madina Halal Meats) used by the shop screens
/// so the cart -> checkout -> orders flow reads as one story. Swap for the
/// `orders` table via Supabase (with Realtime for status) when the backend
/// lands; screens only depend on [Order] and [OrderStatus].
library;

enum OrderStatus {
  placed('Order placed'),
  packing('Packing'),
  onTheWay('On the way'),
  delivered('Delivered'),
  cancelled('Cancelled');

  const OrderStatus(this.label);

  final String label;

  bool get isActive => this == placed || this == packing || this == onTheWay;

  /// The steps shown on the progress timeline, in order.
  static const List<OrderStatus> timeline = <OrderStatus>[
    placed,
    packing,
    onTheWay,
    delivered,
  ];
}

class OrderItem {
  const OrderItem({
    required this.name,
    required this.detail,
    required this.quantity,
    required this.price,
    this.estimatedKg,
    this.actualKg,
  });

  final String name;
  final String detail;
  final int quantity;

  /// Price charged at checkout, in cents.
  final int price;

  /// Meat is sold by estimated weight and re-weighed when packed. When the
  /// packed weight comes in under the estimate the difference is refunded.
  final double? estimatedKg;
  final double? actualKg;

  bool get isWeighed => estimatedKg != null && actualKg != null;

  /// Refund owed for a short weight, in cents (0 when not weighed or heavier).
  int get weightRefund {
    if (!isWeighed || actualKg! >= estimatedKg!) {
      return 0;
    }
    return (price * (1 - actualKg! / estimatedKg!)).round();
  }
}

class Order {
  const Order({
    required this.id,
    required this.store,
    required this.placedAt,
    required this.status,
    required this.items,
    required this.deliveryFee,
    required this.serviceFee,
    required this.address,
    this.etaMinutes,
    this.courierName,
  });

  final String id;
  final String store;
  final String placedAt;
  final OrderStatus status;
  final List<OrderItem> items;

  /// Fees in cents.
  final int deliveryFee;
  final int serviceFee;
  final String address;

  /// Minutes until arrival, for active orders.
  final int? etaMinutes;
  final String? courierName;

  int get itemCount =>
      items.fold(0, (int sum, OrderItem item) => sum + item.quantity);

  String get itemCountLabel => itemCount == 1 ? '1 item' : '$itemCount items';

  int get subtotal =>
      items.fold(0, (int sum, OrderItem item) => sum + item.price);

  int get weightRefund =>
      items.fold(0, (int sum, OrderItem item) => sum + item.weightRefund);

  int get total => subtotal + deliveryFee + serviceFee - weightRefund;

  String get itemSummary => items.map((OrderItem item) => item.name).join(', ');
}

/// Formats cents as `$12.34`.
String formatPrice(int cents) {
  final String dollars = (cents ~/ 100).toString();
  final String rest = (cents % 100).toString().padLeft(2, '0');
  return '\$$dollars.$rest';
}

const List<Order> sampleOrders = <Order>[
  Order(
    id: 'GR-10482',
    store: 'Madina Halal Meats',
    placedAt: 'Today, 5:42 pm',
    status: OrderStatus.onTheWay,
    etaMinutes: 14,
    courierName: 'Imran',
    address: '24 Sydney Rd, Brunswick VIC 3056',
    deliveryFee: 599,
    serviceFee: 150,
    items: <OrderItem>[
      OrderItem(
        name: 'Goat Curry Cut',
        detail: 'Curry cut',
        quantity: 1,
        price: 1699,
        estimatedKg: 1.0,
        actualKg: 0.94,
      ),
      OrderItem(
        name: 'Chicken Curry Pieces',
        detail: 'Skinless',
        quantity: 1,
        price: 2100,
        estimatedKg: 2.0,
        actualKg: 2.0,
      ),
      OrderItem(
        name: 'Basmati Rice',
        detail: '5 kg bag',
        quantity: 1,
        price: 1599,
      ),
    ],
  ),
  Order(
    id: 'GR-10431',
    store: 'Madina Halal Meats',
    placedAt: 'Sat 3 Oct, 11:05 am',
    status: OrderStatus.delivered,
    address: '24 Sydney Rd, Brunswick VIC 3056',
    deliveryFee: 599,
    serviceFee: 150,
    items: <OrderItem>[
      OrderItem(name: 'Lamb Mince', detail: '500 g', quantity: 2, price: 2598),
      OrderItem(
        name: 'Chicken Drumsticks',
        detail: 'Est. weight',
        quantity: 1,
        price: 899,
        estimatedKg: 1.0,
        actualKg: 0.9,
      ),
      OrderItem(
        name: 'Shan Biryani Masala',
        detail: '50 g',
        quantity: 3,
        price: 597,
      ),
    ],
  ),
  Order(
    id: 'GR-10377',
    store: 'Madina Halal Meats',
    placedAt: 'Sun 27 Sep, 6:30 pm',
    status: OrderStatus.cancelled,
    address: '24 Sydney Rd, Brunswick VIC 3056',
    deliveryFee: 599,
    serviceFee: 150,
    items: <OrderItem>[
      OrderItem(
        name: 'Jasmine Rice',
        detail: '2 kg bag',
        quantity: 1,
        price: 1499,
      ),
    ],
  ),
];

Order? findOrder(String? id) {
  for (final Order order in sampleOrders) {
    if (order.id == id) {
      return order;
    }
  }
  return null;
}
