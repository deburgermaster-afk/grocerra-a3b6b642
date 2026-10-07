import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../core/theme/app_theme.dart';

/// Floating five-tab bar from Figma `Tab bar - glass` (B1, 358x64 at y769).
///
/// * fill `#ffffffb2`, floating 11px from the bottom and 11px from each edge
/// * five 64.8x46 tabs with a 4px gap and 9px inner padding
/// * selected tab sits on a `#00000014` full pill, 12/600 black
/// * unselected tabs are 12/500 `#6b6b6b`
class GlassTabBar extends StatelessWidget {
  const GlassTabBar({super.key, required this.index, required this.onSelect});

  final int index;
  final ValueChanged<int> onSelect;

  static const List<_TabSpec> _tabs = <_TabSpec>[
    _TabSpec('Home', 'assets/icons/ic_home.svg'),
    _TabSpec('Browse', 'assets/icons/ic_catalogue.svg'),
    _TabSpec('Catering', 'assets/icons/ic_chef.svg'),
    _TabSpec('Orders', 'assets/icons/ic_receipt.svg'),
    _TabSpec('Profile', 'assets/icons/ic_user.svg'),
  ];

  @override
  Widget build(BuildContext context) {
    return Positioned(
      left: 11,
      right: 11,
      bottom: 11,
      child: Material(
        color: const Color(0xB2FFFFFF),
        borderRadius: BorderRadius.circular(32),
        child: SizedBox(
          height: 64,
          child: Padding(
            padding: const EdgeInsets.all(9),
            child: Row(
              children: <Widget>[
                for (int i = 0; i < _tabs.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 4),
                  Expanded(
                    child: _GlassTab(
                      spec: _tabs[i],
                      selected: i == index,
                      onTap: () => onSelect(i),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _TabSpec {
  const _TabSpec(this.label, this.iconAsset);

  final String label;
  final String iconAsset;
}

class _GlassTab extends StatelessWidget {
  const _GlassTab({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final _TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final Color fg = selected ? AppColors.ink : AppColors.inkMuted;
    return InkWell(
      key: ValueKey<String>('tab-${spec.label}'),
      borderRadius: BorderRadius.circular(23),
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          color: selected ? const Color(0x14000000) : null,
          borderRadius: BorderRadius.circular(23),
        ),
        padding: const EdgeInsets.only(top: 2.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SvgPicture.asset(
              spec.iconAsset,
              width: 24,
              height: 24,
              colorFilter: ColorFilter.mode(fg, BlendMode.srcIn),
            ),
            const SizedBox(height: 2),
            Text(
              spec.label,
              maxLines: 1,
              overflow: TextOverflow.clip,
              style: TextStyle(
                fontSize: 12,
                height: 1.25, // 15px
                fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                color: fg,
              ),
            ),
          ],
        ),
      ),
    );
  }
}