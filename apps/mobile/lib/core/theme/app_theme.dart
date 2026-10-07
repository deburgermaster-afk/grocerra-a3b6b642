import 'package:flutter/material.dart';

/// Grocerra design tokens.
///
/// Values are read directly off the approved Figma frames
/// (`GROCERRA - APP - Flow`), not approximated: every colour below is a hex
/// value that appears in a Figma paint, and Inter is the family used
/// throughout those frames.
abstract final class AppColors {
  static const Color accent = Color(0xFF16A34A);
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
      // The Figma local text styles are the type scale. `height` is the Figma
      // line height divided by the font size (Figma pins line height in px),
      // written out so the source px stays readable.
      textTheme: const TextTheme(
        // `Display` 42/700, 0%, 51px.
        displayMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 42,
          fontWeight: FontWeight.w700,
          height: 1.2143, // 51px
        ),
        // `H1` 30/700, -2% (=-0.6px), 36px - screen titles.
        headlineMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 30,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.6,
          height: 1.2, // 36px
        ),
        // `H2` 28/700, 0%, 34px - section / two-line titles.
        headlineSmall: TextStyle(
          color: AppColors.ink,
          fontSize: 28,
          fontWeight: FontWeight.w700,
          height: 1.2143, // 34px
        ),
        // `H3` 20/700, 0%, 24px - in-page section headings.
        titleLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 20,
          fontWeight: FontWeight.w700,
          height: 1.2, // 24px
        ),
        // Row titles and button labels: 16/600, 19px.
        titleMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w600,
          height: 1.1875, // 19px
        ),
        // `Body - Large` 16/400, 0%, 19px.
        bodyLarge: TextStyle(
          color: AppColors.ink,
          fontSize: 16,
          fontWeight: FontWeight.w400,
          height: 1.1875, // 19px
        ),
        // `Body - Medium` 14/400, 0%, 17px - default body copy.
        bodyMedium: TextStyle(
          color: AppColors.ink,
          fontSize: 14,
          fontWeight: FontWeight.w400,
          height: 1.2143, // 17px
        ),
        // `Body - Small` 13/400, 0%, 16px - secondary copy.
        bodySmall: TextStyle(
          color: AppColors.inkMuted,
          fontSize: 13,
          fontWeight: FontWeight.w400,
          height: 1.2308, // 16px
        ),
        // `Caption` 12/500, 0%, 15px - field labels, captions, legal lines.
        labelMedium: TextStyle(
          color: AppColors.inkMuted,
          fontSize: 12,
          fontWeight: FontWeight.w500,
          height: 1.25, // 15px
        ),
        // `Label` 15/600, 0%, 18px - links and emphasis.
        labelLarge: TextStyle(
          color: AppColors.accent,
          fontSize: 15,
          fontWeight: FontWeight.w600,
          height: 1.2, // 18px
        ),
      ),
    );
  }
}

/// Figma effect styles `Elevation - 1/2/3` (drop shadows, applied as box
/// shadows so they can sit on frames that are not `Card`s).
abstract final class AppShadows {
  /// `Elevation - 1` - 0 4 16 rgba(0,0,0,0.08).
  static const List<BoxShadow> e1 = <BoxShadow>[
    BoxShadow(color: Color(0x14000000), offset: Offset(0, 4), blurRadius: 16),
  ];

  /// `Elevation - 2` - 0 8 32 rgba(0,0,0,0.12).
  static const List<BoxShadow> e2 = <BoxShadow>[
    BoxShadow(color: Color(0x1F000000), offset: Offset(0, 8), blurRadius: 32),
  ];

  /// `Elevation - 3` - 0 8 32 rgba(0,0,0,0.16).
  static const List<BoxShadow> e3 = <BoxShadow>[
    BoxShadow(color: Color(0x29000000), offset: Offset(0, 8), blurRadius: 32),
  ];
}

/// Figma `GROCERRA - Radius` and the radii that appear on the approved user
/// app frames. `full` maps to Figma's `full` (999) - pill / circle shapes.
abstract final class AppRadius {
  static const double none = 0;
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16; // inputs
  static const double xl = 20; // cards
  static const double xxl = 24; // chips, circular icon buttons
  static const double button = 28; // 56-tall buttons
  static const double full = 999;
}

/// Figma `GROCERRA - Spacing` scale (4, 8, 12, 16, 24, 32, 48, 64).
abstract final class AppSpace {
  static const double s1 = 4;
  static const double s2 = 8;
  static const double s3 = 12;
  static const double s4 = 16;
  static const double s5 = 24;
  static const double s6 = 32;
  static const double s7 = 48;
  static const double s8 = 64;
}
