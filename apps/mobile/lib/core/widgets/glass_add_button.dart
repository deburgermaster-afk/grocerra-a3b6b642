import 'package:flutter/material.dart';

import '../theme/app_theme.dart';
import 'app_icon.dart';

/// The 36×36 glass `+` circle used to add a product from an image
/// (B3 product card `1:132`).
///
/// Figma paints it as `#ffffffad` (`glassControl`) with a 1px inside
/// stroke in `#ffffff80` (`glassControlStroke`) and the `Elevation · 2`
/// drop shadow (0/8/32 at 12%). The `plus` glyph is a 20px Figma export;
/// the ripple is clipped to the circle by [customBorder].
class GlassAddButton extends StatelessWidget {
  const GlassAddButton({super.key, required this.onTap, this.size = 36});

  /// `null` renders the disabled (no-ripple) state.
  final VoidCallback? onTap;

  /// Figma nodes are 36×36; exposed for future variants.
  final double size;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.glassControl,
        shape: BoxShape.circle,
        border: Border.all(color: AppColors.glassControlStroke),
        boxShadow: AppShadows.e2,
      ),
      child: Material(
        type: MaterialType.transparency,
        child: InkWell(
          customBorder: const CircleBorder(),
          onTap: onTap,
          child: SizedBox(
            width: size,
            height: size,
            child: Center(child: AppIcon('plus', size: size * 20 / 36)),
          ),
        ),
      ),
    );
  }
}
