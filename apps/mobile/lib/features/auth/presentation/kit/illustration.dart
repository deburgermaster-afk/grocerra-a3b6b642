import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_theme.dart';

/// Notion-style line illustrations (`assets/illustrations/`).
///
/// The SVGs carry colour tokens rather than colours - `{{S}}` ink stroke,
/// `{{F}}` paper, `{{G}}` green, `{{T}}` soft tint - so one drawing serves
/// both themes: ink on paper in light mode, chalk on slate in dark mode.
enum Art { groceryBag, courier, catering, phone, sparkle, leaf, chili }

class Illustration extends StatelessWidget {
  const Illustration(this.art, {super.key, this.width, this.height});

  final Art art;
  final double? width;
  final double? height;

  static final Map<Art, Future<String>> _cache = <Art, Future<String>>{};

  static String _file(Art art) => switch (art) {
    Art.groceryBag => 'grocery_bag',
    Art.courier => 'courier',
    Art.catering => 'catering',
    Art.phone => 'phone',
    Art.sparkle => 'sparkle',
    Art.leaf => 'leaf',
    Art.chili => 'chili',
  };

  static String _hex(Color c) =>
      '#${(c.toARGB32() & 0xFFFFFF).toRadixString(16).padLeft(6, '0')}';

  @override
  Widget build(BuildContext context) {
    // Use the settled palette, not the mid-transition one: re-parsing the SVG
    // on every frame of a theme change would stutter, so the two finished
    // renderings cross-fade instead.
    final Brightness brightness = Theme.of(context).brightness;
    final AuthPalette p = brightness == Brightness.dark
        ? AuthPalette.dark
        : AuthPalette.light;
    final Future<String> source = _cache.putIfAbsent(
      art,
      () =>
          DefaultAssetBundle.of(context)
              .loadString('assets/illustrations/${_file(art)}.svg'),
    );

    return SizedBox(
      width: width,
      height: height,
      child: FutureBuilder<String>(
        future: source,
        builder: (BuildContext context, AsyncSnapshot<String> snap) {
          if (!snap.hasData) return const SizedBox.shrink();
          final String svg = snap.data!
              .replaceAll('{{S}}', _hex(p.lineArt))
              .replaceAll('{{F}}', _hex(p.lineFill))
              .replaceAll('{{G}}', _hex(p.accent))
              .replaceAll('{{T}}', _hex(p.field));
          return AnimatedSwitcher(
            duration: const Duration(milliseconds: 450),
            child: SvgPicture.string(
              svg,
              key: ValueKey<Brightness>(brightness),
              width: width,
              height: height,
            ),
          );
        },
      ),
    );
  }
}
