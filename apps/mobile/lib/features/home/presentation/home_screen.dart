import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `B1 · Home` — exact 390×844 frame port.
///
/// Chrome has no status-bar inset, so we reserve the Figma 47px explicitly.
/// The floating tab bar is owned by `HomeShell`; this screen pads its
/// scrollable content by `AppInsets.tabBar` so nothing lands behind it.
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

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
            _buildHeader(context),
            const SizedBox(height: 36),
            _buildSearch(context),
            const SizedBox(height: 46),
            _buildEntryTiles(),
            const SizedBox(height: 54),
            _buildCategorySection(context),
            const SizedBox(height: 42),
            _buildStoresSection(context),
            const SizedBox(height: 56),
            _buildCartBar(context),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        // Address row — pill at left, two icon buttons at right.
        Row(
          children: <Widget>[
            // Address pill 244×40 #f3f3f3 r20
            Container(
              width: 244,
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(AppRadius.lg),
              ),
              child: Row(
                children: <Widget>[
                  SvgPicture.asset(
                    'assets/icons/ic_pin.svg',
                    width: 20,
                    height: 20,
                    colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '12 Queen St, Melbourne',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 17 / 14,
                      ),
                    ),
                  ),
                  SvgPicture.asset(
                    'assets/icons/ic_chevron.svg',
                    width: 18,
                    height: 18,
                    colorFilter: const ColorFilter.mode(AppColors.ink, BlendMode.srcIn),
                  ),
                ],
              ),
            ),
            const Spacer(),
            // Notifications button 40×40 #f3f3f3 circle + unread dot
            Stack(
              clipBehavior: Clip.none,
              children: <Widget>[
                _IconButton(
                  asset: 'assets/icons/ic_bell.svg',
                  onTap: () => Navigator.of(context).pushNamed('/notifications'),
                  tooltip: 'Notifications',
                ),
                Positioned(
                  right: -2,
                  top: -2,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: const BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(width: 8),
            // Cart button 40×40 black circle
            _IconButton(
              asset: 'assets/icons/ic_bag.svg',
              onTap: () => Navigator.of(context).pushNamed('/cart'),
              filled: true,
              tooltip: 'Cart',
            ),
          ],
        ),
        const SizedBox(height: 10),
        // Title "Groceries & Catering" 28/700
        Text(
          'Groceries & Catering',
          style: theme.textTheme.headlineSmall,
        ),
        const SizedBox(height: 2),
        // Subtitle 14/400 #6b6b6b
        Text(
          'Fresh South Asian essentials and event feasts',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.inkMuted,
            fontWeight: FontWeight.w400,
            height: 17 / 14,
          ),
        ),
      ],
    );
  }

  Widget _buildSearch(BuildContext context) {
    return SearchField(
      hintText: 'Search groceries, stores, caterers…',
      onTap: () => Navigator.of(context).pushNamed('/search'),
      prefixIcon: SvgPicture.asset(
        'assets/icons/ic_search.svg',
        width: 24,
        height: 24,
        colorFilter: const ColorFilter.mode(AppColors.inkMuted, BlendMode.srcIn),
      ),
    );
  }

  Widget _buildEntryTiles() {
    return Row(
      children: <Widget>[
        // Groceries tile 175×124 gradient
        Expanded(
          child: _EntryTile(
            gradient: const LinearGradient(
              begin: Alignment(-0.14, -0.14),
              end: Alignment(0.57, 0.86),
              colors: <Color>[Color(0xFF05944F), Color(0xFF0B3D2B)],
            ),
            iconAsset: 'assets/icons/entry_groceries.svg',
            iconColor: AppColors.surface,
            labelColor: AppColors.surface,
            title: 'Groceries',
            subtitle: 'Delivered in ~60 min',
          ),
        ),
        const SizedBox(width: 8),
        // Catering tile 175×124 #f3f3f3
        Expanded(
          child: _EntryTile(
            color: AppColors.surfaceAlt,
            iconAsset: 'assets/icons/entry_catering.svg',
            iconColor: AppColors.ink,
            labelColor: AppColors.ink,
            title: 'Catering',
            subtitle: 'Events, parties & feasts',
            subtitleColor: AppColors.inkMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildCategorySection(BuildContext context) {
    const List<_Category> categories = <_Category>[
      _Category('Meat'),
      _Category('Rice & Grains'),
      _Category('Spices'),
      _Category('Dairy'),
      _Category('Produce'),
    ];

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: 'Shop groceries',
          actionTitle: 'See all',
          onAction: () => Navigator.of(context).pushNamed('/browse'),
        ),
        const SizedBox(height: 16),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            for (final c in categories) _CategoryTile(category: c),
          ],
        ),
      ],
    );
  }

  Widget _buildStoresSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: 'Stores near you',
          actionTitle: 'See all',
          onAction: () => Navigator.of(context).pushNamed('/browse'),
        ),
        const SizedBox(height: 12),
        _StoreCard(
          name: 'Madina Halal Meats',
          description: 'Halal meats, rice, spices, dairy & more',
          rating: 4.8,
          reviewCount: 320,
          deliveryTime: 'About 60 min',
          tags: const <String>['Halal', '\$5.99 delivery'],
          onTap: () => Navigator.of(context).pushNamed('/store'),
        ),
      ],
    );
  }

  Widget _buildCartBar(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 358,
      height: 56,
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(AppRadius.button),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 14),
      child: Row(
        children: <Widget>[
          Container(
            width: 28,
            height: 28,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surface,
              shape: BoxShape.circle,
            ),
            child: Text(
              '3',
              style: TextStyle(
                fontSize: 13,
                height: 1,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'View cart',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.surface,
            ),
          ),
          const Spacer(),
          Text(
            '\$55.87',
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.surface,
            ),
          ),
        ],
      ),
    );
  }
}

class _IconButton extends StatelessWidget {
  const _IconButton({
    super.key,
    required this.asset,
    required this.onTap,
    this.filled = false,
    this.tooltip,
  });

  final String asset;
  final VoidCallback? onTap;
  final bool filled;
  final String? tooltip;

  @override
  Widget build(BuildContext context) {
    final Color bg = filled ? AppColors.ink : AppColors.surfaceAlt;
    final Color fg = filled ? AppColors.surface : AppColors.ink;

    final Widget content = Material(
      color: bg,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: 40,
          height: 40,
          child: Center(
            child: SvgPicture.asset(
              asset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      return Tooltip(message: tooltip!, child: content);
    }
    return content;
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({
    super.key,
    this.color,
    this.gradient,
    required this.iconAsset,
    required this.iconColor,
    required this.labelColor,
    required this.title,
    required this.subtitle,
    this.subtitleColor,
  });

  final Color? color;
  final Gradient? gradient;
  final String iconAsset;
  final Color iconColor;
  final Color labelColor;
  final String title;
  final String subtitle;
  final Color? subtitleColor;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Container(
      width: 175,
      height: 124,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        gradient: gradient,
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            width: 40,
            height: 40,
            decoration: BoxDecoration(
              color: color != null ? AppColors.ink : AppColors.surface.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Center(
              child: SvgPicture.asset(
                iconAsset,
                width: 22,
                height: 22,
                colorFilter: ColorFilter.mode(iconColor, BlendMode.srcIn),
              ),
            ),
          ),
          const Spacer(),
          Text(
            title,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: theme.textTheme.titleLarge?.copyWith(
              color: labelColor,
              fontWeight: FontWeight.w700,
              height: 24 / 20,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            subtitle,
            maxLines: 1,
            overflow: TextOverflow.clip,
            style: theme.textTheme.labelMedium?.copyWith(
              color: subtitleColor ?? labelColor.withValues(alpha: 0.9),
              fontWeight: FontWeight.w500,
              height: 15 / 12,
            ),
          ),
        ],
      ),
    );
  }
}

class _Category {
  const _Category(this.label);
  final String label;
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({super.key, required this.category});

  final _Category category;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.xl),
          ),
          child: Center(
            child: Text(
              category.label,
              textAlign: TextAlign.center,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 11,
                height: 14 / 11,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          category.label,
          maxLines: 1,
          overflow: TextOverflow.clip,
          style: const TextStyle(
            fontSize: 12,
            height: 15 / 12,
            fontWeight: FontWeight.w500,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}

class _StoreCard extends StatelessWidget {
  const _StoreCard({
    super.key,
    required this.name,
    required this.description,
    required this.rating,
    required this.reviewCount,
    required this.deliveryTime,
    required this.tags,
    this.onTap,
  });

  final String name;
  final String description;
  final double rating;
  final int reviewCount;
  final String deliveryTime;
  final List<String> tags;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(AppRadius.xl),
      child: InkWell(
        borderRadius: BorderRadius.circular(AppRadius.xl),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                width: 112,
                height: 112,
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(AppRadius.xl),
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        height: 19 / 16,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Text(
                      description,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 16 / 13,
                        fontWeight: FontWeight.w400,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        const Icon(Icons.star, size: 13, color: AppColors.ink),
                        const SizedBox(width: 4),
                        Text(
                          rating.toStringAsFixed(1),
                          style: TextStyle(
                            fontSize: 13,
                            height: 16 / 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '($reviewCount) · $deliveryTime',
                          style: TextStyle(
                            fontSize: 13,
                            height: 16 / 13,
                            fontWeight: FontWeight.w400,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 5),
                    Row(
                      children: <Widget>[
                        for (int i = 0; i < tags.length; i++) ...<Widget>[
                          if (i > 0) const SizedBox(width: 6),
                          TagPill(
                            label: tags[i],
                            background: i == 0 ? const Color(0xFF05944F) : AppColors.surfaceAlt,
                            foreground: i == 0 ? AppColors.surface : AppColors.ink,
                            fontSize: 11,
                          ),
                        ],
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}