import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Checkout step 6 — the reference's `Order received` screen.
///
/// The receipt view after the order lands: close / share / Help header, a
/// progress bar over the estimated arrival, a promo card, and the delivery
/// details with their Change / Edit affordances. Demo copy — no live order
/// tracking behind it yet.
class OrderReceivedScreen extends StatelessWidget {
  const OrderReceivedScreen({super.key});

  static const String routeName = '/order-confirmation';

  /// Close: wipe the checkout stack back to the shell.
  void _close(BuildContext context) => Navigator.of(
    context,
  ).pushNamedAndRemoveUntil('/home', (Route<dynamic> _) => false);

  void _snack(BuildContext context, String message) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          behavior: SnackBarBehavior.floating,
          backgroundColor: AppColors.ink,
          shape: const RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
          ),
          content: Text(
            message,
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
              color: AppColors.surface,
            ),
          ),
        ),
      );
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, topInset, 0, 40),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildTopBar(context),
            _buildHeadline(),
            _buildProgress(),
            _buildAdCard(context),
            _buildDeliveryDetails(context),
          ],
        ),
      ),
    );
  }

  /// Close left, share + Help right (reference top bar).
  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: SizedBox(
        height: 44,
        child: Row(
          children: <Widget>[
            IconButton(
              tooltip: 'Close',
              onPressed: () => _close(context),
              icon: const Icon(Icons.close, size: 26, color: AppColors.ink),
            ),
            const Spacer(),
            IconButton(
              tooltip: 'Share',
              onPressed: () => _snack(context, 'Sharing is coming soon'),
              icon: const Icon(
                Icons.share_outlined,
                size: 22,
                color: AppColors.ink,
              ),
            ),
            TextButton(
              onPressed: () => _snack(context, 'Help centre is coming soon'),
              child: const Text(
                'Help',
                style: TextStyle(
                  fontSize: 15,
                  height: 18 / 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeadline() {
    return const Padding(
      padding: EdgeInsets.fromLTRB(16, 4, 16, 0),
      child: Text(
        'Order received',
        style: TextStyle(
          fontSize: 24,
          height: 29 / 24,
          fontWeight: FontWeight.w700,
          color: AppColors.ink,
        ),
      ),
    );
  }

  /// Progress track with the accent fill, then the arrival estimates.
  Widget _buildProgress() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 14, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            height: 6,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.all(Radius.circular(3)),
            ),
            child: FractionallySizedBox(
              widthFactor: 0.4,
              alignment: Alignment.centerLeft,
              child: Container(
                decoration: const BoxDecoration(
                  color: AppColors.accent,
                  borderRadius: BorderRadius.all(Radius.circular(3)),
                ),
              ),
            ),
          ),
          const SizedBox(height: 14),
          const Text(
            'Estimated arrival 9:45 PM',
            style: TextStyle(
              fontSize: 16,
              height: 19 / 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Row(
            children: <Widget>[
              Text(
                'Latest arrival by 10:15 PM',
                style: TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.inkMuted,
                ),
              ),
              SizedBox(width: 5),
              Icon(
                Icons.info_outline,
                size: 14,
                color: AppColors.inkMuted,
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// The reference's in-flow promo card: emoji tile with a discount tag,
  /// add-on copy and `Order Now →` back into the store.
  Widget _buildAdCard(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 18, 16, 0),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(color: AppColors.hairline),
          boxShadow: const <BoxShadow>[
            BoxShadow(
              color: Color(0x0A000000),
              blurRadius: 12,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                // Product tile with the discount tag pinned on it.
                Stack(
                  clipBehavior: Clip.none,
                  children: <Widget>[
                    Container(
                      width: 72,
                      height: 72,
                      decoration: const BoxDecoration(
                        color: Color(0xFFFFEFD9),
                        borderRadius:
                            BorderRadius.all(Radius.circular(AppRadius.lg)),
                      ),
                      alignment: Alignment.center,
                      child: const Text('🍗', style: TextStyle(fontSize: 34)),
                    ),
                    const Positioned(
                      left: -4,
                      bottom: -6,
                      child: TagPill(
                        label: '33% off',
                        background: AppColors.ink,
                        foreground: AppColors.surface,
                        fontSize: 12,
                        radius: 6,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      const Text(
                        "It's not too late to add big flavor to your meal",
                        style: TextStyle(
                          fontSize: 15,
                          height: 18 / 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      const SizedBox(height: 4),
                      const Text(
                        'Get more halal cuts delivered',
                        style: TextStyle(
                          fontSize: 13,
                          height: 16 / 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 10),
                      InkWell(
                        onTap: () =>
                            Navigator.of(context).pushNamed('/store'),
                        child: const Text(
                          'Order Now →',
                          style: TextStyle(
                            fontSize: 14,
                            height: 17 / 14,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            const Align(
              alignment: Alignment.centerRight,
              child: Text(
                'Ad',
                style: TextStyle(
                  fontSize: 11,
                  height: 14 / 11,
                  fontWeight: FontWeight.w400,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// Delivery details: address, dropoff and instructions, each with its
  /// reference action.
  Widget _buildDeliveryDetails(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const Text(
            'Delivery details',
            style: TextStyle(
              fontSize: 20,
              height: 24 / 20,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          _DetailRow(
            label: 'Address',
            value: '12 Queen St, Melbourne, VIC 3000',
            action: 'Change',
            onTap: () =>
                Navigator.of(context).pushNamed('/delivery-address'),
          ),
          _DetailRow(
            label: 'Dropoff option',
            value: 'Leave at reception',
            action: 'Change',
            onTap: () =>
                _snack(context, 'Dropoff options are coming soon'),
          ),
          _DetailRow(
            label: 'Delivery instructions',
            value: 'Leave at the front desk',
            action: 'Edit',
            last: true,
            onTap: () =>
                _snack(context, 'Delivery instructions are coming soon'),
          ),
        ],
      ),
    );
  }
}

/// One `label / value + action` block from the reference's delivery
/// details, separated by hairlines.
class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    required this.action,
    required this.onTap,
    this.last = false,
  });

  final String label;
  final String value;
  final String action;
  final VoidCallback onTap;
  final bool last;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 14),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        label,
                        style: const TextStyle(
                          fontSize: 13,
                          height: 16 / 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      const SizedBox(height: 3),
                      Text(
                        value,
                        style: const TextStyle(
                          fontSize: 15,
                          height: 18 / 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Padding(
                  padding: const EdgeInsets.only(top: 14),
                  child: Text(
                    action,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 18 / 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        if (!last) Container(height: 1, color: AppColors.hairline),
      ],
    );
  }
}
