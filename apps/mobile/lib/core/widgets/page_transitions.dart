import 'package:flutter/material.dart';

/// Smooth fluid page route transitions for Grocerra.
/// Provides easeOutCubic slide + soft fade and subtle scale when changing screens.
class SmoothPageRoute<T> extends PageRouteBuilder<T> {
  SmoothPageRoute({
    required this.builder,
    super.settings,
    this.transitionType = PageTransitionType.slideRight,
    Duration duration = const Duration(milliseconds: 320),
    Duration reverseDuration = const Duration(milliseconds: 260),
  }) : super(
          pageBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
          ) =>
              builder(context),
          transitionDuration: duration,
          reverseTransitionDuration: reverseDuration,
          transitionsBuilder: (
            BuildContext context,
            Animation<double> animation,
            Animation<double> secondaryAnimation,
            Widget child,
          ) {
            final CurvedAnimation curved = CurvedAnimation(
              parent: animation,
              curve: Curves.easeOutCubic,
              reverseCurve: Curves.easeInCubic,
            );

            switch (transitionType) {
              case PageTransitionType.slideRight:
                final Animation<Offset> slide = Tween<Offset>(
                  begin: const Offset(0.08, 0.0),
                  end: Offset.zero,
                ).animate(curved);
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                  child: SlideTransition(position: slide, child: child),
                );

              case PageTransitionType.slideUp:
                final Animation<Offset> slide = Tween<Offset>(
                  begin: const Offset(0.0, 0.12),
                  end: Offset.zero,
                ).animate(curved);
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                  child: SlideTransition(position: slide, child: child),
                );

              case PageTransitionType.zoomFade:
                final Animation<double> scale = Tween<double>(
                  begin: 0.94,
                  end: 1.0,
                ).animate(curved);
                return FadeTransition(
                  opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
                  child: ScaleTransition(scale: scale, child: child),
                );
            }
          },
        );

  final WidgetBuilder builder;
  final PageTransitionType transitionType;
}

enum PageTransitionType {
  slideRight,
  slideUp,
  zoomFade,
}

/// Global PageTransitionsBuilder that can be injected into ThemeData
class SmoothPageTransitionsBuilder extends PageTransitionsBuilder {
  const SmoothPageTransitionsBuilder();

  @override
  Widget buildTransitions<T>(
    PageRoute<T> route,
    BuildContext context,
    Animation<double> animation,
    Animation<double> secondaryAnimation,
    Widget child,
  ) {
    final CurvedAnimation curved = CurvedAnimation(
      parent: animation,
      curve: Curves.easeOutCubic,
      reverseCurve: Curves.easeInCubic,
    );

    final Animation<Offset> slide = Tween<Offset>(
      begin: const Offset(0.06, 0.0),
      end: Offset.zero,
    ).animate(curved);

    return FadeTransition(
      opacity: Tween<double>(begin: 0.0, end: 1.0).animate(curved),
      child: SlideTransition(position: slide, child: child),
    );
  }
}
