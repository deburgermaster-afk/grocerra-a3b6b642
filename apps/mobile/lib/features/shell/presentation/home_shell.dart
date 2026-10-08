import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_tab_bar.dart';
import '../../catering/presentation/catering_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../profile/presentation/profile_screen.dart';
import '../../search/presentation/search_overlay.dart';

/// Root shell: three tabs (Home - Catering - Profile) on a floating glass
/// bar, plus search.
///
/// Opening search is two moves: the bar's search pill stretches
/// right-to-left across the bar, then [SearchOverlay] lifts it from the
/// bottom of the screen into a full page. Closing plays both in reverse.
/// The bar floats over content; scrolling screens pad by
/// `AppInsets.tabBar`.
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const String routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell>
    with SingleTickerProviderStateMixin {
  int _index = 0;

  /// Search pill stretched across the bar.
  bool _stretched = false;

  /// Full-page search mounted (rising, open or falling).
  bool _overlay = false;

  late final AnimationController _rise = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 520),
    reverseDuration: const Duration(milliseconds: 420),
  );

  Timer? _pending;

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    CateringScreen(),
    ProfileScreen(),
  ];

  Future<void> _openSearch() async {
    if (_stretched) return;
    setState(() => _stretched = true);
    _pending?.cancel();
    _pending = Timer(GlassTabBar.expand, () {
      if (!mounted) return;
      setState(() => _overlay = true);
      _rise.forward(from: 0);
    });
  }

  Future<void> _closeSearch() async {
    _pending?.cancel();
    if (_overlay) {
      FocusManager.instance.primaryFocus?.unfocus();
      await _rise.reverse();
      if (!mounted) return;
      setState(() => _overlay = false);
    }
    setState(() => _stretched = false);
  }

  @override
  void dispose() {
    _pending?.cancel();
    _rise.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_stretched,
      onPopInvokedWithResult: (bool didPop, Object? _) {
        if (!didPop) _closeSearch();
      },
      child: Scaffold(
        backgroundColor: AppColors.surface,
        resizeToAvoidBottomInset: false,
        body: Stack(
          children: <Widget>[
            Positioned.fill(
              child: IndexedStack(index: _index, children: _tabs),
            ),
            GlassTabBar(
              index: _index,
              onSelect: (int value) => setState(() => _index = value),
              onSearchTap: _openSearch,
              searchExpanded: _stretched,
            ),
            if (_overlay)
              Positioned.fill(
                child: SearchOverlay(progress: _rise, onClose: _closeSearch),
              ),
          ],
        ),
      ),
    );
  }
}
