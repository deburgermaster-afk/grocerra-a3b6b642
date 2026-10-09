import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/models/store_order.dart';
import '../data/repositories/store_orders_repository.dart';

class OrderHistoryScreen extends StatefulWidget {
  final StoreOrdersRepository repository;

  const OrderHistoryScreen({
    super.key,
    required this.repository,
  });

  @override
  State<OrderHistoryScreen> createState() => _OrderHistoryScreenState();
}

class _OrderHistoryScreenState extends State<OrderHistoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedTab = 'all'; // 'all', 'completed', 'cancelled', 'refunded', 'catering'
  String _datePreset = 'Today · Oct 9, 2026';
  int _currentPage = 1;
  static const int _pageSize = 8;

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<List<StoreOrder>>(
      stream: widget.repository.watchOrders(),
      builder: (context, snapshot) {
        final allOrders = snapshot.data ?? [];

        // Apply filters
        final filteredOrders = allOrders.where((order) {
          // Status tab filter
          if (_selectedTab == 'completed' && order.status != StoreOrderStatus.completed) {
            return false;
          }
          if (_selectedTab == 'cancelled' && order.status != StoreOrderStatus.declined) {
            return false;
          }
          if (_selectedTab == 'refunded' &&
              order.status != StoreOrderStatus.refunded &&
              order.status != StoreOrderStatus.disputed) {
            return false;
          }
          if (_selectedTab == 'catering' && !order.isCatering) {
            return false;
          }

          // Search query filter
          if (_searchQuery.isNotEmpty) {
            final query = _searchQuery.toLowerCase();
            final matchesId = order.id.toLowerCase().contains(query);
            final matchesCustomer = order.customerName.toLowerCase().contains(query);
            final matchesPin = (order.courierPickupPin ?? '').toLowerCase().contains(query);
            final matchesCourier = (order.courierProvider ?? '').toLowerCase().contains(query);
            if (!matchesId && !matchesCustomer && !matchesPin && !matchesCourier) {
              return false;
            }
          }

          return true;
        }).toList();

        // Calculate tab counts
        final completedCount = allOrders.where((o) => o.status == StoreOrderStatus.completed).length;
        final cancelledCount = allOrders.where((o) => o.status == StoreOrderStatus.declined).length;
        final refundedCount = allOrders
            .where((o) => o.status == StoreOrderStatus.refunded || o.status == StoreOrderStatus.disputed)
            .length;
        final cateringCount = allOrders.where((o) => o.isCatering).length;

        // Pagination calculation
        final totalOrders = filteredOrders.length;
        final totalPages = (totalOrders / _pageSize).ceil().clamp(1, 999);
        final clampedPage = _currentPage.clamp(1, totalPages);
        final startIndex = (clampedPage - 1) * _pageSize;
        final endIndex = (startIndex + _pageSize).clamp(0, totalOrders);
        final pagedOrders = totalOrders > 0 ? filteredOrders.sublist(startIndex, endIndex) : <StoreOrder>[];

        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // Page Header with Title, Date Range Filter, and Export Button
            _buildPageHeader(),

            const SizedBox(height: 16),

            // Main Table Card
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Column(
                  children: [
                    // Search & Filter Header
                    _buildFilterControls(
                      totalCount: allOrders.length,
                      completedCount: completedCount,
                      cancelledCount: cancelledCount,
                      refundedCount: refundedCount,
                      cateringCount: cateringCount,
                    ),

                    const Divider(height: 1, color: AppColors.hairline),

                    // Table Column Headers & Rows with Horizontal Scroll Guard
                    Expanded(
                      child: LayoutBuilder(
                        builder: (context, constraints) {
                          final minTableWidth = 1080.0;
                          final tableWidth =
                              constraints.maxWidth > minTableWidth ? constraints.maxWidth : minTableWidth;

                          return SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: SizedBox(
                              width: tableWidth,
                              child: Column(
                                children: [
                                  _buildTableHeader(),
                                  const Divider(height: 1, color: AppColors.hairline),
                                  Expanded(
                                    child: pagedOrders.isEmpty
                                        ? _buildEmptyState()
                                        : ListView.separated(
                                            itemCount: pagedOrders.length,
                                            separatorBuilder: (_, _) =>
                                                const Divider(height: 1, color: AppColors.hairline),
                                            itemBuilder: (context, index) {
                                              final order = pagedOrders[index];
                                              return _buildOrderRow(order);
                                            },
                                          ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const Divider(height: 1, color: AppColors.hairline),

                    // Pagination Footer
                    _buildPaginationFooter(
                      startIndex: totalOrders == 0 ? 0 : startIndex + 1,
                      endIndex: endIndex,
                      totalCount: totalOrders,
                      currentPage: clampedPage,
                      totalPages: totalPages,
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildPageHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        // Title
        const Row(
          children: [
            Text(
              'All Orders History',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),

        // Action controls (Date Filter + Export)
        Wrap(
          spacing: 10,
          crossAxisAlignment: WrapCrossAlignment.center,
          children: [
            // Date Preset Button
            ShadButton.outline(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              onPressed: _showDatePresetDialog,
              leading: const Icon(Icons.calendar_today_outlined, size: 15, color: AppColors.ink),
              child: Text(
                _datePreset,
                style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
            ),

            // Export CSV Button
            ShadButton.outline(
              height: 38,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              onPressed: _handleExportCsv,
              leading: const Icon(Icons.file_download_outlined, size: 16, color: AppColors.ink),
              child: const Text(
                'Export',
                style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.ink),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildFilterControls({
    required int totalCount,
    required int completedCount,
    required int cancelledCount,
    required int refundedCount,
    required int cateringCount,
  }) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Search Input
          Container(
            height: 42,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Row(
              children: [
                const Icon(Icons.search_rounded, size: 18, color: AppColors.inkMuted),
                const SizedBox(width: 8),
                Expanded(
                  child: TextField(
                    controller: _searchController,
                    onChanged: (val) {
                      setState(() {
                        _searchQuery = val.trim();
                        _currentPage = 1;
                      });
                    },
                    decoration: const InputDecoration(
                      hintText: 'Search by Order #, customer name, or courier PIN',
                      hintStyle: TextStyle(fontSize: 13, color: AppColors.inkMuted),
                      border: InputBorder.none,
                      isDense: true,
                      contentPadding: EdgeInsets.zero,
                    ),
                    style: const TextStyle(fontSize: 13, color: AppColors.ink, fontWeight: FontWeight.w500),
                  ),
                ),
                if (_searchQuery.isNotEmpty)
                  GestureDetector(
                    onTap: () {
                      _searchController.clear();
                      setState(() {
                        _searchQuery = '';
                        _currentPage = 1;
                      });
                    },
                    child: const Icon(Icons.close_rounded, size: 16, color: AppColors.inkMuted),
                  ),
              ],
            ),
          ),

          const SizedBox(height: 14),

          // Status Filter Tabs
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _buildStatusTab('all', 'All Orders', totalCount),
                const SizedBox(width: 8),
                _buildStatusTab('completed', 'Completed', completedCount),
                const SizedBox(width: 8),
                _buildStatusTab('cancelled', 'Cancelled', cancelledCount),
                const SizedBox(width: 8),
                _buildStatusTab('refunded', 'Refunded / Disputed', refundedCount),
                const SizedBox(width: 8),
                _buildStatusTab('catering', 'Catering', cateringCount),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTab(String tabKey, String label, int count) {
    final isSelected = _selectedTab == tabKey;

    return InkWell(
      onTap: () {
        setState(() {
          _selectedTab = tabKey;
          _currentPage = 1;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent.withValues(alpha: 0.10) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : Colors.transparent,
            width: 1,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 13,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.accentDark : AppColors.inkMuted,
              ),
            ),
            const SizedBox(width: 6),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 1.5),
              decoration: BoxDecoration(
                color: isSelected ? AppColors.accent : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(999),
              ),
              child: Text(
                '$count',
                style: TextStyle(
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                  color: isSelected ? Colors.white : AppColors.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: const Color(0xFFFAFAFA),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 11),
      child: const Row(
        children: [
          SizedBox(width: 90, child: Text('ORDER ID', style: _headerStyle)),
          Expanded(child: Text('CUSTOMER', style: _headerStyle)),
          SizedBox(width: 120, child: Text('ITEMS', style: _headerStyle)),
          SizedBox(width: 120, child: Text('DATE/TIME', style: _headerStyle)),
          SizedBox(width: 130, child: Text('COURIER', style: _headerStyle)),
          SizedBox(width: 110, child: Text('TOTAL AMOUNT', style: _headerStyle)),
          SizedBox(width: 130, child: Text('STATUS', style: _headerStyle)),
          SizedBox(width: 250, child: Text('ACTIONS', style: _headerStyle, textAlign: TextAlign.end)),
        ],
      ),
    );
  }

  static const _headerStyle = TextStyle(
    fontSize: 11,
    fontWeight: FontWeight.w800,
    color: Color(0xFF64748B),
    letterSpacing: 0.5,
  );

  Widget _buildOrderRow(StoreOrder order) {
    final totalFormatted = '\$${(order.totalCents / 100).toStringAsFixed(2)}';
    final itemCountText = order.isCatering
        ? 'Catering ${order.items.isNotEmpty ? order.items.first.name.contains('40') ? '40 pax' : '25 pax' : 'Catering'}'
        : '${order.items.length} items';

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Order ID
          SizedBox(
            width: 90,
            child: Text(
              '#${order.id}',
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                fontFamily: 'monospace',
              ),
            ),
          ),

          // Customer
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  order.customerName,
                  style: const TextStyle(
                    fontSize: 13.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.ink,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  order.customerPhone,
                  style: const TextStyle(
                    fontSize: 11,
                    color: AppColors.inkMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),

          // Items
          SizedBox(
            width: 120,
            child: order.isCatering
                ? Align(
                    alignment: Alignment.centerLeft,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF3C7),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: const Text(
                        '🥘 Catering',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: Color(0xFFB45309)),
                      ),
                    ),
                  )
                : Text(
                    itemCountText,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
          ),

          // Date/Time
          SizedBox(
            width: 120,
            child: Text(
              _formatOrderTime(order.createdAt),
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w500,
                color: AppColors.inkMuted,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          // Courier (Uber Direct or DoorDash Drive)
          SizedBox(
            width: 130,
            child: Row(
              children: [
                Icon(
                  order.courierProvider == 'DoorDash Drive'
                      ? Icons.delivery_dining_rounded
                      : Icons.directions_car_rounded,
                  size: 15,
                  color: AppColors.inkMuted,
                ),
                const SizedBox(width: 6),
                Flexible(
                  child: Text(
                    order.courierProvider ?? 'Uber Direct',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),

          // Total Amount
          SizedBox(
            width: 110,
            child: Text(
              totalFormatted,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
              ),
            ),
          ),

          // Status Badge
          SizedBox(
            width: 130,
            child: _buildStatusBadge(order),
          ),

          // Actions
          SizedBox(
            width: 250,
            child: Wrap(
              spacing: 6,
              runSpacing: 4,
              alignment: WrapAlignment.end,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                // View Receipt Button
                ShadButton.outline(
                  height: 32,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  onPressed: () => _showReceiptDialog(order),
                  child: const Text('View Receipt', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                ),

                // GST Invoice PDF OR Dispute Details Button
                if (order.status == StoreOrderStatus.refunded || order.status == StoreOrderStatus.disputed)
                  ShadButton.outline(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () => _showDisputeDialog(order),
                    child: const Text(
                      'Dispute Details',
                      style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: Color(0xFFB45309)),
                    ),
                  )
                else
                  ShadButton.outline(
                    height: 32,
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    onPressed: () => _showGstInvoiceDialog(order),
                    child: const Text('GST Invoice PDF', style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700)),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(StoreOrder order) {
    Color bg;
    Color fg;
    String label;

    switch (order.status) {
      case StoreOrderStatus.completed:
        bg = const Color(0xFFDCFCE7);
        fg = const Color(0xFF166534);
        label = 'Delivered';
        break;
      case StoreOrderStatus.refunded:
        bg = const Color(0xFFFEF3C7);
        fg = const Color(0xFFB45309);
        final refundStr = order.refundAmountCents != null
            ? 'Refunded (\$${(order.refundAmountCents! / 100).toStringAsFixed(2)})'
            : 'Refunded';
        label = refundStr;
        break;
      case StoreOrderStatus.disputed:
        bg = const Color(0xFFFFEDD5);
        fg = const Color(0xFFC2410C);
        label = 'Disputed';
        break;
      case StoreOrderStatus.declined:
        bg = const Color(0xFFFEE2E2);
        fg = const Color(0xFFDC2626);
        label = 'Cancelled';
        break;
      case StoreOrderStatus.inPacking:
        bg = const Color(0xFFDBEAFE);
        fg = const Color(0xFF1D4ED8);
        label = 'In Packing';
        break;
      case StoreOrderStatus.readyForDriver:
        bg = const Color(0xFFE0E7FF);
        fg = const Color(0xFF4338CA);
        label = 'Ready for Driver';
        break;
      case StoreOrderStatus.incoming:
        bg = const Color(0xFFF3E8FF);
        fg = const Color(0xFF6B21A8);
        label = 'Incoming';
        break;
    }

    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(6),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.w800,
            color: fg,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.receipt_long_outlined, size: 48, color: AppColors.inkMuted),
            const SizedBox(height: 12),
            const Text(
              'No orders match your filter criteria',
              style: TextStyle(fontSize: 15, fontWeight: FontWeight.bold, color: AppColors.ink),
            ),
            const SizedBox(height: 6),
            const Text(
              'Try clearing your search query or selecting a different status filter tab.',
              style: TextStyle(fontSize: 12.5, color: AppColors.inkMuted),
            ),
            const SizedBox(height: 16),
            ShadButton.outline(
              height: 34,
              onPressed: () {
                _searchController.clear();
                setState(() {
                  _searchQuery = '';
                  _selectedTab = 'all';
                  _currentPage = 1;
                });
              },
              child: const Text('Reset All Filters'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaginationFooter({
    required int startIndex,
    required int endIndex,
    required int totalCount,
    required int currentPage,
    required int totalPages,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Row counter text
          Text(
            totalCount == 0 ? 'No orders found' : 'Showing $startIndex–$endIndex of $totalCount orders',
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.inkMuted,
            ),
          ),

          // Pagination buttons
          Row(
            children: [
              ShadButton.outline(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                enabled: currentPage > 1,
                onPressed: () {
                  if (currentPage > 1) {
                    setState(() => _currentPage = currentPage - 1);
                  }
                },
                child: const Text('Previous', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  'Page $currentPage of $totalPages',
                  style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.ink),
                ),
              ),
              const SizedBox(width: 8),
              ShadButton.outline(
                height: 34,
                padding: const EdgeInsets.symmetric(horizontal: 12),
                enabled: currentPage < totalPages,
                onPressed: () {
                  if (currentPage < totalPages) {
                    setState(() => _currentPage = currentPage + 1);
                  }
                },
                child: const Text('Next', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        ],
      ),
    );
  }

  String _formatOrderTime(DateTime dt) {
    final now = DateTime.now();
    final diff = now.difference(dt);

    final hour = dt.hour > 12 ? dt.hour - 12 : (dt.hour == 0 ? 12 : dt.hour);
    final ampm = dt.hour >= 12 ? 'PM' : 'AM';
    final minute = dt.minute.toString().padLeft(2, '0');
    final timeStr = '$hour:$minute $ampm';

    if (diff.inDays == 0 && dt.day == now.day) {
      return 'Today $timeStr';
    } else if (diff.inDays <= 1) {
      return 'Yesterday $timeStr';
    } else {
      return '${dt.day}/${dt.month} $timeStr';
    }
  }

  // ==========================================
  // MODALS & DIALOGS
  // ==========================================

  void _showReceiptDialog(StoreOrder order) {
    final totalDollars = (order.totalCents / 100).toStringAsFixed(2);
    final gstComponent = (order.totalCents / 100 / 11).toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.receipt_rounded, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Digital Receipt · Order #${order.id}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
        content: SizedBox(
          width: 520,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Store Info Header
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Column(
                    children: [
                      Text(
                        'Madina Halal Meats & Groceries',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.ink),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '142 Sydney Road, Coburg VIC 3058 · Tel: (03) 9386 1234',
                        style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                      ),
                      Text(
                        'ABN: 45 123 456 789 · Halal Certification: HCAA-VIC-4892',
                        style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Customer & Courier Metadata
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Customer: ${order.customerName}',
                              style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                          Text('Address: ${order.deliveryAddress}',
                              style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('Courier: ${order.courierProvider ?? "Store"}',
                            style: const TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold)),
                        Text('Pickup PIN: ${order.courierPickupPin ?? "N/A"}',
                            style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.hairline),
                const SizedBox(height: 10),

                // Itemized breakdown table
                const Text(
                  'Itemized Purchased Products',
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w800, color: AppColors.inkMuted),
                ),
                const SizedBox(height: 8),

                ...order.items.map((item) {
                  final lineTotal = '\$${((item.unitPriceCents * item.quantity) / 100).toStringAsFixed(2)}';
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(item.name,
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
                              if (item.isCatchWeight && item.actualWeightKg != null)
                                Text('Captured weight: ${item.actualWeightKg!.toStringAsFixed(2)} kg',
                                    style: const TextStyle(fontSize: 11, color: AppColors.accentDark))
                              else
                                Text('SKU: ${item.sku} · Qty: ${item.quantity}',
                                    style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                            ],
                          ),
                        ),
                        Text(lineTotal,
                            style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold, color: AppColors.ink)),
                      ],
                    ),
                  );
                }),

                const SizedBox(height: 14),
                const Divider(height: 1, color: AppColors.hairline),
                const SizedBox(height: 10),

                // Totals & GST
                _buildReceiptLine('Subtotal', totalDollars),
                _buildReceiptLine('Delivery & Bagging', '\$0.00 AUD (Included)'),
                _buildReceiptLine('GST Component (10% inc)', '\$$gstComponent AUD'),
                const Divider(height: 16, color: AppColors.hairline),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Total Paid (AUD)',
                        style: TextStyle(fontSize: 15, fontWeight: FontWeight.w900, color: AppColors.ink)),
                    Text('\$$totalDollars AUD',
                        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w900, color: AppColors.accentDark)),
                  ],
                ),
              ],
            ),
          ),
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Thermal receipt sent to counter receipt printer!'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            leading: const Icon(Icons.print_outlined, size: 16),
            child: const Text('Print Thermal Receipt'),
          ),
          ShadButton(
            height: 36,
            backgroundColor: AppColors.ink,
            hoverBackgroundColor: AppColors.accentDark,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget _buildReceiptLine(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(fontSize: 12, color: AppColors.inkMuted)),
          Text(value, style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
        ],
      ),
    );
  }

  void _showGstInvoiceDialog(StoreOrder order) {
    final invoiceNum = order.invoiceNumber ?? 'INV-2026-${order.id}';
    final totalDollars = (order.totalCents / 100).toStringAsFixed(2);
    final gstComponent = (order.totalCents / 100 / 11).toStringAsFixed(2);
    final subtotalExGst = ((order.totalCents / 100) - (order.totalCents / 100 / 11)).toStringAsFixed(2);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.description_outlined, color: AppColors.accent, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Australian Tax Invoice · $invoiceNum',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
        content: SizedBox(
          width: 580,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // Formal Invoice Badge & Supplier Details
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('TAX INVOICE',
                              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w900, color: AppColors.ink)),
                          SizedBox(height: 4),
                          Text('Madina Halal Meats & Groceries Pty Ltd',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold)),
                          Text('ABN: 45 123 456 789', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                          Text('142 Sydney Road, Coburg VIC 3058', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(6),
                          border: Border.all(color: const Color(0xFF86EFAC)),
                        ),
                        child: const Text('PAID IN FULL',
                            style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w900, color: Color(0xFF166534))),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 14),

                // Bill to / Order Info
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('BILL TO / RECIPIENT:',
                              style: TextStyle(fontSize: 10, fontWeight: FontWeight.bold, color: AppColors.inkMuted)),
                          Text(order.customerName,
                              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink)),
                          Text(order.deliveryAddress,
                              style: const TextStyle(fontSize: 11.5, color: AppColors.inkMuted)),
                        ],
                      ),
                    ),
                    const SizedBox(width: 14),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Text('INVOICE #: $invoiceNum',
                            style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: AppColors.ink)),
                        Text('Date of Issue: ${_formatOrderTime(order.createdAt)}',
                            style: const TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                        const Text('Currency: AUD (Australian Dollars)',
                            style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                      ],
                    ),
                  ],
                ),

                const SizedBox(height: 14),

                // GST breakdown box
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Column(
                    children: [
                      _buildReceiptLine('Subtotal (Excl. GST)', '\$$subtotalExGst AUD'),
                      _buildReceiptLine('Total GST (10%)', '\$$gstComponent AUD'),
                      const Divider(height: 12, color: AppColors.hairline),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text('Total Invoice Amount (Inc. GST)',
                              style: TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.ink)),
                          Text('\$$totalDollars AUD',
                              style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w900, color: AppColors.ink)),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text('GST Tax Invoice PDF downloaded: $invoiceNum.pdf'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            leading: const Icon(Icons.download_rounded, size: 16),
            child: const Text('Download PDF'),
          ),
          ShadButton(
            height: 36,
            backgroundColor: AppColors.ink,
            hoverBackgroundColor: AppColors.accentDark,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDisputeDialog(StoreOrder order) {
    final refundStr =
        order.refundAmountCents != null ? '\$${(order.refundAmountCents! / 100).toStringAsFixed(2)} AUD' : 'N/A';

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                const Icon(Icons.gavel_rounded, color: Color(0xFFD97706), size: 20),
                const SizedBox(width: 8),
                Text(
                  'Dispute & Refund Details · Order #${order.id}',
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink),
                ),
              ],
            ),
            IconButton(
              icon: const Icon(Icons.close, size: 18),
              onPressed: () => Navigator.of(ctx).pop(),
            ),
          ],
        ),
        content: SizedBox(
          width: 500,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFFFDE68A)),
                ),
                child: Row(
                  children: [
                    const Icon(Icons.info_outline, color: Color(0xFFB45309), size: 20),
                    const SizedBox(width: 10),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('Automatic Dispute Resolution',
                              style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.bold, color: Color(0xFF92400E))),
                          Text('Refund Amount Credited: $refundStr',
                              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFB45309))),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 14),

              Text('Reported Reason: ${order.refundReason ?? "Item quality report"}',
                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: AppColors.ink)),
              const SizedBox(height: 6),
              Text(
                order.disputeNotes ?? 'No additional agent notes recorded.',
                style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
              ),

              const SizedBox(height: 14),
              const Divider(height: 1, color: AppColors.hairline),
              const SizedBox(height: 10),

              const Text(
                'Merchant Protection Status: Active. Payout retained by Grocerra insurance protocol.',
                style: TextStyle(fontSize: 11, fontStyle: FontStyle.italic, color: Color(0xFF166534)),
              ),
            ],
          ),
        ),
        actions: [
          ShadButton.outline(
            height: 36,
            onPressed: () {
              Navigator.of(ctx).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Dispute appeal ticket #APL-8476 created with merchant support.'),
                  backgroundColor: AppColors.accent,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            child: const Text('Appeal Dispute'),
          ),
          ShadButton(
            height: 36,
            backgroundColor: AppColors.ink,
            hoverBackgroundColor: AppColors.accentDark,
            onPressed: () => Navigator.of(ctx).pop(),
            child: const Text('Close', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showDatePresetDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        title: const Text('Select Date Filter Range',
            style: TextStyle(fontSize: 16, fontWeight: FontWeight.w800, color: AppColors.ink)),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDatePresetItem('Today · Oct 9, 2026', ctx),
            _buildDatePresetItem('Yesterday · Oct 8, 2026', ctx),
            _buildDatePresetItem('Last 7 Days', ctx),
            _buildDatePresetItem('This Month (October 2026)', ctx),
            _buildDatePresetItem('All Time History', ctx),
          ],
        ),
      ),
    );
  }

  Widget _buildDatePresetItem(String label, BuildContext ctx) {
    final isSelected = _datePreset == label;
    return ListTile(
      dense: true,
      title: Text(label,
          style: TextStyle(
            fontSize: 13,
            fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
            color: isSelected ? AppColors.accentDark : AppColors.ink,
          )),
      trailing: isSelected ? const Icon(Icons.check_rounded, color: AppColors.accent, size: 18) : null,
      onTap: () {
        setState(() {
          _datePreset = label;
          _currentPage = 1;
        });
        Navigator.of(ctx).pop();
      },
    );
  }

  void _handleExportCsv() {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Exported order history report ($_datePreset) as CSV!'),
        backgroundColor: AppColors.accent,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
