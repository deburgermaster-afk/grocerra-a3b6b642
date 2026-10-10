import 'package:flutter/material.dart';

/// The 21px-tall tag pill from the approved frames (store tags such as
/// `Halal` and `$5.99 delivery`, promo and status chips).
class TagPill extends StatelessWidget {
  const TagPill({
    super.key,
    required this.label,
    this.background = const Color(0xFFF3F3F3),
    this.foreground = const Color(0xFF000000),
    this.fontSize = 11,
    this.radius = 10.5,
    this.height = 21,
    this.padding = const EdgeInsets.symmetric(horizontal: 7),
  });

  final String label;
  final Color background;
  final Color foreground;
  final double fontSize;

  /// Corner radius; 10.5 is the 21px-tall pill, promo tags use 6.
  final double radius;

  /// Pill heights: 21 (default), 22 (B3 store tags), 26 (B4 product chips).
  final double height;

  /// Inner padding; the ported frames pin their own values per pill.
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: padding,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(radius),
      ),
      child: Text(
        label,
        maxLines: 1,
        style: TextStyle(
          fontSize: fontSize,
          height: 1.1,
          fontWeight: FontWeight.w600,
          color: foreground,
        ),
      ),
    );
  }
}
