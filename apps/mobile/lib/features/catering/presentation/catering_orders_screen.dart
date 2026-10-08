import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_request_details_screen.dart';

/// Figma `C·S3 · Catering orders — List` (390×844)
///
/// Customer's catering bookings history screen:
/// - Title: "Catering orders"
/// - Upcoming section:
///   - Wedding · 80 guests, Sat, 24 Oct 2026 [Confirmed - black badge]
/// - Past section:
///   - Birthday · 25 guests, Sat, 6 Sep 2026 [Delivered - green badge]
///   - Eid · 60 guests, Sun, 14 Jun 2026 [Cancelled - gray badge]
/// - Tapping any card opens live order details (C8)
class CateringOrdersScreen extends StatelessWidget {
  const CateringOrdersScreen({super.key});

  static const String routeName = '/catering/orders';

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            // Navigation Bar
            Container(
              padding: EdgeInsets.fromLTRB(16, topInset, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.hairline)),
              ),
              child: Row(
                children: <Widget>[
                  RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Catering orders',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 20, 16, 32),
                children: <Widget>[
                  // Upcoming Section
                  const Text(
                    'Upcoming',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    context: context,
                    title: 'Wedding · 80 guests',
                    date: 'Sat, 24 Oct 2026',
                    status: 'Confirmed',
                    statusBg: AppColors.ink,
                    statusTextColor: Colors.white,
                  ),

                  const SizedBox(height: 28),

                  // Past Section
                  const Text(
                    'Past',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    context: context,
                    title: 'Birthday · 25 guests',
                    date: 'Sat, 6 Sep 2026',
                    status: 'Delivered',
                    statusBg: const Color(0xFFDCFCE7),
                    statusTextColor: const Color(0xFF15803D),
                  ),
                  const SizedBox(height: 12),
                  _buildOrderCard(
                    context: context,
                    title: 'Eid · 60 guests',
                    date: 'Sun, 14 Jun 2026',
                    status: 'Cancelled',
                    statusBg: const Color(0xFFF4F4F5),
                    statusTextColor: AppColors.inkMuted,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildOrderCard({
    required BuildContext context,
    required String title,
    required String date,
    required String status,
    required Color statusBg,
    required Color statusTextColor,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: () {
        Navigator.of(context).pushNamed(CateringRequestDetailsScreen.routeName);
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFFE4E4E7)),
        ),
        child: Row(
          children: <Widget>[
            // Black circle icon
            Container(
              width: 44,
              height: 44,
              decoration: const BoxDecoration(
                color: Color(0xFF18181B),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.restaurant_rounded,
                color: Colors.white,
                size: 20,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    date,
                    style: const TextStyle(
                      fontSize: 13,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: statusBg,
                borderRadius: BorderRadius.circular(14),
              ),
              child: Text(
                status,
                style: TextStyle(
                  color: statusTextColor,
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
