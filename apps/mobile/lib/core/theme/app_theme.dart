import 'package:flutter/material.dart';
import '../widgets/page_transitions.dart';

/// Grocerra design tokens.
///
/// Values are read directly off the approved Figma frames
/// (`GROCERRA - APP - Flow`), not approximated: every colour below is a hex
/// value that appears in a Figma paint, and Inter is the family used
/// throughout those frames.
abstract final class AppColors {
  static const Color accent = Color(0xFF16A34A);
  static const Color accentLight = Color(0xFFDCFCE7);
  static const Color accentDark = Color(0xFF0F7B4F);

  /// Body / heading ink. Figma text paints are pure black.
  static const Color ink = Color(0xFF000000);

  /// Secondary text, field labels and placeholders (`#6b6b6b` in Figma).
  static const Color inkMuted = Color(0xFF6B6B6B);

  static const Color canvas = Color(0xFFF7F7F8);
  static const Color surface = Color(0xFFFFFFFF);

  /// Input fills, segmented-control track and nav indicators (`#f3f3f3`).
  static const Color surfaceAlt = Color(0xFFF3F3F3);

  /// Hairline strokes - button outlines and dividers (`#e6e6e6`).
  static const Color hairline = Color(0xFFE6E6E6);
  static const Color danger = Color(0xFFDC2626);
}

abstract final class AppTheme {
  static ThemeData light() {
    const ColorScheme scheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.ink,
      onPrimary: AppColors.surface,
      secondary: AppColors.accent,
      onSecondary: AppColors.surface,
      error: AppColors.danger,
      onError: AppColors.surface,
      surface: AppColors.surface,
      onSurface: AppColors.ink,
      surfaceContainerHighest: AppColors.surfaceAlt,
      outline: AppColors.hairline,
    );

    return ThemeData(
      useMaterial3: true,
      // The approved Figma screens are set in Inter; declaring it here makes
      // every text style inherit it without repeating `fontFamily` per node.
      fontFamily: 'Inter',
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.canvas,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: <TargetPlatform, PageTransitionsBuilder>{
          TargetPlatform.android: SmoothPageTransitionsBuilder(),
          TargetPlatform.iOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.windows: SmoothPageTransitionsBuilder(),
          TargetPlatform.macOS: SmoothPageTransitionsBuilder(),
          TargetPlatform.linux: SmoothPageTransitionsBuilder(),
        },
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: AppColors.canvas,
        foregroundColor: AppColors.ink,
        elevation: 0,
        centerTitle: false,
        titleTextStyle: TextStyle(
          color: AppColors.ink,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.5,
        ),
      ),
      // Figma buttons are 56 tall with a 28 radius and a 16/600 label.
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.ink,
          foregroundColor: AppColors.surface,
          minimumSize: const Size.fromHeight(56),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(28),
          ),
          textStyle: const TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
      // Figma inputs are 52 tall, r16, `#f3f3f3`, 16px side padding with a
      // 16/500 `#6b6b6b` placeholder.
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        hintStyle: const TextStyle(
          color: AppColors.inkMuted,
          fontSize: 16,
          fontWeight: FontWeight.w500,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16.5,
        ),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
      ),
      navigationBarTheme: NavigationBarThemeData(
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.surfaceAlt,
        height: 64,
        labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return TextStyle(
            fontSize: 11,
            fontWeight: selected ? FontWeight.w700 : FontWeight.w500,
            color: selected ? AppColors.ink : AppColors.inkMuted,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith<IconThemeData>((
          Set<WidgetState> states,
        ) {
          final bool selected = states.contains(WidgetState.selected);
          return IconThemeData(
            size: 22,
            color: selected ? AppColors.ink : AppColors.inkMuted,
          );
        }),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.hairline,
        thickness: 1,
        space: 1,
      ),
      textTheme: const TextTheme(
        // Figma `Welcome back` / screen titles: 30/700, -2% tracking.
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
        ),
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
        ),
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w600,
        ),
        bodyMedium: TextStyle(color: AppColors.ink, fontSize: 15),
        bodySmall: TextStyle(color: AppColors.inkMuted, fontSize: 13),
        // Field labels, captions and legal lines: 12/500 `#6b6b6b`.
        labelMedium: TextStyle(
          color: AppColors.inkMuted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
        ),
        labelLarge: TextStyle(
          color: AppColors.accent,
          fontSize: 15,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
