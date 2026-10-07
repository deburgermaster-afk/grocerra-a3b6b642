import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

/// Placeholder for the blueprint screens *Profile*, *Favourites*,
/// *Promotions*, *Notifications*, *Help & Support* and
/// *Legal & account settings*.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Profile',
      blueprintScreen: 'Profile / Legal & account settings',
      wiringNote:
          'Account details, addresses, favourites, promotions, notifications, '
          'help & support, legal (Terms, Privacy) and delete-account '
          'confirmation. Backend: Supabase Auth (email, phone OTP, Apple, '
          'Google) + edge fn: auth hooks.',
    );
  }
}
