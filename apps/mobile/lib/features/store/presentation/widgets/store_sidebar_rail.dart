import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';

class StoreNavItem {
  final String label;
  final String route;
  final IconData icon;
  final String? badge;

  const StoreNavItem({
    required this.label,
    required this.route,
    required this.icon,
    this.badge,
  });
}

class StoreSidebarRail extends StatelessWidget {
  final String currentRoute;
  final ValueChanged<String> onNavigate;
  final int incomingCount;

  const StoreSidebarRail({
    super.key,
    required this.currentRoute,
    required this.onNavigate,
    this.incomingCount = 1,
  });

  @override
  Widget build(BuildContext context) {
    final items = [
      StoreNavItem(
        label: 'Live',
        route: '/store/live',
        icon: Icons.local_mall_outlined,
        badge: incomingCount > 0 ? '$incomingCount' : null,
      ),
      const StoreNavItem(
        label: 'Orders',
        route: '/store/orders',
        icon: Icons.receipt_long_outlined,
      ),
      const StoreNavItem(
        label: 'Stats',
        route: '/store/analytics',
        icon: Icons.insights_outlined,
      ),
      const StoreNavItem(
        label: '86 Stock',
        route: '/store/inventory',
        icon: Icons.inventory_2_outlined,
      ),
      const StoreNavItem(
        label: 'Payouts',
        route: '/store/payouts',
        icon: Icons.account_balance_wallet_outlined,
      ),
      const StoreNavItem(
        label: 'Issues',
        route: '/store/issues',
        icon: Icons.report_problem_outlined,
      ),
      const StoreNavItem(
        label: 'Catering',
        route: '/store/catering',
        icon: Icons.room_service_outlined,
      ),
      const StoreNavItem(
        label: 'Settings',
        route: '/store/settings',
        icon: Icons.tune_outlined,
      ),
    ];

    return Container(
      width: 76,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        border: Border(
          right: BorderSide(color: AppColors.hairline, width: 1),
        ),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Expanded(
            child: ListView.separated(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              itemCount: items.length,
              separatorBuilder: (_, _) => const SizedBox(height: 8),
              itemBuilder: (context, index) {
                final item = items[index];
                final isActive = currentRoute == item.route ||
                    (item.route == '/store/live' && currentRoute == '/store');

                return Tooltip(
                  message: '${item.label} Module',
                  waitDuration: const Duration(milliseconds: 300),
                  child: InkWell(
                    onTap: () => onNavigate(item.route),
                    borderRadius: BorderRadius.circular(16),
                    child: Container(
                      height: 56,
                      decoration: BoxDecoration(
                        color: isActive ? const Color(0xFFECFDF5) : Colors.transparent,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isActive ? const Color(0xFFA7F3D0) : Colors.transparent,
                          width: 1,
                        ),
                      ),
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                item.icon,
                                size: 22,
                                color: isActive
                                    ? AppColors.accentDark
                                    : AppColors.inkMuted,
                              ),
                              const SizedBox(height: 3),
                              Text(
                                item.label,
                                style: TextStyle(
                                  fontSize: 10,
                                  fontWeight:
                                      isActive ? FontWeight.w700 : FontWeight.w600,
                                  color: isActive
                                      ? AppColors.accentDark
                                      : AppColors.inkMuted,
                                ),
                              ),
                            ],
                          ),
                          if (item.badge != null)
                            Positioned(
                              top: 4,
                              right: 4,
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                  horizontal: 5,
                                  vertical: 1.5,
                                ),
                                decoration: BoxDecoration(
                                  color: AppColors.accent,
                                  borderRadius: BorderRadius.circular(999),
                                  border: Border.all(
                                    color: Colors.white,
                                    width: 1.5,
                                  ),
                                ),
                                child: Text(
                                  item.badge!,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9.5,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.only(bottom: 12),
            child: Text(
              'v1.0',
              style: TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9CA3AF),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
