import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Colour tokens for the welcome, onboarding and auth flow.
///
/// Black, grey and a restrained green, in a dark and a light variant. It is a
/// [ThemeExtension] so [AnimatedTheme] cross-fades every token when the
/// brightness flips, instead of the screen snapping between palettes.
@immutable
class AuthPalette extends ThemeExtension<AuthPalette> {
  const AuthPalette({
    required this.background,
    required this.surface,
    required this.field,
    required this.fieldBorder,
    required this.ink,
    required this.muted,
    required this.faint,
    required this.primary,
    required this.onPrimary,
    required this.secondary,
    required this.onSecondary,
    required this.accent,
    required this.accentSoft,
    required this.danger,
    required this.lineArt,
    required this.lineFill,
  });

  static const AuthPalette dark = AuthPalette(
    background: Color(0xFF0A0B0A),
    surface: Color(0xFF141614),
    field: Color(0xFF191C1A),
    fieldBorder: Color(0xFF262A27),
    ink: Color(0xFFF4F6F4),
    muted: Color(0xFF8B938D),
    faint: Color(0xFF59605B),
    primary: Color(0xFFFFFFFF),
    onPrimary: Color(0xFF0A0B0A),
    secondary: Color(0xFF1C1F1D),
    onSecondary: Color(0xFFF4F6F4),
    accent: Color(0xFF22C55E),
    accentSoft: Color(0x2622C55E),
    danger: Color(0xFFF87171),
    lineArt: Color(0xFFE6EAE6),
    lineFill: Color(0xFF1A1E1B),
  );

  static const AuthPalette light = AuthPalette(
    background: Color(0xFFF6F7F5),
    surface: Color(0xFFFFFFFF),
    field: Color(0xFFECEEEB),
    fieldBorder: Color(0xFFDFE2DE),
    ink: Color(0xFF0B0D0B),
    muted: Color(0xFF656C66),
    faint: Color(0xFFA0A6A1),
    primary: Color(0xFF0B0D0B),
    onPrimary: Color(0xFFFFFFFF),
    secondary: Color(0xFFE6E9E5),
    onSecondary: Color(0xFF0B0D0B),
    accent: Color(0xFF16A34A),
    accentSoft: Color(0x2216A34A),
    danger: Color(0xFFDC2626),
    lineArt: Color(0xFF121412),
    lineFill: Color(0xFFFFFFFF),
  );

  final Color background;
  final Color surface;
  final Color field;
  final Color fieldBorder;
  final Color ink;
  final Color muted;
  final Color faint;

  /// The high-contrast pill (white on dark, black on light).
  final Color primary;
  final Color onPrimary;

  /// The quiet grey pill (social sign-in, secondary actions).
  final Color secondary;
  final Color onSecondary;
  final Color accent;
  final Color accentSoft;
  final Color danger;

  /// Stroke and paper colours for the line illustrations.
  final Color lineArt;
  final Color lineFill;

  static AuthPalette of(BuildContext context) =>
      Theme.of(context).extension<AuthPalette>() ?? dark;

  @override
  AuthPalette copyWith() => this;

  @override
  AuthPalette lerp(AuthPalette? other, double t) {
    if (other == null) return this;
    Color l(Color a, Color b) => Color.lerp(a, b, t)!;
    return AuthPalette(
      background: l(background, other.background),
      surface: l(surface, other.surface),
      field: l(field, other.field),
      fieldBorder: l(fieldBorder, other.fieldBorder),
      ink: l(ink, other.ink),
      muted: l(muted, other.muted),
      faint: l(faint, other.faint),
      primary: l(primary, other.primary),
      onPrimary: l(onPrimary, other.onPrimary),
      secondary: l(secondary, other.secondary),
      onSecondary: l(onSecondary, other.onSecondary),
      accent: l(accent, other.accent),
      accentSoft: l(accentSoft, other.accentSoft),
      danger: l(danger, other.danger),
      lineArt: l(lineArt, other.lineArt),
      lineFill: l(lineFill, other.lineFill),
    );
  }
}

/// The viewer's light / dark / system choice, remembered on the device.
abstract final class AuthThemeMode {
  static const String _key = 'grocerra.theme_mode';

  /// Defaults to dark, the reference look, until the viewer picks.
  static final ValueNotifier<ThemeMode> notifier = ValueNotifier<ThemeMode>(
    ThemeMode.dark,
  );

  static Future<void> load() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? stored = prefs.getString(_key);
      notifier.value = ThemeMode.values.firstWhere(
        (ThemeMode mode) => mode.name == stored,
        orElse: () => ThemeMode.dark,
      );
    } catch (_) {
      // Storage unavailable (private window): keep the default.
    }
  }

  static Future<void> toggle(Brightness current) async {
    notifier.value = current == Brightness.dark
        ? ThemeMode.light
        : ThemeMode.dark;
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString(_key, notifier.value.name);
    } catch (_) {}
  }

  static Brightness resolve(BuildContext context, ThemeMode mode) =>
      switch (mode) {
        ThemeMode.dark => Brightness.dark,
        ThemeMode.light => Brightness.light,
        ThemeMode.system => MediaQuery.platformBrightnessOf(context),
      };
}

/// Type scale for the flow, set in Geist.
abstract final class AuthType {
  static const String family = 'Geist';
  static const String accentFamily = 'InstrumentSerif';

  /// Screen titles: "Hey, Welcome Back".
  static TextStyle title(Color color) => TextStyle(
    fontFamily: family,
    fontSize: 36,
    height: 1.08,
    fontWeight: FontWeight.w600,
    letterSpacing: -1.4,
    color: color,
  );

  /// Hero lines on welcome and onboarding.
  static TextStyle hero(Color color) => TextStyle(
    fontFamily: family,
    fontSize: 34,
    height: 1.12,
    fontWeight: FontWeight.w500,
    letterSpacing: -1.2,
    color: color,
  );

  /// The editorial italic word ("Fresh.").
  static TextStyle accent(Color color, double size) => TextStyle(
    fontFamily: accentFamily,
    fontStyle: FontStyle.italic,
    fontSize: size * 1.12,
    height: 1.0,
    letterSpacing: -0.4,
    color: color,
  );

  static TextStyle body(Color color) => TextStyle(
    fontFamily: family,
    fontSize: 15,
    height: 1.45,
    fontWeight: FontWeight.w400,
    letterSpacing: -0.15,
    color: color,
  );

  static TextStyle label(Color color) => TextStyle(
    fontFamily: family,
    fontSize: 16,
    height: 1.2,
    fontWeight: FontWeight.w600,
    letterSpacing: -0.2,
    color: color,
  );

  static TextStyle small(Color color) => TextStyle(
    fontFamily: family,
    fontSize: 13.5,
    height: 1.3,
    fontWeight: FontWeight.w500,
    letterSpacing: -0.1,
    color: color,
  );
}

/// Wraps an auth-flow screen in its palette, Geist type and system bar style,
/// animating between dark and light.
class AuthScope extends StatelessWidget {
  const AuthScope({super.key, required this.child});

  final Widget child;

  static ThemeData themeFor(Brightness brightness) {
    final AuthPalette p = brightness == Brightness.dark
        ? AuthPalette.dark
        : AuthPalette.light;
    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      fontFamily: AuthType.family,
      scaffoldBackgroundColor: p.background,
      colorScheme: ColorScheme.fromSeed(
        seedColor: p.accent,
        brightness: brightness,
        primary: p.primary,
        onPrimary: p.onPrimary,
        surface: p.background,
        onSurface: p.ink,
        error: p.danger,
      ),
      textSelectionTheme: TextSelectionThemeData(
        cursorColor: p.accent,
        selectionColor: p.accentSoft,
        selectionHandleColor: p.accent,
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: p.ink,
        contentTextStyle: AuthType.small(p.background),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      splashFactory: NoSplash.splashFactory,
      highlightColor: Colors.transparent,
      extensions: <ThemeExtension<dynamic>>[p],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: AuthThemeMode.notifier,
      builder: (BuildContext context, ThemeMode mode, Widget? _) {
        final Brightness brightness = AuthThemeMode.resolve(context, mode);
        final bool dark = brightness == Brightness.dark;
        return AnnotatedRegion<SystemUiOverlayStyle>(
          value: dark ? SystemUiOverlayStyle.light : SystemUiOverlayStyle.dark,
          child: AnimatedTheme(
            data: themeFor(brightness),
            duration: const Duration(milliseconds: 450),
            curve: Curves.easeInOutCubic,
            child: child,
          ),
        );
      },
    );
  }
}
