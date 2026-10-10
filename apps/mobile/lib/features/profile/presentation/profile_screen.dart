import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/services/session_manager.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../auth/presentation/kit/motion.dart';
import '../../auth/presentation/welcome_screen.dart';

/// Profile: who is signed in, account links, and sign out.
///
/// Reads the cached Supabase session, so it shows the account instantly and
/// offline. Signing out clears the session on this device; the app root
/// hears the `signedOut` event and returns to Welcome.
class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  void _soon(BuildContext context, String what) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.fromLTRB(16, 0, 16, 92),
          content: Text('$what is coming soon'),
        ),
      );
  }

  Future<void> _signOut(BuildContext context) async {
    final bool? ok = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: const Text('Sign out?'),
        content: const Text('You can sign back in any time.'),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text(
              'Sign out',
              style: TextStyle(color: AppColors.danger),
            ),
          ),
        ],
      ),
    );
    if (ok == true) await AuthService.signOut();
  }

  void _toWelcome(BuildContext context) {
    Navigator.of(context).pushAndRemoveUntil(
      FadeThroughRoute<void>(page: const WelcomeScreen()),
      (Route<dynamic> _) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    final ({String name, String email})? account = SessionManager.account;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: ListView(
        padding: EdgeInsets.fromLTRB(
          16,
          AppInsets.statusBar(context) + 4,
          16,
          AppInsets.tabBar,
        ),
        children: <Widget>[
          const Text(
            'Account',
            style: TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.w700,
              letterSpacing: -0.6,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 14),
          _AccountCard(account: account, onSignIn: () => _toWelcome(context)),
          const SizedBox(height: 14),
          _Row(
            icon: Icons.receipt_long_outlined,
            title: 'Orders',
            onTap: () => Navigator.of(context).pushNamed('/orders'),
          ),
          _Row(
            icon: Icons.location_on_outlined,
            title: 'Saved addresses',
            onTap: () => _soon(context, 'Saved addresses'),
          ),
          _Row(
            icon: Icons.credit_card_outlined,
            title: 'Payment methods',
            onTap: () => _soon(context, 'Payment methods'),
          ),
          _Row(
            icon: Icons.favorite_border_rounded,
            title: 'Favourites',
            onTap: () =>
                Navigator.of(context).pushNamed('/profile/favourites'),
          ),
          _Row(
            icon: Icons.local_offer_outlined,
            title: 'Promotions',
            onTap: () => Navigator.of(context).pushNamed(
              '/profile/promotions',
            ),
          ),
          _Row(
            icon: Icons.help_outline_rounded,
            title: 'Help & support',
            onTap: () => Navigator.of(context).pushNamed('/profile/help'),
          ),
          _Row(
            icon: Icons.shield_outlined,
            title: 'Privacy & terms',
            onTap: () => Navigator.of(context).pushNamed('/profile/legal'),
          ),
          if (account != null) ...<Widget>[
            const SizedBox(height: 12),
            _Row(
              icon: Icons.logout_rounded,
              title: 'Sign out',
              danger: true,
              onTap: () => _signOut(context),
            ),
          ],
        ],
      ),
    );
  }
}

class _AccountCard extends StatelessWidget {
  const _AccountCard({required this.account, required this.onSignIn});

  final ({String name, String email})? account;
  final VoidCallback onSignIn;

  @override
  Widget build(BuildContext context) {
    final ({String name, String email})? a = account;
    final String initial = a == null ? '?' : a.name.characters.first;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        children: <Widget>[
          Container(
            width: 52,
            height: 52,
            decoration: const BoxDecoration(
              color: AppColors.accent,
              shape: BoxShape.circle,
            ),
            alignment: Alignment.center,
            child: Text(
              initial.toUpperCase(),
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.surface,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  a?.name ?? 'Browsing as guest',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 17,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  a?.email ?? 'Sign in to order and track deliveries',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          if (a == null)
            FilledButton(
              style: FilledButton.styleFrom(
                minimumSize: const Size(0, 38),
                padding: const EdgeInsets.symmetric(horizontal: 16),
                textStyle: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                ),
              ),
              onPressed: onSignIn,
              child: const Text('Sign in'),
            ),
        ],
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.icon,
    required this.title,
    required this.onTap,
    this.danger = false,
  });

  final IconData icon;
  final String title;
  final VoidCallback onTap;
  final bool danger;

  @override
  Widget build(BuildContext context) {
    final Color fg = danger ? AppColors.danger : AppColors.ink;
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 4),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 22, color: fg),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: fg,
                ),
              ),
            ),
            if (!danger)
              const Icon(
                Icons.chevron_right_rounded,
                size: 20,
                color: AppColors.inkMuted,
              ),
          ],
        ),
      ),
    );
  }
}
