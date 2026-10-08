import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../../core/widgets/search_field.dart';
import 'search_results_screen.dart';

/// Figma `D1 · Search Query & Trending` (390×844)
///
/// Entry search view featuring:
/// - Instant autofocus SearchField with clear action
/// - Recent search history with clear all
/// - Melbourne trending halal searches
/// - Quick category pills
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  final TextEditingController _searchController = TextEditingController();
  final List<String> _recentSearches = <String>[
    'Baby goat curry cut',
    'Shan special biryani',
    'Aashirvaad atta 10kg',
  ];

  static const List<String> _trendingSearches = <String>[
    'Fresh Halal Baby Goat',
    'Daawat Basmati 5kg',
    'National Mango Pickle',
    'Rooh Afza Syrup',
    'Chicken Tikka Breast',
    'Paneer 1kg Block',
    'Paratha Family Pack',
    'King Prawns Fresh',
  ];

  static const List<_CategoryChip> _popularCategories = <_CategoryChip>[
    _CategoryChip('Halal Meat', Icons.set_meal_rounded),
    _CategoryChip('Rice & Grains', Icons.grain_rounded),
    _CategoryChip('Spices & Masalas', Icons.local_fire_department_rounded),
    _CategoryChip('Dairy & Ghee', Icons.cake_rounded),
    _CategoryChip('Sweets & Desserts', Icons.celebration_rounded),
  ];

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _submitSearch(String query) {
    final String clean = query.trim();
    if (clean.isEmpty) return;
    if (!_recentSearches.contains(clean)) {
      setState(() {
        _recentSearches.insert(0, clean);
      });
    }
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => SearchResultsScreen(initialQuery: clean),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            // Search Input Header
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
                      controller: _searchController,
                      autofocus: true,
                      hintText: 'Search halal meat, spices, groceries…',
                      onChanged: (String val) {
                        setState(() {});
                      },
                    ),
                  ),
                  if (_searchController.text.isNotEmpty) ...<Widget>[
                    const SizedBox(width: 8),
                    IconButton(
                      icon: const Icon(Icons.clear_rounded, size: 20, color: AppColors.inkMuted),
                      onPressed: () {
                        setState(() {
                          _searchController.clear();
                        });
                      },
                    ),
                  ],
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 40),
                children: <Widget>[
                  // Recent Searches
                  if (_recentSearches.isNotEmpty) ...<Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: <Widget>[
                        const Text(
                          'Recent Searches',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.3,
                            color: AppColors.ink,
                          ),
                        ),
                        GestureDetector(
                          onTap: () => setState(() => _recentSearches.clear()),
                          child: const Text(
                            'Clear all',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 10),
                    Wrap(
                      spacing: 8,
                      runSpacing: 8,
                      children: _recentSearches.map((String query) {
                        return InputChip(
                          label: Text(query),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w500,
                            color: AppColors.ink,
                          ),
                          backgroundColor: AppColors.surfaceAlt,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          onPressed: () => _submitSearch(query),
                          onDeleted: () {
                            setState(() {
                              _recentSearches.remove(query);
                            });
                          },
                          deleteIconColor: AppColors.inkMuted,
                        );
                      }).toList(),
                    ),
                    const SizedBox(height: 24),
                  ],

                  // Popular Categories
                  const Text(
                    'Explore by Category',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  SizedBox(
                    height: 44,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemCount: _popularCategories.length,
                      separatorBuilder: (BuildContext context, int index) => const SizedBox(width: 8),
                      itemBuilder: (BuildContext context, int index) {
                        final _CategoryChip cat = _popularCategories[index];
                        return ActionChip(
                          avatar: Icon(cat.icon, size: 16, color: AppColors.ink),
                          label: Text(cat.label),
                          labelStyle: const TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          backgroundColor: AppColors.surfaceAlt,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                            side: BorderSide.none,
                          ),
                          onPressed: () => _submitSearch(cat.label),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 28),

                  // Trending in Melbourne
                  const Text(
                    'Trending in Melbourne',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ..._trendingSearches.map((String query) {
                    return ListTile(
                      contentPadding: EdgeInsets.zero,
                      leading: Container(
                        width: 36,
                        height: 36,
                        decoration: const BoxDecoration(
                          color: AppColors.surfaceAlt,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.trending_up_rounded,
                          size: 18,
                          color: AppColors.accentDark,
                        ),
                      ),
                      title: Text(
                        query,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.north_west_rounded,
                        size: 16,
                        color: AppColors.inkMuted,
                      ),
                      onTap: () => _submitSearch(query),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CategoryChip {
  const _CategoryChip(this.label, this.icon);
  final String label;
  final IconData icon;
}
