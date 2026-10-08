import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'order_issue_details_screen.dart';

/// Figma `E1 · Order Issue Category Selection` (390×844)
///
/// Entry point for customer disputes (entered from Tracking Help B9-B11
/// or past order Report an Issue C8):
/// - Displays target order reference (#9821 Madina Halal Meats)
/// - Australian Consumer Law (ACL) guarantee badge
/// - 5 categorical dispute triggers
class OrderIssueChooseScreen extends StatelessWidget {
  const OrderIssueChooseScreen({super.key});

  static const String routeName = '/order-issue';

  static const List<_IssueCategory> _categories = <_IssueCategory>[
    _IssueCategory(
      id: 'scale_discrepancy',
      title: 'Catch-Weight Scale Discrepancy',
      subtitle: 'Scale weight was less than pre-authorized hold amount',
      icon: Icons.scale_rounded,
    ),
    _IssueCategory(
      id: 'missing_item',
      title: 'Missing Item from Delivery Bag',
      subtitle: 'Paid for items that were not found in your sealed bags',
      icon: Icons.shopping_bag_outlined,
    ),
    _IssueCategory(
      id: 'damaged_item',
      title: 'Damaged or Leaking Item',
      subtitle: 'Containers opened or spilled during courier transit',
      icon: Icons.broken_image_outlined,
    ),
    _IssueCategory(
      id: 'quality_freshness',
      title: 'Quality or Freshness Issue',
      subtitle: 'Meat or produce failed Grocerra 100% freshness guarantee',
      icon: Icons.spa_outlined,
    ),
    _IssueCategory(
      id: 'wrong_substitution',
      title: 'Incorrect Butcher Substitution',
      subtitle: 'Received different cut or brand without approval',
      icon: Icons.swap_horiz_rounded,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            // Top Navigation Bar
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
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Order Help & Refund',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 40),
                children: <Widget>[
                  // Order Summary Card
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      children: <Widget>[
                        Container(
                          width: 44,
                          height: 44,
                          decoration: const BoxDecoration(
                            color: AppColors.surface,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.receipt_long_rounded, color: AppColors.ink),
                        ),
                        const SizedBox(width: 14),
                        const Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Order #9821 • Madina Halal Meats',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'Delivered to Coburg • \$53.99 AUD',
                                style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 18),

                  // ACL Guarantee Note
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: const Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Icon(Icons.verified_user_rounded, size: 20, color: Color(0xFF166534)),
                        SizedBox(width: 10),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                'Australian Consumer Law Guarantee',
                                style: TextStyle(
                                  fontSize: 13,
                                  fontWeight: FontWeight.w800,
                                  color: Color(0xFF166534),
                                ),
                              ),
                              SizedBox(height: 2),
                              Text(
                                'All Grocerra butcher scale weights are guaranteed accurate. Approved disputes receive instant wallet credit or direct Stripe card refunds.',
                                style: TextStyle(fontSize: 12, color: Color(0xFF15803D), height: 1.3),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  const Text(
                    'What went wrong with this order?',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.3,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),

                  // Issue Categories List
                  ..._categories.map((_IssueCategory cat) {
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 12),
                      child: GestureDetector(
                        onTap: () {
                          Navigator.of(context).pushNamed(
                            OrderIssueDetailsScreen.routeName,
                            arguments: <String, dynamic>{
                              'category': cat.title,
                              'categoryId': cat.id,
                            },
                          );
                        },
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            color: AppColors.surface,
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(color: AppColors.hairline),
                          ),
                          child: Row(
                            children: <Widget>[
                              Container(
                                width: 42,
                                height: 42,
                                decoration: const BoxDecoration(
                                  color: AppColors.surfaceAlt,
                                  shape: BoxShape.circle,
                                ),
                                child: Icon(cat.icon, size: 20, color: AppColors.ink),
                              ),
                              const SizedBox(width: 14),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(
                                      cat.title,
                                      style: const TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.w700,
                                        color: AppColors.ink,
                                      ),
                                    ),
                                    const SizedBox(height: 2),
                                    Text(
                                      cat.subtitle,
                                      style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                                    ),
                                  ],
                                ),
                              ),
                              const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.inkMuted),
                            ],
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _IssueCategory {
  const _IssueCategory({
    required this.id,
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String id;
  final String title;
  final String subtitle;
  final IconData icon;
}
