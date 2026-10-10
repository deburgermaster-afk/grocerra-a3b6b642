import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_checkout_screen.dart';

/// Figma `C5 · Quote review` (390×844)
///
/// Customer reviews quote provided by caterer:
/// - Title: "Your catering quote"
/// - Event, Date, Caterer summary card
/// - Menu items breakdown (Goat biryani, Goat curry, Seekh kebabs, Gulab jamun)
/// - Total $1,240 (Delivery & setup included)
/// - Actions: "Request changes", "Decline", and primary "Accept quote" -> C6
class CateringQuoteReviewScreen extends StatelessWidget {
  const CateringQuoteReviewScreen({
    super.key,
    this.guestCount = 80,
  });

  final int guestCount;

  static const String routeName = '/catering/quote-review';

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final Map<String, dynamic> args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            <String, dynamic>{};

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
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Your catering quote',
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
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  // Quote Details Card
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        _buildDetailRow('Event', 'Wedding · 80 guests · Melbourne'),
                        const SizedBox(height: 12),
                        _buildDetailRow('Date', 'Sat, 24 Oct 2026'),
                        const SizedBox(height: 12),
                        _buildDetailRow('Caterer', 'Madina Halal Catering'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // Menu Section
                  const Text(
                    'Menu',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  _buildMenuItemRow('Goat biryani', 'Serves 80'),
                  const Divider(height: 20, color: Color(0xFFF4F4F5)),
                  _buildMenuItemRow('Goat curry', 'Serves 80'),
                  const Divider(height: 20, color: Color(0xFFF4F4F5)),
                  _buildMenuItemRow('Seekh kebabs', '80 pieces'),
                  const Divider(height: 20, color: Color(0xFFF4F4F5)),
                  _buildMenuItemRow('Gulab jamun', '80 pieces'),

                  const SizedBox(height: 28),

                  // Total Box
                  const Text(
                    'Total',
                    style: TextStyle(
                      fontSize: 14,
                      color: AppColors.inkMuted,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.baseline,
                    textBaseline: TextBaseline.alphabetic,
                    children: const <Widget>[
                      Text(
                        '\$1,240',
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                          letterSpacing: -0.5,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  const Text(
                    'Delivery & setup included',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.inkMuted,
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Secondary Actions: Request changes / Decline
                  Row(
                    children: <Widget>[
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(content: Text('Request changes message sent to caterer.')),
                            );
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: AppColors.ink,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: AppColors.outline),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'Request changes',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFFDC2626),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                            side: const BorderSide(color: Color(0xFFFEE2E2)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                          ),
                          child: const Text(
                            'Decline',
                            style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),

            // Bottom CTA: Accept quote -> C6
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CateringCheckoutScreen.routeName,
                    arguments: <String, dynamic>{
                      ...args,
                      'total': '\$1,240',
                      'deposit': '\$372',
                      'balance': '\$868',
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: const Text(
                  'Accept quote',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildDetailRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
        ),
        Text(
          value,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
        ),
      ],
    );
  }

  static Widget _buildMenuItemRow(String name, String serves) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: AppColors.ink),
        ),
        Text(
          serves,
          style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
        ),
      ],
    );
  }
}
