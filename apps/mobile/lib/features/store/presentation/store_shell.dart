import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';
import '../data/repositories/store_orders_repository.dart';
import 'widgets/store_header.dart';
import 'widgets/store_sidebar_rail.dart';
import 'live_orders_board_screen.dart';
import 'order_packing_screen.dart';
import 'order_history_screen.dart';
import 'store_analytics_screen.dart';
import 'store_payouts_screen.dart';
import 'store_issues_screen.dart';
import 'store_inventory_screen.dart';
import 'store_catering_screen.dart';
import 'store_settings_screen.dart';

class StoreShell extends StatefulWidget {
  final StoreOrdersRepository repository;
  final String initialRoute;

  const StoreShell({
    super.key,
    required this.repository,
    this.initialRoute = '/store/live',
  });

  @override
  State<StoreShell> createState() => _StoreShellState();
}

class _StoreShellState extends State<StoreShell> {
  late String _activeRoute;
  bool _isOpen = true;
  bool _isRushMode = false;
  bool _soundEnabled = true;

  @override
  void initState() {
    super.initState();
    _activeRoute = widget.initialRoute;
  }

  void _handleNavigate(String route) {
    setState(() {
      _activeRoute = route;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ShadTheme(
      data: ShadThemeData(
        colorScheme: const ShadGreenColorScheme.light(),
        radius: const BorderRadius.all(Radius.circular(8)),
      ),
      child: Scaffold(
        backgroundColor: AppColors.canvas,
        body: SafeArea(
          child: Column(
            children: [
              // Top Persistent Store Header
              StoreHeader(
                isOpen: _isOpen,
                onToggleOpen: (val) => setState(() => _isOpen = val),
                isRushMode: _isRushMode,
                onToggleRush: (val) => setState(() => _isRushMode = val),
                soundEnabled: _soundEnabled,
                onToggleSound: () => setState(() => _soundEnabled = !_soundEnabled),
              ),

              // Main Body: Left Sidebar Rail + Active Page Viewport
              Expanded(
                child: Row(
                  children: [
                    // Persistent Left Sidebar Rail
                    StoreSidebarRail(
                      currentRoute: _activeRoute,
                      onNavigate: _handleNavigate,
                      incomingCount: 1,
                    ),

                    // Main Viewport
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(20),
                        child: _buildActiveScreen(),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildActiveScreen() {
    switch (_activeRoute) {
      case '/store/live':
      case '/store':
        return LiveOrdersBoardScreen(
          repository: widget.repository,
          onOpenPackingStation: () => _handleNavigate('/store/packing'),
        );
      case '/store/orders':
      case '/store/history':
        return OrderHistoryScreen(
          repository: widget.repository,
        );
      case '/store/analytics':
        return const StoreAnalyticsScreen();
      case '/store/inventory':
        return const StoreInventoryScreen();
      case '/store/payouts':
        return const StorePayoutsScreen();
      case '/store/issues':
        return const StoreIssuesScreen();
      case '/store/catering':
        return const StoreCateringScreen();
      case '/store/settings':
        return const StoreSettingsScreen();
      case '/store/packing':
        return OrderPackingScreen(
          orderId: '8489',
          repository: widget.repository,
          onBackToLiveBoard: () => _handleNavigate('/store/live'),
        );
      default:
        return LiveOrdersBoardScreen(repository: widget.repository);
    }
  }
}
