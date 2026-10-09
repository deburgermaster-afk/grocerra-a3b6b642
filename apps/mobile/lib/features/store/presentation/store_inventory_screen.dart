import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StoreInventoryScreen extends StatefulWidget {
  const StoreInventoryScreen({super.key});

  @override
  State<StoreInventoryScreen> createState() => _StoreInventoryScreenState();
}

class _StoreInventoryScreenState extends State<StoreInventoryScreen> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedCategory = 'all'; // 'all', 'butcher', 'pantry', 'produce', 'sold_out'

  // Mock Inventory Items with live 86 toggle states
  late List<Map<String, dynamic>> _inventoryItems;

  @override
  void initState() {
    super.initState();
    _inventoryItems = [
      {
        'id': 'sku-1',
        'name': 'Fresh Halal Baby Goat Curry Cut',
        'sku': 'BUT-GOAT-001',
        'category': 'Halal Butcher',
        'deptKey': 'butcher',
        'price': r'$28.50 / kg',
        'stock': '34.5 kg in cold storage',
        'inStock': true,
        'icon': Icons.set_meal_outlined,
      },
      {
        'id': 'sku-2',
        'name': 'Daawat Traditional Basmati Rice 5kg',
        'sku': 'GRN-DAAW-5KG',
        'category': 'South Asian Pantry',
        'deptKey': 'pantry',
        'price': r'$21.90',
        'stock': '18 bags on Aisle 3',
        'inStock': true,
        'icon': Icons.grain_outlined,
      },
      {
        'id': 'sku-3',
        'name': 'Shan Bombay Biryani Masala 50g',
        'sku': 'PAN-SHAN-BOMBAY',
        'category': 'South Asian Pantry',
        'deptKey': 'pantry',
        'price': r'$2.45',
        'stock': '64 packs on Shelf B2',
        'inStock': true,
        'icon': Icons.restaurant_menu_outlined,
      },
      {
        'id': 'sku-4',
        'name': 'Fresh Mint & Coriander Bunches',
        'sku': 'PRD-MINT-BUN',
        'category': 'Fresh Produce',
        'deptKey': 'produce',
        'price': r'$2.00 / bunch',
        'stock': '0 bunches (Sold Out)',
        'inStock': false, // Currently 86'd
        'icon': Icons.eco_outlined,
      },
      {
        'id': 'sku-5',
        'name': 'Aashirvaad Superior MP Atta 10kg',
        'sku': 'GRN-AASH-10KG',
        'category': 'South Asian Pantry',
        'deptKey': 'pantry',
        'price': r'$14.00',
        'stock': '12 bags on Pallet 4',
        'inStock': true,
        'icon': Icons.shopping_bag_outlined,
      },
      {
        'id': 'sku-6',
        'name': 'National Garlic & Ginger Paste 330g',
        'sku': 'PAN-NAT-GGP',
        'category': 'South Asian Pantry',
        'deptKey': 'pantry',
        'price': r'$3.80',
        'stock': '28 jars on Shelf C1',
        'inStock': true,
        'icon': Icons.kitchen_outlined,
      },
      {
        'id': 'sku-7',
        'name': 'Spring Lamb Shoulder Bone-In',
        'sku': 'BUT-LAMB-SHLD',
        'category': 'Halal Butcher',
        'deptKey': 'butcher',
        'price': r'$22.90 / kg',
        'stock': '21.0 kg in display case',
        'inStock': true,
        'icon': Icons.dinner_dining_outlined,
      },
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showAddProductDialog() {
    final nameCtrl = TextEditingController();
    final priceCtrl = TextEditingController();
    final stockCtrl = TextEditingController();
    String category = 'Halal Butcher';

    showDialog(
      context: context,
      builder: (ctx) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return Dialog(
              backgroundColor: Colors.transparent,
              child: Container(
                width: 520,
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.hairline),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.08),
                      blurRadius: 20,
                      offset: const Offset(0, 8),
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Container(
                          width: 40,
                          height: 40,
                          decoration: BoxDecoration(
                            color: AppColors.accent.withOpacity(0.12),
                            borderRadius: BorderRadius.circular(8),
                          ),
                          child: const Icon(
                            Icons.add_box_outlined,
                            color: AppColors.accent,
                            size: 22,
                          ),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Add Custom Product SKU',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Publish item directly to Grocerra Customer App catalog',
                                style: TextStyle(
                                  fontSize: 12,
                                  color: AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close, size: 20, color: AppColors.inkMuted),
                          onPressed: () => Navigator.of(ctx).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Product Name Input
                    const Text('Product Title', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
                    const SizedBox(height: 6),
                    TextField(
                      controller: nameCtrl,
                      decoration: InputDecoration(
                        hintText: 'e.g. Royal Basmati Rice 10kg',
                        hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                        filled: true,
                        fillColor: AppColors.canvas,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                        enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Price & Stock
                    Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(r'Unit Price ($ AUD)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: priceCtrl,
                                decoration: InputDecoration(
                                  hintText: r'$18.50',
                                  filled: true,
                                  fillColor: AppColors.canvas,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(width: 14),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text('Initial Stock', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
                              const SizedBox(height: 6),
                              TextField(
                                controller: stockCtrl,
                                decoration: InputDecoration(
                                  hintText: '20 units',
                                  filled: true,
                                  fillColor: AppColors.canvas,
                                  contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                                  enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 20),

                    // Actions
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        ShadButton.outline(
                          onPressed: () => Navigator.of(ctx).pop(),
                          child: const Text('Cancel', style: TextStyle(color: AppColors.ink)),
                        ),
                        const SizedBox(width: 10),
                        ShadButton(
                          backgroundColor: AppColors.accent,
                          onPressed: () {
                            if (nameCtrl.text.isNotEmpty) {
                              setState(() {
                                _inventoryItems.insert(0, {
                                  'id': 'sku-${DateTime.now().millisecondsSinceEpoch}',
                                  'name': nameCtrl.text,
                                  'sku': 'CUSTOM-${nameCtrl.text.hashCode.abs().toString().substring(0, 4)}',
                                  'category': category,
                                  'deptKey': 'pantry',
                                  'price': priceCtrl.text.isNotEmpty ? priceCtrl.text : r'$10.00',
                                  'stock': stockCtrl.text.isNotEmpty ? stockCtrl.text : '10 units in stock',
                                  'inStock': true,
                                  'icon': Icons.inventory_2_outlined,
                                });
                              });
                            }
                            Navigator.of(ctx).pop();
                          },
                          child: const Text('Save & Publish SKU', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    // Apply filters
    final filteredItems = _inventoryItems.where((item) {
      if (_selectedCategory == 'butcher' && item['deptKey'] != 'butcher') return false;
      if (_selectedCategory == 'pantry' && item['deptKey'] != 'pantry') return false;
      if (_selectedCategory == 'produce' && item['deptKey'] != 'produce') return false;
      if (_selectedCategory == 'sold_out' && (item['inStock'] as bool)) return false;

      if (_searchQuery.isNotEmpty) {
        final q = _searchQuery.toLowerCase();
        final name = (item['name'] as String).toLowerCase();
        final sku = (item['sku'] as String).toLowerCase();
        return name.contains(q) || sku.contains(q);
      }
      return true;
    }).toList();

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header & Add Custom Product CTA
          _buildHeader(),
          const SizedBox(height: 20),

          // 2. 4 Inventory Health KPI Cards
          _buildKpiCards(),
          const SizedBox(height: 20),

          // 3. Search Bar & Department Filter Pills
          _buildSearchAndFilters(),
          const SizedBox(height: 16),

          // 4. SKU Inventory Table
          _buildTableCard(filteredItems),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title & Subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Quick 86 Stock & Catalog',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Instant 1-tap stock-out switches and manual catalog management',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Add Custom Product Button
          ShadButton(
            backgroundColor: AppColors.accent,
            onPressed: _showAddProductDialog,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add, size: 16, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  '+ Add Custom Product',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 48) / 4;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // KPI 1: Active Catalog
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.inventory_2_outlined,
              iconColor: AppColors.accent,
              iconBgColor: AppColors.accent.withOpacity(0.12),
              title: 'Active Catalog',
              value: '482 SKUs',
              badgeText: '474 In Stock',
              badgeColor: AppColors.accent,
              subtext: 'Synchronized with POS database',
            ),

            // KPI 2: Currently 86'd
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.block_outlined,
              iconColor: AppColors.danger,
              iconBgColor: const Color(0xFFFEF2F2),
              title: "Currently 86'd",
              value: '8 Sold Out',
              badgeText: "86'd from customer app",
              badgeColor: AppColors.danger,
              subtext: 'Auto-hidden from search catalog',
            ),

            // KPI 3: Low Stock Alerts
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.warning_amber_rounded,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFD97706).withOpacity(0.12),
              title: 'Low Stock Alerts',
              value: '14 SKUs',
              badgeText: '<5 units on shelf',
              badgeColor: const Color(0xFFD97706),
              subtext: 'Restock order suggested',
            ),

            // KPI 4: Inventory Sync
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.sync_rounded,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFF0284C7).withOpacity(0.12),
              title: 'Inventory Sync',
              value: '100% Live',
              badgeText: 'WebSocket connected',
              badgeColor: const Color(0xFF0284C7),
              subtext: 'Zero manual refresh needed',
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required double width,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required String subtext,
  }) {
    return Container(
      width: width < 220 ? 220 : width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchAndFilters() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          // Search Input
          TextField(
            controller: _searchController,
            onChanged: (val) => setState(() => _searchQuery = val),
            decoration: InputDecoration(
              hintText: 'Search 482 store SKUs by name or barcode...',
              hintStyle: const TextStyle(fontSize: 13.5, color: AppColors.inkMuted),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.inkMuted),
              filled: true,
              fillColor: AppColors.canvas,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
              enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.hairline)),
              focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(8), borderSide: const BorderSide(color: AppColors.accent)),
            ),
          ),
          const SizedBox(height: 12),

          // Filter Pills
          Row(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildPill('all', 'All Products (482)'),
                      const SizedBox(width: 8),
                      _buildPill('butcher', 'Halal Butcher (64)'),
                      const SizedBox(width: 8),
                      _buildPill('pantry', 'South Asian Pantry (240)'),
                      const SizedBox(width: 8),
                      _buildPill('produce', 'Fresh Produce (118)'),
                      const SizedBox(width: 8),
                      _buildPill('sold_out', "Sold Out (86'd) (8)"),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPill(String key, String label) {
    final isSelected = _selectedCategory == key;
    return InkWell(
      onTap: () => setState(() => _selectedCategory = key),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.accent : AppColors.canvas,
          borderRadius: BorderRadius.circular(6),
          border: Border.all(color: isSelected ? AppColors.accent : AppColors.hairline),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? Colors.white : AppColors.ink,
          ),
        ),
      ),
    );
  }

  Widget _buildTableCard(List<Map<String, dynamic>> items) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Store Inventory & 86 Master Switch',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 4),
                      Text(
                        'Toggle item availability with 1 touch to prevent customer ordering when physical stock is depleted',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Text(
                    '${items.length} SKUs Listed',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkMuted),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.hairline),

          // Horizontal scroll table guard
          LayoutBuilder(
            builder: (context, constraints) {
              const minTableWidth = 1080.0;
              final tableWidth = constraints.maxWidth > minTableWidth ? constraints.maxWidth : minTableWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      const Divider(height: 1, color: AppColors.hairline),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: items.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.hairline),
                        itemBuilder: (context, index) {
                          return _buildItemRow(items[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.canvas,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: const Row(
        children: [
          SizedBox(
            width: 340,
            child: Text('Product Name & SKU', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
          ),
          SizedBox(
            width: 180,
            child: Text('Category / Department', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
          ),
          SizedBox(
            width: 140,
            child: Text(r'Unit Price ($ AUD)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
          ),
          SizedBox(
            width: 160,
            child: Text('Stock Level', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
          ),
          SizedBox(
            width: 260,
            child: Text('Online Availability (86 Toggle)', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted)),
          ),
        ],
      ),
    );
  }

  Widget _buildItemRow(Map<String, dynamic> item) {
    final bool inStock = item['inStock'] as bool;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Product Name & SKU
          SizedBox(
            width: 340,
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Icon(item['icon'] as IconData, size: 18, color: AppColors.ink),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item['name'] as String,
                        style: const TextStyle(
                          fontSize: 13.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        item['sku'] as String,
                        style: const TextStyle(
                          fontSize: 11,
                          fontFamily: 'monospace',
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Category
          SizedBox(
            width: 180,
            child: Text(
              item['category'] as String,
              style: const TextStyle(fontSize: 13, color: AppColors.ink),
            ),
          ),

          // Price
          SizedBox(
            width: 140,
            child: Text(
              item['price'] as String,
              style: const TextStyle(fontSize: 13.5, fontWeight: FontWeight.w700, color: AppColors.ink),
            ),
          ),

          // Stock Level
          SizedBox(
            width: 160,
            child: Text(
              item['stock'] as String,
              style: TextStyle(
                fontSize: 12.5,
                color: inStock ? AppColors.inkMuted : AppColors.danger,
                fontWeight: inStock ? FontWeight.w500 : FontWeight.w600,
              ),
            ),
          ),

          // 86 Toggle Control
          SizedBox(
            width: 260,
            child: Row(
              children: [
                ShadSwitch(
                  value: inStock,
                  onChanged: (val) {
                    setState(() {
                      item['inStock'] = val;
                      item['stock'] = val ? '10 units in stock' : '0 units (Sold Out)';
                    });
                  },
                ),
                const SizedBox(width: 10),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: inStock
                        ? AppColors.accent.withOpacity(0.12)
                        : const Color(0xFFFEF2F2),
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(
                      color: inStock
                          ? AppColors.accent.withOpacity(0.3)
                          : const Color(0xFFFECACA),
                    ),
                  ),
                  child: Text(
                    inStock ? 'In Stock' : "86'd (Sold Out)",
                    style: TextStyle(
                      fontSize: 11.5,
                      fontWeight: FontWeight.w700,
                      color: inStock ? AppColors.accent : AppColors.danger,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
