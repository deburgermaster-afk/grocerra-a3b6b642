import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/models/store_order.dart';
import '../data/repositories/store_orders_repository.dart';

class OrderPackingScreen extends StatefulWidget {
  final String orderId;
  final StoreOrdersRepository repository;
  final VoidCallback onBackToLiveBoard;

  const OrderPackingScreen({
    super.key,
    required this.orderId,
    required this.repository,
    required this.onBackToLiveBoard,
  });

  @override
  State<OrderPackingScreen> createState() => _OrderPackingScreenState();
}

class _OrderPackingScreenState extends State<OrderPackingScreen> {
  int _chilledBags = 2;
  int _ambientBags = 1;

  // Scale weights cache (itemId -> weightKg)
  final Map<String, double> _scaleWeights = {};

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StoreOrder>>(
      stream: widget.repository.watchOrders(),
      builder: (context, snapshot) {
        final orders = snapshot.data ?? [];
        final order = orders.firstWhere(
          (o) => o.id == widget.orderId,
          orElse: () => orders.isNotEmpty
              ? orders.firstWhere(
                  (o) => o.status == StoreOrderStatus.inPacking,
                  orElse: () => orders.first,
                )
              : StoreOrder(
                  id: widget.orderId,
                  customerName: 'Ayesha K.',
                  customerPhone: '+61 412 889 123',
                  deliveryAddress: '24 Baxter St, Coburg VIC',
                  customerNote: 'Please pack Halal goat meat separately in leakproof bag',
                  totalCents: 7450,
                  status: StoreOrderStatus.inPacking,
                  createdAt: DateTime.now(),
                  acceptCountdownSeconds: 45,
                  prepDueMinutes: 12,
                  items: const [],
                ),
        );

        // Sync bag counts if order already has them
        if (order.chilledBagsCount > 0 && _chilledBags == 2) {
          _chilledBags = order.chilledBagsCount;
        }
        if (order.ambientBagsCount > 0 && _ambientBags == 1) {
          _ambientBags = order.ambientBagsCount;
        }

        return Column(
          children: [
            // Top Bar / Packing Header
            _buildTopBar(order),
            const SizedBox(height: 16),

            // Customer Special Note Banner (if present)
            if (order.customerNote != null && order.customerNote!.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: _buildCustomerNoteBanner(order.customerNote!),
              ),

            // Main 2-Column Split (65% Checklist / 35% Bagging & Courier)
            Expanded(
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Left Column: Items Checklist & Catch-Weight Scales (65%)
                  Expanded(
                    flex: 65,
                    child: _buildChecklistSection(order),
                  ),

                  const SizedBox(width: 20),

                  // Right Column: Packaging & Courier Handover Station (35%)
                  Expanded(
                    flex: 35,
                    child: _buildPackagingSection(order),
                  ),
                ],
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildTopBar(StoreOrder order) {
    final progressPercent = (order.packingProgress * 100).toInt();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        children: [
          // Back to Live Board Button
          ShadButton.outline(
            height: 38,
            padding: const EdgeInsets.symmetric(horizontal: 12),
            onPressed: widget.onBackToLiveBoard,
            leading: const Icon(Icons.arrow_back_ios_new, size: 14, color: AppColors.ink),
            child: const Text(
              'Live Board',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),

          const SizedBox(width: 14),

          Container(
            height: 24,
            width: 1,
            color: AppColors.hairline,
          ),

          const SizedBox(width: 14),

          // Order Details & Customer metadata
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  children: [
                    Text(
                      'Packing Order #${order.id}',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: Text(
                        'Prep Due: ${order.prepDueMinutes} mins',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFFB45309),
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 2),
                Text(
                  'Customer: ${order.customerName} (${order.customerPhone}) · ${order.deliveryAddress}',
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          const SizedBox(width: 20),

          // Progress Indicator
          SizedBox(
            width: 200,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${order.packedCount}/${order.items.length} Packed',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    Text(
                      '$progressPercent%',
                      style: const TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),
                ClipRRect(
                  borderRadius: BorderRadius.circular(999),
                  child: ShadProgress(
                    value: order.packingProgress,
                    minHeight: 6,
                    color: AppColors.accent,
                    backgroundColor: AppColors.surfaceAlt,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCustomerNoteBanner(String note) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      decoration: BoxDecoration(
        color: const Color(0xFFFFFBEB),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFDE68A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.info_outline_rounded, size: 18, color: Color(0xFFD97706)),
          const SizedBox(width: 10),
          Expanded(
            child: RichText(
              text: TextSpan(
                style: const TextStyle(fontSize: 12.5, color: Color(0xFF92400E)),
                children: [
                  const TextSpan(
                    text: 'Customer Note: ',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: '"$note"',
                    style: const TextStyle(fontStyle: FontStyle.italic),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistSection(StoreOrder order) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section Title
          Padding(
            padding: const EdgeInsets.all(16),
            child: Wrap(
              alignment: WrapAlignment.spaceBetween,
              crossAxisAlignment: WrapCrossAlignment.center,
              spacing: 12,
              runSpacing: 6,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Text(
                      'Items Checklist',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        '${order.packedCount} of ${order.items.length} Ready',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ],
                ),
                const Text(
                  'Tap item to check off · Butcher scale auto-updates weight',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.hairline),

          // Items List
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.all(16),
              itemCount: order.items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final item = order.items[index];
                if (item.isCatchWeight) {
                  return _buildCatchWeightItemCard(order, item);
                } else {
                  return _buildStandardItemCard(order, item);
                }
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStandardItemCard(StoreOrder order, StoreOrderItem item) {
    final unitPrice = (item.unitPriceCents / 100).toStringAsFixed(2);
    final totalPrice = ((item.unitPriceCents * item.quantity) / 100).toStringAsFixed(2);

    return InkWell(
      onTap: () {
        widget.repository.updateOrderItemPacked(order.id, item.id, !item.isPacked);
      },
      borderRadius: BorderRadius.circular(10),
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: item.isPacked ? const Color(0xFFF9FAFB) : Colors.white,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(
            color: item.isPacked ? const Color(0xFFD1FAE5) : AppColors.hairline,
            width: 1,
          ),
        ),
        child: Row(
          children: [
            // Checkbox Icon
            Container(
              width: 24,
              height: 24,
              decoration: BoxDecoration(
                color: item.isPacked ? AppColors.accent : Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: item.isPacked ? AppColors.accent : const Color(0xFFCBD5E1),
                  width: 1.5,
                ),
              ),
              child: item.isPacked
                  ? const Icon(Icons.check, size: 16, color: Colors.white)
                  : null,
            ),

            const SizedBox(width: 14),

            // Item Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Flexible(
                        child: Text(
                          item.name,
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: item.isPacked ? AppColors.inkMuted : AppColors.ink,
                            decoration: item.isPacked ? TextDecoration.lineThrough : null,
                          ),
                        ),
                      ),
                      const SizedBox(width: 8),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          'Qty: ${item.quantity}',
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Wrap(
                    crossAxisAlignment: WrapCrossAlignment.center,
                    spacing: 6,
                    runSpacing: 2,
                    children: [
                      if (item.category != null) ...[
                        Text(
                          item.category!,
                          style: const TextStyle(
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        const Text('·', style: TextStyle(color: AppColors.inkMuted)),
                      ],
                      Text(
                        'SKU: ${item.sku}',
                        style: const TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        '\$$unitPrice ea (\$$totalPrice total)',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(width: 12),

            // Item Actions (Packed Badge OR Substitution Menu)
            if (item.isPacked)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFDCFCE7),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Packed ✓',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: Color(0xFF166534),
                  ),
                ),
              )
            else
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  ShadButton.outline(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () => _showSubstitutionDialog(item),
                    child: const Text(
                      'Substitute',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkMuted),
                    ),
                  ),
                  const SizedBox(width: 6),
                  ShadButton.outline(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () => _showRefundDialog(item),
                    child: const Text(
                      'Out of Stock',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: Color(0xFFDC2626)),
                    ),
                  ),
                ],
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildCatchWeightItemCard(StoreOrder order, StoreOrderItem item) {
    // Current actual or edited scale weight
    final currentWeight = _scaleWeights[item.id] ?? (item.actualWeightKg ?? item.requestedWeightKg ?? 1.50);
    final requestedWeight = item.requestedWeightKg ?? 1.50;
    final unitPricePerKg = item.unitPriceCents / 100.0;
    final capturedPrice = (currentWeight * unitPricePerKg).toStringAsFixed(2);
    final targetPrice = (requestedWeight * unitPricePerKg).toStringAsFixed(2);

    // Tolerance calculation: ±10% pre-authorization limit
    final weightDelta = currentWeight - requestedWeight;
    final percentageDiff = (weightDelta / requestedWeight) * 100;
    final isWithinTolerance = percentageDiff.abs() <= 10.0;
    final maxAllowedWeight = (requestedWeight * 1.10).toStringAsFixed(2);

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF0FDF4),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF86EFAC), width: 1.5),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header row with Butcher Badge
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 8,
            runSpacing: 4,
            children: [
              Wrap(
                spacing: 8,
                runSpacing: 4,
                crossAxisAlignment: WrapCrossAlignment.center,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                      border: Border.all(color: const Color(0xFF4ADE80)),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text('🥩', style: TextStyle(fontSize: 12)),
                        SizedBox(width: 4),
                        Text(
                          'HALAL BUTCHER · CATCH WEIGHT',
                          style: TextStyle(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: Color(0xFF166534),
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  if (item.isPacked)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: AppColors.accent,
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Weight Confirmed ✓',
                        style: TextStyle(
                          fontSize: 10,
                          fontWeight: FontWeight.w800,
                          color: Colors.white,
                        ),
                      ),
                    ),
                ],
              ),
              Text(
                'Requested: ${requestedWeight.toStringAsFixed(2)} kg (\$$targetPrice)',
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ),

          const SizedBox(height: 10),

          // Product title and SKU
          Text(
            item.name,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            'SKU: ${item.sku} · Hand cut to order · Pack leakproof',
            style: const TextStyle(
              fontSize: 11.5,
              fontWeight: FontWeight.w500,
              color: AppColors.inkMuted,
            ),
          ),

          const SizedBox(height: 12),

          // High-Contrast Digital Scale Readout Terminal
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFCBD5E1)),
            ),
            child: Wrap(
              spacing: 12,
              runSpacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              alignment: WrapAlignment.spaceBetween,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Digital LCD Scale Box
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFF0F172A),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const Icon(Icons.scale_rounded, color: Color(0xFF4ADE80), size: 18),
                          const SizedBox(width: 8),
                          Text(
                            '${currentWeight.toStringAsFixed(2)} kg',
                            style: const TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.w900,
                              color: Color(0xFF4ADE80),
                              fontFamily: 'monospace',
                              letterSpacing: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Wrap(
                          crossAxisAlignment: WrapCrossAlignment.center,
                          spacing: 6,
                          children: [
                            Text(
                              '\$$capturedPrice AUD',
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w800,
                                color: AppColors.ink,
                              ),
                            ),
                            Text(
                              weightDelta >= 0
                                  ? '(+\$${(weightDelta * unitPricePerKg).toStringAsFixed(2)})'
                                  : '(-\$${(weightDelta.abs() * unitPricePerKg).toStringAsFixed(2)})',
                              style: TextStyle(
                                fontSize: 11.5,
                                fontWeight: FontWeight.w700,
                                color: weightDelta >= 0 ? const Color(0xFF166534) : const Color(0xFFDC2626),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 2),
                        Text(
                          isWithinTolerance
                              ? '✓ Within ±10% pre-auth limit (up to $maxAllowedWeight kg)'
                              : '⚠️ Exceeds ±10% pre-auth limit. Contact customer.',
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.w600,
                            color: isWithinTolerance ? const Color(0xFF166534) : const Color(0xFFDC2626),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),

                // Scale Weight Increment Adjusters
                Wrap(
                  spacing: 6,
                  runSpacing: 6,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    ShadButton.outline(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: () {
                        setState(() {
                          _scaleWeights[item.id] = (currentWeight - 0.05).clamp(0.10, 10.0);
                        });
                      },
                      child: const Text('-0.05 kg', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    ShadButton.outline(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 8),
                      onPressed: () {
                        setState(() {
                          _scaleWeights[item.id] = (currentWeight + 0.05).clamp(0.10, 10.0);
                        });
                      },
                      child: const Text('+0.05 kg', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                    ),
                    ShadButton(
                      height: 34,
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      backgroundColor: AppColors.accent,
                      hoverBackgroundColor: AppColors.accentDark,
                      onPressed: () async {
                        await widget.repository.updateItemScaleWeight(order.id, item.id, currentWeight);
                        if (context.mounted) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(
                              content: Text('Scale weight confirmed: ${currentWeight.toStringAsFixed(2)} kg (\$$capturedPrice AUD)'),
                              backgroundColor: AppColors.accent,
                              duration: const Duration(seconds: 2),
                              behavior: SnackBarBehavior.floating,
                            ),
                          );
                        }
                      },
                      child: const Text(
                        'Lock Weight ✓',
                        style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.bold, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPackagingSection(StoreOrder order) {
    return Column(
      children: [
        // Scrollable content area for packaging cards and courier info
        Expanded(
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Packaging Summary Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Packaging Allocation',
                style: TextStyle(
                  fontSize: 14.5,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 4),
              const Text(
                'Separate chilled meats from ambient dry goods.',
                style: TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkMuted,
                ),
              ),

              const SizedBox(height: 14),

              // Chilled Bags Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0F9FF),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFBAE6FD)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('❄️', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Chilled Bags',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF0369A1),
                              ),
                            ),
                            Text(
                              'Insulated foil seal',
                              style: TextStyle(fontSize: 10.5, color: Color(0xFF0284C7)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ShadButton.outline(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (_chilledBags > 0) setState(() => _chilledBags--);
                          },
                          child: const Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$_chilledBags',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF0369A1)),
                          ),
                        ),
                        ShadButton.outline(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() => _chilledBags++),
                          child: const Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 10),

              // Ambient Bags Counter
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color(0xFFFDF4E7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFCD34D)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Row(
                      children: [
                        Text('🛍️', style: TextStyle(fontSize: 16)),
                        SizedBox(width: 8),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Ambient Bags',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF92400E),
                              ),
                            ),
                            Text(
                              'Dry grocery paper bag',
                              style: TextStyle(fontSize: 10.5, color: Color(0xFFB45309)),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        ShadButton.outline(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.zero,
                          onPressed: () {
                            if (_ambientBags > 0) setState(() => _ambientBags--);
                          },
                          child: const Text('-', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: Text(
                            '$_ambientBags',
                            style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w800, color: Color(0xFF92400E)),
                          ),
                        ),
                        ShadButton.outline(
                          height: 32,
                          width: 32,
                          padding: EdgeInsets.zero,
                          onPressed: () => setState(() => _ambientBags++),
                          child: const Text('+', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Courier Live Status Card
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Courier Dispatch',
                    style: TextStyle(
                      fontSize: 14.5,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Text(
                      'Uber Direct',
                      style: TextStyle(fontSize: 10.5, fontWeight: FontWeight.w800, color: Color(0xFF166534)),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: AppColors.accent,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Driver arriving in ~8 mins',
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              const Text(
                'Vehicle: Silver Toyota Corolla · Rego: 1AB-2CD',
                style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
              ),
            ],
          ),
        ),

        const SizedBox(height: 14),

        // Thermal Printer Slips Action
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.hairline),
          ),
          child: Column(
            children: [
              ShadButton.outline(
                width: double.infinity,
                height: 44,
                padding: const EdgeInsets.symmetric(horizontal: 10),
                onPressed: () => _showThermalSlipModal(order),
                leading: const Icon(Icons.print_outlined, size: 18, color: AppColors.ink),
                child: Flexible(
                  child: Text(
                    'Print Bag Slips (${_chilledBags + _ambientBags} Bags)',
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ),
            ],
          ),
        ),
              ],
            ),
          ),
        ),

        const SizedBox(height: 12),

        // Primary Final Action Button (Pinned at bottom)
        ShadButton(
          width: double.infinity,
          height: 52,
          padding: const EdgeInsets.symmetric(horizontal: 12),
          backgroundColor: AppColors.accent,
          hoverBackgroundColor: AppColors.accentDark,
          onPressed: () async {
            await widget.repository.markOrderPacked(order.id, _chilledBags, _ambientBags);
            if (context.mounted) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Order #${order.id} marked Packed & Sealed! Moved to Ready for Driver column.'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
              widget.onBackToLiveBoard();
            }
          },
          child: const Flexible(
            child: Text(
              '✓ Mark Packed & Ready for Courier',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w900,
                color: Colors.white,
                letterSpacing: 0.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  void _showThermalSlipModal(StoreOrder order) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Row(
          children: [
            Icon(Icons.receipt_outlined, color: AppColors.accent),
            SizedBox(width: 8),
            Text('Thermal Printer Slip Preview', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
          ],
        ),
        content: Container(
          width: 320,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: const Color(0xFFFAFAFA),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFFE5E7EB)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text('GROCERRA STORE SLIP', style: TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.w900, fontSize: 13)),
              const Text('Madina Halal Meats & Groceries', style: TextStyle(fontFamily: 'monospace', fontSize: 11)),
              const Text('Coburg VIC · Ph: +61 3 9384 1234', style: TextStyle(fontFamily: 'monospace', fontSize: 10, color: Colors.grey)),
              const Divider(color: Colors.black26),
              Text('ORDER #${order.id}', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 14)),
              Text('Customer: ${order.customerName}', style: const TextStyle(fontFamily: 'monospace', fontSize: 12)),
              Text('Courier: Uber Direct · PIN: 5821', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 12)),
              const Divider(color: Colors.black26),
              Align(
                alignment: Alignment.centerLeft,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('BAG ALLOCATION: ${_chilledBags + _ambientBags} TOTAL', style: const TextStyle(fontFamily: 'monospace', fontWeight: FontWeight.bold, fontSize: 11)),
                    Text('• $_chilledBags x CHILLED (Halal Meats)', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                    Text('• $_ambientBags x AMBIENT (Dry Goods)', style: const TextStyle(fontFamily: 'monospace', fontSize: 11)),
                  ],
                ),
              ),
              const Divider(color: Colors.black26),
              const Text('* * * READY FOR PICKUP * * *', style: TextStyle(fontFamily: 'monospace', fontSize: 10)),
            ],
          ),
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close'),
          ),
          ShadButton(
            height: 36,
            backgroundColor: AppColors.accent,
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Simulated thermal print job sent to counter receipt printer!'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Print Now', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showSubstitutionDialog(StoreOrderItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Text('Substitute "${item.name}"?', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Select store alternative (Customer auto-notified via SMS/Push):',
              style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
            ),
            const SizedBox(height: 12),
            _substituteOption(ctx, 'Shan Special Biryani Masala 50g', 'Equal value (\$2.45)'),
            _substituteOption(ctx, 'National Bombay Biryani Masala 50g', 'Equal value (\$2.45)'),
            _substituteOption(ctx, 'Mehran Bombay Biryani 50g', 'Equal value (\$2.30)'),
          ],
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
        ],
      ),
    );
  }

  Widget _substituteOption(BuildContext ctx, String name, String sub) {
    return ListTile(
      dense: true,
      contentPadding: EdgeInsets.zero,
      leading: const Icon(Icons.swap_horiz_rounded, color: AppColors.accent),
      title: Text(name, style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
      subtitle: Text(sub, style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
      onTap: () {
        Navigator.of(ctx).pop();
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Substituted with "$name". Customer notified!'),
            backgroundColor: AppColors.accent,
            behavior: SnackBarBehavior.floating,
          ),
        );
      },
    );
  }

  void _showRefundDialog(StoreOrderItem item) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Mark Out of Stock & Refund?', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
        content: Text(
          'Remove "${item.name}" from order? Customer will be instantly refunded \$${((item.unitPriceCents * item.quantity) / 100).toStringAsFixed(2)} to their card.',
          style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Cancel'),
          ),
          ShadButton(
            height: 36,
            backgroundColor: const Color(0xFFDC2626),
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('Item marked out of stock. Auto-refund of \$${((item.unitPriceCents * item.quantity) / 100).toStringAsFixed(2)} queued.'),
                  backgroundColor: const Color(0xFFDC2626),
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Confirm Refund', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}
