import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';

/// Confirmation moment after verifying an email or resetting a password: a
/// green ring draws itself, the tick follows, a soft pulse ripples out.
class AuthSuccessScreen extends StatefulWidget {
  const AuthSuccessScreen({
    super.key,
    required this.title,
    required this.message,
    required this.action,
    required this.onContinue,
  });

  final String title;
  final String message;
  final String action;
  final void Function(BuildContext context) onContinue;

  @override
  State<AuthSuccessScreen> createState() => _AuthSuccessScreenState();
}

class _AuthSuccessScreenState extends State<AuthSuccessScreen>
    with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1400),
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(const Duration(milliseconds: 250), () {
      if (!mounted) return;
      _c.forward();
      HapticFeedback.heavyImpact();
    });
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
              child: Column(
                children: <Widget>[
                  const Spacer(flex: 3),
                  SizedBox(
                    width: 160,
                    height: 160,
                    child: AnimatedBuilder(
                      animation: _c,
                      builder: (BuildContext context, Widget? _) => CustomPaint(
                        painter: _TickPainter(
                          t: _c.value,
                          color: p.accent,
                          soft: p.accentSoft,
                          ink: p.onPrimary,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 36),
                  Reveal(
                    order: 6,
                    child: Text(
                      widget.title,
                      textAlign: TextAlign.center,
                      style: AuthType.title(p.ink).copyWith(fontSize: 32),
                    ),
                  ),
                  const SizedBox(height: 12),
                  Reveal(
                    order: 7,
                    child: Text(
                      widget.message,
                      textAlign: TextAlign.center,
                      style: AuthType.body(p.muted),
                    ),
                  ),
                  const Spacer(flex: 4),
                  Reveal(
                    order: 9,
                    child: AuthButton(
                      label: widget.action,
                      onPressed: () => widget.onContinue(context),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TickPainter extends CustomPainter {
  const _TickPainter({
    required this.t,
    required this.color,
    required this.soft,
    required this.ink,
  });

  final double t;
  final Color color;
  final Color soft;
  final Color ink;

  double _seg(double from, double to) =>
      Curves.easeOutCubic.transform(((t - from) / (to - from)).clamp(0, 1));

  @override
  void paint(Canvas canvas, Size size) {
    final Offset c = size.center(Offset.zero);
    final double r = size.width * 0.32;

    // Ripple.
    final double ripple = _seg(0.45, 1);
    if (ripple > 0 && ripple < 1) {
      canvas.drawCircle(
        c,
        r * (1 + ripple * 0.55),
        Paint()..color = soft.withValues(alpha: soft.a * (1 - ripple)),
      );
    }

    // Disc grows in after the ring closes.
    final double fill = Curves.easeOutBack.transform(
      ((t - 0.35) / 0.3).clamp(0, 1),
    );
    canvas.drawCircle(c, r * fill, Paint()..color = color);

    // Ring draws itself.
    final double ring = _seg(0, 0.4);
    canvas.drawArc(
      Rect.fromCircle(center: c, radius: r),
      -math.pi / 2,
      2 * math.pi * ring,
      false,
      Paint()
        ..color = color
        ..style = PaintingStyle.stroke
        ..strokeWidth = 4
        ..strokeCap = StrokeCap.round,
    );

    // Tick.
    final double tick = _seg(0.55, 0.9);
    if (tick > 0) {
      final Path path = Path()
        ..moveTo(c.dx - r * 0.42, c.dy + r * 0.02)
        ..lineTo(c.dx - r * 0.1, c.dy + r * 0.34)
        ..lineTo(c.dx + r * 0.46, c.dy - r * 0.3);
      final Path partial = Path();
      for (final metric in path.computeMetrics()) {
        partial.addPath(
          metric.extractPath(0, metric.length * tick),
          Offset.zero,
        );
      }
      canvas.drawPath(
        partial,
        Paint()
          ..color = ink
          ..style = PaintingStyle.stroke
          ..strokeWidth = 7
          ..strokeCap = StrokeCap.round
          ..strokeJoin = StrokeJoin.round,
      );
    }
  }

  @override
  bool shouldRepaint(_TickPainter old) =>
      old.t != t || old.color != color || old.ink != ink;
}
