import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_quote_review_screen.dart';
import '../../support/presentation/order_issue_choose_screen.dart';

/// Figma `C8 · Catering order / Request tracking` (390×844)
///
/// Post-submission live request & order tracking screen:
/// - Title: "Catering Request Details"
/// - Request ID badge (#CR-20418 · Wedding · 80 guests)
/// - Stepper timeline:
///   1. Request sent (Sat, 24 Oct)
///   2. Quote received (Madina Halal Catering · $1,240) [ACTIVE]
///   3. Confirmed & deposit paid
///   4. Prep & cooking
///   5. Delivered & setup
/// - Quote Action Card: "Review Caterer Quote ($1,240)" -> C5
/// - Order Details: Venue, items, timing
/// - Action grid buttons: Contact caterer, View receipt, Request changes, Report an issue
class CateringRequestDetailsScreen extends StatelessWidget {
  const CateringRequestDetailsScreen({super.key});

  static const String routeName = '/catering/request-details';

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final Map<String, dynamic> args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            <String, dynamic>{};

    final String eventPlanning = (args['planning'] as String?) ?? 'Wedding';
    final int guestCount = (args['guestCount'] as int?) ?? 80;
    final String eventDate = (args['eventDate'] as String?) ?? 'Sat, 24 Oct 2026';
    final String location = (args['location'] as String?) ?? '24 Maple Street, Apt 3B';

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
                        'Catering Request Details',
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
                padding: const EdgeInsets.fromLTRB(20, 16, 20, 32),
                children: <Widget>[
                  // Request Reference Header
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const <Widget>[
                          Text(
                            'Request #CR-20418',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Submitted 10 mins ago',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                      Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFFDCFCE7),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Text(
                          'ACTIVE',
                          style: TextStyle(
                            color: Color(0xFF15803D),
                            fontSize: 11,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // Ready Quote Card (CTA to review quote)
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF0FDF4),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFBBF7D0)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            Icon(Icons.check_circle_rounded, color: Color(0xFF15803D), size: 18),
                            SizedBox(width: 8),
                            Text(
                              'Quote Received · Madina Halal Catering',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                                color: Color(0xFF15803D),
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        const Text(
                          'Total: \$1,240 AUD (Deposit \$372 due to lock booking)',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFF166534),
                          ),
                        ),
                        const SizedBox(height: 12),
                        FilledButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(
                              CateringQuoteReviewScreen.routeName,
                              arguments: args,
                            );
                          },
                          style: FilledButton.styleFrom(
                            backgroundColor: AppColors.ink,
                            minimumSize: const Size(double.infinity, 44),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                          ),
                          child: const Text(
                            'Review Quote & Accept (\$1,240)',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Stepper / Timeline
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildTimelineStep(
                          title: 'Request sent',
                          subtitle: 'Sat, 24 Oct · Details submitted',
                          isCompleted: true,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'Quote ready for review',
                          subtitle: 'Madina Halal Catering submitted quote',
                          isActive: true,
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'Deposit & confirmation',
                          subtitle: 'Pay 30% deposit to lock booking',
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'Prep & cooking',
                          isLast: false,
                        ),
                        _buildTimelineStep(
                          title: 'Delivered / set up',
                          isLast: true,
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Event Logistics Card
                  Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          '$eventPlanning · $guestCount guests',
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w800,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          'Melbourne · $eventDate',
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          location,
                          style: const TextStyle(
                            fontSize: 13,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        const Divider(height: 20, color: Color(0xFFF4F4F5)),
                        const Text(
                          'Menu preferences: Goat biryani, Goat curry, Seekh kebabs, Gulab jamun',
                          style: TextStyle(
                            fontSize: 13,
                            color: AppColors.ink,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Action Buttons Grid (2 rows)
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Calling Madina Halal Catering (+61 3 9481 2299)...')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Contact caterer', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Viewing preliminary quote receipt...')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('View quote', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request changes dialog.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Request changes', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pushNamed(OrderIssueChooseScreen.routeName);
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          ),
                          child: const Text('Report an issue', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // Policy note footer
                  Center(
                    child: Column(
                      children: const <Widget>[
                        Text(
                          'Changes allowed until Wed, 21 Oct.',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'Cancel request · Free cancellation until 7 days before. See terms',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildTimelineStep({
    required String title,
    String? subtitle,
    bool isCompleted = false,
    bool isActive = false,
    required bool isLast,
  }) {
    Color dotColor;
    if (isActive) {
      dotColor = const Color(0xFF16A34A); // Green active
    } else if (isCompleted) {
      dotColor = AppColors.ink;
    } else {
      dotColor = const Color(0xFFD4D4D8);
    }

    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Column(
          children: <Widget>[
            Container(
              width: 12,
              height: 12,
              decoration: BoxDecoration(
                color: (isActive || isCompleted) ? dotColor : Colors.white,
                shape: BoxShape.circle,
                border: Border.all(
                  color: dotColor,
                  width: (isActive || isCompleted) ? 0 : 2,
                ),
              ),
            ),
            if (!isLast)
              Container(
                width: 2,
                height: 32,
                color: const Color(0xFFE4E4E7),
              ),
          ],
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: (isActive || isCompleted) ? FontWeight.w700 : FontWeight.w500,
                  color: (isActive || isCompleted) ? AppColors.ink : AppColors.inkMuted,
                ),
              ),
              if (subtitle != null) ...<Widget>[
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: const TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
