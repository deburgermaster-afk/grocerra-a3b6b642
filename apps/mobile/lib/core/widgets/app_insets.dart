import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Vertical insets the approved Figma frames assume.
///
/// Every Figma frame starts with a 47px status bar. On Chrome the browser
/// supplies no safe-area inset, so screens must reserve that height
/// explicitly or their content lands 47px too high.
abstract final class AppInsets {
  /// Height of the Figma status bar. Never smaller than the platform inset so
  /// a notch on a real device still clears.
  static double statusBar(BuildContext context) =>
      math.max(MediaQuery.of(context).padding.top, 47);

  /// Clearance for the floating 64px tab bar (Figma: y769, 11px from the
  /// bottom), so scrolling content ends underneath it instead of behind it.
  static const double tabBar = 88;
}
