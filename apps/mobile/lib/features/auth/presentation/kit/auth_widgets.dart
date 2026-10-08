import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'auth_theme.dart';
import 'motion.dart';

enum AuthButtonVariant { primary, secondary }

/// The 56px pill from the reference frames. White on dark / black on light
/// for the main action, quiet grey for the rest. While [loading] the label
/// morphs into three pulsing dots so the tap is acknowledged instantly.
class AuthButton extends StatelessWidget {
  const AuthButton({
    super.key,
    required this.label,
    required this.onPressed,
    this.variant = AuthButtonVariant.primary,
    this.loading = false,
    this.leading,
  });

  final String label;
  final VoidCallback? onPressed;
  final AuthButtonVariant variant;
  final bool loading;
  final Widget? leading;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final bool primary = variant == AuthButtonVariant.primary;
    final Color bg = primary ? p.primary : p.secondary;
    final Color fg = primary ? p.onPrimary : p.onSecondary;
    final bool enabled = onPressed != null && !loading;

    return Pressable(
      onTap: enabled ? onPressed : null,
      semanticLabel: label,
      child: AnimatedOpacity(
        duration: Motion.quick,
        opacity: onPressed == null ? 0.45 : 1,
        child: AnimatedContainer(
          duration: Motion.quick,
          height: 56,
          width: double.infinity,
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(28),
            border: primary ? null : Border.all(color: p.fieldBorder),
          ),
          alignment: Alignment.center,
          child: AnimatedSwitcher(
            duration: const Duration(milliseconds: 260),
            switchInCurve: Motion.enter,
            switchOutCurve: Motion.exit,
            transitionBuilder: (Widget child, Animation<double> a) =>
                FadeTransition(
                  opacity: a,
                  child: ScaleTransition(
                    scale: Tween<double>(begin: 0.85, end: 1).animate(a),
                    child: child,
                  ),
                ),
            child: loading
                ? _Dots(color: fg, key: const ValueKey<String>('dots'))
                : Row(
                    key: const ValueKey<String>('label'),
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      if (leading != null) ...<Widget>[
                        leading!,
                        const SizedBox(width: 10),
                      ],
                      Text(label, style: AuthType.label(fg)),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}

class _Dots extends StatefulWidget {
  const _Dots({super.key, required this.color});

  final Color color;

  @override
  State<_Dots> createState() => _DotsState();
}

class _DotsState extends State<_Dots> with SingleTickerProviderStateMixin {
  late final AnimationController _c = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 900),
  )..repeat();

  @override
  void dispose() {
    _c.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _c,
      builder: (BuildContext context, Widget? _) => Row(
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          for (int i = 0; i < 3; i++)
            Container(
              width: 7,
              height: 7,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: widget.color.withValues(
                  alpha:
                      0.3 +
                      0.7 *
                          (0.5 +
                              0.5 *
                                  math.sin(
                                    (_c.value - i * 0.18) * 2 * math.pi,
                                  )),
                ),
                shape: BoxShape.circle,
              ),
            ),
        ],
      ),
    );
  }
}

/// "‹ Back" from the reference frames.
class BackPill extends StatelessWidget {
  const BackPill({super.key, this.onTap});

  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Pressable(
      semanticLabel: 'Back',
      onTap: onTap ?? () => Navigator.of(context).maybePop(),
      pressedScale: 0.92,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Icon(Icons.arrow_back_ios_new_rounded, size: 16, color: p.ink),
            const SizedBox(width: 6),
            Text('Back', style: AuthType.small(p.ink)),
          ],
        ),
      ),
    );
  }
}

/// Text input with an icon, a filled field and a focus state that warms to
/// green. Errors slide in underneath instead of jumping the layout.
class AuthField extends StatefulWidget {
  const AuthField({
    super.key,
    required this.controller,
    required this.hint,
    required this.icon,
    this.obscure = false,
    this.keyboardType,
    this.textInputAction = TextInputAction.next,
    this.autofillHints,
    this.error,
    this.onSubmitted,
    this.onChanged,
    this.focusNode,
  });

  final TextEditingController controller;
  final String hint;
  final IconData icon;
  final bool obscure;
  final TextInputType? keyboardType;
  final TextInputAction textInputAction;
  final Iterable<String>? autofillHints;
  final String? error;
  final ValueChanged<String>? onSubmitted;
  final ValueChanged<String>? onChanged;
  final FocusNode? focusNode;

  @override
  State<AuthField> createState() => _AuthFieldState();
}

class _AuthFieldState extends State<AuthField> {
  late final FocusNode _focus = widget.focusNode ?? FocusNode();
  late bool _hidden = widget.obscure;

  @override
  void initState() {
    super.initState();
    _focus.addListener(_onFocus);
  }

  void _onFocus() => setState(() {});

  @override
  void dispose() {
    _focus.removeListener(_onFocus);
    if (widget.focusNode == null) _focus.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final bool focused = _focus.hasFocus;
    final bool hasError = widget.error != null;
    final Color border = hasError
        ? p.danger
        : focused
        ? p.accent
        : p.fieldBorder.withValues(alpha: 0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        AnimatedContainer(
          duration: const Duration(milliseconds: 240),
          curve: Motion.enter,
          height: 56,
          decoration: BoxDecoration(
            color: p.field,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: border, width: 1.4),
            boxShadow: focused && !hasError
                ? <BoxShadow>[
                    BoxShadow(
                      color: p.accentSoft,
                      blurRadius: 0,
                      spreadRadius: 4,
                    ),
                  ]
                : const <BoxShadow>[],
          ),
          child: Row(
            children: <Widget>[
              const SizedBox(width: 16),
              TweenAnimationBuilder<Color?>(
                duration: const Duration(milliseconds: 240),
                tween: ColorTween(
                  end: hasError
                      ? p.danger
                      : focused
                      ? p.accent
                      : p.muted,
                ),
                builder: (_, Color? c, _) =>
                    Icon(widget.icon, size: 20, color: c),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: TextField(
                  controller: widget.controller,
                  focusNode: _focus,
                  obscureText: _hidden,
                  keyboardType: widget.keyboardType,
                  textInputAction: widget.textInputAction,
                  autofillHints: widget.autofillHints,
                  onSubmitted: widget.onSubmitted,
                  onChanged: widget.onChanged,
                  style: AuthType.label(p.ink)
                      .copyWith(fontWeight: FontWeight.w500),
                  decoration: InputDecoration(
                    isCollapsed: true,
                    border: InputBorder.none,
                    filled: false,
                    hintText: widget.hint,
                    hintStyle: AuthType.label(p.faint)
                        .copyWith(fontWeight: FontWeight.w400),
                  ),
                ),
              ),
              if (widget.obscure)
                Pressable(
                  semanticLabel: _hidden ? 'Show password' : 'Hide password',
                  pressedScale: 0.85,
                  onTap: () => setState(() => _hidden = !_hidden),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 14),
                    child: AnimatedSwitcher(
                      duration: Motion.quick,
                      transitionBuilder: (Widget c, Animation<double> a) =>
                          RotationTransition(
                            turns: Tween<double>(
                              begin: 0.75,
                              end: 1,
                            ).animate(a),
                            child: FadeTransition(opacity: a, child: c),
                          ),
                      child: Icon(
                        _hidden
                            ? Icons.visibility_off_outlined
                            : Icons.visibility_outlined,
                        key: ValueKey<bool>(_hidden),
                        size: 20,
                        color: p.muted,
                      ),
                    ),
                  ),
                )
              else
                const SizedBox(width: 16),
            ],
          ),
        ),
        AnimatedSize(
          duration: const Duration(milliseconds: 260),
          curve: Motion.enter,
          alignment: Alignment.topLeft,
          child: AnimatedSwitcher(
            duration: Motion.quick,
            child: hasError
                ? Padding(
                    key: ValueKey<String>(widget.error!),
                    padding: const EdgeInsets.fromLTRB(6, 8, 6, 0),
                    child: Text(widget.error!, style: AuthType.small(p.danger)),
                  )
                : const SizedBox(width: double.infinity),
          ),
        ),
      ],
    );
  }
}

/// Four bars that fill and warm from red to green as the password gets
/// stronger, live with every keystroke.
class PasswordStrength extends StatelessWidget {
  const PasswordStrength({super.key, required this.password});

  final String password;

  static int score(String value) {
    if (value.isEmpty) return 0;
    int s = 0;
    if (value.length >= 8) s++;
    if (value.length >= 12) s++;
    if (RegExp('[A-Z]').hasMatch(value) && RegExp('[a-z]').hasMatch(value)) {
      s++;
    }
    if (RegExp(r'[0-9]').hasMatch(value) ||
        RegExp(r'[^A-Za-z0-9]').hasMatch(value)) {
      s++;
    }
    return math.max(1, s);
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final int s = score(password);
    final Color tone = switch (s) {
      0 || 1 => p.danger,
      2 => const Color(0xFFF59E0B),
      _ => p.accent,
    };
    const List<String> words = <String>['', 'Weak', 'Okay', 'Good', 'Strong'];

    // Collapses to nothing until the first keystroke, then unfolds.
    return AnimatedSize(
      duration: const Duration(milliseconds: 280),
      curve: Motion.enter,
      alignment: Alignment.topCenter,
      child: password.isEmpty
          ? const SizedBox(width: double.infinity)
          : Padding(
              padding: const EdgeInsets.only(top: 10),
              child: Row(
                children: <Widget>[
                  for (int i = 0; i < 4; i++) ...<Widget>[
                    Expanded(
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 260 + i * 40),
                        curve: Motion.enter,
                        height: 4,
                        decoration: BoxDecoration(
                          color: i < s ? tone : p.fieldBorder,
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  SizedBox(
                    width: 52,
                    child: Text(
                      words[s],
                      textAlign: TextAlign.end,
                      style: AuthType.small(tone),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}

/// "—— or ——".
class OrDivider extends StatelessWidget {
  const OrDivider({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final Widget line = Expanded(
      child: Container(height: 1, color: p.fieldBorder),
    );
    return Row(
      children: <Widget>[
        line,
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: Text('or', style: AuthType.small(p.faint)),
        ),
        line,
      ],
    );
  }
}

/// Apple / Google brand marks, drawn so they stay crisp in both themes.
class BrandMark extends StatelessWidget {
  const BrandMark.apple({super.key}) : google = false;
  const BrandMark.google({super.key}) : google = true;

  final bool google;

  static const String _google =
      '<svg viewBox="0 0 48 48" xmlns="http://www.w3.org/2000/svg">'
      '<path fill="#FFC107" d="M43.6 20.1H42V20H24v8h11.3C33.7 32.7 29.2 36 24 36c-6.6 0-12-5.4-12-12s5.4-12 12-12c3.1 0 5.8 1.2 7.9 3.1l5.7-5.7C34 6.1 29.3 4 24 4 12.9 4 4 12.9 4 24s8.9 20 20 20 20-8.9 20-20c0-1.3-.1-2.6-.4-3.9z"/>'
      '<path fill="#FF3D00" d="m6.3 14.7 6.6 4.8C14.7 15.1 19 12 24 12c3.1 0 5.8 1.2 7.9 3.1l5.7-5.7C34 6.1 29.3 4 24 4 16.3 4 9.7 8.3 6.3 14.7z"/>'
      '<path fill="#4CAF50" d="M24 44c5.2 0 9.9-2 13.4-5.2l-6.2-5.2C29.2 35.1 26.7 36 24 36c-5.2 0-9.6-3.3-11.3-8l-6.5 5C9.5 39.6 16.2 44 24 44z"/>'
      '<path fill="#1976D2" d="M43.6 20.1H42V20H24v8h11.3c-.8 2.2-2.2 4.2-4.1 5.6l6.2 5.2C37 39.2 44 34 44 24c0-1.3-.1-2.6-.4-3.9z"/>'
      '</svg>';

  @override
  Widget build(BuildContext context) {
    if (google) return SvgPicture.string(_google, width: 20, height: 20);
    return Icon(Icons.apple, size: 22, color: AuthPalette.of(context).ink);
  }
}

/// Sun / moon button that flips the flow between light and dark.
class ThemeToggle extends StatelessWidget {
  const ThemeToggle({super.key});

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final Brightness b = Theme.of(context).brightness;
    final bool dark = b == Brightness.dark;
    return Pressable(
      semanticLabel: dark ? 'Switch to light mode' : 'Switch to dark mode',
      pressedScale: 0.88,
      onTap: () => AuthThemeMode.toggle(b),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          color: p.secondary,
          shape: BoxShape.circle,
          border: Border.all(color: p.fieldBorder),
        ),
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 420),
          switchInCurve: Curves.easeOutBack,
          transitionBuilder: (Widget c, Animation<double> a) =>
              RotationTransition(
                turns: Tween<double>(begin: -0.35, end: 0).animate(a),
                child: ScaleTransition(scale: a, child: c),
              ),
          child: Icon(
            dark ? Icons.light_mode_outlined : Icons.dark_mode_outlined,
            key: ValueKey<bool>(dark),
            size: 18,
            color: p.ink,
          ),
        ),
      ),
    );
  }
}

/// Soft, blurred colour behind every screen: a few large green and grey
/// glows that drift slowly, like light through frosted glass. No lines.
class AuthBackdrop extends StatelessWidget {
  const AuthBackdrop({super.key, this.glow = true});

  final bool glow;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final Color green = p.accent.withValues(alpha: dark ? 0.26 : 0.20);
    final Color grey = dark
        ? const Color(0xFF8A958D).withValues(alpha: 0.14)
        : const Color(0xFF9AA59D).withValues(alpha: 0.18);
    final Color deep = dark
        ? const Color(0xFF0F5132).withValues(alpha: 0.32)
        : p.accent.withValues(alpha: 0.10);

    return Stack(
      fit: StackFit.expand,
      children: <Widget>[
        ColoredBox(color: p.background),
        if (glow) ...<Widget>[
          _Glow(
            color: green,
            at: const Offset(1.0, -0.02),
            size: 0.95,
            phase: 0,
          ),
          _Glow(
            color: grey,
            at: const Offset(-0.05, 0.5),
            size: 0.8,
            phase: 0.35,
          ),
          _Glow(
            color: deep,
            at: const Offset(0.75, 1.05),
            size: 0.95,
            phase: 0.7,
          ),
        ],
      ],
    );
  }
}

/// One large radial glow, fading to nothing at its edge, drifting on a
/// long loop. Radial gradients are already soft, so no blur pass is needed.
class _Glow extends StatelessWidget {
  const _Glow({
    required this.color,
    required this.at,
    required this.size,
    required this.phase,
  });

  final Color color;

  /// Centre as a fraction of the screen (0,0 top-left .. 1,1 bottom-right).
  /// Centres sit on or past the edges so the glow washes in from them.
  final Offset at;

  /// Diameter as a fraction of the screen's longer side.
  final double size;
  final double phase;

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    final double d = math.max(screen.width, screen.height) * size;
    return Positioned(
      left: at.dx * screen.width - d / 2,
      top: at.dy * screen.height - d / 2,
      width: d,
      height: d,
      child: Float(
        amplitude: 28,
        period: const Duration(seconds: 14),
        phase: phase,
        rotate: 0,
        child: SizedBox(
          width: d,
          height: d,
          child: DecoratedBox(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              gradient: RadialGradient(
                colors: <Color>[
                  color,
                  color.withValues(alpha: color.a * 0.45),
                  color.withValues(alpha: 0),
                ],
                stops: const <double>[0, 0.4, 1],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// The GROCERRA wordmark, text only, straight from the brand files:
/// `4.svg` on dark, `5.svg` on light, `6.svg` on brand green.
class Wordmark extends StatelessWidget {
  const Wordmark({super.key, this.width = 200, this.onGreen = false});

  final double width;

  /// Use the white-and-black version made for green surfaces.
  final bool onGreen;

  /// Width / height of the cropped artwork.
  static const double aspect = 6.77;

  @override
  Widget build(BuildContext context) {
    final bool dark = Theme.of(context).brightness == Brightness.dark;
    final String file = onGreen
        ? 'wordmark_on_green'
        : dark
        ? 'wordmark_dark'
        : 'wordmark_light';
    return SizedBox(
      width: width,
      height: width / aspect,
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 450),
        child: SvgPicture.asset(
          'assets/brand/$file.svg',
          key: ValueKey<String>(file),
          width: width,
          height: width / aspect,
        ),
      ),
    );
  }
}

/// Code entry: [length] boxes over one hidden field, so paste and SMS / email
/// autofill work. The active box glows, digits pop in as they land.
class OtpInput extends StatefulWidget {
  const OtpInput({
    super.key,
    required this.controller,
    this.length = 6,
    this.onCompleted,
    this.hasError = false,
  });

  final TextEditingController controller;
  final int length;
  final ValueChanged<String>? onCompleted;
  final bool hasError;

  @override
  State<OtpInput> createState() => _OtpInputState();
}

class _OtpInputState extends State<OtpInput>
    with SingleTickerProviderStateMixin {
  final FocusNode _focus = FocusNode();
  late final AnimationController _caret = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1000),
  );

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (Motion.reduced(context)) {
      _caret.value = 1;
    } else if (!_caret.isAnimating) {
      _caret.repeat(reverse: true);
    }
  }

  @override
  void initState() {
    super.initState();
    widget.controller.addListener(_changed);
    _focus.addListener(_changed);
  }

  void _changed() {
    setState(() {});
    final String v = widget.controller.text;
    if (v.length == widget.length) widget.onCompleted?.call(v);
  }

  @override
  void dispose() {
    widget.controller.removeListener(_changed);
    _focus.dispose();
    _caret.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final String value = widget.controller.text;

    return GestureDetector(
      onTap: () => _focus.requestFocus(),
      child: Stack(
        children: <Widget>[
          // The real input: invisible but focusable, so the keyboard,
          // paste and one-time-code autofill all work.
          Positioned.fill(
            child: Opacity(
              opacity: 0,
              child: TextField(
                controller: widget.controller,
                focusNode: _focus,
                autofocus: true,
                keyboardType: TextInputType.number,
                autofillHints: const <String>[AutofillHints.oneTimeCode],
                maxLength: widget.length,
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.digitsOnly,
                ],
                decoration: const InputDecoration(counterText: ''),
                showCursor: false,
              ),
            ),
          ),
          IgnorePointer(
            child: Row(
              children: <Widget>[
                for (int i = 0; i < widget.length; i++) ...<Widget>[
                  if (i > 0) const SizedBox(width: 10),
                  Expanded(child: _box(p, value, i)),
                ],
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _box(AuthPalette p, String value, int i) {
    final bool filled = i < value.length;
    final bool active = _focus.hasFocus && i == value.length;
    final Color border = widget.hasError
        ? p.danger
        : active
        ? p.accent
        : filled
        ? p.faint
        : p.fieldBorder.withValues(alpha: 0);

    return AspectRatio(
      aspectRatio: 0.86,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Motion.enter,
        decoration: BoxDecoration(
          color: p.field,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: border, width: 1.4),
          boxShadow: active
              ? <BoxShadow>[BoxShadow(color: p.accentSoft, spreadRadius: 4)]
              : const <BoxShadow>[],
        ),
        alignment: Alignment.center,
        child: AnimatedSwitcher(
          duration: const Duration(milliseconds: 280),
          switchInCurve: Curves.easeOutBack,
          transitionBuilder: (Widget c, Animation<double> a) =>
              ScaleTransition(scale: a, child: c),
          child: filled
              ? Text(
                  value[i],
                  key: ValueKey<String>('d$i${value[i]}'),
                  style: AuthType.title(p.ink).copyWith(fontSize: 26),
                )
              : active
              ? FadeTransition(
                  key: const ValueKey<String>('caret'),
                  opacity: _caret,
                  child: Container(width: 2, height: 24, color: p.accent),
                )
              : const SizedBox.shrink(key: ValueKey<String>('empty')),
        ),
      ),
    );
  }
}
