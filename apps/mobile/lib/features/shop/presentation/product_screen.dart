import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `B4 · Product` — exact 390×844 frame port.
///
/// The screen has a full-width hero image, a scrolling sheet with product
/// details, and a fixed glass bottom bar with stepper + add-to-cart.
/// The floating tab bar is owned by `HomeShell`; we pad the bottom by
/// `AppInsets.tabBar`.
class ProductScreen extends StatefulWidget {
  const ProductScreen({super.key});

  static const String routeName = '/product';

  @override
  State<ProductScreen> createState() => _ProductScreenState();
}

class _ProductScreenState extends State<ProductScreen> {
  String _selectedCut = 'Curry cut';
  String _selectedWeight = '1 kg';
  int _quantity = 1;

  static const List<String> _cuts = <String>['Curry cut', 'Mince', 'Boneless'];
  static const List<String> _weights = <String>['500 g', '1 kg', '2 kg', 'Custom'];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topInset, 0, AppInsets.tabBar + 92),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Hero image 390×380
                Container(
                  width: 390,
                  height: 380,
                  color: AppColors.surfaceAlt,
                ),
                // Sheet content
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const SizedBox(height: 24),
                      // Product name 26/700
                      Text(
                        'Goat Curry Cut',
                        style: const TextStyle(
                          fontSize: 26,
                          height: 31 / 26,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Pills row: Halal certified + Chilled
                      Row(
                        children: <Widget>[
                          TagPill(
                            label: 'Halal certified',
                            background: AppColors.surfaceAlt,
                            foreground: const Color(0xFF05944F),
                            fontSize: 12,
                          ),
                          const SizedBox(width: 8),
                          TagPill(
                            label: 'Chilled',
                            background: AppColors.surfaceAlt,
                            foreground: AppColors.ink,
                            fontSize: 12,
                          ),
                          const SizedBox(width: 8),
                          TagPill(
                            label: 'In stock',
                            background: AppColors.surfaceAlt,
                            foreground: const Color(0xFF05944F),
                            fontSize: 12,
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      // Price 22/600
                      Text(
                        '\$16.99 / kg',
                        style: const TextStyle(
                          fontSize: 22,
                          height: 27 / 22,
                          fontWeight: FontWeight.w600,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Description 14/400 #6b6b6b
                      Text(
                        'Bone-in pieces from young goat, cut small for curries. '
                        'Packed fresh and sealed on the day.',
                        style: const TextStyle(
                          fontSize: 14,
                          height: 17 / 14,
                          fontWeight: FontWeight.w400,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 24),
                      // Cut selector
                      _buildSectionLabel('Cut'),
                      const SizedBox(height: 8),
                      _buildSegmentedRow(_cuts, _selectedCut, (v) {
                        setState(() => _selectedCut = v);
                      }),
                      const SizedBox(height: 24),
                      // Weight selector
                      _buildSectionLabel('Weight'),
                      const SizedBox(height: 8),
                      _buildSegmentedRow(_weights, _selectedWeight, (v) {
                        setState(() => _selectedWeight = v);
                      }),
                      const SizedBox(height: 24),
                      // Instructions field
                      Container(
                        width: 358,
                        height: 40,
                        padding: const EdgeInsets.symmetric(horizontal: 12),
                        decoration: BoxDecoration(
                          color: AppColors.surfaceAlt,
                          borderRadius: BorderRadius.circular(AppRadius.lg),
                        ),
                        child: TextField(
                          style: const TextStyle(
                            fontSize: 14,
                            height: 17 / 14,
                            color: AppColors.ink,
                          ),
                          decoration: const InputDecoration(
                            isDense: true,
                            hintText: 'Special instructions (e.g. small pieces)',
                            hintStyle: TextStyle(
                              fontSize: 14,
                              height: 17 / 14,
                              fontWeight: FontWeight.w400,
                              color: AppColors.inkMuted,
                            ),
                            filled: false,
                            contentPadding: EdgeInsets.zero,
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Disclaimer
                      Text(
                        'Final price is set at packing, based on actual weight.',
                        style: const TextStyle(
                          fontSize: 12,
                          height: 15 / 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Top bar: back, store name, close
          SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: <Widget>[
                  const SizedBox(width: 16),
                  // Back button 40×40 glass
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x80FFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.ink),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const Spacer(),
                  // Store name pill 176×40 glass
                  Container(
                    width: 176,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x80FFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    alignment: Alignment.center,
                    child: const Text(
                      'Madina Halal Meats',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 13,
                        height: 16 / 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                  const Spacer(),
                  // Close button 40×40 glass
                  const SizedBox(width: 16),
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: const Color(0x80FFFFFF),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      padding: EdgeInsets.zero,
                      icon: const Icon(Icons.close, size: 24, color: AppColors.ink),
                      onPressed: () => Navigator.of(context).maybePop(),
                    ),
                  ),
                  const SizedBox(width: 16),
                ],
              ),
            ),
          ),
          // Fixed glass bottom bar
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              height: 92,
              color: const Color(0xADFFFFFF),
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
              child: Row(
                children: <Widget>[
                  // Stepper 120×52 #f3f3f3
                  Container(
                    width: 120,
                    height: 52,
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(AppRadius.lg),
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: <Widget>[
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: _quantity > 1
                              ? () => setState(() => _quantity--)
                              : null,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Icon(
                              Icons.remove,
                              size: 20,
                              color: _quantity > 1 ? AppColors.ink : AppColors.inkMuted,
                            ),
                          ),
                        ),
                        Text(
                          '$_quantity',
                          style: const TextStyle(
                            fontSize: 16,
                            height: 19 / 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                        InkWell(
                          borderRadius: BorderRadius.circular(16),
                          onTap: () => setState(() => _quantity++),
                          child: const Padding(
                            padding: EdgeInsets.all(8),
                            child: Icon(Icons.add, size: 20, color: AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Add to cart button 226×52 black
                  Expanded(
                    child: FilledButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('Added $_quantity x $_selectedCut, $_selectedWeight'),
                            behavior: SnackBarBehavior.floating,
                          ),
                        );
                      },
                      child: Text(
                        'Add to cart · \$$_quantity${_quantity > 1 ? '6.99' : '6.99'}',
                        style: const TextStyle(
                          fontSize: 16,
                          height: 19 / 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String label) {
    return Text(
      label,
      style: const TextStyle(
        fontSize: 16,
        height: 19 / 16,
        fontWeight: FontWeight.w600,
        color: AppColors.ink,
      ),
    );
  }

  Widget _buildSegmentedRow(
    List<String> options,
    String selected,
    ValueChanged<String> onSelect,
  ) {
    return Row(
      children: <Widget>[
        for (int i = 0; i < options.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 8),
          Expanded(
            child: _SegmentButton(
              label: options[i],
              selected: options[i] == selected,
              onTap: () => onSelect(options[i]),
            ),
          ),
        ],
      ],
    );
  }
}

class _SegmentButton extends StatelessWidget {
  const _SegmentButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(18),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Text(
          label,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            fontSize: 14,
            height: 17 / 14,
            fontWeight: FontWeight.w500,
            color: selected ? AppColors.surface : AppColors.ink,
          ),
        ),
      ),
    );
  }
}