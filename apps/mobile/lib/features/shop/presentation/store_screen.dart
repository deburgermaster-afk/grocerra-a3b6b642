import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `B3 · Store · Madina Halal Meats` — exact 390×844 frame port.
///
/// The frame is taller than 844 due to the product grid. This screen scrolls
/// with a fixed glass header (back, title, search) and the product grid below.
/// The floating tab bar is owned by `HomeShell`; we pad the bottom by
/// `AppInsets.tabBar`.
class StoreScreen extends StatefulWidget {
  const StoreScreen({super.key});

  static const String routeName = '/store';

  @override
  State<StoreScreen> createState() => _StoreScreenState();
}

class _StoreScreenState extends State<StoreScreen> {
  int _selectedCategory = 1; // 0=All, 1=Meat, etc.

  static const List<_CategoryChip> _categories = <_CategoryChip>[
    _CategoryChip('All', false),
    _CategoryChip('Meat', true),
    _CategoryChip('Rice & Grains', false),
    _CategoryChip('Spices', false),
    _CategoryChip('Dairy', false),
    _CategoryChip('Fresh Produce', false),
    _CategoryChip('Frozen', false),
    _CategoryChip('Sweets', false),
  ];

  static const List<_Product> _products = <_Product>[
    _Product(
      name: 'Baby Goat Shoulder',
      variants: '500 g · 1 kg · 2 kg',
      price: '\$19.99 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: null,
    ),
    _Product(
      name: 'Baby Goat Leg',
      variants: '1 kg · 1.5 kg · 2 kg',
      price: '\$21.50 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: null,
    ),
    _Product(
      name: 'Goat Curry Cut',
      variants: '500 g · 1 kg · 2 kg',
      price: '\$16.99 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: null,
    ),
    _Product(
      name: 'Lamb Leg',
      variants: 'Whole · 2 kg',
      price: '\$19.00 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: LinearGradient(
        begin: Alignment(-0.14, -0.14),
        end: Alignment(0.57, 0.86),
        colors: <Color>[Color(0xFF9C3B2E), Color(0xFFD4766A)],
      ),
      isSoldOut: true,
    ),
    _Product(
      name: 'Goat Mince',
      variants: '500 g · 1 kg',
      price: '\$15.99 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: null,
    ),
    _Product(
      name: 'Lamb Chops',
      variants: '500 g · 1 kg',
      price: '\$24.99 / kg',
      tag: 'Halal',
      tagColor: Color(0xFF05944F),
      imageGradient: null,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, topInset, 0, AppInsets.tabBar),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildGlassHeader(topInset),
            _buildStoreInfo(),
            _buildCategoryChips(),
            const SizedBox(height: 12),
            _buildSectionHeader(),
            const SizedBox(height: 12),
            _buildLowStockPill(),
            const SizedBox(height: 12),
            _buildProductGrid(),
            const SizedBox(height: 56), // cart bar space
          ],
        ),
      ),
    );
  }

  Widget _buildGlassHeader(double topInset) {
    final double safeTop = topInset > 47 ? topInset - 47 : 0;
    return Container(
      height: 125 + safeTop,
      color: AppColors.surfaceAlt.withValues(alpha: 0.5),
      padding: EdgeInsets.only(top: safeTop),
      child: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
            child: Row(
              children: <Widget>[
                // Back button 40×40 with subtle background
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: const Color(0x0F000000),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).maybePop(),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'Madina Halal Meats',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 22,
                      height: 27 / 22,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                // Search icon
                Container(
                  width: 40,
                  height: 40,
                  decoration: BoxDecoration(
                    color: AppColors.surfaceAlt,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(Icons.search, size: 24, color: AppColors.ink),
                    onPressed: () => Navigator.of(context).pushNamed('/search'),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStoreInfo() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Row(
        children: <Widget>[
          const Icon(Icons.star, size: 12, color: AppColors.ink),
          const SizedBox(width: 4),
          const Text(
            '4.8',
            style: TextStyle(
              fontSize: 13,
              height: 16 / 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              '(320) · About 60 min · \$5.99 delivery',
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 16 / 13,
                fontWeight: FontWeight.w400,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryChips() {
    return SizedBox(
      height: 36,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 16),
        itemCount: _categories.length,
        separatorBuilder: (_, _) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          final chip = _categories[index];
          final isSelected = index == _selectedCategory;
          return GestureDetector(
            onTap: () => setState(() => _selectedCategory = index),
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 150),
              padding: const EdgeInsets.symmetric(horizontal: 16),
              height: 36,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.ink : AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(18),
              ),
              child: Text(
                chip.label,
                style: TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  fontWeight: isSelected ? FontWeight.w600 : FontWeight.w500,
                  color: isSelected ? AppColors.surface : AppColors.ink,
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildSectionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Text(
            'Goat & Lamb',
            style: const TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const Text(
            '6 items',
            style: TextStyle(
              fontSize: 13,
              height: 16 / 13,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLowStockPill() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Align(
        alignment: Alignment.centerRight,
        child: TagPill(
          label: 'Only 3 left',
          background: AppColors.surfaceAlt,
          foreground: AppColors.ink,
          fontSize: 11,
        ),
      ),
    );
  }

  Widget _buildProductGrid() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        children: <Widget>[
          for (int row = 0; row < 3; row++) ...<Widget>[
            if (row > 0) const SizedBox(height: 12),
            Row(
              children: <Widget>[
                Expanded(
                  child: _ProductCard(product: _products[row * 2]),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: _ProductCard(product: _products[row * 2 + 1]),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }
}

class _CategoryChip {
  const _CategoryChip(this.label, this.initiallySelected);
  final String label;
  final bool initiallySelected;
}

class _Product {
  const _Product({
    required this.name,
    required this.variants,
    required this.price,
    required this.tag,
    required this.tagColor,
    this.imageGradient,
    this.isSoldOut = false,
  });

  final String name;
  final String variants;
  final String price;
  final String tag;
  final Color tagColor;
  final Gradient? imageGradient;
  final bool isSoldOut;
}

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.product});

  final _Product product;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final bool soldOut = product.isSoldOut;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Image 171×150 with tag and plus button
        Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            Container(
              width: 171,
              height: 150,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.xl),
                gradient: product.imageGradient,
              ),
            ),
            if (soldOut)
              Container(
                width: 171,
                height: 150,
                decoration: BoxDecoration(
                  color: AppColors.ink.withValues(alpha: 0.5),
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
            // Tag pill
            Positioned(
              left: 8,
              top: 8,
              child: TagPill(
                label: product.tag,
                background: product.tagColor,
                foreground: AppColors.surface,
                fontSize: 11,
              ),
            ),
            // Plus button
            Positioned(
              right: 8,
              bottom: 8,
              child: Container(
                width: 36,
                height: 36,
                decoration: BoxDecoration(
                  color: const Color(0xADFFFFFF),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: IconButton(
                  padding: EdgeInsets.zero,
                  icon: const Icon(Icons.add, size: 20, color: AppColors.ink),
                  onPressed: soldOut ? null : () {},
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Text(
          product.name,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: theme.textTheme.bodyMedium?.copyWith(
            fontWeight: FontWeight.w600,
            height: 17 / 14,
            color: soldOut ? AppColors.inkMuted : AppColors.ink,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          product.variants,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 13,
            height: 16 / 13,
            fontWeight: FontWeight.w400,
            color: AppColors.inkMuted,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          product.price,
          style: TextStyle(
            fontSize: 14,
            height: 17 / 14,
            fontWeight: FontWeight.w600,
            color: soldOut ? AppColors.inkMuted : AppColors.ink,
          ),
        ),
        if (soldOut) ...<Widget>[
          const SizedBox(height: 4),
          Center(
            child: TagPill(
              label: 'Sold out',
              background: const Color(0xFFE11900),
              foreground: AppColors.surface,
              fontSize: 11,
            ),
          ),
        ],
      ],
    );
  }
}