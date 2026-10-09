enum StoreOrderStatus {
  incoming,
  inPacking,
  readyForDriver,
  completed,
  declined,
  refunded,
  disputed,
}

class StoreOrderItem {
  final String id;
  final String name;
  final String sku;
  final int quantity;
  final int unitPriceCents;
  final bool isCatchWeight;
  final double? requestedWeightKg;
  final double? actualWeightKg;
  final bool isPacked;
  final String? category;

  const StoreOrderItem({
    required this.id,
    required this.name,
    required this.sku,
    required this.quantity,
    required this.unitPriceCents,
    this.isCatchWeight = false,
    this.requestedWeightKg,
    this.actualWeightKg,
    this.isPacked = false,
    this.category,
  });

  StoreOrderItem copyWith({
    bool? isPacked,
    double? actualWeightKg,
  }) {
    return StoreOrderItem(
      id: id,
      name: name,
      sku: sku,
      quantity: quantity,
      unitPriceCents: unitPriceCents,
      isCatchWeight: isCatchWeight,
      requestedWeightKg: requestedWeightKg,
      actualWeightKg: actualWeightKg ?? this.actualWeightKg,
      isPacked: isPacked ?? this.isPacked,
      category: category,
    );
  }

  factory StoreOrderItem.fromJson(Map<String, dynamic> json) {
    return StoreOrderItem(
      id: json['id'] as String? ?? '',
      name: json['name'] as String? ?? '',
      sku: json['sku'] as String? ?? '',
      quantity: json['quantity'] as int? ?? 1,
      unitPriceCents: json['unit_price_cents'] as int? ?? 0,
      isCatchWeight: json['is_catch_weight'] as bool? ?? false,
      requestedWeightKg: (json['requested_weight_kg'] as num?)?.toDouble(),
      actualWeightKg: (json['actual_weight_kg'] as num?)?.toDouble(),
      isPacked: json['is_packed'] as bool? ?? false,
      category: json['category'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'sku': sku,
      'quantity': quantity,
      'unit_price_cents': unitPriceCents,
      'is_catch_weight': isCatchWeight,
      'requested_weight_kg': requestedWeightKg,
      'actual_weight_kg': actualWeightKg,
      'is_packed': isPacked,
      'category': category,
    };
  }
}

class StoreOrder {
  final String id;
  final String customerName;
  final String customerPhone;
  final String deliveryAddress;
  final String? customerNote;
  final List<StoreOrderItem> items;
  final int totalCents;
  final StoreOrderStatus status;
  final DateTime createdAt;
  final int acceptCountdownSeconds;
  final int prepDueMinutes;
  final String? courierProvider;
  final String? courierDriverName;
  final int? courierEtaMinutes;
  final String? courierPickupPin;
  final int chilledBagsCount;
  final int ambientBagsCount;
  final bool isCatering;
  final int? refundAmountCents;
  final String? refundReason;
  final String? disputeNotes;
  final String? invoiceNumber;

  const StoreOrder({
    required this.id,
    required this.customerName,
    required this.customerPhone,
    required this.deliveryAddress,
    this.customerNote,
    required this.items,
    required this.totalCents,
    required this.status,
    required this.createdAt,
    this.acceptCountdownSeconds = 45,
    this.prepDueMinutes = 15,
    this.courierProvider,
    this.courierDriverName,
    this.courierEtaMinutes,
    this.courierPickupPin,
    this.chilledBagsCount = 0,
    this.ambientBagsCount = 1,
    this.isCatering = false,
    this.refundAmountCents,
    this.refundReason,
    this.disputeNotes,
    this.invoiceNumber,
  });

  double get packingProgress {
    if (items.isEmpty) return 0.0;
    final packed = items.where((i) => i.isPacked).length;
    return packed / items.length;
  }

  int get packedCount => items.where((i) => i.isPacked).length;

  StoreOrder copyWith({
    StoreOrderStatus? status,
    List<StoreOrderItem>? items,
    int? acceptCountdownSeconds,
    int? prepDueMinutes,
    String? courierProvider,
    String? courierDriverName,
    int? courierEtaMinutes,
    String? courierPickupPin,
    int? chilledBagsCount,
    int? ambientBagsCount,
    bool? isCatering,
    int? refundAmountCents,
    String? refundReason,
    String? disputeNotes,
    String? invoiceNumber,
  }) {
    return StoreOrder(
      id: id,
      customerName: customerName,
      customerPhone: customerPhone,
      deliveryAddress: deliveryAddress,
      customerNote: customerNote,
      items: items ?? this.items,
      totalCents: totalCents,
      status: status ?? this.status,
      createdAt: createdAt,
      acceptCountdownSeconds: acceptCountdownSeconds ?? this.acceptCountdownSeconds,
      prepDueMinutes: prepDueMinutes ?? this.prepDueMinutes,
      courierProvider: courierProvider ?? this.courierProvider,
      courierDriverName: courierDriverName ?? this.courierDriverName,
      courierEtaMinutes: courierEtaMinutes ?? this.courierEtaMinutes,
      courierPickupPin: courierPickupPin ?? this.courierPickupPin,
      chilledBagsCount: chilledBagsCount ?? this.chilledBagsCount,
      ambientBagsCount: ambientBagsCount ?? this.ambientBagsCount,
      isCatering: isCatering ?? this.isCatering,
      refundAmountCents: refundAmountCents ?? this.refundAmountCents,
      refundReason: refundReason ?? this.refundReason,
      disputeNotes: disputeNotes ?? this.disputeNotes,
      invoiceNumber: invoiceNumber ?? this.invoiceNumber,
    );
  }

  factory StoreOrder.fromJson(Map<String, dynamic> json) {
    return StoreOrder(
      id: json['id'] as String? ?? '',
      customerName: json['customer_name'] as String? ?? '',
      customerPhone: json['customer_phone'] as String? ?? '',
      deliveryAddress: json['delivery_address'] as String? ?? '',
      customerNote: json['customer_note'] as String?,
      items: (json['items'] as List<dynamic>? ?? [])
          .map((item) => StoreOrderItem.fromJson(item as Map<String, dynamic>))
          .toList(),
      totalCents: json['total_cents'] as int? ?? 0,
      status: StoreOrderStatus.values.firstWhere(
        (e) => e.name == json['status'],
        orElse: () => StoreOrderStatus.incoming,
      ),
      createdAt: json['created_at'] != null
          ? DateTime.parse(json['created_at'] as String)
          : DateTime.now(),
      acceptCountdownSeconds: json['accept_countdown_seconds'] as int? ?? 45,
      prepDueMinutes: json['prep_due_minutes'] as int? ?? 15,
      courierProvider: json['courier_provider'] as String?,
      courierDriverName: json['courier_driver_name'] as String?,
      courierEtaMinutes: json['courier_eta_minutes'] as int?,
      courierPickupPin: json['courier_pickup_pin'] as String?,
      chilledBagsCount: json['chilled_bags_count'] as int? ?? 0,
      ambientBagsCount: json['ambient_bags_count'] as int? ?? 1,
      isCatering: json['is_catering'] as bool? ?? false,
      refundAmountCents: json['refund_amount_cents'] as int?,
      refundReason: json['refund_reason'] as String?,
      disputeNotes: json['dispute_notes'] as String?,
      invoiceNumber: json['invoice_number'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'customer_name': customerName,
      'customer_phone': customerPhone,
      'delivery_address': deliveryAddress,
      'customer_note': customerNote,
      'items': items.map((i) => i.toJson()).toList(),
      'total_cents': totalCents,
      'status': status.name,
      'created_at': createdAt.toIso8601String(),
      'accept_countdown_seconds': acceptCountdownSeconds,
      'prep_due_minutes': prepDueMinutes,
      'courier_provider': courierProvider,
      'courier_driver_name': courierDriverName,
      'courier_eta_minutes': courierEtaMinutes,
      'courier_pickup_pin': courierPickupPin,
      'chilled_bags_count': chilledBagsCount,
      'ambient_bags_count': ambientBagsCount,
      'is_catering': isCatering,
      'refund_amount_cents': refundAmountCents,
      'refund_reason': refundReason,
      'dispute_notes': disputeNotes,
      'invoice_number': invoiceNumber,
    };
  }
}
