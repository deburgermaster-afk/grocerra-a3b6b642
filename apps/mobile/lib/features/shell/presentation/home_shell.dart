import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glass_tab_bar.dart';
import '../../browse/presentation/browse_screen.dart';
import '../../catering/presentation/catering_screen.dart';
import '../../home/presentation/home_screen.dart';
import '../../orders/presentation/orders_screen.dart';
import '../../profile/presentation/profile_screen.dart';

/// Root shell: the floating five-tab navigation bar
/// (Home - Browse - Catering - Orders - Profile) from Figma `Tab bar - glass`.
///
/// The bar floats over the content exactly as it does in the frames (B1 places
/// it at y769 on a white canvas) rather than reserving space, so screens keep
/// the coordinates Figma gives them. Screens that scroll should pad their
/// content by [AppInsets.tabBar].
class HomeShell extends StatefulWidget {
  const HomeShell({super.key});

  static const String routeName = '/home';

  @override
  State<HomeShell> createState() => _HomeShellState();
}

class _HomeShellState extends State<HomeShell> {
  int _index = 0;

  static const List<Widget> _tabs = <Widget>[
    HomeScreen(),
    BrowseScreen(),
    CateringScreen(),
    OrdersScreen(),
    ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          Positioned.fill(
            child: IndexedStack(index: _index, children: _tabs),
          ),
          GlassTabBar(
            index: _index,
            onSelect: (int value) => setState(() => _index = value),
          ),
        ],
      ),
    );
  }
}
