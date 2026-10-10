import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/secondary_button.dart';
import 'catering_request_details_screen.dart';

/// Figma `C4 · Quote request sent` (390×844)
///
/// Post-submission confirmation screen:
/// - Green check circle
/// - "Request sent" & "You'll get quotes within 24 hours."
/// - Summary card: #CR-20418, Event, Date, Location
/// - "View request" CTA -> C5
/// - "Back to home" CTA -> /
class CateringConfirmationScreen extends StatelessWidget {
  const CateringConfirmationScreen({super.key});

  static const String routeName = '/catering/confirmation';

  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            <String, dynamic>{};

    final String requestNumber = '#CR-20418';
    final String eventPlanning = (args['planning'] as String?) ?? 'Wedding';
    final int guestCount = (args['guestCount'] as int?) ?? 80;
    final String eventDate = (args['eventDate'] as String?) ?? 'Sat, 24 Oct 2026';
    final String location = (args['location'] as String?) ?? '24 Maple Street';

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 24),
          child: Column(
            children: <Widget>[
              const Spacer(),

              // Green check circle
              Container(
                width: 72,
                height: 72,
                decoration: const BoxDecoration(
                  color: Color(0xFF16A34A),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                  Icons.check_rounded,
                  color: Colors.white,
                  size: 42,
                ),
              ),

              const SizedBox(height: 24),

              // Title & subtitle
              const Text(
                'Request sent',
                style: TextStyle(
                  color: AppColors.ink,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  letterSpacing: -0.5,
                ),
              ),
              const SizedBox(height: 8),
              const Text(
                "You'll get quotes within 24 hours.",
                style: TextStyle(
                  color: AppColors.inkMuted,
                  fontSize: 15,
                ),
              ),

              const SizedBox(height: 32),

              // Request Details Card
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFFE4E4E7)),
                ),
                child: Column(
                  children: <Widget>[
                    _buildRow('Request number', requestNumber, isBold: true),
                    const Divider(height: 24, color: Color(0xFFF4F4F5)),
                    _buildRow('Event', '$eventPlanning · $guestCount guests'),
                    const Divider(height: 24, color: Color(0xFFF4F4F5)),
                    _buildRow('Event date', eventDate),
                    const Divider(height: 24, color: Color(0xFFF4F4F5)),
                    _buildRow('Location', location),
                  ],
                ),
              ),

              const Spacer(),

              // Actions
              FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CateringRequestDetailsScreen.routeName,
                    arguments: <String, dynamic>{
                      ...args,
                      'guestCount': guestCount,
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  minimumSize: const Size(double.infinity, 56),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(28)),
                ),
                child: const Text(
                  'View request',
                  style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                ),
              ),
              const SizedBox(height: 12),
              SecondaryButton(
                onPressed: () => Navigator.of(context).popUntil((Route<dynamic> r) => r.isFirst),
                label: 'Back to home',
              ),
            ],
          ),
        ),
      ),
    );
  }

  static Widget _buildRow(String label, String value, {bool isBold = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: const TextStyle(
            fontSize: 14,
            color: AppColors.inkMuted,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: 14,
            fontWeight: isBold ? FontWeight.w800 : FontWeight.w600,
            color: AppColors.ink,
          ),
        ),
      ],
    );
  }
}
