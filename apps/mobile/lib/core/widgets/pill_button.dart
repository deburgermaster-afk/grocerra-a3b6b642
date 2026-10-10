import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The Figma pill button whose fill / stroke / label colour combination is not
/// covered by `AppButton`'s `primary`, `outline` or `text` variants:
///
/// * `Copied` (C22.01 node `1:2387`) - white fill, no stroke,
/// * `Chat with us` (C25.01 `1:2516`) and `Sign out` (C26.01 `1:2553`) -
///   `#f3f3f3` fill, black label,
/// * `Delete account` (C26.02 `1:2596`) - `#e11900` fill with a 1px black
///   stroke and a white label.
///
/// Radius follows the Figma rule for these frames: half the height (40 -> 20,
/// 48 -> 24, 56 -> 28). Screens must use this widget rather than styling a
/// `FilledButton` / `OutlinedButton` inline.
class PillButton extends StatelessWidget {
  const PillButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.fill = AppColors.surface,
    this.stroke,
    this.labelColor = AppColors.ink,
    this.labelStyle,
    this.height = 48,
    this.expand = true,
  });

  /// Button caption.
  final String label;

  /// `null` renders the disabled (A·S1) treatment.
  final VoidCallback? onPressed;

  /// Figma paint for the pill fill.
  final Color fill;

  /// Optional 1px Figma stroke (`null` = no stroke).
  final Color? stroke;

  /// Figma label paint.
  final Color labelColor;

  /// Overrides the default 16/600 label style (theme `titleMedium`).
  final TextStyle? labelStyle;

  /// Figma heights: 40 (C22 referral actions), 48 (C25 contact), 56 (C26).
  final double height;

  /// `true` fills the available width; `false` hugs the label.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final bool inactive = onPressed == null;
    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(height / 2),
      side: stroke == null ? BorderSide.none : BorderSide(color: stroke!),
    );

    final TextStyle labelTextStyle =
        (labelStyle ?? Theme.of(context).textTheme.titleMedium!)
            .copyWith(color: labelColor);

    return Semantics(
      button: true,
      enabled: !inactive,
      label: label,
      child: Material(
        color: fill,
        shape: shape,
        child: InkWell(
          onTap: inactive ? null : onPressed,
          customBorder: shape,
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight: height,
              minWidth: expand ? double.infinity : 0,
            ),
            child: Container(
              height: height,
              alignment: Alignment.center,
              padding: EdgeInsets.symmetric(horizontal: expand ? 24 : 0),
              child: Text(label, style: labelTextStyle),
            ),
          ),
        ),
      ),
    );
  }
}
