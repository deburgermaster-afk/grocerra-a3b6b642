import 'package:flutter/material.dart';

import '../../../core/models/catalog_models.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/store_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import '../../cart/presentation/added_to_basket_sheet.dart';
import '../../cart/presentation/cart_sheet.dart';

/// Screen #09: Store Detail (Prototype: Madina Halal Meats / Dhaka Fresh Grocers).
/// Displays store header, glowing halal badges, ETA, category tabs, and product catalog with
/// catch-weight variant selectors and quick-add actions with fluid micro-interactions.
class StoreDetailScreen extends StatefulWidget {
  const StoreDetailScreen({required this.store, super.key});

  final Store store;

  static const String routeName = '/store-detail';

  @override
  State<StoreDetailScreen> createState() => _StoreDetailScreenState();
}

class _StoreDetailScreenState extends State<StoreDetailScreen> {
  List<Product> _products = <Product>[];
  List<Category> _categories = <Category>[];
  String? _selectedCategoryId;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadCatalog();
  }

  Future<void> _loadCatalog() async {
    setState(() => _isLoading = true);
    final List<Category> cats = await StoreService.instance.getCategories();
    final List<Product> prods = await StoreService.instance.getProductsByStore(
      widget.store.id,
      categoryId: _selectedCategoryId,
    );
    if (mounted) {
      setState(() {
        _categories = cats;
        _products = prods;
        _isLoading = false;
      });
    }
  }

  void _onCategorySelected(String? catId) {
    setState(() => _selectedCategoryId = catId);
    _loadCatalog();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: CustomScrollView(
        slivers: <Widget>[
          // Sliver App Bar with Hero Image & Glass Back Button
          SliverAppBar(
            expandedHeight: 220,
            pinned: true,
            leading: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ScalePressable(
                onTap: () => Navigator.of(context).pop(),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.9),
                    shape: BoxShape.circle,
                    boxShadow: const <BoxShadow>[
                      BoxShadow(color: Color(0x1A000000), blurRadius: 8),
                    ],
                  ),
                  child: const Icon(
                    Icons.arrow_back_rounded,
                    color: AppColors.ink,
                    size: 20,
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: ScalePressable(
                  onTap: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          'Saved ${widget.store.name} to favourites!',
                        ),
                        duration: const Duration(seconds: 1),
                      ),
                    );
                  },
                  child: Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.9),
                      shape: BoxShape.circle,
                      boxShadow: const <BoxShadow>[
                        BoxShadow(color: Color(0x1A000000), blurRadius: 8),
                      ],
                    ),
                    child: const Icon(
                      Icons.favorite_border_rounded,
                      color: AppColors.ink,
                      size: 20,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 8),
            ],
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                widget.store.heroImageUrl,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) => Container(
                  color: AppColors.accentDark,
                  child: const Center(
                    child: Icon(
                      Icons.store_rounded,
                      size: 64,
                      color: Colors.white54,
                    ),
                  ),
                ),
              ),
            ),
          ),

          // Store Header Info with Glowing Badges
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          widget.store.name,
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.5,
                          ),
                        ),
                      ),
                      if (widget.store.isHalalCertified)
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF065F46),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: const Text(
                            'HALAL CERTIFIED',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 10,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                        ),
                    ],
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${widget.store.cuisines.join(' · ')} • ${widget.store.suburb}',
                    style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 14),

                  // Delivery & Rating Badges
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE2E8F0)),
                      boxShadow: const <BoxShadow>[
                        BoxShadow(
                          color: Color(0x06000000),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 12,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: <Widget>[
                        _InfoItem(
                          icon: Icons.star_rounded,
                          iconColor: const Color(0xFFF59E0B),
                          title: '${widget.store.rating}',
                          subtitle: '(${widget.store.reviewCount}+ reviews)',
                        ),
                        _VerticalDivider(),
                        _InfoItem(
                          icon: Icons.access_time_filled_rounded,
                          iconColor: const Color(0xFF10B981),
                          title: '${widget.store.deliveryEtaMinutes} mins',
                          subtitle: 'Uber & DoorDash',
                        ),
                        _VerticalDivider(),
                        _InfoItem(
                          icon: Icons.delivery_dining_rounded,
                          iconColor: AppColors.ink,
                          title: widget.store.formattedDeliveryFee,
                          subtitle: widget.store.formattedMinOrder,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            ),
          ),

          // Categories Horizontal Filter Bar
          SliverToBoxAdapter(
            child: SizedBox(
              height: 40,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                children: <Widget>[
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ScalePressable(
                      onTap: () => _onCategorySelected(null),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 9,
                        ),
                        decoration: BoxDecoration(
                          color: _selectedCategoryId == null
                              ? const Color(0xFF0F172A)
                              : Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          border: Border.all(
                            color: _selectedCategoryId == null
                                ? const Color(0xFF10B981)
                                : const Color(0xFFE2E8F0),
                          ),
                          boxShadow: _selectedCategoryId == null
                              ? <BoxShadow>[
                                  BoxShadow(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.3),
                                    blurRadius: 8,
                                  ),
                                ]
                              : null,
                        ),
                        child: Text(
                          'All Items',
                          style: TextStyle(
                            color: _selectedCategoryId == null
                                ? Colors.white
                                : AppColors.ink,
                            fontWeight: FontWeight.w700,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                  ..._categories.map((Category cat) {
                    final bool isSel = _selectedCategoryId == cat.id;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: ScalePressable(
                        onTap: () => _onCategorySelected(cat.id),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 9,
                          ),
                          decoration: BoxDecoration(
                            color: isSel
                                ? const Color(0xFF0F172A)
                                : Colors.white,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: isSel
                                  ? const Color(0xFF10B981)
                                  : const Color(0xFFE2E8F0),
                            ),
                            boxShadow: isSel
                                ? <BoxShadow>[
                                    BoxShadow(
                                      color: const Color(0xFF10B981)
                                          .withValues(alpha: 0.3),
                                      blurRadius: 8,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Text(
                            cat.name,
                            style: TextStyle(
                              color: isSel ? Colors.white : AppColors.ink,
                              fontWeight: FontWeight.w700,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ),

          const SliverToBoxAdapter(child: SizedBox(height: 16)),

          // Products List with Staggered Cascades & Glowing Cards
          if (_isLoading)
            const SliverFillRemaining(
              child: Center(
                child: CircularProgressIndicator(color: AppColors.accentDark),
              ),
            )
          else if (_products.isEmpty)
            SliverFillRemaining(
              child: Center(
                child: Text(
                  'No items found in this section',
                  style: TextStyle(color: Colors.grey.shade600),
                ),
              ),
            )
          else
            SliverPadding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 120),
              sliver: SliverList(
                delegate: SliverChildBuilderDelegate((
                  BuildContext context,
                  int index,
                ) {
                  final Product prod = _products[index];
                  return StaggeredReveal(
                    index: index,
                    child: _ProductCard(
                      product: prod,
                      onAdd: (ProductVariant variant) {
                        CartService.instance.addItem(
                          product: prod,
                          variant: variant,
                        );
                        AddedToBasketSheet.show(
                          context,
                          product: prod,
                          variant: variant,
                        );
                      },
                    ),
                  );
                }, childCount: _products.length),
              ),
            ),
        ],
      ),

      // Clean Floating Island Bottom Cart Bar
      bottomNavigationBar: ValueListenableBuilder<List<CartItem>>(
        valueListenable: CartService.instance.itemsNotifier,
        builder: (BuildContext context, List<CartItem> items, Widget? child) {
          if (items.isEmpty) return const SizedBox.shrink();
          final int count = CartService.instance.totalItemCount;

          return Container(
            color: Colors.transparent,
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            child: GestureDetector(
              onTap: () => CartSheet.show(context),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(24),
                  boxShadow: const <BoxShadow>[
                    BoxShadow(
                      color: Color(0x33000000),
                      blurRadius: 16,
                      offset: Offset(0, 6),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Row(
                      children: <Widget>[
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981).withValues(alpha: 0.25),
                            borderRadius: BorderRadius.circular(10),
                          ),
                          child: Text(
                            '$count',
                            style: const TextStyle(
                              color: Color(0xFF34D399),
                              fontWeight: FontWeight.w800,
                              fontSize: 13,
                            ),
                          ),
                        ),
                        const SizedBox(width: 12),
                        const Text(
                          'View Basket',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: <Widget>[
                        Text(
                          CartService.instance.formattedSubtotal,
                          style: const TextStyle(
                            color: Color(0xFF34D399),
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Icon(
                          Icons.arrow_forward_rounded,
                          color: Color(0xFF34D399),
                          size: 18,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product, required this.onAdd});

  final Product product;
  final ValueChanged<ProductVariant> onAdd;

  @override
  Widget build(BuildContext context) {
    final ProductVariant? variant = product.defaultVariant;

    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFFE2E8F0)),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x06000000),
              blurRadius: 8,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Product Image
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.network(
                product.imageUrl,
                width: 90,
                height: 90,
                fit: BoxFit.cover,
                errorBuilder: (
                  BuildContext context,
                  Object error,
                  StackTrace? stackTrace,
                ) => Container(
                  width: 90,
                  height: 90,
                  color: Colors.grey.shade100,
                  child: const Icon(
                    Icons.shopping_basket_rounded,
                    size: 32,
                    color: Colors.grey,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 14),

            // Product Details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    product.name,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                      letterSpacing: -0.2,
                    ),
                  ),
                  const SizedBox(height: 3),
                  Text(
                    product.description,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  const SizedBox(height: 8),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            product.formattedPrice,
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentDark,
                            ),
                          ),
                          if (product.isCatchWeight)
                            const Text(
                              'Scale weight hold (+10%)',
                              style: TextStyle(
                                fontSize: 10,
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF059669),
                              ),
                            ),
                        ],
                      ),
                      if (variant != null)
                        GestureDetector(
                          onTap: () => onAdd(variant),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 14,
                              vertical: 7,
                            ),
                            decoration: BoxDecoration(
                              color: const Color(0xFF0F172A),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Icon(
                                  Icons.add_rounded,
                                  size: 16,
                                  color: Colors.white,
                                ),
                                SizedBox(width: 4),
                                Text(
                                  'Add',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 12,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _InfoItem extends StatelessWidget {
  const _InfoItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final Color iconColor;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(icon, size: 16, color: iconColor),
            const SizedBox(width: 4),
            Text(
              title,
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                fontSize: 13,
                letterSpacing: -0.2,
              ),
            ),
          ],
        ),
        const SizedBox(height: 2),
        Text(
          subtitle,
          style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
        ),
      ],
    );
  }
}

class _VerticalDivider extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(width: 1, height: 28, color: const Color(0xFFE2E8F0));
  }
}
