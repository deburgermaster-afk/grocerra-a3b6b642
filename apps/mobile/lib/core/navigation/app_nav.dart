import 'package:flutter/material.dart';

/// Back navigation that also works on a cold start.
///
/// Screens reached by pushing (Store, Product, Cart, Checkout, Search,
/// Account sub-pages, ...) normally pop back to the screen beneath them.
/// When the same route is opened directly (browser reload, deep link,
/// restart) there is nothing beneath it, and a plain `maybePop()` silently
/// does nothing - the back control looks broken.
///
/// Every back control calls this instead: pop when there is a route to pop,
/// otherwise clear the stack and push [fallbackRoute] - the screen's designed
/// parent (Store -> Home, Product -> Store, Cart -> Home, ...). The
/// initializer in `app.dart` builds deep links as a single-entry stack, so
/// `canPop()` is an honest signal of "was this pushed".
void popOrFallback(BuildContext context, String fallbackRoute) {
  final NavigatorState navigator = Navigator.of(context);
  if (navigator.canPop()) {
    navigator.pop();
  } else {
    navigator.pushNamedAndRemoveUntil(
      fallbackRoute,
      (Route<dynamic> route) => false,
    );
  }
}
