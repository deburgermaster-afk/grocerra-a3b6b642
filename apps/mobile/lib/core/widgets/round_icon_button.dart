import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// The 40x40 circular icon button used across the approved frames
/// (B1 notifications / cart, F list actions). Circles, so radius is half the
/// size; `filled` renders the black variant with a white glyph.
class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.filled = false,
    this.size = 40,
    this.iconSize = 24,
    this.tooltip,
    this.child,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool filled;
  final double size;
  final double iconSize;
  final String? tooltip;

  /// Replaces the glyph, for badges such as the unread dot.
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    final Widget content = child ?? Icon(icon, size: iconSize);

    Widget button = Material(
      color: filled ? AppColors.ink : AppColors.surfaceAlt,
      shape: const CircleBorder(),
      child: InkWell(
        customBorder: const CircleBorder(),
        onTap: onTap,
        child: SizedBox(
          width: size,
          height: size,
          child: Center(
            child: DefaultTextStyle(
              style: TextStyle(
                color: filled ? AppColors.surface : AppColors.ink,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
              child: IconTheme(
                data: IconThemeData(
                  size: iconSize,
                  color: filled ? AppColors.surface : AppColors.ink,
                ),
                child: content,
              ),
            ),
          ),
        ),
      ),
    );

    if (tooltip != null) {
      button = Tooltip(message: tooltip!, child: button);
    }
    return button;
  }
}
