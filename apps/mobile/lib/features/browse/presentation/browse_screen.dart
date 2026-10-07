import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';

/// Figma `B2 · Browse` — exact 390×844 frame port.
///
/// Content scrolls; the floating tab bar is owned by `HomeShell` so we pad
/// the bottom by `AppInsets.tabBar`. The status bar is reserved via
/// `AppInsets.statusBar(context)`.
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, topInset, 16, AppInsets.tabBar),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header: "Browse" 30/700
            Text('Browse', style: Theme.of(context).textTheme.headlineMedium),
            const SizedBox(height: 17),
            // Search field 358×48
            SearchField(
              hintText: 'Search groceries, stores, caterers…',
              onTap: () => Navigator.of(context).pushNamed('/search'),
            ),
            const SizedBox(height: 24),
            // Section header
            SectionHeader(
              title: 'Shop groceries',
              actionTitle: 'See all',
              onAction: () => Navigator.of(context).pushNamed('/browse'),
            ),
            const SizedBox(height: 16),
            // Category grid — 4 rows × 2 cols, each 173×84, gap 12
            _buildCategoryGrid(),
            const SizedBox(height: 20),
            // Catering entry banner 358×84 black
            _buildCateringEntry(context),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryGrid() {
    const List<_Category> categories = <_Category>[
      _Category('Meat', Icons.local_dining),
      _Category('Rice & Grains', Icons.grain),
      _Category('Spices', Icons.eco),
      _Category('Dairy', Icons.local_grocery_store),
      _Category('Fresh Produce', Icons.apple),
      _Category('Frozen Meals', Icons.ac_unit),
      _Category('Sweets', Icons.cake),
      _Category('Lentils & Pulses', Icons.grass),
    ];

    return Column(
      children: <Widget>[
        for (int row = 0; row < 4; row++) ...<Widget>[
          if (row > 0) const SizedBox(height: 12),
          Row(
            children: <Widget>[
              Expanded(
                child: _CategoryCard(category: categories[row * 2]),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _CategoryCard(category: categories[row * 2 + 1]),
              ),
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
        onTap: () => Navigator.of(context).pushNamed('/catering/quote-event'),
        child: SizedBox(
          width: 358,
          height: 84,
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                // Icon bubble 48×48 #ffffff29
                Container(
                  width: 48,
                  height: 48,
                  decoration: BoxDecoration(
                    color: AppColors.surface.withValues(alpha: 0.16),
                    borderRadius: BorderRadius.circular(24),
                  ),
                  child: const Icon(
                    Icons.restaurant_menu,
                    size: 24,
                    color: AppColors.surface,
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
                // Arrow 32×32 white
                Container(
                  width: 32,
                  height: 32,
                  decoration: const BoxDecoration(
                    color: AppColors.surface,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    size: 18,
                    color: AppColors.ink,
                  ),
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
  const _Category(this.label, this.icon);
  final String label;
  final IconData icon;
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
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Icon(category.icon, size: 28, color: AppColors.ink),
              const SizedBox(height: 8),
              Text(
                category.label,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 12,
                  height: 15 / 12,
                  fontWeight: FontWeight.w500,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}