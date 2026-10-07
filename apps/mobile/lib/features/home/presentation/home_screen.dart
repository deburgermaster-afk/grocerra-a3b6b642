import 'package:flutter/material.dart';

import '../../../core/models/catalog_models.dart';
import '../../../core/services/cart_service.dart';
import '../../../core/services/store_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import '../../cart/presentation/cart_sheet.dart';
import '../../store/presentation/store_detail_screen.dart';

/// Screen #06: Groceries & Catering Home
/// High-fidelity home screen upgraded with modern glowing animations:
/// - Rotating & breathing GlowRing Live Express Dispatch banner
/// - Luminous GlowCard service entry cards (Groceries vs Catering)
/// - Interactive ScalePressable Category Rail with ambient hover/touch glow
/// - Staggered cascade store cards with Halal live pulse radar badges
/// - Floating Glowing Island Cart capsule with live price & counter bounce
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Store> _stores = <Store>[];
  List<Category> _categories = <Category>[];
  String? _selectedCuisine;
  bool _isLoading = true;

  final List<String> _cuisines = <String>[
    'All',
    'Pakistani',
    'Indian',
    'Bangladeshi',
    'Halal',
  ];

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    setState(() => _isLoading = true);
    final List<Category> cats = await StoreService.instance.getCategories();
    final List<Store> stores = await StoreService.instance.getStores(
      cuisineFilter: _selectedCuisine == 'All' ? null : _selectedCuisine,
    );
    if (mounted) {
      setState(() {
        _categories = cats;
        _stores = stores;
        _isLoading = false;
      });
    }
  }

  void _onCuisineSelected(String cuisine) {
    setState(() {
      _selectedCuisine = cuisine;
    });
    _loadData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      body: SafeArea(
        child: Stack(
          children: <Widget>[
            RefreshIndicator(
              color: AppColors.accentDark,
              onRefresh: _loadData,
              child: ListView(
                padding: const EdgeInsets.only(bottom: 120),
                children: <Widget>[
                  // Top Location & Notification Header
                  Padding(
                    padding: const EdgeInsets.fromLTRB(16, 12, 16, 10),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Expanded(
                          child: ScalePressable(
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Delivering to: 24 Maple Street, Coburg VIC 3058',
                                  ),
                                  duration: Duration(seconds: 2),
                                ),
                              );
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Container(
                                  padding: const EdgeInsets.all(7),
                                  decoration: BoxDecoration(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.12),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Icon(
                                    Icons.location_on,
                                    color: AppColors.accentDark,
                                    size: 18,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Flexible(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: <Widget>[
                                          Text(
                                            'Coburg, Melbourne',
                                            style: TextStyle(
                                              fontWeight: FontWeight.w800,
                                              fontSize: 15,
                                              color: AppColors.ink,
                                              letterSpacing: -0.3,
                                            ),
                                          ),
                                          Icon(
                                            Icons.keyboard_arrow_down,
                                            size: 18,
                                          ),
                                        ],
                                      ),
                                      Text(
                                        '24 Maple Street · 3058',
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Color(0xFF64748B),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Row(
                          children: <Widget>[
                            // Notification Bell with Micro Scale
                            ScalePressable(
                              onTap: () {
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('No new alerts right now.'),
                                    duration: Duration(seconds: 1),
                                  ),
                                );
                              },
                              child: Container(
                                padding: const EdgeInsets.all(8),
                                decoration: BoxDecoration(
                                  color: Colors.white,
                                  borderRadius: BorderRadius.circular(12),
                                  border: Border.all(
                                    color: const Color(0xFFE2E8F0),
                                  ),
                                ),
                                child: const Icon(
                                  Icons.notifications_none_outlined,
                                  color: AppColors.ink,
                                  size: 20,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            // Cart Quick Button with Badge & Glow
                            ValueListenableBuilder<List<CartItem>>(
                              valueListenable:
                                  CartService.instance.itemsNotifier,
                              builder: (
                                BuildContext context,
                                List<CartItem> items,
                                _,
                              ) {
                                final int count =
                                    CartService.instance.totalItemCount;
                                return ScalePressable(
                                  onTap: () => CartSheet.show(context),
                                  child: Container(
                                    padding: const EdgeInsets.all(8),
                                    decoration: BoxDecoration(
                                      color: count > 0
                                          ? const Color(0xFF0F172A)
                                          : Colors.white,
                                      borderRadius: BorderRadius.circular(12),
                                      border: Border.all(
                                        color: count > 0
                                            ? const Color(0xFF10B981)
                                            : const Color(0xFFE2E8F0),
                                      ),
                                      boxShadow: count > 0
                                          ? <BoxShadow>[
                                              BoxShadow(
                                                color: const Color(0xFF10B981)
                                                    .withValues(alpha: 0.35),
                                                blurRadius: 10,
                                              ),
                                            ]
                                          : null,
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: <Widget>[
                                        Icon(
                                          Icons.shopping_bag_outlined,
                                          color: count > 0
                                              ? const Color(0xFF34D399)
                                              : AppColors.ink,
                                          size: 20,
                                        ),
                                        if (count > 0) ...<Widget>[
                                          const SizedBox(width: 5),
                                          Text(
                                            '$count',
                                            style: const TextStyle(
                                              color: Colors.white,
                                              fontSize: 12,
                                              fontWeight: FontWeight.w800,
                                            ),
                                          ),
                                        ],
                                      ],
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  // Search Bar with Sleek Border
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 14,
                        vertical: 12,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE2E8F0)),
                        boxShadow: const <BoxShadow>[
                          BoxShadow(
                            color: Color(0x06000000),
                            blurRadius: 10,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.search, color: Color(0xFF94A3B8)),
                          const SizedBox(width: 10),
                          Text(
                            'Search halal goat, paratha, shan biryani...',
                            style: TextStyle(
                              color: Colors.grey.shade500,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Signature Glowing Live Express Dispatch Banner (Code & Chill style)
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: GlowCard(
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text(
                              'Dual Dispatch Active: Uber Direct & DoorDash quoting live in Coburg',
                            ),
                            duration: Duration(seconds: 2),
                          ),
                        );
                      },
                      borderRadius: 22,
                      borderWidth: 1.5,
                      glowColor: const Color(0xFF10B981),
                      backgroundColor: const Color(0xFF0F172A),
                      enableBorderGlow: true,
                      enableAmbientShadow: true,
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: <Widget>[
                          // The signature rotating and breathing glowing ring!
                          const GlowRing(
                            size: 60,
                            strokeWidth: 3.2,
                            glowColor: Color(0xFF10B981),
                            secondaryColor: Color(0xFF064E3B),
                            child: Icon(
                              Icons.electric_bolt_rounded,
                              color: Color(0xFF34D399),
                              size: 26,
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                Row(
                                  children: const <Widget>[
                                    GlowBadge(
                                      label: 'LIVE DISPATCH',
                                      showPulseDot: true,
                                      glowColor: Color(0xFF10B981),
                                      backgroundColor: Color(0x3310B981),
                                      textColor: Color(0xFF34D399),
                                    ),
                                    SizedBox(width: 8),
                                    Text(
                                      'Coburg VIC',
                                      style: TextStyle(
                                        color: Color(0xFF94A3B8),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 6),
                                const Text(
                                  '30–45m Halal & Fresh Fast',
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 15,
                                    fontWeight: FontWeight.w800,
                                    letterSpacing: -0.3,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                const Text(
                                  'Scale-weight meat & pantry delivered cold',
                                  style: TextStyle(
                                    color: Color(0xFF94A3B8),
                                    fontSize: 11,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const Icon(
                            Icons.arrow_forward_ios_rounded,
                            size: 14,
                            color: Color(0xFF34D399),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Dual Service Glowing Entry Tiles: Groceries vs Catering
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: _ServiceCard(
                            title: 'Groceries',
                            subtitle: 'Fresh Halal & Spices\n30–45 mins',
                            tag: 'ON DEMAND',
                            backgroundColor: AppColors.accentDark,
                            glowColor: const Color(0xFF10B981),
                            icon: Icons.shopping_basket_rounded,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text('Viewing groceries feed.'),
                                  duration: Duration(milliseconds: 800),
                                ),
                              );
                            },
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _ServiceCard(
                            title: 'Catering',
                            subtitle: 'Feasts & Bulk Trays\nCustom Quotes',
                            tag: 'EVENTS',
                            backgroundColor: const Color(0xFF1E293B),
                            glowColor: const Color(0xFFF59E0B),
                            icon: Icons.restaurant_menu_rounded,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                const SnackBar(
                                  content: Text(
                                    'Switching to Catering Feast planner...',
                                  ),
                                  duration: Duration(milliseconds: 800),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Category Icon Rail with Micro-Interactions
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Shop by Department',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 92,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _categories.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 12),
                      itemBuilder: (BuildContext context, int index) {
                        final Category cat = _categories[index];
                        return _CategoryItem(category: cat);
                      },
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Cuisine Filter Chips
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: const <Widget>[
                        Text(
                          'Featured Stores',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.4,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 10),
                  SizedBox(
                    height: 38,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      itemCount: _cuisines.length,
                      separatorBuilder: (_, _) => const SizedBox(width: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final String c = _cuisines[index];
                        final bool isSel =
                            (_selectedCuisine == null && c == 'All') ||
                            _selectedCuisine == c;
                        return ScalePressable(
                          onTap: () => _onCuisineSelected(c),
                          child: Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 8,
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
                                            .withValues(alpha: 0.25),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Text(
                              c,
                              style: TextStyle(
                                color: isSel ? Colors.white : AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 13,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 18),

                  // Stores Listing with Staggered Cascading Animation
                  if (_isLoading)
                    const Padding(
                      padding: EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: CircularProgressIndicator(
                          color: AppColors.accentDark,
                        ),
                      ),
                    )
                  else if (_stores.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Text(
                          'No stores found matching this cuisine filter.',
                          style: TextStyle(color: Colors.grey.shade600),
                        ),
                      ),
                    )
                  else
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Column(
                        children: List<Widget>.generate(_stores.length, (
                          int index,
                        ) {
                          final Store store = _stores[index];
                          return StaggeredReveal(
                            index: index,
                            child: _StoreCard(
                              store: store,
                              onTap: () {
                                Navigator.of(context).push(
                                  MaterialPageRoute<void>(
                                    builder: (_) =>
                                        StoreDetailScreen(store: store),
                                  ),
                                );
                              },
                            ),
                          );
                        }),
                      ),
                    ),
                ],
              ),
            ),

            // Sleek Floating Island Cart Capsule (Appears with glowing outline)
            ValueListenableBuilder<List<CartItem>>(
              valueListenable: CartService.instance.itemsNotifier,
              builder: (BuildContext context, List<CartItem> items, _) {
                final int count = CartService.instance.totalItemCount;
                if (count == 0) return const SizedBox.shrink();

                return Positioned(
                  bottom: 20,
                  left: 16,
                  right: 16,
                  child: GlowCard(
                    onTap: () => CartSheet.show(context),
                    borderRadius: 24,
                    borderWidth: 1.5,
                    glowColor: const Color(0xFF10B981),
                    backgroundColor: const Color(0xFF0F172A),
                    enableBorderGlow: true,
                    enableAmbientShadow: true,
                    padding: const EdgeInsets.symmetric(
                      horizontal: 18,
                      vertical: 14,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        Row(
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: const Color(0xFF10B981)
                                    .withValues(alpha: 0.2),
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(
                                Icons.shopping_bag_rounded,
                                color: Color(0xFF34D399),
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisSize: MainAxisSize.min,
                              children: <Widget>[
                                Text(
                                  '$count ${count == 1 ? "item" : "items"} in basket',
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                Text(
                                  CartService.instance.formattedSubtotal,
                                  style: const TextStyle(
                                    color: Color(0xFF34D399),
                                    fontSize: 12,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                        Row(
                          children: const <Widget>[
                            Text(
                              'View Basket',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                            SizedBox(width: 4),
                            Icon(
                              Icons.arrow_forward_rounded,
                              size: 16,
                              color: Color(0xFF34D399),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _ServiceCard extends StatelessWidget {
  const _ServiceCard({
    required this.title,
    required this.subtitle,
    required this.tag,
    required this.backgroundColor,
    required this.icon,
    required this.onTap,
    this.glowColor = const Color(0xFF10B981),
  });

  final String title;
  final String subtitle;
  final String tag;
  final Color backgroundColor;
  final IconData icon;
  final VoidCallback onTap;
  final Color glowColor;

  @override
  Widget build(BuildContext context) {
    return GlowCard(
      onTap: onTap,
      backgroundColor: backgroundColor,
      glowColor: glowColor,
      borderRadius: 20,
      borderWidth: 1.4,
      enableBorderGlow: true,
      enableAmbientShadow: true,
      child: ShimmerGlint(
        intensity: 0.18,
        child: SizedBox(
          height: 126,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    GlowBadge(
                      label: tag,
                      backgroundColor: Colors.white.withValues(alpha: 0.16),
                      glowColor: glowColor,
                      textColor: Colors.white,
                    ),
                    Icon(
                      icon,
                      color: Colors.white.withValues(alpha: 0.9),
                      size: 22,
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w800,
                        letterSpacing: -0.3,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      subtitle,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.85),
                        fontSize: 11,
                        height: 1.2,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _CategoryItem extends StatelessWidget {
  const _CategoryItem({required this.category});

  final Category category;

  IconData _getIcon(String name) {
    switch (name) {
      case 'set_meal':
        return Icons.set_meal_rounded;
      case 'grain':
        return Icons.grain_rounded;
      case 'local_fire_department':
        return Icons.local_fire_department_rounded;
      case 'spa':
        return Icons.spa_rounded;
      case 'cake':
        return Icons.cake_rounded;
      case 'ac_unit':
        return Icons.ac_unit_rounded;
      default:
        return Icons.shopping_basket_rounded;
    }
  }

  @override
  Widget build(BuildContext context) {
    return ScalePressable(
      onTap: () {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Department: ${category.name}'),
            duration: const Duration(milliseconds: 800),
          ),
        );
      },
      child: Column(
        children: <Widget>[
          Container(
            width: 58,
            height: 58,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(18),
              border: Border.all(color: const Color(0xFFE2E8F0)),
              boxShadow: <BoxShadow>[
                BoxShadow(
                  color: AppColors.accent.withValues(alpha: 0.08),
                  blurRadius: 10,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Icon(
              _getIcon(category.iconName),
              color: AppColors.accentDark,
              size: 26,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            category.name,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store, required this.onTap});

  final Store store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: GlowCard(
        onTap: onTap,
        borderRadius: 22,
        borderWidth: 1.2,
        glowColor: const Color(0xFF10B981),
        enableBorderGlow: store.isHalalCertified,
        enableAmbientShadow: true,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Image with Badges
            ClipRRect(
              borderRadius:
                  const BorderRadius.vertical(top: Radius.circular(20)),
              child: Stack(
                children: <Widget>[
                  Image.network(
                    store.heroImageUrl,
                    height: 154,
                    width: double.infinity,
                    fit: BoxFit.cover,
                    errorBuilder: (
                      BuildContext context,
                      Object error,
                      StackTrace? stackTrace,
                    ) => Container(
                      height: 154,
                      color: Colors.grey.shade200,
                      child: const Center(
                        child: Icon(
                          Icons.storefront_rounded,
                          size: 48,
                          color: Colors.grey,
                        ),
                      ),
                    ),
                  ),
                  // ETA pill with glowing neon border
                  Positioned(
                    bottom: 12,
                    right: 12,
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 10,
                        vertical: 5,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.black.withValues(alpha: 0.78),
                        borderRadius: BorderRadius.circular(14),
                        border: Border.all(
                          color:
                              const Color(0xFF10B981).withValues(alpha: 0.6),
                          width: 1,
                        ),
                        boxShadow: <BoxShadow>[
                          BoxShadow(
                            color: const Color(0xFF10B981)
                                .withValues(alpha: 0.25),
                            blurRadius: 8,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          const Icon(
                            Icons.access_time_filled_rounded,
                            size: 13,
                            color: Color(0xFF34D399),
                          ),
                          const SizedBox(width: 4),
                          Text(
                            '${store.deliveryEtaMinutes} min',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w700,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  // Halal Certified Badge with pulse glow dot
                  if (store.isHalalCertified)
                    Positioned(
                      top: 12,
                      left: 12,
                      child: GlowBadge(
                        label: 'HALAL CERTIFIED',
                        showPulseDot: true,
                        glowColor: const Color(0xFF10B981),
                        backgroundColor: const Color(0xE6064E3B),
                        textColor: Colors.white,
                      ),
                    ),
                ],
              ),
            ),

            // Store Info
            Padding(
              padding: const EdgeInsets.all(14),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          store.name,
                          style: const TextStyle(
                            fontSize: 17,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                            letterSpacing: -0.3,
                          ),
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 3,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(color: const Color(0xFFFDE68A)),
                        ),
                        child: Row(
                          children: <Widget>[
                            const Icon(
                              Icons.star_rounded,
                              size: 14,
                              color: Color(0xFFD97706),
                            ),
                            const SizedBox(width: 3),
                            Text(
                              '${store.rating}',
                              style: const TextStyle(
                                fontWeight: FontWeight.w800,
                                fontSize: 12,
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
                    '${store.cuisines.join(' · ')} • ${store.suburb}',
                    style: TextStyle(
                      fontSize: 13,
                      color: Colors.grey.shade600,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: <Widget>[
                      Text(
                        store.formattedDeliveryFee,
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                      Text(
                        ' • ${store.formattedMinOrder}',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
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
