import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../shell/presentation/home_shell.dart';

/// Figma `E3 · Claim Submitted & SLA Guarantee` (390×844)
///
/// Dispute confirmation screen:
/// - Support reference code `#TICK-GROC-4819`
/// - 2-hour Melbourne support review promise
/// - Automatic Stripe / Grocerra credit refund
/// - Navigation back to home shell
class OrderIssueSubmittedScreen extends StatelessWidget {
  const OrderIssueSubmittedScreen({super.key});

  static const String routeName = '/order-issue/submitted';

  @override
  Widget build(BuildContext context) {
    const String ticketId = 'TICK-GROC-4819';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              const Spacer(),

              // Victory Checkmark Badge
              Container(
                width: 80,
                height: 80,
                decoration: const BoxDecoration(
                  color: AppColors.accentDark,
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.assignment_turned_in_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),

              const SizedBox(height: 24),

              const Text(
                'Claim Submitted!',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.6,
                ),
              ),
              const SizedBox(height: 6),
              const Text(
                'Ticket Reference #$ticketId',
                style: TextStyle(
                  color: AppColors.accentDark,
                  fontSize: 15,
                  fontWeight: FontWeight.w800,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                'Your dispute has been logged with our Melbourne customer care team.',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 14,
                ),
              ),

              const SizedBox(height: 32),

              // SLA Card
              Container(
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surfaceAlt,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Column(
                  children: <Widget>[
                    _SupportRow(
                      icon: Icons.timer_outlined,
                      title: '2-Hour Review Guarantee',
                      subtitle: 'Reviewed directly by local Melbourne operations',
                    ),
                    Divider(height: 20, color: AppColors.hairline),
                    _SupportRow(
                      icon: Icons.currency_exchange_rounded,
                      title: 'Direct Refund Credited',
                      subtitle: 'Processed straight to your chosen refund method',
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // Primary CTA
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    HomeShell.routeName,
                    (Route<dynamic> r) => false,
                  );
                },
                child: const Text('Back to Home'),
              ),
              const SizedBox(height: 12),
            ],
          ),
        ),
      ),
    );
  }
}

class _SupportRow extends StatelessWidget {
  const _SupportRow({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: 36,
          height: 36,
          decoration: const BoxDecoration(
            color: AppColors.surface,
            shape: BoxShape.circle,
          ),
          child: Icon(icon, size: 18, color: AppColors.accentDark),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                subtitle,
                style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
