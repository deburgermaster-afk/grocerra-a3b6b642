import 'package:flutter/material.dart';

import '../../../core/models/order_models.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import 'order_confirmation_screen.dart';

/// Screen #12 & #13: Checkout & Dual Courier Dispatch Selection
/// Implements complete checkout flow according to Reevake blueprints:
/// - Delivery Address & drop-off instructions
/// - Dual Courier quoting (Uber Direct vs DoorDash Drive) with lowest GST-inclusive fee
/// - Driver tip chips ($0, $2, $4, $6 AUD)
/// - Catch-weight +10% pre-authorization hold disclosure
/// - Promo code redemption
/// - Glowing "Authorize & Place Order" CTA
class CheckoutScreen extends StatefulWidget {
  const CheckoutScreen({super.key});

  @override
  State<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends State<CheckoutScreen> {
  String _selectedCourier = 'Uber Direct';
  int _courierFeeCents = 550; // $5.50 AUD
  int _tipCents = 200; // $2.00 AUD
  bool _isLeaveAtDoor = true;
  bool _isProcessing = false;
  final TextEditingController _promoController = TextEditingController();
  int _promoDiscountCents = 0;
  String? _appliedPromoCode;

  final List<int> _tipOptions = <int>[0, 200, 400, 600];

  void _applyPromo() {
    final String code = _promoController.text.trim().toUpperCase();
    if (code == 'SPICE10') {
      setState(() {
        _promoDiscountCents = 1000; // $10.00 AUD
        _appliedPromoCode = 'SPICE10';
      });
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Promo SPICE10 applied: \$10.00 off!'),
          backgroundColor: Color(0xFF10B981),
        ),
      );
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Invalid code. Try "SPICE10" for \$10 off!'),
        ),
      );
    }
  }

  Future<void> _placeOrder() async {
    setState(() => _isProcessing = true);
    await Future<void>.delayed(const Duration(milliseconds: 1400));
    if (!mounted) return;

    final List<CartItem> cartItems = CartService.instance.items;
    final int subtotal = CartService.instance.subtotalCents;
    final int preAuthHold = CartService.instance.estimatedPreAuthHoldCents;
    final int total =
        (subtotal + _courierFeeCents + _tipCents - _promoDiscountCents)
            .clamp(0, 999999);

    final OrderModel order = OrderModel(
      id: 'ord_${DateTime.now().millisecondsSinceEpoch}',
      orderNumber: 'GR-${DateTime.now().millisecondsSinceEpoch % 10000}',
      storeId: cartItems.isNotEmpty ? cartItems.first.product.storeId : 'store_1',
      storeName: cartItems.isNotEmpty
          ? cartItems.first.product.storeName
          : 'Madina Halal Meats',
      status: OrderStatus.confirmed,
      subtotalCents: subtotal,
      deliveryFeeCents: _courierFeeCents,
      tipCents: _tipCents,
      totalCents: total,
      preAuthHoldCents: preAuthHold,
      courierPartner: '$_selectedCourier (Lowest Rate)',
      deliveryEtaMinutes: _selectedCourier == 'Uber Direct' ? 28 : 34,
      deliveryAddress: '24 Maple Street, Coburg VIC 3058',
      createdAt: DateTime.now(),
      items: cartItems
          .map((CartItem ci) => OrderItemModel(
                name: ci.product.name,
                productId: ci.product.id,
                variantLabel: ci.variant.label,
                unitPriceCents: ci.variant.priceCents,
                quantity: ci.quantity,
                isCatchWeight: ci.variant.isPricedByWeight,
              ))
          .toList(),
    );

    CartService.instance.clearCart();
    setState(() => _isProcessing = false);

    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(
        builder: (_) => OrderConfirmationScreen(order: order),
      ),
    );
  }

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final int subtotal = CartService.instance.subtotalCents;
    final int preAuthHold = CartService.instance.estimatedPreAuthHoldCents;
    final int finalAuthorized =
        (subtotal + _courierFeeCents + _tipCents - _promoDiscountCents)
            .clamp(0, 999999);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'Checkout & Delivery',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 18,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 120),
        children: <Widget>[
          // Delivery Address Card
          GlowCard(
            borderRadius: 20,
            borderWidth: 1.0,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    Row(
                      children: <Widget>[
                        Icon(
                          Icons.location_on_rounded,
                          color: AppColors.accentDark,
                          size: 20,
                        ),
                        SizedBox(width: 8),
                        Text(
                          'Delivery Address',
                          style: TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ],
                    ),
                    GlowBadge(
                      label: 'HOME',
                      glowColor: Color(0xFF10B981),
                      backgroundColor: Color(0xFFDCFCE7),
                      textColor: Color(0xFF065F46),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  '24 Maple Street, Coburg VIC 3058',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  'Apartment 3B · Buzz 034 · Coburg North delivery corridor',
                  style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                ),
                const SizedBox(height: 12),
                Row(
                  children: <Widget>[
                    Checkbox(
                      value: _isLeaveAtDoor,
                      activeColor: AppColors.accentDark,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(4),
                      ),
                      onChanged: (bool? val) {
                        setState(() => _isLeaveAtDoor = val ?? true);
                      },
                    ),
                    const Expanded(
                      child: Text(
                        'Leave order at my doorstep (Contactless Delivery)',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w500),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 16),

          // Dual Courier Quote Selector (Uber Direct vs DoorDash Drive)
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Courier Dispatch Selection',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.3,
              ),
            ),
          ),
          const SizedBox(height: 8),

          // Uber Direct Quote Card
          GlowCard(
            onTap: () {
              setState(() {
                _selectedCourier = 'Uber Direct';
                _courierFeeCents = 550;
              });
            },
            borderRadius: 18,
            borderWidth: 1.4,
            glowColor: const Color(0xFF10B981),
            backgroundColor: _selectedCourier == 'Uber Direct'
                ? const Color(0xFF0F172A)
                : Colors.white,
            enableBorderGlow: _selectedCourier == 'Uber Direct',
            enableAmbientShadow: _selectedCourier == 'Uber Direct',
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedCourier == 'Uber Direct'
                            ? const Color(0xFF10B981).withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.local_shipping_rounded,
                        color: _selectedCourier == 'Uber Direct'
                            ? const Color(0xFF34D399)
                            : AppColors.ink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Text(
                              'Uber Direct Express',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: _selectedCourier == 'Uber Direct'
                                    ? Colors.white
                                    : AppColors.ink,
                              ),
                            ),
                            const SizedBox(width: 6),
                            const GlowBadge(
                              label: 'LOWEST FEE',
                              showPulseDot: true,
                              glowColor: Color(0xFF10B981),
                              backgroundColor: Color(0x3310B981),
                              textColor: Color(0xFF34D399),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '25–35 mins · Live GPS tracking',
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedCourier == 'Uber Direct'
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$5.50 AUD',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _selectedCourier == 'Uber Direct'
                        ? const Color(0xFF34D399)
                        : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 10),

          // DoorDash Drive Quote Card
          GlowCard(
            onTap: () {
              setState(() {
                _selectedCourier = 'DoorDash Drive';
                _courierFeeCents = 620;
              });
            },
            borderRadius: 18,
            borderWidth: 1.4,
            glowColor: const Color(0xFFEF4444),
            backgroundColor: _selectedCourier == 'DoorDash Drive'
                ? const Color(0xFF0F172A)
                : Colors.white,
            enableBorderGlow: _selectedCourier == 'DoorDash Drive',
            enableAmbientShadow: _selectedCourier == 'DoorDash Drive',
            padding: const EdgeInsets.all(14),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  children: <Widget>[
                    Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: _selectedCourier == 'DoorDash Drive'
                            ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                            : Colors.grey.shade100,
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.delivery_dining_rounded,
                        color: _selectedCourier == 'DoorDash Drive'
                            ? const Color(0xFFF87171)
                            : AppColors.ink,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'DoorDash Drive',
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: _selectedCourier == 'DoorDash Drive'
                                ? Colors.white
                                : AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '30–40 mins · Insulated thermal bag',
                          style: TextStyle(
                            fontSize: 12,
                            color: _selectedCourier == 'DoorDash Drive'
                                ? Colors.grey.shade400
                                : Colors.grey.shade600,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                Text(
                  '\$6.20 AUD',
                  style: TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: _selectedCourier == 'DoorDash Drive'
                        ? const Color(0xFFF87171)
                        : AppColors.ink,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 18),

          // Driver Tip Rail
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 4),
            child: Text(
              'Courier Tip (100% goes to driver)',
              style: TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            children: _tipOptions.map((int tip) {
              final bool isSel = _tipCents == tip;
              final String label = tip == 0 ? 'No tip' : '\$${tip ~/ 100}';
              return Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: ScalePressable(
                    onTap: () => setState(() => _tipCents = tip),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: isSel ? const Color(0xFF0F172A) : Colors.white,
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color: isSel
                              ? const Color(0xFF10B981)
                              : const Color(0xFFE2E8F0),
                        ),
                        boxShadow: isSel
                            ? <BoxShadow>[
                                BoxShadow(
                                  color: const Color(0xFF10B981)
                                      .withValues(alpha: 0.25),
                                  blurRadius: 8,
                                ),
                              ]
                            : null,
                      ),
                      child: Center(
                        child: Text(
                          label,
                          style: TextStyle(
                            color: isSel ? Colors.white : AppColors.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),

          const SizedBox(height: 20),

          // Catch-weight Pre-authorization Hold Disclosure
          if (CartService.instance.hasCatchWeightItems)
            GlowCard(
              borderRadius: 18,
              borderWidth: 1.2,
              glowColor: const Color(0xFF10B981),
              backgroundColor: const Color(0xFFF0FDF4),
              enableBorderGlow: false,
              enableAmbientShadow: false,
              padding: const EdgeInsets.all(14),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: const <Widget>[
                  PulseGlowDot(
                    color: Color(0xFF10B981),
                    size: 8,
                    rippleRadius: 18,
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Australian Catch-Weight Pre-Authorization Hold',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF065F46),
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Your basket includes fresh meat or produce priced per kg. We place a temporary +10% authorization hold on your card. Upon scale-weighing and dispatch, only the exact weight is captured.',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF047857),
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

          const SizedBox(height: 16),

          // Promo Code Field
          Row(
            children: <Widget>[
              Expanded(
                child: TextField(
                  controller: _promoController,
                  textCapitalization: TextCapitalization.characters,
                  decoration: InputDecoration(
                    hintText: 'Promo Code (e.g. SPICE10)',
                    filled: true,
                    fillColor: Colors.white,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(14),
                      borderSide: const BorderSide(color: Color(0xFFE2E8F0)),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
              ScalePressable(
                onTap: _applyPromo,
                child: Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: const Text(
                    'Apply',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Order Pricing Summary
          GlowCard(
            borderRadius: 20,
            borderWidth: 1.0,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                _SummaryLine(
                  label: 'Subtotal (GST-inclusive)',
                  value: '\$${(subtotal / 100).toStringAsFixed(2)}',
                ),
                const SizedBox(height: 8),
                _SummaryLine(
                  label: 'Courier Delivery ($_selectedCourier)',
                  value: '\$${(_courierFeeCents / 100).toStringAsFixed(2)}',
                ),
                if (_tipCents > 0) ...<Widget>[
                  const SizedBox(height: 8),
                  _SummaryLine(
                    label: 'Driver Tip',
                    value: '\$${(_tipCents / 100).toStringAsFixed(2)}',
                  ),
                ],
                if (_promoDiscountCents > 0) ...<Widget>[
                  const SizedBox(height: 8),
                  _SummaryLine(
                    label: 'Promo Discount ($_appliedPromoCode)',
                    value: '-\$${(_promoDiscountCents / 100).toStringAsFixed(2)}',
                    valueColor: const Color(0xFF10B981),
                  ),
                ],
                if (preAuthHold > 0) ...<Widget>[
                  const SizedBox(height: 8),
                  _SummaryLine(
                    label: 'Est. Catch-Weight Hold (+10%)',
                    value: '\$${(preAuthHold / 100).toStringAsFixed(2)}',
                    valueColor: const Color(0xFF059669),
                  ),
                ],
                const Divider(height: 24),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    const Text(
                      'Total to Authorize',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    Text(
                      '\$${(finalAuthorized / 100).toStringAsFixed(2)} AUD',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),

      // Bottom Primary Glowing Payment Button
      bottomNavigationBar: Container(
        color: Colors.white,
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        child: GlowButton(
          label: _isProcessing
              ? 'Authorizing via Stripe...'
              : 'Pay with Apple Pay · \$${(finalAuthorized / 100).toStringAsFixed(2)}',
          icon: Icons.lock_rounded,
          isLoading: _isProcessing,
          glowColor: const Color(0xFF10B981),
          backgroundColor: const Color(0xFF0F172A),
          textColor: Colors.white,
          onTap: _placeOrder,
        ),
      ),
    );
  }
}

class _SummaryLine extends StatelessWidget {
  const _SummaryLine({
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(fontSize: 13, color: Colors.grey.shade700),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: valueColor ?? AppColors.ink,
          ),
        ),
      ],
    );
  }
}
