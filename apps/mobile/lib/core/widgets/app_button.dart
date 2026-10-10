import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// Figma button variants, read off the approved frames:
///
/// * [primary] - solid `#000` pill, white 16/600 label (B4 Add to cart,
///   C09/C10 checkout CTAs).
/// * [outline] - white fill, 1px `#cfcfcf` stroke (`AppColors.outline`,
///   Figma `color/neutral/light`), black label.
/// * [text] - transparent fill, black label.
///
/// The loading/disabled state follows Figma A·S1: `#f3f3f3` fill, `#6b6b6b`
/// 16/600 label and a black spinner.
///
/// Screens must use this widget - never style `FilledButton`,
/// `OutlinedButton` or `TextButton` inline.
class AppButton extends StatelessWidget {
  const AppButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AppButtonVariant.primary,
    this.height = 46,
    this.loading = false,
    this.icon,
    this.labelStyle,
    this.expand = true,
  });

  /// Button caption.
  final String label;

  /// `null` renders the disabled (A·S1) state.
  final VoidCallback? onPressed;

  final AppButtonVariant variant;

  /// Figma heights: 46 (auth rows), 52 (B4 Add to cart), 56 (cart /
  /// checkout CTAs).
  final double height;

  /// Shows the Figma A·S1 loading treatment (spinner + label, muted colours).
  final bool loading;

  /// Optional leading glyph (20px icon with a 10px gap before the label).
  final Widget? icon;

  /// Overrides the default 16/600 label style (theme `titleMedium`).
  /// An explicit [TextStyle.color] wins in the active state; disabled /
  /// loading keeps the A·S1 muted treatment.
  final TextStyle? labelStyle;

  /// `true` fills the available width (Figma buttons are 356-358 wide);
  /// `false` hugs the label.
  final bool expand;

  @override
  Widget build(BuildContext context) {
    final bool inactive = loading || onPressed == null;
    // Figma radii are 28 on 46/56 tall buttons and 26 on 52 tall ones - both
    // clamp to a pill, so half the height is the rendered radius everywhere.
    final double radius = height / 2;

    Color background;
    Color foreground;
    BorderSide side = BorderSide.none;

    switch (variant) {
      case AppButtonVariant.primary:
        background = inactive ? AppColors.surfaceAlt : AppColors.ink;
        foreground = inactive ? AppColors.inkMuted : AppColors.surface;
      case AppButtonVariant.outline:
        background = AppColors.surface;
        side = const BorderSide(color: AppColors.outline);
        foreground = inactive ? AppColors.inkMuted : AppColors.ink;
      case AppButtonVariant.text:
        background = Colors.transparent;
        foreground = inactive ? AppColors.inkMuted : AppColors.ink;
    }

    final TextStyle labelTextStyle =
        (labelStyle ?? Theme.of(context).textTheme.titleMedium!).copyWith(
          color: inactive ? foreground : (labelStyle?.color ?? foreground),
        );

    final RoundedRectangleBorder shape = RoundedRectangleBorder(
      borderRadius: BorderRadius.circular(radius),
      side: side,
    );

    final Widget content = loading
        ? Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  // A·S1 spinner is black on the #f3f3f3 disabled fill.
                  color: variant == AppButtonVariant.primary
                      ? AppColors.ink
                      : AppColors.inkMuted,
                ),
              ),
              // Figma A·S1 button layout: 10px between spinner and label.
              const SizedBox(width: 10),
              Text(label, style: labelTextStyle),
            ],
          )
        : icon == null
        ? Text(label, style: labelTextStyle)
        : Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              icon!,
              // 10px between the glyph and the label.
              const SizedBox(width: 10),
              Text(label, style: labelTextStyle),
            ],
          );

    return Semantics(
      button: true,
      enabled: !inactive,
      label: label,
      child: Material(
        color: background,
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
              child: content,
            ),
          ),
        ),
      ),
    );
  }
}

/// See [AppButton].
enum AppButtonVariant { primary, outline, text }
