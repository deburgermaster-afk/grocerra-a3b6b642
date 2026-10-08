import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Figma `D-S1 · Filter & Sort Sheet`
///
/// Filter bottom sheet for search results:
/// - Sort by (Recommended, Nearest, Price low-high, Highest rated)
/// - Dietary certification (100% Halal certified, Vegetarian, Nut-free)
/// - Price rating ($, $$, $$$)
/// - Delivery ETA (<30 min, <45 min, Any)
class FilterModalSheet extends StatefulWidget {
  const FilterModalSheet({
    super.key,
    this.selectedSort = 'Recommended',
    this.isHalalOnly = true,
    this.isVegOnly = false,
    this.selectedPrice = 'Any',
    this.onApply,
  });

  final String selectedSort;
  final bool isHalalOnly;
  final bool isVegOnly;
  final String selectedPrice;
  final void Function(String sort, bool halal, bool veg, String price)? onApply;

  static Future<void> show(
    BuildContext context, {
    String selectedSort = 'Recommended',
    bool isHalalOnly = true,
    bool isVegOnly = false,
    String selectedPrice = 'Any',
    void Function(String sort, bool halal, bool veg, String price)? onApply,
  }) {
    return showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => FilterModalSheet(
        selectedSort: selectedSort,
        isHalalOnly: isHalalOnly,
        isVegOnly: isVegOnly,
        selectedPrice: selectedPrice,
        onApply: onApply,
      ),
    );
  }

  @override
  State<FilterModalSheet> createState() => _FilterModalSheetState();
}

class _FilterModalSheetState extends State<FilterModalSheet> {
  late String _sort;
  late bool _halal;
  late bool _veg;
  late String _price;

  static const List<String> _sortOptions = <String>[
    'Recommended',
    'Nearest first',
    'Price: Low to High',
    'Customer rating',
  ];

  static const List<String> _priceOptions = <String>[
    'Any',
    '\$',
    '\$\$',
    '\$\$\$',
  ];

  @override
  void initState() {
    super.initState();
    _sort = widget.selectedSort;
    _halal = widget.isHalalOnly;
    _veg = widget.isVegOnly;
    _price = widget.selectedPrice;
  }

  void _reset() {
    setState(() {
      _sort = 'Recommended';
      _halal = true;
      _veg = false;
      _price = 'Any';
    });
  }

  void _apply() {
    widget.onApply?.call(_sort, _halal, _veg, _price);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        left: 20,
        right: 20,
        top: 12,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      child: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            // Handle bar 44x5 #e6e6e6
            Center(
              child: Container(
                width: 44,
                height: 5,
                decoration: BoxDecoration(
                  color: AppColors.hairline,
                  borderRadius: BorderRadius.circular(2.5),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Header Row
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                const Text(
                  'Filters & Sort',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w700,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                TextButton(
                  onPressed: _reset,
                  child: const Text(
                    'Reset',
                    style: TextStyle(
                      color: AppColors.inkMuted,
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 18),

            // Sort By Section
            const Text(
              'Sort By',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Wrap(
              spacing: 8,
              runSpacing: 8,
              children: _sortOptions.map((String option) {
                final bool isSelected = _sort == option;
                return ChoiceChip(
                  label: Text(option),
                  selected: isSelected,
                  selectedColor: AppColors.ink,
                  backgroundColor: AppColors.surfaceAlt,
                  labelStyle: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: isSelected ? AppColors.surface : AppColors.ink,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                    side: BorderSide.none,
                  ),
                  showCheckmark: false,
                  onSelected: (bool selected) {
                    if (selected) setState(() => _sort = option);
                  },
                );
              }).toList(),
            ),

            const SizedBox(height: 20),

            // Dietary & Certification Section
            const Text(
              'Dietary & Halal Standards',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Material(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(16),
              clipBehavior: Clip.antiAlias,
              child: Column(
                children: <Widget>[
                  SwitchListTile(
                    value: _halal,
                    title: const Text(
                      '100% Halal Certified Only',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    subtitle: const Text(
                      'Butcher and kitchen certification verified',
                      style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                    ),
                    activeThumbColor: AppColors.accentDark,
                    onChanged: (bool val) => setState(() => _halal = val),
                  ),
                  const Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.hairline),
                  SwitchListTile(
                    value: _veg,
                    title: const Text(
                      'Pure Vegetarian / Jain Options',
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    activeThumbColor: AppColors.accentDark,
                    onChanged: (bool val) => setState(() => _veg = val),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Price Level
            const Text(
              'Price Range',
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              children: _priceOptions.map((String p) {
                final bool isSelected = _price == p;
                return Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: OutlinedButton(
                      onPressed: () => setState(() => _price = p),
                      style: OutlinedButton.styleFrom(
                        backgroundColor: isSelected ? AppColors.ink : AppColors.surfaceAlt,
                        foregroundColor: isSelected ? AppColors.surface : AppColors.ink,
                        side: BorderSide.none,
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                      child: Text(
                        p,
                        style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                      ),
                    ),
                  ),
                );
              }).toList(),
            ),

            const SizedBox(height: 28),

            // Apply Button 56px r28 black
            FilledButton(
              onPressed: _apply,
              child: const Text('Apply Filters'),
            ),
          ],
        ),
      ),
    ),
  );
  }
}
