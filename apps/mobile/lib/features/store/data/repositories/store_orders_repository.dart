import 'dart:async';
import '../models/store_order.dart';

abstract class StoreOrdersRepository {
  Stream<List<StoreOrder>> watchOrders();
  Future<List<StoreOrder>> getOrders();
  Future<void> acceptOrder(String orderId, {int prepBufferMinutes = 0});
  Future<void> declineOrder(String orderId, String reason);
  Future<void> updateOrderItemPacked(String orderId, String itemId, bool isPacked);
  Future<void> updateItemScaleWeight(String orderId, String itemId, double weightKg);
  Future<void> markOrderPacked(String orderId, int chilledBags, int ambientBags);
  Future<void> handoverToCourier(String orderId);
}

class MockStoreOrdersRepository implements StoreOrdersRepository {
  final _ordersController = StreamController<List<StoreOrder>>.broadcast();
  List<StoreOrder> _orders = [];

  MockStoreOrdersRepository() {
    _initMockData();
  }

  void _initMockData() {
    _orders = [
      StoreOrder(
        id: '8492',
        customerName: 'Ayesha K.',
        customerPhone: '+61 412 889 123',
        deliveryAddress: '24 Baxter St, Coburg VIC 3058',
        customerNote: 'Please pack Halal goat meat separately in leakproof bag',
        totalCents: 7450,
        status: StoreOrderStatus.incoming,
        createdAt: DateTime.now().subtract(const Duration(seconds: 15)),
        acceptCountdownSeconds: 45,
        prepDueMinutes: 14,
        items: const [
          StoreOrderItem(
            id: 'item-1',
            name: 'Daawat Traditional Basmati Rice 5kg',
            sku: 'GRN-DAAW-5KG',
            quantity: 1,
            unitPriceCents: 2190,
            category: 'Basmati & Grains',
          ),
          StoreOrderItem(
            id: 'item-2',
            name: 'Shan Bombay Biryani Masala 50g',
            sku: 'PAN-SHAN-BOMBAY',
            quantity: 3,
            unitPriceCents: 245,
            category: 'Spices & Masalas',
          ),
          StoreOrderItem(
            id: 'item-3',
            name: 'Fresh Halal Baby Goat Curry Cut',
            sku: 'BUT-GOAT-001',
            quantity: 1,
            unitPriceCents: 2850,
            isCatchWeight: true,
            requestedWeightKg: 1.50,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-4',
            name: 'Fresh Mint & Coriander Bunches',
            sku: 'PRD-HERB-CMB',
            quantity: 2,
            unitPriceCents: 350,
            category: 'Fresh Produce',
          ),
          StoreOrderItem(
            id: 'item-5',
            name: 'National Ginger Garlic Paste 330g',
            sku: 'PAN-NAT-GG',
            quantity: 1,
            unitPriceCents: 395,
            category: 'Spices & Masalas',
          ),
        ],
      ),
      StoreOrder(
        id: '8489',
        customerName: 'Tariq M.',
        customerPhone: '+61 423 456 789',
        deliveryAddress: '88 Bell St, Coburg VIC 3058',
        customerNote: 'Ring counter bell upon arrival',
        totalCents: 5240,
        status: StoreOrderStatus.inPacking,
        createdAt: DateTime.now().subtract(const Duration(minutes: 8)),
        prepDueMinutes: 8,
        chilledBagsCount: 2,
        ambientBagsCount: 1,
        items: const [
          StoreOrderItem(
            id: 'item-201',
            name: 'Daawat Traditional Basmati Rice 5kg',
            sku: 'GRN-DAAW-5KG',
            quantity: 1,
            unitPriceCents: 2190,
            isPacked: true,
            category: 'Basmati & Grains',
          ),
          StoreOrderItem(
            id: 'item-202',
            name: 'Shan Biryani Masala 50g',
            sku: 'PAN-SHAN-BOMBAY',
            quantity: 2,
            unitPriceCents: 245,
            isPacked: true,
            category: 'Spices & Masalas',
          ),
          StoreOrderItem(
            id: 'item-203',
            name: 'Fresh Halal Baby Goat Curry Cut',
            sku: 'BUT-GOAT-001',
            quantity: 1,
            unitPriceCents: 2926,
            isCatchWeight: true,
            requestedWeightKg: 1.50,
            actualWeightKg: 1.54,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-204',
            name: 'Fresh Mint & Coriander Bunches',
            sku: 'PRD-HERB-CMB',
            quantity: 2,
            unitPriceCents: 350,
            isPacked: false,
            category: 'Fresh Produce',
          ),
        ],
      ),
      StoreOrder(
        id: '8485',
        customerName: 'Farhan M.',
        customerPhone: '+61 433 112 998',
        deliveryAddress: '102 Sydney Rd, Brunswick VIC 3056',
        totalCents: 6240,
        status: StoreOrderStatus.readyForDriver,
        createdAt: DateTime.now().subtract(const Duration(minutes: 18)),
        courierProvider: 'Uber Direct',
        courierDriverName: 'Alex M.',
        courierEtaMinutes: 3,
        courierPickupPin: '5821',
        chilledBagsCount: 1,
        ambientBagsCount: 2,
        items: const [
          StoreOrderItem(
            id: 'item-301',
            name: 'Fresh Halal Chicken Breast 1kg',
            sku: 'BUT-CHK-BRST',
            quantity: 2,
            unitPriceCents: 1450,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-302',
            name: 'Royal Basmati Rice 5kg',
            sku: 'GRN-ROYL-5KG',
            quantity: 1,
            unitPriceCents: 2200,
            isPacked: true,
            category: 'Basmati & Grains',
          ),
        ],
      ),
      // Historical Completed Order #8480
      StoreOrder(
        id: '8480',
        customerName: 'Zainab R.',
        customerPhone: '+61 411 992 334',
        deliveryAddress: '45 Victoria St, Brunswick VIC 3056',
        totalCents: 11890,
        status: StoreOrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(hours: 1, minutes: 20)),
        courierProvider: 'DoorDash Drive',
        courierDriverName: 'Kevin P.',
        courierPickupPin: '4190',
        chilledBagsCount: 2,
        ambientBagsCount: 2,
        invoiceNumber: 'INV-2026-8480',
        items: const [
          StoreOrderItem(
            id: 'item-401',
            name: 'Fresh Halal Baby Goat Curry Cut',
            sku: 'BUT-GOAT-001',
            quantity: 2,
            unitPriceCents: 2850,
            isCatchWeight: true,
            requestedWeightKg: 3.0,
            actualWeightKg: 3.05,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-402',
            name: 'Daawat Traditional Basmati Rice 5kg',
            sku: 'GRN-DAAW-5KG',
            quantity: 2,
            unitPriceCents: 2190,
            isPacked: true,
            category: 'Basmati & Grains',
          ),
          StoreOrderItem(
            id: 'item-403',
            name: 'Shan Bombay Biryani Masala 50g',
            sku: 'PAN-SHAN-BOMBAY',
            quantity: 4,
            unitPriceCents: 245,
            isPacked: true,
            category: 'Spices & Masalas',
          ),
        ],
      ),
      // Historical Refunded Order #8476
      StoreOrder(
        id: '8476',
        customerName: 'Bilal T.',
        customerPhone: '+61 455 334 221',
        deliveryAddress: '12 Munro St, Coburg VIC 3058',
        totalCents: 3420,
        status: StoreOrderStatus.refunded,
        createdAt: DateTime.now().subtract(const Duration(hours: 2, minutes: 5)),
        courierProvider: 'Uber Direct',
        courierDriverName: 'Rashid A.',
        courierPickupPin: '3318',
        chilledBagsCount: 1,
        ambientBagsCount: 1,
        refundAmountCents: 450,
        refundReason: 'Damaged item: 1x Fresh Mint & Coriander bruised during transit',
        disputeNotes: 'Automatic partial refund approved (\$4.50 AUD) under Uber Direct merchant protection policy.',
        invoiceNumber: 'INV-2026-8476',
        items: const [
          StoreOrderItem(
            id: 'item-501',
            name: 'Fresh Halal Beef Mince 1kg',
            sku: 'BUT-BEEF-MNC',
            quantity: 1,
            unitPriceCents: 1850,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-502',
            name: 'Shan Meat Masala 50g',
            sku: 'PAN-SHAN-MEAT',
            quantity: 2,
            unitPriceCents: 245,
            isPacked: true,
            category: 'Spices & Masalas',
          ),
          StoreOrderItem(
            id: 'item-503',
            name: 'Fresh Mint & Coriander Bunches',
            sku: 'PRD-HERB-CMB',
            quantity: 2,
            unitPriceCents: 350,
            isPacked: true,
            category: 'Fresh Produce',
          ),
        ],
      ),
      // Historical Catering Order #8471
      StoreOrder(
        id: '8471',
        customerName: 'S. Ahmed',
        customerPhone: '+61 400 778 899',
        deliveryAddress: 'Grand Hall, 220 Sydney Rd, Brunswick VIC 3056',
        customerNote: 'Community gathering catering order · 40 pax',
        totalCents: 68000,
        status: StoreOrderStatus.completed,
        isCatering: true,
        createdAt: DateTime.now().subtract(const Duration(hours: 3, minutes: 30)),
        courierProvider: 'Uber Direct',
        courierDriverName: 'Uber Van - Tariq M.',
        courierPickupPin: 'CAT-40',
        chilledBagsCount: 6,
        ambientBagsCount: 4,
        invoiceNumber: 'INV-2026-8471',
        items: const [
          StoreOrderItem(
            id: 'item-601',
            name: 'Catering Halal Mutton Dum Biryani (40 Pax Cauldron)',
            sku: 'CAT-BIR-40P',
            quantity: 1,
            unitPriceCents: 45000,
            isPacked: true,
            category: 'Catering',
          ),
          StoreOrderItem(
            id: 'item-602',
            name: 'Fresh Halal Chicken Seekh Kebabs (40 Skewers)',
            sku: 'CAT-KB-40',
            quantity: 1,
            unitPriceCents: 15000,
            isPacked: true,
            category: 'Catering',
          ),
          StoreOrderItem(
            id: 'item-603',
            name: 'Cucumber & Mint Raita (5 Litre Dispenser)',
            sku: 'CAT-RAITA-5L',
            quantity: 1,
            unitPriceCents: 8000,
            isPacked: true,
            category: 'Catering',
          ),
        ],
      ),
      // Historical Completed Order #8468
      StoreOrder(
        id: '8468',
        customerName: 'Mariam H.',
        customerPhone: '+61 422 667 889',
        deliveryAddress: '31 Donald St, Brunswick VIC 3056',
        totalCents: 4850,
        status: StoreOrderStatus.completed,
        createdAt: DateTime.now().subtract(const Duration(hours: 4, minutes: 40)),
        courierProvider: 'Uber Direct',
        courierDriverName: 'Sam K.',
        courierPickupPin: '1289',
        chilledBagsCount: 1,
        ambientBagsCount: 1,
        invoiceNumber: 'INV-2026-8468',
        items: const [
          StoreOrderItem(
            id: 'item-701',
            name: 'Fresh Halal Chicken Drumsticks 2kg',
            sku: 'BUT-CHK-DRUM',
            quantity: 1,
            unitPriceCents: 1650,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-702',
            name: 'Shan Tandoori Masala 50g',
            sku: 'PAN-SHAN-TAND',
            quantity: 2,
            unitPriceCents: 245,
            isPacked: true,
            category: 'Spices & Masalas',
          ),
          StoreOrderItem(
            id: 'item-703',
            name: 'Lal Qilla Basmati Rice 5kg',
            sku: 'GRN-LAL-5KG',
            quantity: 1,
            unitPriceCents: 2450,
            isPacked: true,
            category: 'Basmati & Grains',
          ),
        ],
      ),
      // Historical Cancelled / Declined Order #8465
      StoreOrder(
        id: '8465',
        customerName: 'Omar K.',
        customerPhone: '+61 411 223 344',
        deliveryAddress: '350 Glenroy Rd, Glenroy VIC 3046',
        customerNote: 'Customer outside maximum 12km delivery radius',
        totalCents: 8920,
        status: StoreOrderStatus.declined,
        createdAt: DateTime.now().subtract(const Duration(hours: 5, minutes: 50)),
        courierProvider: 'DoorDash Drive',
        items: const [
          StoreOrderItem(
            id: 'item-801',
            name: 'Fresh Halal Lamb Chops 1.5kg',
            sku: 'BUT-LMB-CHP',
            quantity: 1,
            unitPriceCents: 4200,
            category: 'Halal Butcher',
          ),
        ],
      ),
      // Historical Catering Order #8460
      StoreOrder(
        id: '8460',
        customerName: 'Hassan D.',
        customerPhone: '+61 499 887 766',
        deliveryAddress: 'Coburg Community Hall, Elm St, Coburg VIC 3058',
        totalCents: 42500,
        status: StoreOrderStatus.completed,
        isCatering: true,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 2)),
        courierProvider: 'DoorDash Drive',
        courierDriverName: 'DoorDash Large - Bilal H.',
        courierPickupPin: 'CAT-25',
        chilledBagsCount: 4,
        ambientBagsCount: 3,
        invoiceNumber: 'INV-2026-8460',
        items: const [
          StoreOrderItem(
            id: 'item-901',
            name: 'Catering Halal Chicken Biryani (25 Pax Cauldron)',
            sku: 'CAT-BIR-25P',
            quantity: 1,
            unitPriceCents: 29500,
            isPacked: true,
            category: 'Catering',
          ),
          StoreOrderItem(
            id: 'item-902',
            name: 'Fresh Halal Shami Kebabs (25 Pieces)',
            sku: 'CAT-SHAMI-25',
            quantity: 1,
            unitPriceCents: 13000,
            isPacked: true,
            category: 'Catering',
          ),
        ],
      ),
      // Historical Disputed Order #8455
      StoreOrder(
        id: '8455',
        customerName: 'Leila B.',
        customerPhone: '+61 477 112 334',
        deliveryAddress: '18 Albion St, Brunswick VIC 3056',
        totalCents: 9580,
        status: StoreOrderStatus.disputed,
        createdAt: DateTime.now().subtract(const Duration(days: 1, hours: 4)),
        courierProvider: 'Uber Direct',
        courierDriverName: 'Alex M.',
        courierPickupPin: '9021',
        refundAmountCents: 1200,
        refundReason: 'Customer reported missing 1x Shan Biryani and wrong yogurt brand',
        disputeNotes: 'Customer opened dispute with DoorDash/Uber support. Merchant provided packing photo evidence.',
        invoiceNumber: 'INV-2026-8455',
        items: const [
          StoreOrderItem(
            id: 'item-1001',
            name: 'Fresh Halal Baby Goat Curry Cut 2kg',
            sku: 'BUT-GOAT-001',
            quantity: 1,
            unitPriceCents: 5700,
            isPacked: true,
            category: 'Halal Butcher',
          ),
          StoreOrderItem(
            id: 'item-1002',
            name: 'Jalna Pot Set Greek Yogurt 1kg',
            sku: 'DAI-JAL-1KG',
            quantity: 2,
            unitPriceCents: 750,
            isPacked: true,
            category: 'Dairy',
          ),
        ],
      ),
    ];
    _emit();
  }

  void _emit() {
    _ordersController.add(List.unmodifiable(_orders));
  }

  @override
  Stream<List<StoreOrder>> watchOrders() {
    // Immediate initial push on listen
    Future.microtask(_emit);
    return _ordersController.stream;
  }

  @override
  Future<List<StoreOrder>> getOrders() async {
    return List.unmodifiable(_orders);
  }

  @override
  Future<void> acceptOrder(String orderId, {int prepBufferMinutes = 0}) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      final current = _orders[index];
      _orders[index] = current.copyWith(
        status: StoreOrderStatus.inPacking,
        prepDueMinutes: current.prepDueMinutes + prepBufferMinutes,
      );
      _emit();
    }
  }

  @override
  Future<void> declineOrder(String orderId, String reason) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: StoreOrderStatus.declined,
      );
      _emit();
    }
  }

  @override
  Future<void> updateOrderItemPacked(String orderId, String itemId, bool isPacked) async {
    final oIdx = _orders.indexWhere((o) => o.id == orderId);
    if (oIdx != -1) {
      final order = _orders[oIdx];
      final newItems = order.items.map((i) {
        if (i.id == itemId) return i.copyWith(isPacked: isPacked);
        return i;
      }).toList();
      _orders[oIdx] = order.copyWith(items: newItems);
      _emit();
    }
  }

  @override
  Future<void> updateItemScaleWeight(String orderId, String itemId, double weightKg) async {
    final oIdx = _orders.indexWhere((o) => o.id == orderId);
    if (oIdx != -1) {
      final order = _orders[oIdx];
      final newItems = order.items.map((i) {
        if (i.id == itemId) return i.copyWith(actualWeightKg: weightKg, isPacked: true);
        return i;
      }).toList();
      _orders[oIdx] = order.copyWith(items: newItems);
      _emit();
    }
  }

  @override
  Future<void> markOrderPacked(String orderId, int chilledBags, int ambientBags) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: StoreOrderStatus.readyForDriver,
        chilledBagsCount: chilledBags,
        ambientBagsCount: ambientBags,
        courierProvider: 'Uber Direct',
        courierEtaMinutes: 5,
        courierPickupPin: '5821',
      );
      _emit();
    }
  }

  @override
  Future<void> handoverToCourier(String orderId) async {
    final index = _orders.indexWhere((o) => o.id == orderId);
    if (index != -1) {
      _orders[index] = _orders[index].copyWith(
        status: StoreOrderStatus.completed,
      );
      _emit();
    }
  }

  void dispose() {
    _ordersController.close();
  }
}
