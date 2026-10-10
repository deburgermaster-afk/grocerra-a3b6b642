import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// The shared SVG icon widget.
///
/// Glyphs come from an SVG exported off the approved Figma file
/// (`assets/icons/ic_<name>.svg`); screens pass the Figma icon name
/// (e.g. `AppIcon('star')`) rather than calling `SvgPicture` directly.
class AppIcon extends StatelessWidget {
  const AppIcon(this.name, {super.key, this.size = 24, this.color});

  /// Figma icon name, mapped to `assets/icons/ic_<name>.svg`.
  final String name;

  /// Rendered box in logical pixels (Figma icon frames are square).
  final double size;

  /// Optional tint. Figma glyphs are single-colour, so tinting recolours the
  /// strokes/fills via [BlendMode.srcIn]; omit to keep the exported colour.
  final Color? color;

  @override
  Widget build(BuildContext context) {
    final Color? tint = color;
    return SvgPicture.asset(
      'assets/icons/ic_$name.svg',
      width: size,
      height: size,
      colorFilter: tint == null ? null : ColorFilter.mode(tint, BlendMode.srcIn),
    );
  }
}
