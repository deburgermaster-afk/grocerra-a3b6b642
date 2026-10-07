/// Order and delivery tracking domain models for Grocerra.
library;

enum OrderStatus {
  placed,
  confirmed,
  accepted,
  packing,
  dispatched,
  delivered,
  cancelled,
}

class OrderItemModel {
  const OrderItemModel({
    required this.name,
    required this.variantLabel,
    required this.quantity,
    required this.unitPriceCents,
    this.productId,
    this.finalWeightGrams,
    this.isCatchWeight = false,
  });

  final String? productId;
  final String name;
  String get productName => name;
  final String variantLabel;
  final int quantity;
  final int unitPriceCents;
  final int? finalWeightGrams;
  final bool isCatchWeight;

  int get totalCents => unitPriceCents * quantity;
  String get formattedTotal => '\$${(totalCents / 100).toStringAsFixed(2)}';
}

class OrderModel {
  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.storeName,
    this.storeId,
    this.storeImageUrl =
        'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=600&q=80',
    required this.status,
    DateTime? placedAt,
    DateTime? createdAt,
    required this.deliveryAddress,
    required this.subtotalCents,
    required this.deliveryFeeCents,
    this.platformFeeCents = 150,
    this.tipCents = 0,
    required this.totalCents,
    this.preAuthHoldCents = 0,
    required this.items,
    String? courierProvider,
    String? courierPartner,
    this.driverName = 'Ahmed K.',
    this.driverPhone = '+61 400 123 456',
    this.deliveryEtaMinutes = 20,
    this.proofPhotoUrl,
  })  : placedAt = placedAt ?? createdAt ?? DateTime.now(),
        courierProvider = courierPartner ?? courierProvider ?? 'Uber Direct';

  final String id;
  final String orderNumber;
  final String? storeId;
  final String storeName;
  final String storeImageUrl;
  final OrderStatus status;
  final DateTime placedAt;
  DateTime get createdAt => placedAt;
  final String deliveryAddress;
  final int subtotalCents;
  final int deliveryFeeCents;
  final int platformFeeCents;
  final int tipCents;
  final int totalCents;
  final int preAuthHoldCents;
  final List<OrderItemModel> items;
  final String courierProvider;
  String get courierPartner => courierProvider;
  final String driverName;
  final String driverPhone;
  final int deliveryEtaMinutes;
  final String? proofPhotoUrl;

  bool get hasCatchWeightHold =>
      preAuthHoldCents > 0 || items.any((OrderItemModel i) => i.isCatchWeight);

  String get formattedTotal => '\$${(totalCents / 100).toStringAsFixed(2)}';

  String get statusDisplay {
    switch (status) {
      case OrderStatus.placed:
      case OrderStatus.confirmed:
        return 'Order Placed';
      case OrderStatus.accepted:
        return 'Store Accepted';
      case OrderStatus.packing:
        return 'Weighing & Packing';
      case OrderStatus.dispatched:
        return 'On the way';
      case OrderStatus.delivered:
        return 'Delivered';
      case OrderStatus.cancelled:
        return 'Cancelled';
    }
  }

  bool get isActive =>
      status != OrderStatus.delivered && status != OrderStatus.cancelled;
}
