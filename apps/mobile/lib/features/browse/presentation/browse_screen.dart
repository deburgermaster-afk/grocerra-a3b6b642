import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/store_card.dart';

/// Figma `C07.01 · Browse` (`1:552`) - 390×1140 scroll frame port.
///
/// Content scrolls. In the reference this is a shell tab under the floating
/// tab bar; this app's shell has three tabs (Home/Catering/Profile), so
/// Browse is a pushed route and pads its bottom normally. The status bar is
/// reserved via `AppInsets.statusBar(context)`.
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        // Header band y47..103 with "Browse" at y59 (47+12).
        padding: EdgeInsets.fromLTRB(16, topInset + 12, 16, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header: "Browse" 30/700
            Text('Browse', style: Theme.of(context).textTheme.headlineMedium),
            // Title ends y95, search starts y120.
            const SizedBox(height: 25),
            // Search field 358×48 — glyph 22/10 (B2).
            SearchField(
              hintText: 'Search groceries, stores, caterers…',
              iconSize: 22,
              gap: 10,
              onTap: () => Navigator.of(context).pushNamed('/search'),
            ),
            // Search ends y168, "Shop groceries" y184.
            const SizedBox(height: 16),
            // Section header
            SectionHeader(
              title: 'Shop groceries',
              actionTitle: 'See all',
              // TODO(handoff): this `See all` sits inside C07.01 itself and
              // has no mapped destination in H04/H05 - it renders but stays
              // inert (pushing `/browse` here would nest a second shell).
              onAction: null,
            ),
            const SizedBox(height: 16),
            // Category grid — 4 rows × 2 cols, each 173×84, gap 12
            _buildCategoryGrid(),
            // Grid ends y596 (frame), catering entry +16 below it.
            const SizedBox(height: 16),
            // Catering entry banner 358×84 black
            _buildCateringEntry(context),
            // Content itemSpacing 16 -> "Popular stores" title (y592 of the
            // content box), then the two 358×112 store cards with 16px gaps.
            const SizedBox(height: 16),
            const SectionHeader(title: 'Popular stores'),
            const SizedBox(height: 16),
            StoreCard(
              imageAsset: 'store_madina.png',
              name: 'Madina Halal Meats',
              description: 'Halal meats, rice, spices, dairy & more',
              rating: 4.8,
              reviewCount: 320,
              deliveryTime: 'About 60 min',
              tags: const <String>['Halal', '\$5.99 delivery'],
              // Same mapping as the C04.01 cards: store card -> C06.01.
              onTap: () => Navigator.of(context).pushNamed('/store'),
            ),
            const SizedBox(height: 16),
            StoreCard(
              imageAsset: 'store_alnoor.png',
              name: 'Al-Noor Spice & Grocer',
              description: 'Spices, lentils, rice, flour & pantry staples',
              rating: 4.6,
              reviewCount: 184,
              deliveryTime: 'Closes in 30 min',
              tags: const <String>['Halal', '\$3.99 delivery'],
              onTap: () => Navigator.of(context).pushNamed('/store'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    const List<_Category> categories = <_Category>[
      _Category.photo('Meat', 'cat_meat.png'),
      _Category.photo('Rice & Grains', 'cat_rice.png'),
      _Category.photo('Spices', 'cat_spices_bubble.png'),
      _Category('Dairy', 'milk'),
      _Category('Fresh Produce', 'leaf'),
      _Category('Frozen Meals', 'snow'),
      _Category('Sweets', 'cake'),
      _Category('Lentils & Pulses', 'bean'),
    ];

    return Column(
      children: <Widget>[
        for (int row = 0; row < 4; row++) ...<Widget>[
          if (row > 0) const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(child: _CategoryCard(category: categories[row * 2])),
              const SizedBox(width: 12),
              Expanded(child: _CategoryCard(category: categories[row * 2 + 1])),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildCateringEntry(BuildContext context) {
    return Material(
      color: AppColors.ink,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        // Nav map: `Catering entry → C17.01 · Catering hub`.
        onTap: () => Navigator.of(context).pushNamed('/catering'),
        child: Container(
          height: 84,
          margin: const EdgeInsets.symmetric(horizontal: 16),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            child: Row(
              children: <Widget>[
                // Icon bubble 48×48 #ffffff29, r24, chef-hat 24 white
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    color: AppColors.glassBubbleMuted,
                    borderRadius: BorderRadius.all(Radius.circular(24)),
                  ),
                  // Center: without it the 48px Container tightens the
                  // constraints and the 24px glyph is forced to fill it.
                  child: const Center(
                    child: AppIcon('chef', size: 24, color: AppColors.surface),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        'Catering',
                        style: const TextStyle(
                          fontSize: 18,
                          height: 22 / 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.surface,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Plan an event and get quotes',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 16 / 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.surface,
                        ),
                      ),
                    ],
                  ),
                ),
                // Arrow 32×32 white, r16, icon/right 18 black
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Center(child: AppIcon('right', size: 18)),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Category {
  const _Category(this.label, this.iconName) : photoAsset = null;

  /// Photo-filled bubble (Meat / Rice & Grains / Spices in Figma).
  const _Category.photo(this.label, this.photoAsset) : iconName = null;

  final String label;

  /// Figma `icon/*` name for vector bubbles.
  final String? iconName;

  /// PNG asset for photo bubbles.
  final String? photoAsset;
}

class _CategoryCard extends StatelessWidget {
  const _CategoryCard({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: () => Navigator.of(context).pushNamed('/store'),
        child: SizedBox(
          width: 173,
          height: 84,
          child: Padding(
            // Figma: 16 left / 12 right / 14 vertical, 8px gap, label left,
            // 56×56 bubble right.
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 14,
            ).copyWith(right: 12),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: Text(
                    category.label,
                    maxLines: 2,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 18 / 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                _Bubble(category: category),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Bubble extends StatelessWidget {
  const _Bubble({required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    final String? photo = category.photoAsset;
    if (photo != null) {
      return ClipRRect(
        borderRadius: BorderRadius.circular(28),
        child: Image.asset(
          'assets/icons/$photo',
          width: 56,
          height: 56,
          fit: BoxFit.cover,
        ),
      );
    }
    // White circle, r28, 26px black-stroke glyph. Center loosens the
    // Container's tight 56px constraints, otherwise SvgPicture is forced
    // to fill the bubble and renders the glyph at 56 instead of 26.
    return Container(
      width: 56,
      height: 56,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        shape: BoxShape.circle,
      ),
      child: Center(child: AppIcon(category.iconName!, size: 26)),
    );
  }
}
