import 'dart:math' as math;
import 'package:flutter/material.dart';

/// Modern Glowing & Micro-Animation System
/// Inspired by high-craft fintech & creative coding UI animations
/// (Meridian Finance Dashboard by Code & Chill):
/// - Rotating & breathing glowing neon rings
/// - Luminous animated border gradient cards with ambient colored drop-shadows
/// - Tactile spring-scale micro-interactions on tap
/// - Specular shimmer glint light sweeps across buttons & banners
/// - Breathing pulse status dots with expanding radar rings
/// - Staggered cascade entrance transitions for smooth screen reveals

/// 1. The Signature Rotating & Breathing Glowing Ring
/// A mesmerizing circular ring that rotates smoothly and breathes with
/// a luminous neon ambient glow.
class GlowRing extends StatefulWidget {
  const GlowRing({
    super.key,
    this.size = 120,
    this.strokeWidth = 3.5,
    this.glowColor = const Color(0xFF10B981),
    this.secondaryColor = const Color(0xFF064E3B),
    this.child,
    this.isRotating = true,
    this.isBreathing = true,
    this.duration = const Duration(seconds: 4),
  });

  final double size;
  final double strokeWidth;
  final Color glowColor;
  final Color secondaryColor;
  final Widget? child;
  final bool isRotating;
  final bool isBreathing;
  final Duration duration;

  @override
  State<GlowRing> createState() => _GlowRingState();
}

class _GlowRingState extends State<GlowRing>
    with TickerProviderStateMixin {
  late AnimationController _rotateController;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();
    _rotateController = AnimationController(
      vsync: this,
      duration: widget.duration,
    );
    if (widget.isRotating) {
      _rotateController.repeat();
    }

    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _pulseAnimation = Tween<double>(begin: 0.85, end: 1.15).animate(
      CurvedAnimation(parent: _pulseController, curve: Curves.easeInOutSine),
    );
    if (widget.isBreathing) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _rotateController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: Listenable.merge(<Listenable>[_rotateController, _pulseController]),
      builder: (BuildContext context, Widget? child) {
        final double scale = widget.isBreathing ? _pulseAnimation.value : 1.0;
        final double angle = widget.isRotating
            ? _rotateController.value * 2 * math.pi
            : 0.0;

        return SizedBox(
          width: widget.size,
          height: widget.size,
          child: Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Ambient Diffuse Glow Underlay
              Transform.scale(
                scale: scale,
                child: Container(
                  width: widget.size * 0.88,
                  height: widget.size * 0.88,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: <BoxShadow>[
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.35),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                      BoxShadow(
                        color: widget.glowColor.withValues(alpha: 0.15),
                        blurRadius: 50,
                        spreadRadius: 8,
                      ),
                    ],
                  ),
                ),
              ),

              // Rotating Glowing Sweep Ring
              Transform.rotate(
                angle: angle,
                child: CustomPaint(
                  size: Size(widget.size, widget.size),
                  painter: _GlowRingPainter(
                    strokeWidth: widget.strokeWidth,
                    primaryColor: widget.glowColor,
                    secondaryColor: widget.secondaryColor,
                  ),
                ),
              ),

              // Inner Child Widget (e.g. icon, count, avatar)
              if (widget.child != null)
                Center(child: widget.child),
            ],
          ),
        );
      },
    );
  }
}

class _GlowRingPainter extends CustomPainter {
  _GlowRingPainter({
    required this.strokeWidth,
    required this.primaryColor,
    required this.secondaryColor,
  });

  final double strokeWidth;
  final Color primaryColor;
  final Color secondaryColor;

  @override
  void paint(Canvas canvas, Size size) {
    final Rect rect = Offset.zero & size;
    final Offset center = Offset(size.width / 2, size.height / 2);
    final double radius = (size.width - strokeWidth * 2) / 2;

    // Track circle (dim underlay)
    final Paint trackPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.12)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth * 0.7;
    canvas.drawCircle(center, radius, trackPaint);

    // Glowing Sweep Gradient Arc
    final SweepGradient gradient = SweepGradient(
      colors: <Color>[
        primaryColor.withValues(alpha: 0.0),
        primaryColor.withValues(alpha: 0.3),
        primaryColor,
        Colors.white,
      ],
      stops: const <double>[0.0, 0.5, 0.85, 1.0],
      startAngle: 0.0,
      endAngle: math.pi * 2,
    );

    final Paint arcPaint = Paint()
      ..shader = gradient.createShader(rect)
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeWidth = strokeWidth;

    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      0,
      math.pi * 1.8,
      false,
      arcPaint,
    );

    // Leading bright glowing dot at the head of the arc
    final double headAngle = math.pi * 1.8;
    final double headX = center.dx + radius * math.cos(headAngle);
    final double headY = center.dy + radius * math.sin(headAngle);

    final Paint dotPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(headX, headY), strokeWidth * 0.9, dotPaint);

    final Paint dotGlowPaint = Paint()
      ..color = primaryColor.withValues(alpha: 0.8)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(headX, headY), strokeWidth * 1.8, dotGlowPaint);
  }

  @override
  bool shouldRepaint(covariant _GlowRingPainter oldDelegate) =>
      oldDelegate.strokeWidth != strokeWidth ||
      oldDelegate.primaryColor != primaryColor;
}

/// 2. Glowing Animated Card (GlowCard)
/// A futuristic card with an ambient glowing border, animated gradient highlights,
/// soft neon drop-shadow, and responsive spring scale touch feedback.
class GlowCard extends StatefulWidget {
  const GlowCard({
    super.key,
    required this.child,
    this.onTap,
    this.backgroundColor = Colors.white,
    this.glowColor = const Color(0xFF10B981),
    this.borderRadius = 20.0,
    this.padding,
    this.margin,
    this.borderWidth = 1.2,
    this.enableBorderGlow = true,
    this.enableAmbientShadow = true,
    this.height,
    this.width,
  });

  final Widget child;
  final VoidCallback? onTap;
  final Color backgroundColor;
  final Color glowColor;
  final double borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderWidth;
  final bool enableBorderGlow;
  final bool enableAmbientShadow;
  final double? height;
  final double? width;

  @override
  State<GlowCard> createState() => _GlowCardState();
}

class _GlowCardState extends State<GlowCard>
    with SingleTickerProviderStateMixin {
  late AnimationController _borderController;
  bool _isPressed = false;
  bool _isHovered = false;

  @override
  void initState() {
    super.initState();
    _borderController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 5),
    );
    if (widget.enableBorderGlow) {
      _borderController.repeat();
    }
  }

  @override
  void dispose() {
    _borderController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedScale(
      scale: _isPressed ? 0.97 : (_isHovered ? 1.015 : 1.0),
      duration: const Duration(milliseconds: 140),
      curve: Curves.easeOutCubic,
      child: MouseRegion(
        onEnter: (_) => setState(() => _isHovered = true),
        onExit: (_) => setState(() => _isHovered = false),
        child: GestureDetector(
          onTapDown: (_) {
            if (widget.onTap != null) setState(() => _isPressed = true);
          },
          onTapUp: (_) {
            if (widget.onTap != null) setState(() => _isPressed = false);
          },
          onTapCancel: () {
            if (widget.onTap != null) setState(() => _isPressed = false);
          },
          onTap: widget.onTap,
          child: Container(
            height: widget.height,
            width: widget.width,
            margin: widget.margin,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              boxShadow: widget.enableAmbientShadow
                  ? <BoxShadow>[
                      BoxShadow(
                        color: widget.glowColor.withValues(
                          alpha: _isHovered ? 0.22 : 0.08,
                        ),
                        blurRadius: _isHovered ? 20 : 12,
                        spreadRadius: _isHovered ? 1 : 0,
                        offset: const Offset(0, 4),
                      ),
                      const BoxShadow(
                        color: Color(0x06000000),
                        blurRadius: 6,
                        offset: Offset(0, 2),
                      ),
                    ]
                  : null,
            ),
            child: widget.enableBorderGlow
                ? AnimatedBuilder(
                    animation: _borderController,
                    builder: (BuildContext context, Widget? child) {
                      final double angle = _borderController.value * 2 * math.pi;
                      return Container(
                        padding: EdgeInsets.all(widget.borderWidth),
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(widget.borderRadius),
                          gradient: SweepGradient(
                            colors: <Color>[
                              widget.glowColor.withValues(alpha: 0.15),
                              widget.glowColor.withValues(alpha: 0.8),
                              const Color(0xFF6EE7B7),
                              widget.glowColor.withValues(alpha: 0.15),
                            ],
                            stops: const <double>[0.0, 0.45, 0.75, 1.0],
                            transform: GradientRotation(angle),
                          ),
                        ),
                        child: Container(
                          padding: widget.padding,
                          decoration: BoxDecoration(
                            color: widget.backgroundColor,
                            borderRadius: BorderRadius.circular(
                              widget.borderRadius - widget.borderWidth,
                            ),
                          ),
                          child: widget.child,
                        ),
                      );
                    },
                  )
                : Container(
                    padding: widget.padding,
                    decoration: BoxDecoration(
                      color: widget.backgroundColor,
                      borderRadius: BorderRadius.circular(widget.borderRadius),
                      border: Border.all(
                        color: const Color(0xFFE5E7EB),
                        width: widget.borderWidth,
                      ),
                    ),
                    child: widget.child,
                  ),
          ),
        ),
      ),
    );
  }
}

/// 3. Tactile Spring Pressable (ScalePressable)
/// Applies an organic spring scale on touch/press down (scale down to 0.96)
/// with instant tactile feedback.
class ScalePressable extends StatefulWidget {
  const ScalePressable({
    super.key,
    required this.child,
    required this.onTap,
    this.pressedScale = 0.96,
    this.duration = const Duration(milliseconds: 130),
    this.curve = Curves.easeOutCubic,
    this.enableHaptic = true,
  });

  final Widget child;
  final VoidCallback? onTap;
  final double pressedScale;
  final Duration duration;
  final Curve curve;
  final bool enableHaptic;

  @override
  State<ScalePressable> createState() => _ScalePressableState();
}

class _ScalePressableState extends State<ScalePressable> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) {
        if (widget.onTap != null) {
          setState(() => _isPressed = true);
        }
      },
      onTapUp: (_) {
        if (widget.onTap != null) {
          setState(() => _isPressed = false);
        }
      },
      onTapCancel: () {
        if (widget.onTap != null) {
          setState(() => _isPressed = false);
        }
      },
      onTap: widget.onTap,
      child: AnimatedScale(
        scale: _isPressed ? widget.pressedScale : 1.0,
        duration: widget.duration,
        curve: widget.curve,
        child: widget.child,
      ),
    );
  }
}

/// 4. Specular Shimmer Glint (ShimmerGlint)
/// Sweeps an angled light beam across a widget on a smooth interval,
/// giving buttons and banners a glossy, futuristic pulse.
class ShimmerGlint extends StatefulWidget {
  const ShimmerGlint({
    super.key,
    required this.child,
    this.duration = const Duration(milliseconds: 2800),
    this.glintColor = Colors.white,
    this.intensity = 0.35,
  });

  final Widget child;
  final Duration duration;
  final Color glintColor;
  final double intensity;

  @override
  State<ShimmerGlint> createState() => _ShimmerGlintState();
}

class _ShimmerGlintState extends State<ShimmerGlint>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration)
      ..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return ShaderMask(
          blendMode: BlendMode.srcATop,
          shaderCallback: (Rect bounds) {
            final double value = _controller.value;
            // Glint moves from -1.0 to 2.0
            final double offset = -1.0 + (value * 3.0);
            return LinearGradient(
              begin: Alignment(offset - 0.5, -1.0),
              end: Alignment(offset + 0.5, 1.0),
              colors: <Color>[
                widget.glintColor.withValues(alpha: 0.0),
                widget.glintColor.withValues(alpha: widget.intensity),
                widget.glintColor.withValues(alpha: 0.0),
              ],
              stops: const <double>[0.0, 0.5, 1.0],
            ).createShader(bounds);
          },
          child: widget.child,
        );
      },
      child: widget.child,
    );
  }
}

/// 5. Breathing Pulse Status Dot (PulseGlowDot)
/// A live status radar dot with expanding concentric ripple rings and
/// an illuminated center core.
class PulseGlowDot extends StatefulWidget {
  const PulseGlowDot({
    super.key,
    this.color = const Color(0xFF10B981),
    this.size = 10.0,
    this.rippleRadius = 24.0,
  });

  final Color color;
  final double size;
  final double rippleRadius;

  @override
  State<PulseGlowDot> createState() => _PulseGlowDotState();
}

class _PulseGlowDotState extends State<PulseGlowDot>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1800),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: widget.rippleRadius,
      height: widget.rippleRadius,
      child: AnimatedBuilder(
        animation: _controller,
        builder: (BuildContext context, Widget? child) {
          final double progress = _controller.value;
          final double rippleSize =
              widget.size + (widget.rippleRadius - widget.size) * progress;
          final double opacity = (1.0 - progress).clamp(0.0, 1.0);

          return Stack(
            alignment: Alignment.center,
            children: <Widget>[
              // Expanding Ripple Ring
              Container(
                width: rippleSize,
                height: rippleSize,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(
                    color: widget.color.withValues(alpha: opacity * 0.5),
                    width: 1.5,
                  ),
                ),
              ),

              // Soft Inner Ambient Glow
              Container(
                width: widget.size * 1.5,
                height: widget.size * 1.5,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color.withValues(alpha: 0.25),
                ),
              ),

              // Solid Glowing Center Dot
              Container(
                width: widget.size,
                height: widget.size,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: widget.color,
                  boxShadow: <BoxShadow>[
                    BoxShadow(
                      color: widget.color.withValues(alpha: 0.8),
                      blurRadius: 6,
                      spreadRadius: 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

/// 6. Staggered Cascade Entrance (StaggeredReveal)
/// Slides up and fades in child widgets with an index-staggered delay.
class StaggeredReveal extends StatefulWidget {
  const StaggeredReveal({
    super.key,
    required this.child,
    this.index = 0,
    this.delayPerIndexMs = 50,
    this.slideOffset = 18.0,
    this.duration = const Duration(milliseconds: 450),
  });

  final Widget child;
  final int index;
  final int delayPerIndexMs;
  final double slideOffset;
  final Duration duration;

  @override
  State<StaggeredReveal> createState() => _StaggeredRevealState();
}

class _StaggeredRevealState extends State<StaggeredReveal>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(vsync: this, duration: widget.duration);
    _fadeAnimation = CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    );
    _slideAnimation = Tween<double>(
      begin: widget.slideOffset,
      end: 0.0,
    ).animate(CurvedAnimation(
      parent: _controller,
      curve: Curves.easeOutCubic,
    ));

    final int delay = widget.index * widget.delayPerIndexMs;
    Future<void>.delayed(Duration(milliseconds: delay), () {
      if (mounted) _controller.forward();
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (BuildContext context, Widget? child) {
        return Opacity(
          opacity: _fadeAnimation.value,
          child: Transform.translate(
            offset: Offset(0, _slideAnimation.value),
            child: widget.child,
          ),
        );
      },
    );
  }
}

/// 7. Glowing Pill Badge (GlowBadge)
/// High-contrast status pill with subtle neon edge and ambient glow.
class GlowBadge extends StatelessWidget {
  const GlowBadge({
    super.key,
    required this.label,
    this.icon,
    this.glowColor = const Color(0xFF10B981),
    this.backgroundColor,
    this.textColor = Colors.white,
    this.showPulseDot = false,
  });

  final String label;
  final IconData? icon;
  final Color glowColor;
  final Color? backgroundColor;
  final Color textColor;
  final bool showPulseDot;

  @override
  Widget build(BuildContext context) {
    final Color bg = backgroundColor ?? const Color(0xFF0F172A);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: glowColor.withValues(alpha: 0.6),
          width: 1.2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: glowColor.withValues(alpha: 0.28),
            blurRadius: 10,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          if (showPulseDot) ...<Widget>[
            PulseGlowDot(color: glowColor, size: 7, rippleRadius: 16),
            const SizedBox(width: 6),
          ] else if (icon != null) ...<Widget>[
            Icon(icon, size: 13, color: glowColor),
            const SizedBox(width: 5),
          ],
          Text(
            label,
            style: TextStyle(
              color: textColor,
              fontSize: 11,
              fontWeight: FontWeight.w800,
              letterSpacing: 0.4,
            ),
          ),
        ],
      ),
    );
  }
}

/// 8. Glowing Primary CTA Button (GlowButton)
/// A high-impact button with ambient neon glow, shimmer glint, and spring touch.
class GlowButton extends StatelessWidget {
  const GlowButton({
    super.key,
    required this.label,
    required this.onTap,
    this.icon,
    this.glowColor = const Color(0xFF10B981),
    this.backgroundColor = const Color(0xFF0F172A),
    this.textColor = Colors.white,
    this.height = 54.0,
    this.borderRadius = 18.0,
    this.isLoading = false,
  });

  final String label;
  final VoidCallback onTap;
  final IconData? icon;
  final Color glowColor;
  final Color backgroundColor;
  final Color textColor;
  final double height;
  final double borderRadius;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return ScalePressable(
      onTap: isLoading ? null : onTap,
      child: Container(
        height: height,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(borderRadius),
          boxShadow: <BoxShadow>[
            BoxShadow(
              color: glowColor.withValues(alpha: 0.35),
              blurRadius: 18,
              spreadRadius: 1,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: ShimmerGlint(
          intensity: 0.25,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
              color: backgroundColor,
              borderRadius: BorderRadius.circular(borderRadius),
              border: Border.all(
                color: glowColor.withValues(alpha: 0.5),
                width: 1.2,
              ),
            ),
            child: Center(
              child: isLoading
                  ? SizedBox(
                      width: 22,
                      height: 22,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.5,
                        valueColor: AlwaysStoppedAnimation<Color>(glowColor),
                      ),
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        if (icon != null) ...<Widget>[
                          Icon(icon, size: 20, color: glowColor),
                          const SizedBox(width: 8),
                        ],
                        Text(
                          label,
                          style: TextStyle(
                            color: textColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            letterSpacing: -0.2,
                          ),
                        ),
                      ],
                    ),
            ),
          ),
        ),
      ),
    );
  }
}
