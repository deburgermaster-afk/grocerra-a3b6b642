import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The 358x48 pill search field from Figma (B1 y174, A7 y156, D1).
///
/// `#f3f3f3`, radius 24, 24px glyph 16px in from the left, 15/400 `#6b6b6b`
/// placeholder starting at 48px. Renders as a tappable target by default so a
/// screen can navigate to the search flow; pass [controller] to make it a live
/// input instead.
class SearchField extends StatelessWidget {
  const SearchField({
    super.key,
    this.hintText,
    this.onTap,
    this.controller,
    this.autofocus = false,
    this.iconSize = 24,
    this.gap = 8,
    this.focusNode,
    this.onChanged,
    this.prefixIcon,
  });

  final String? hintText;
  final VoidCallback? onTap;
  final TextEditingController? controller;
  final bool autofocus;
  final double iconSize;

  /// Space between the glyph and the placeholder text (Figma B1 uses 8,
  /// B2 Browse uses 10).
  final double gap;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final Widget? prefixIcon;

  @override
  Widget build(BuildContext context) {
    final bool live = controller != null || onTap == null;

    final Widget row = Row(
      children: <Widget>[
        const SizedBox(width: 16),
        prefixIcon ??
            Icon(Icons.search, size: iconSize, color: AppColors.inkMuted),
        SizedBox(width: gap),
        Expanded(
          child: live
              ? TextField(
                  controller: controller,
                  focusNode: focusNode,
                  autofocus: autofocus,
                  onChanged: onChanged,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 18 / 15,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    isDense: true,
                    hintText: hintText,
                    hintStyle: const TextStyle(
                      fontSize: 15,
                      height: 18 / 15,
                      fontWeight: FontWeight.w400,
                      color: AppColors.inkMuted,
                    ),
                    filled: false,
                    contentPadding: EdgeInsets.zero,
                    border: InputBorder.none,
                  ),
                )
              : Text(
                  hintText ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.clip,
                  style: const TextStyle(
                    fontSize: 15,
                    height: 18 / 15,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkMuted,
                  ),
                ),
        ),
        const SizedBox(width: 16),
      ],
    );

    return Material(
      color: AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(24),
      child: InkWell(
        borderRadius: BorderRadius.circular(24),
        onTap: onTap,
        child: SizedBox(height: 48, child: row),
      ),
    );
  }
}
