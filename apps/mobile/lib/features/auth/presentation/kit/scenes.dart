import 'package:flutter/material.dart';

import 'auth_theme.dart';
import 'illustration.dart';
import 'motion.dart';

/// A small floating UI card laid over the illustrations, like the prompt
/// cards in the reference onboarding: it says what the scene is about in
/// product terms ("Arriving in 12 min").
class SceneChip extends StatelessWidget {
  const SceneChip({
    super.key,
    required this.label,
    this.leading,
    this.caption,
    this.live = false,
  });

  final String label;
  final Widget? leading;
  final String? caption;

  /// Adds a pulsing green dot, for live status.
  final bool live;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        color: p.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: p.fieldBorder),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.18),
            blurRadius: 24,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (live) ...<Widget>[
            const _LiveDot(),
            const SizedBox(width: 8),
          ] else if (leading != null) ...<Widget>[
            leading!,
            const SizedBox(width: 8),
          ],
          Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                label,
                style: AuthType.small(p.ink)
                    .copyWith(fontWeight: FontWeight.w600),
              ),
              if (caption != null)
                Text(
                  caption!,
                  style: AuthType.small(p.muted).copyWith(fontSize: 11.5),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LiveDot extends StatefulWidget {
  const _LiveDot();

  @override
  State<_LiveDot> createState() => _LiveDotState();
}

class _LiveDotState extends State<_LiveDot>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1600),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.value = 0;
    } else if (!_c.isAnimating) {
      _c.repeat();
    }
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color g = AuthPalette.of(context).accent;
    return SizedBox(
      width: 14,
      height: 14,
      child: AnimatedBuilder(
        animation: _c,
        builder: (BuildContext context, Widget? _) => Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              width: 6 + 8 * _c.value,
              height: 6 + 8 * _c.value,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: g.withValues(alpha: 0.45 * (1 - _c.value)),
              ),
            ),
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(shape: BoxShape.circle, color: g),
            ),
          ],
        ),
      ),
    );
  }
}

/// Green tick in a circle, for chips.
class TickBadge extends StatelessWidget {
  const TickBadge({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Container(
      width: 18,
      height: 18,
      decoration: BoxDecoration(color: p.accent, shape: BoxShape.circle),
      child: Icon(Icons.check_rounded, size: 13, color: p.onPrimary),
    );
  }
}

/// One positioned, floating, staggered-in piece of a scene. Positions are
/// fractions of the scene box so the composition scales with the screen.
class ScenePiece {
  const ScenePiece({
    required this.child,
    required this.x,
    required this.y,
    this.width,
    this.phase = 0,
    this.amplitude = 6,
    this.angle = 0,
    this.depth = 1,
  });

  final Widget child;

  /// Centre of the piece, 0..1 of the scene's width / height.
  final double x;
  final double y;

  /// Fraction of the scene width (null: intrinsic size).
  final double? width;
  final double phase;
  final double amplitude;
  final double angle;

  /// Parallax depth: how far this piece travels when the scene slides.
  final double depth;
}

/// Lays out [pieces] in a box, floats each one, brings them in one by one
/// and shifts them at different depths by [parallax] (-1..1).
class Scene extends StatelessWidget {
  const Scene({super.key, required this.pieces, this.parallax = 0});

  final List<ScenePiece> pieces;
  final double parallax;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (BuildContext context, BoxConstraints c) {
        final double w = c.maxWidth;
        final double h = c.maxHeight;
        return Stack(
          clipBehavior: Clip.none,
          children: <Widget>[
            for (int i = 0; i < pieces.length; i++) _place(pieces[i], i, w, h),
          ],
        );
      },
    );
  }

  Widget _place(ScenePiece piece, int index, double w, double h) {
    final double? pw = piece.width == null ? null : piece.width! * w;
    return Positioned(
      left: piece.x * w - (pw ?? 0) / 2 + parallax * piece.depth * w * 0.35,
      top: piece.y * h,
      width: pw,
      child: FractionalTranslation(
        translation: Offset(pw == null ? -0.5 : 0, -0.5),
        child: Reveal(
          order: index,
          offset: 26,
          duration: const Duration(milliseconds: 820),
          child: Float(
            phase: piece.phase,
            amplitude: piece.amplitude,
            child: Transform.rotate(angle: piece.angle, child: piece.child),
          ),
        ),
      ),
    );
  }
}

/// The three onboarding stories and the welcome collage.
abstract final class Scenes {
  static List<ScenePiece> groceries() => const <ScenePiece>[
    ScenePiece(
      child: Illustration(Art.groceryBag),
      x: 0.5,
      y: 0.5,
      width: 0.66,
    ),
    ScenePiece(
      child: Illustration(Art.sparkle),
      x: 0.16,
      y: 0.2,
      width: 0.09,
      phase: 0.4,
      depth: 1.6,
    ),
    ScenePiece(
      child: Illustration(Art.leaf),
      x: 0.86,
      y: 0.16,
      width: 0.1,
      phase: 0.7,
      angle: 0.3,
      depth: 1.8,
    ),
    ScenePiece(
      child: SceneChip(label: 'Halal certified', leading: TickBadge()),
      x: 0.24,
      y: 0.86,
      phase: 0.2,
      depth: 1.4,
    ),
    ScenePiece(
      child: SceneChip(label: 'Goat curry cut', caption: r'1 kg · $16.99'),
      x: 0.78,
      y: 0.74,
      phase: 0.55,
      depth: 1.7,
    ),
  ];

  static List<ScenePiece> catering() => const <ScenePiece>[
    ScenePiece(child: Illustration(Art.catering), x: 0.5, y: 0.52, width: 0.72),
    ScenePiece(
      child: Illustration(Art.chili),
      x: 0.14,
      y: 0.2,
      width: 0.11,
      phase: 0.3,
      angle: -0.3,
      depth: 1.7,
    ),
    ScenePiece(
      child: SceneChip(
        label: 'Quote request sent',
        caption: 'Biryani for 40 guests',
        leading: TickBadge(),
      ),
      x: 0.62,
      y: 0.12,
      phase: 0.6,
      depth: 1.5,
    ),
    ScenePiece(
      child: Illustration(Art.sparkle),
      x: 0.88,
      y: 0.78,
      width: 0.08,
      phase: 0.15,
      depth: 1.9,
    ),
  ];

  static List<ScenePiece> tracking() => const <ScenePiece>[
    ScenePiece(
      child: Illustration(Art.phone),
      x: 0.72,
      y: 0.38,
      width: 0.4,
      angle: 0.08,
      phase: 0.5,
      depth: 0.7,
    ),
    ScenePiece(
      child: Illustration(Art.courier),
      x: 0.4,
      y: 0.66,
      width: 0.66,
      amplitude: 4,
      depth: 1.3,
    ),
    ScenePiece(
      child: SceneChip(
        label: 'Arriving in 12 min',
        caption: 'Imran is on the way',
        live: true,
      ),
      x: 0.3,
      y: 0.14,
      phase: 0.25,
      depth: 1.6,
    ),
  ];

  /// Welcome screen collage: all three stories in one frame.
  static List<ScenePiece> welcome() => const <ScenePiece>[
    ScenePiece(
      child: Illustration(Art.phone),
      x: 0.84,
      y: 0.34,
      width: 0.3,
      angle: 0.14,
      phase: 0.6,
    ),
    ScenePiece(
      child: Illustration(Art.groceryBag),
      x: 0.48,
      y: 0.42,
      width: 0.56,
    ),
    ScenePiece(
      child: Illustration(Art.courier),
      x: 0.22,
      y: 0.76,
      width: 0.42,
      phase: 0.3,
      amplitude: 4,
    ),
    ScenePiece(
      child: Illustration(Art.sparkle),
      x: 0.12,
      y: 0.18,
      width: 0.08,
      phase: 0.4,
    ),
    ScenePiece(
      child: Illustration(Art.chili),
      x: 0.9,
      y: 0.68,
      width: 0.1,
      phase: 0.8,
      angle: 0.4,
    ),
    ScenePiece(
      child: SceneChip(label: 'Arriving in 12 min', live: true),
      x: 0.7,
      y: 0.86,
      phase: 0.2,
    ),
  ];
}
