import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';

/// Locks the Inter metrics used by the app against the text widths measured
/// from the approved Figma frames. A drift here means the bundled font
/// silently changed and every screen's alignment shifts with it.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUpAll(() async {
    final FontLoader loader = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'));
    await loader.load();
  });

  double widthOf(String text, double size, FontWeight weight, {double? letterSpacing}) {
    final TextPainter painter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontFamily: 'Inter',
          fontSize: size,
          fontWeight: weight,
          letterSpacing: letterSpacing,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    return painter.width;
  }

  test('Inter widths match the Figma A5 text nodes', () {
    // Figma `Welcome back` TEXT node: 209x36, Inter Bold 30, -2% tracking.
    final double title = widthOf('Welcome back', 30, FontWeight.w700, letterSpacing: -0.6);
    // Figma `GROCERRA` wordmark: 119x22, Inter Bold 18, +14% tracking.
    final double wordmark = widthOf('GROCERRA', 18, FontWeight.w700, letterSpacing: 2.52);

    debugPrint('title    = ${title.toStringAsFixed(1)} (Figma 209)');
    debugPrint('wordmark = ${wordmark.toStringAsFixed(1)} (Figma 119)');

    expect(title, closeTo(209, 8));
    expect(wordmark, closeTo(119, 6));
  });

  test('legal line fits the Figma content column on one line', () {
    // Figma `Terms` TEXT node sits at x=32 inside the 358px content column,
    // i.e. centred with 16px either side, and renders as a single 326x15 line.
    const String legal = 'By continuing you agree to our Terms and Privacy Policy.';
    final double width = widthOf(legal, 12, FontWeight.w500);
    debugPrint('legal    = ${width.toStringAsFixed(1)} (Figma 326, column 358)');

    expect(width, closeTo(326, 2));
    expect(width, lessThanOrEqualTo(358));
  });
}
