import 'package:flutter/material.dart';

import '../../../core/services/auth_service.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';
import '../../auth/presentation/sign_in_screen.dart';

/// Screen #42: Profile & Account Settings
/// Includes user details card, saved addresses, payment methods, favourites,
/// promo codes, help & support, and account management.
class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final TextEditingController _promoController = TextEditingController();

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _showPromoModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: EdgeInsets.only(
            left: 20,
            right: 20,
            top: 20,
            bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Promotions & Referrals',
                style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
              ),
              const SizedBox(height: 12),
              Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFFF0FDF4),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFBBF7D0)),
                ),
                child: Row(
                  children: const <Widget>[
                    Icon(Icons.card_giftcard, color: AppColors.accentDark),
                    SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            'Your Referral Code: GROCERRA20',
                            style: TextStyle(
                              fontWeight: FontWeight.w800,
                              color: AppColors.accentDark,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Give \$10 off first order, get \$10 credit.',
                            style: TextStyle(fontSize: 12, color: Color(0xFF166534)),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _promoController,
                decoration: InputDecoration(
                  hintText: 'Enter Promo Code (e.g. SPICE10)',
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  suffixIcon: TextButton(
                    onPressed: () {
                      final String code = _promoController.text.trim();
                      Navigator.of(ctx).pop();
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(
                            code.toUpperCase() == 'SPICE10'
                                ? 'Promo SPICE10 applied: 10% off basket!'
                                : 'Invalid promo code.',
                          ),
                          backgroundColor: code.toUpperCase() == 'SPICE10'
                              ? AppColors.accentDark
                              : Colors.red,
                        ),
                      );
                    },
                    child: const Text('Apply'),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showHelpModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) {
        return Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.all(20),
          child: SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const Text(
                  'Help & Support',
                  style: TextStyle(fontWeight: FontWeight.w800, fontSize: 18),
                ),
                const SizedBox(height: 14),
                ListTile(
                  leading: const Icon(Icons.scale, color: AppColors.accentDark),
                  title: const Text('How Catch-Weight Works'),
                  subtitle: const Text('Pre-authorization hold & scale weight capture'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.assignment_return, color: AppColors.accentDark),
                  title: const Text('Refund Policy (ACL Compliant)'),
                  subtitle: const Text('Missing items, quality, or damage reports'),
                  onTap: () {},
                ),
                ListTile(
                  leading: const Icon(Icons.email, color: AppColors.accentDark),
                  title: const Text('Email Support'),
                  subtitle: const Text('support@grocerra.com.au'),
                  onTap: () {},
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  void _confirmSignOut() {
    showDialog<void>(
      context: context,
      builder: (BuildContext ctx) {
        return AlertDialog(
          title: const Text('Sign Out'),
          content: const Text('Are you sure you want to sign out of Grocerra?'),
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              onPressed: () async {
                Navigator.of(ctx).pop();
                await AuthService.signOut();
                if (mounted) {
                  Navigator.of(context).pushNamedAndRemoveUntil(
                    SignInScreen.routeName,
                    (Route<dynamic> r) => false,
                  );
                }
              },
              child: const Text('Sign Out', style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFBFBFB),
      appBar: AppBar(
        title: const Text(
          'Account & Profile',
          style: TextStyle(fontWeight: FontWeight.w800, fontSize: 20),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: <Widget>[
          // User Info Card with GlowRing and Verified Badge
          GlowCard(
            borderRadius: 22,
            borderWidth: 1.2,
            glowColor: const Color(0xFF10B981),
            backgroundColor: Colors.white,
            enableBorderGlow: false,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(16),
            child: Row(
              children: <Widget>[
                const GlowRing(
                  size: 64,
                  strokeWidth: 3.0,
                  glowColor: Color(0xFF10B981),
                  secondaryColor: Color(0xFF064E3B),
                  child: CircleAvatar(
                    radius: 24,
                    backgroundColor: Color(0xFFDCFCE7),
                    child: Text(
                      'TA',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Row(
                        children: const <Widget>[
                          Text(
                            'Tayyab Anjum',
                            style: TextStyle(
                              fontSize: 17,
                              fontWeight: FontWeight.w800,
                              color: AppColors.ink,
                              letterSpacing: -0.3,
                            ),
                          ),
                          SizedBox(width: 6),
                          GlowBadge(
                            label: 'VERIFIED',
                            showPulseDot: true,
                            glowColor: Color(0xFF10B981),
                            backgroundColor: Color(0xFFDCFCE7),
                            textColor: Color(0xFF065F46),
                          ),
                        ],
                      ),
                      const SizedBox(height: 3),
                      Text(
                        '+61 412 345 678 • Coburg, Melbourne',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.edit_outlined),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Edit profile modal')),
                    );
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // Menu Section 1: Addresses & Payments
          _SectionCard(
            title: 'Saved Preferences',
            items: <_MenuItem>[
              _MenuItem(
                icon: Icons.location_on_outlined,
                title: 'Delivery Addresses',
                subtitle: 'Home: 24 Maple Street, Coburg',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.credit_card_outlined,
                title: 'Payment Methods',
                subtitle: 'Visa ending in 4242 · Apple Pay',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.favorite_border,
                title: 'Saved Stores & Caterers',
                subtitle: 'Madina Halal Meats, Karachi Feast',
                onTap: () {},
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Menu Section 2: Perks & Help
          _SectionCard(
            title: 'Benefits & Support',
            items: <_MenuItem>[
              _MenuItem(
                icon: Icons.local_offer_outlined,
                title: 'Promotions & Referral Code',
                subtitle: 'Share code & apply coupons',
                onTap: _showPromoModal,
              ),
              _MenuItem(
                icon: Icons.notifications_none_outlined,
                title: 'Notifications',
                subtitle: 'Delivery alerts and order updates',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.help_outline,
                title: 'Help Centre & FAQs',
                subtitle: 'Catch-weight guide, refund policy',
                onTap: _showHelpModal,
              ),
            ],
          ),

          const SizedBox(height: 16),

          // Menu Section 3: Legal & Sign Out
          _SectionCard(
            title: 'Legal & Security',
            items: <_MenuItem>[
              _MenuItem(
                icon: Icons.verified_user_outlined,
                title: 'Terms of Service & Privacy Policy',
                subtitle: 'Australian Consumer Law (ACL)',
                onTap: () {},
              ),
              _MenuItem(
                icon: Icons.logout,
                title: 'Sign Out',
                subtitle: 'Log out of this device',
                iconColor: Colors.red,
                titleColor: Colors.red,
                onTap: _confirmSignOut,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SectionCard extends StatelessWidget {
  const _SectionCard({required this.title, required this.items});

  final String title;
  final List<_MenuItem> items;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE5E7EB)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 14, 16, 4),
            child: Text(
              title,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: Colors.grey.shade500,
                letterSpacing: 0.5,
              ),
            ),
          ),
          ...items.asMap().entries.map((MapEntry<int, _MenuItem> entry) {
            final int idx = entry.key;
            final _MenuItem item = entry.value;
            final bool isLast = idx == items.length - 1;

            return Column(
              children: <Widget>[
                ListTile(
                  leading: Icon(item.icon, color: item.iconColor ?? AppColors.ink),
                  title: Text(
                    item.title,
                    style: TextStyle(
                      fontWeight: FontWeight.w700,
                      fontSize: 14,
                      color: item.titleColor ?? AppColors.ink,
                    ),
                  ),
                  subtitle: Text(
                    item.subtitle,
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  trailing: const Icon(Icons.chevron_right, size: 20, color: Colors.grey),
                  onTap: item.onTap,
                ),
                if (!isLast)
                  Divider(
                    height: 1,
                    indent: 56,
                    endIndent: 16,
                    color: Colors.grey.shade100,
                  ),
              ],
            );
          }),
        ],
      ),
    );
  }
}

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.onTap,
    this.iconColor,
    this.titleColor,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback onTap;
  final Color? iconColor;
  final Color? titleColor;
}
