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
  });

  final String label;
  final Color background;
  final Color foreground;
  final double fontSize;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 21,
      padding: const EdgeInsets.symmetric(horizontal: 7),
      alignment: Alignment.center,
      decoration: BoxDecoration(
        color: background,
        borderRadius: BorderRadius.circular(10.5),
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
