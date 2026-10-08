import 'dart:math' as math;

import 'package:flutter/widgets.dart';

/// Vertical insets shared by the shell screens.
abstract final class AppInsets {
  /// Top inset. Kept compact: on a phone this is the real notch / status-bar inset;
  /// in a browser, where there is none, just a 12px breathing gap instead of
  /// the Figma frame's mock 47px status bar.
  static double statusBar(BuildContext context) =>
      math.max(MediaQuery.of(context).padding.top, 12);

  /// Clearance for the floating 64px tab bar (Figma: y769, 11px from the
  /// bottom), so scrolling content ends underneath it instead of behind it.
  static const double tabBar = 88;
}
