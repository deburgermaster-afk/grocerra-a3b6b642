import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';

import 'auth_theme.dart';

/// Motion tokens for the flow. One easing family everywhere keeps it calm.
abstract final class Motion {
  static const Curve enter = Curves.easeOutQuart;
  static const Curve exit = Curves.easeInOutCubic;
  static const Duration page = Duration(milliseconds: 560);
  static const Duration quick = Duration(milliseconds: 220);

  /// Gap between staggered children.
  static const Duration stagger = Duration(milliseconds: 55);

  /// Endless ambient loops (floating art, blinking caret). Tests switch
  /// this off so `pumpAndSettle` can settle.
  static bool ambient = true;

  static bool reduced(BuildContext context) =>
      !ambient || (MediaQuery.maybeDisableAnimationsOf(context) ?? false);
}

/// Makes any child feel physical: it sinks a little under the finger, then
/// springs back with a slight overshoot when released, with a light haptic
/// tick on tap.
class Pressable extends StatefulWidget {
  const Pressable({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.965,
    this.haptic = true,
    this.semanticLabel,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final bool haptic;
  final String? semanticLabel;

  @override
  State<Pressable> createState() => _PressableState();
}

class _PressableState extends State<Pressable>
    with SingleTickerProviderStateMixin {
  late final AnimationController _scale = AnimationController.unbounded(
    vsync: this,
    value: 1,
  );

  static const SpringDescription _spring = SpringDescription(
    mass: 1,
    stiffness: 420,
    damping: 18,
  );

  void _to(double target, {double velocity = 0}) {
    _scale.animateWith(
      SpringSimulation(_spring, _scale.value, target, velocity),
    );
  }

  bool get _enabled => widget.onTap != null;

  @override
  void dispose() {
    _scale.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: _enabled,
      label: widget.semanticLabel,
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTapDown: _enabled ? (_) => _to(widget.pressedScale) : null,
        onTapCancel: _enabled ? () => _to(1) : null,
        onTapUp: _enabled ? (_) => _to(1, velocity: 2.4) : null,
        onTap: _enabled
            ? () {
                if (widget.haptic) HapticFeedback.lightImpact();
                widget.onTap!();
              }
            : null,
        child: AnimatedBuilder(
          animation: _scale,
          builder: (BuildContext context, Widget? child) =>
              Transform.scale(scale: _scale.value, child: child),
          child: widget.child,
        ),
      ),
    );
  }
}

/// Fades and lifts its child into place after [order] stagger steps, so a
/// screen assembles itself top to bottom instead of appearing all at once.
class Reveal extends StatefulWidget {
  const Reveal({
    super.key,
    required this.child,
    this.order = 0,
    this.offset = 18,
    this.delay = const Duration(milliseconds: 80),
    this.duration = const Duration(milliseconds: 620),
  });

  final Widget child;
  final int order;
  final double offset;
  final Duration delay;
  final Duration duration;

  @override
  State<Reveal> createState() => _RevealState();
}

class _RevealState extends State<Reveal> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.duration,
  );
  late final Animation<double> _t = CurvedAnimation(
    parent: _c,
    curve: Motion.enter,
  );

  @override
  void initState() {
    super.initState();
    Future<void>.delayed(widget.delay + Motion.stagger * widget.order, () {
      if (mounted) _c.forward();
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) _c.value = 1;
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _t,
      builder: (BuildContext context, Widget? child) => Opacity(
        opacity: _t.value,
        child: Transform.translate(
          offset: Offset(0, (1 - _t.value) * widget.offset),
          child: child,
        ),
      ),
      child: widget.child,
    );
  }
}

/// Page transition for the flow: the new screen glides in from the right
/// while the old one drifts back and dims, like a stack of cards.
class AuthRoute<T> extends PageRouteBuilder<T> {
  AuthRoute({required Widget page, super.settings})
    : super(
        transitionDuration: Motion.page,
        reverseTransitionDuration: const Duration(milliseconds: 440),
        pageBuilder: (_, _, _) => AuthScope(child: page),
        transitionsBuilder:
            (
              BuildContext context,
              Animation<double> animation,
              Animation<double> secondary,
              Widget child,
            ) {
              final Animation<double> inT = CurvedAnimation(
                parent: animation,
                curve: Motion.enter,
                reverseCurve: Motion.exit,
              );
              final Animation<double> outT = CurvedAnimation(
                parent: secondary,
                curve: Motion.enter,
                reverseCurve: Motion.exit,
              );
              return AnimatedBuilder(
                animation: Listenable.merge(<Listenable>[inT, outT]),
                child: child,
                builder: (BuildContext context, Widget? child) {
                  final double width = MediaQuery.sizeOf(context).width;
                  final double dx =
                      (1 - inT.value) * width * 0.22 -
                      outT.value * width * 0.08;
                  return Opacity(
                    opacity: (inT.value * (1 - outT.value * 0.45)).clamp(
                      0.0,
                      1.0,
                    ),
                    child: Transform.translate(
                      offset: Offset(dx, 0),
                      child: Transform.scale(
                        scale: 1 - outT.value * 0.04,
                        child: child,
                      ),
                    ),
                  );
                },
              );
            },
      );
}

/// A soft cross-fade with a slight zoom, for moments that replace the
/// whole context (splash -> welcome, auth -> home).
class FadeThroughRoute<T> extends PageRouteBuilder<T> {
  FadeThroughRoute({required Widget page, bool scoped = true, super.settings})
    : super(
        transitionDuration: const Duration(milliseconds: 700),
        pageBuilder: (_, _, _) => scoped ? AuthScope(child: page) : page,
        transitionsBuilder: (_, Animation<double> animation, _, Widget child) {
          final Animation<double> t = CurvedAnimation(
            parent: animation,
            curve: Motion.enter,
          );
          return FadeTransition(
            opacity: t,
            child: ScaleTransition(
              scale: Tween<double>(begin: 1.04, end: 1).animate(t),
              child: child,
            ),
          );
        },
      );
}

/// Shakes its child sideways, the universal "that's not right".
class Shake extends StatefulWidget {
  const Shake({super.key, required this.child});

  final Widget child;

  @override
  State<Shake> createState() => ShakeState();
}

class ShakeState extends State<Shake> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 480),
  );

  void shake() {
    HapticFeedback.mediumImpact();
    _c.forward(from: 0);
  }

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double t = _c.value;
        final double dx = math.sin(t * math.pi * 6) * 10 * (1 - t);
        return Transform.translate(offset: Offset(dx, 0), child: child);
      },
    );
  }
}

/// A slow, endless bob for illustration pieces so the scene feels alive.
class Float extends StatefulWidget {
  const Float({
    super.key,
    required this.child,
    this.amplitude = 6,
    this.period = const Duration(milliseconds: 4200),
    this.phase = 0,
    this.rotate = 0.012,
  });

  final Widget child;
  final double amplitude;
  final Duration period;

  /// 0..1 offset into the cycle so neighbours don't move in lockstep.
  final double phase;

  /// Peak rotation in radians.
  final double rotate;

  @override
  State<Float> createState() => _FloatState();
}

class _FloatState extends State<Float> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: widget.period,
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _c.stop();
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
    return AnimatedBuilder(
      animation: _c,
      child: widget.child,
      builder: (BuildContext context, Widget? child) {
        final double a = (_c.value + widget.phase) * 2 * math.pi;
        return Transform.translate(
          offset: Offset(0, math.sin(a) * widget.amplitude),
          child: Transform.rotate(
            angle: math.cos(a) * widget.rotate,
            child: child,
          ),
        );
      },
    );
  }
}
