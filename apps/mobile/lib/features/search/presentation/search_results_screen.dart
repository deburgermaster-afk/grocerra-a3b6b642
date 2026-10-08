import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/tag_pill.dart';
import 'filter_modal_sheet.dart';

/// Figma `D2 · Search Results` (390×844)
///
/// Query results screen with:
/// - Sticky search header with back and filter triggers
/// - Products vs Stores tab toggle
/// - Filter chips (100% Halal, Under $20, Fast delivery)
/// - Add to basket actions with variant selection
class SearchResultsScreen extends StatefulWidget {
  const SearchResultsScreen({
    super.key,
    this.initialQuery = '',
  });

  final String initialQuery;

  static const String routeName = '/search/results';

  @override
  State<SearchResultsScreen> createState() => _SearchResultsScreenState();
}

class _SearchResultsScreenState extends State<SearchResultsScreen> {
  late TextEditingController _controller;
  int _activeTabIndex = 0; // 0 = Products, 1 = Stores
  bool _halalFilter = true;
  String _sortOption = 'Recommended';

  static const List<_ProductResult> _mockProducts = <_ProductResult>[
    _ProductResult(
      name: 'Baby Goat Curry Cut',
      storeName: 'Madina Halal Meats',
      price: '\$16.99 / kg',
      tag: 'Halal Certified',
      isCatchWeight: true,
      imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&q=80',
    ),
    _ProductResult(
      name: 'Baby Goat Shoulder',
      storeName: 'Madina Halal Meats',
      price: '\$19.99 / kg',
      tag: 'Halal Certified',
      isCatchWeight: true,
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=400&q=80',
    ),
    _ProductResult(
      name: 'Shan Special Bombay Biryani',
      storeName: 'Spice Bazaar Brunswick',
      price: '\$2.49',
      tag: '50g Box',
      isCatchWeight: false,
      imageUrl: 'https://images.unsplash.com/photo-1596040033229-a9821ebd058d?w=400&q=80',
    ),
    _ProductResult(
      name: 'Daawat Ultima Basmati Rice 5kg',
      storeName: 'Dhaka Fresh Grocers',
      price: '\$18.99',
      tag: 'Aged Long Grain',
      isCatchWeight: false,
      imageUrl: 'https://images.unsplash.com/photo-1586201375761-83865001e31c?w=400&q=80',
    ),
    _ProductResult(
      name: 'Aashirvaad Sharbati Atta 10kg',
      storeName: 'Spice Bazaar Brunswick',
      price: '\$21.99',
      tag: '100% Whole Wheat',
      isCatchWeight: false,
      imageUrl: 'https://images.unsplash.com/photo-1509440159596-0249088772ff?w=400&q=80',
    ),
  ];

  static const List<_StoreResult> _mockStores = <_StoreResult>[
    _StoreResult(
      name: 'Madina Halal Meats',
      cuisine: 'Butcher & Poultry',
      distance: '1.2 km',
      eta: '25-35 mins',
      deliveryFee: '\$5.50 delivery',
      rating: '4.9',
      imageUrl: 'https://images.unsplash.com/photo-1607623814075-e51df1bdc82f?w=400&q=80',
    ),
    _StoreResult(
      name: 'Spice Bazaar Brunswick',
      cuisine: 'South Asian Groceries',
      distance: '2.4 km',
      eta: '30-40 mins',
      deliveryFee: '\$4.99 delivery',
      rating: '4.8',
      imageUrl: 'https://images.unsplash.com/photo-1542838132-92c53300491e?w=400&q=80',
    ),
    _StoreResult(
      name: 'Dhaka Fresh Grocers',
      cuisine: 'Bengali & Indian Spices',
      distance: '3.1 km',
      eta: '35-45 mins',
      deliveryFee: '\$5.99 delivery',
      rating: '4.7',
      imageUrl: 'https://images.unsplash.com/photo-1578916171728-46686eac8d58?w=400&q=80',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _controller = TextEditingController(text: widget.initialQuery);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _openFilters() {
    FilterModalSheet.show(
      context,
      selectedSort: _sortOption,
      isHalalOnly: _halalFilter,
      onApply: (String sort, bool halal, bool veg, String price) {
        setState(() {
          _sortOption = sort;
          _halalFilter = halal;
        });
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final String query = _controller.text.trim();

    final List<_ProductResult> products = _mockProducts.where((_ProductResult p) {
      if (query.isNotEmpty &&
          !p.name.toLowerCase().contains(query.toLowerCase()) &&
          !p.storeName.toLowerCase().contains(query.toLowerCase())) {
        return false;
      }
      return true;
    }).toList();

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        children: <Widget>[
          // Top Search Bar Header
          Container(
            padding: EdgeInsets.fromLTRB(16, topInset, 16, 12),
            decoration: const BoxDecoration(
              color: AppColors.surface,
              border: Border(bottom: BorderSide(color: AppColors.hairline)),
            ),
            child: Row(
              children: <Widget>[
                RoundIconButton(
                  icon: Icons.arrow_back_rounded,
                  tooltip: 'Back',
                  onTap: () => Navigator.of(context).pop(),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: SearchField(
                    controller: _controller,
                    hintText: 'Search groceries & stores…',
                    onChanged: (String val) => setState(() {}),
                  ),
                ),
                const SizedBox(width: 8),
                RoundIconButton(
                  icon: Icons.tune_rounded,
                  tooltip: 'Filter',
                  onTap: _openFilters,
                ),
              ],
            ),
          ),

          // Segmented Tab Control (Products vs Stores)
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 12, 16, 6),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTabIndex = 0),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _activeTabIndex == 0 ? AppColors.ink : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Products (${products.length})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _activeTabIndex == 0 ? AppColors.surface : AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _activeTabIndex = 1),
                    child: Container(
                      height: 40,
                      decoration: BoxDecoration(
                        color: _activeTabIndex == 1 ? AppColors.ink : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Center(
                        child: Text(
                          'Stores (${_mockStores.length})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: _activeTabIndex == 1 ? AppColors.surface : AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          // Active filter chip row
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.fromLTRB(16, 6, 16, 8),
            child: Row(
              children: <Widget>[
                FilterChip(
                  label: const Text('100% Halal Certified'),
                  selected: _halalFilter,
                  selectedColor: const Color(0xFFDCFCE7),
                  checkmarkColor: AppColors.accentDark,
                  labelStyle: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: _halalFilter ? AppColors.accentDark : AppColors.ink,
                  ),
                  backgroundColor: AppColors.surfaceAlt,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: BorderSide.none,
                  ),
                  onSelected: (bool val) => setState(() => _halalFilter = val),
                ),
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: _openFilters,
                  child: TagPill(label: 'Sort: $_sortOption'),
                ),
                const SizedBox(width: 8),
                const TagPill(label: 'Fast Delivery (<45m)'),
              ],
            ),
          ),

          const Divider(height: 1, color: AppColors.hairline),

          // Body Content
          Expanded(
            child: _activeTabIndex == 0
                ? _buildProductsView(products, query)
                : _buildStoresView(_mockStores),
          ),
        ],
      ),
    );
  }

  Widget _buildProductsView(List<_ProductResult> products, String query) {
    if (products.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              const Icon(Icons.search_off_rounded, size: 56, color: AppColors.inkMuted),
              const SizedBox(height: 14),
              Text(
                'No products found for "$query"',
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Try checking for spelling or searching for general categories like "Mutton", "Rice" or "Spices".',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
              ),
            ],
          ),
        ),
      );
    }

    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: products.length,
      separatorBuilder: (BuildContext context, int index) => const Divider(height: 20, color: AppColors.hairline),
      itemBuilder: (BuildContext context, int index) {
        final _ProductResult product = products[index];

        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/product'),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              // Image
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.network(
                  product.imageUrl,
                  width: 80,
                  height: 80,
                  fit: BoxFit.cover,
                  errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                    width: 80,
                    height: 80,
                    color: AppColors.surfaceAlt,
                    child: const Icon(Icons.shopping_bag_outlined, color: AppColors.inkMuted),
                  ),
                ),
              ),
              const SizedBox(width: 14),

              // Details
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      product.name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.2,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      product.storeName,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: <Widget>[
                        Text(
                          product.price,
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        if (product.isCatchWeight) ...<Widget>[
                          const SizedBox(width: 6),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFDCFCE7),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Scale weight hold',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accentDark,
                              ),
                            ),
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),

              // Add Button
              FilledButton(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Added ${product.name} to basket!'),
                      duration: const Duration(seconds: 1),
                      action: SnackBarAction(
                        label: 'View Cart',
                        onPressed: () => Navigator.of(context).pushNamed('/cart'),
                      ),
                    ),
                  );
                },
                style: FilledButton.styleFrom(
                  minimumSize: const Size(68, 36),
                  padding: const EdgeInsets.symmetric(horizontal: 14),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
                ),
                child: const Text('+ Add', style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700)),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStoresView(List<_StoreResult> stores) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(16, 12, 16, 80),
      itemCount: stores.length,
      separatorBuilder: (BuildContext context, int index) => const SizedBox(height: 14),
      itemBuilder: (BuildContext context, int index) {
        final _StoreResult store = stores[index];

        return GestureDetector(
          onTap: () => Navigator.of(context).pushNamed('/store'),
          child: Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: AppColors.hairline),
            ),
            padding: const EdgeInsets.all(14),
            child: Row(
              children: <Widget>[
                ClipRRect(
                  borderRadius: BorderRadius.circular(16),
                  child: Image.network(
                    store.imageUrl,
                    width: 72,
                    height: 72,
                    fit: BoxFit.cover,
                    errorBuilder: (BuildContext context, Object error, StackTrace? stackTrace) => Container(
                      width: 72,
                      height: 72,
                      color: AppColors.surfaceAlt,
                      child: const Icon(Icons.storefront_rounded),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: <Widget>[
                          Expanded(
                            child: Text(
                              store.name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                            decoration: BoxDecoration(
                              color: const Color(0xFFFEF3C7),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Row(
                              children: <Widget>[
                                const Icon(Icons.star_rounded, size: 12, color: Color(0xFFD97706)),
                                const SizedBox(width: 2),
                                Text(
                                  store.rating,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: Color(0xFF92400E),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${store.cuisine} • ${store.distance}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${store.eta} • ${store.deliveryFee}',
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _ProductResult {
  const _ProductResult({
    required this.name,
    required this.storeName,
    required this.price,
    required this.tag,
    required this.isCatchWeight,
    required this.imageUrl,
  });

  final String name;
  final String storeName;
  final String price;
  final String tag;
  final bool isCatchWeight;
  final String imageUrl;
}

class _StoreResult {
  const _StoreResult({
    required this.name,
    required this.cuisine,
    required this.distance,
    required this.eta,
    required this.deliveryFee,
    required this.rating,
    required this.imageUrl,
  });

  final String name;
  final String cuisine;
  final String distance;
  final String eta;
  final String deliveryFee;
  final String rating;
  final String imageUrl;
}
