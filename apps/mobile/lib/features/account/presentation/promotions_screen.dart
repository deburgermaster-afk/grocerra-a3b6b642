import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/screen_header.dart';

/// `App / Semi Bold / 14 / Line Auto` in black - the `Use` action on the
/// `Available promos` rows (nodes `1:2406` / `1:2412`).
const TextStyle _useLabel = TextStyle(
  fontSize: 14,
  height: 17 / 14,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// Figma `C22.01 · Promotions` — exact 390×844 frame port.
///
/// White frame: 104-tall header (back + `H1`), then 358-wide content at
/// y156 — referral card (`#f3f3f3` r20), promo-code row (r16 input with a
/// black stroke + 52-tall `Apply`), and the `Available promos` list.
class PromotionsScreen extends StatefulWidget {
  const PromotionsScreen({super.key});

  static const String routeName = '/profile/promotions';

  @override
  State<PromotionsScreen> createState() => _PromotionsScreenState();
}

class _PromotionsScreenState extends State<PromotionsScreen> {
  /// C22.01 `SARA-4F7K` - a detached 24/700, 29px style (no tracking).
  static const TextStyle _referralCode = TextStyle(
    fontSize: 24,
    height: 29 / 24,
    fontWeight: FontWeight.w700,
    color: AppColors.ink,
  );

  /// `App / Semi Bold / 15 / Line Auto` - the pill labels.
  static const TextStyle _pillLabel = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w600,
  );

  /// `App / Medium / 12 / Line Auto` (15px line box) in pure black.
  static const TextStyle _fieldLabel = TextStyle(
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  /// Same caption style in `#6b6b6b`.
  static const TextStyle _caption = TextStyle(
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.inkMuted,
  );

  /// C22.01 error line (node `1:2399`) - `#e11900`.
  static const TextStyle _error = TextStyle(
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.danger,
  );

  /// Mock state: the demo code the frame shows, which the backend rejects.
  final TextEditingController _promoController =
      TextEditingController(text: 'SPICE10');
  bool _showExpiredError = true;

  @override
  void dispose() {
    _promoController.dispose();
    super.dispose();
  }

  void _copyCode() {
    Clipboard.setData(const ClipboardData(text: 'SARA-4F7K'));
  }

  void _applyPromo() {
    setState(() {
      // Local mock: `SPICE10` is the expired code the frame illustrates.
      _showExpiredError =
          _promoController.text.trim().toUpperCase() == 'SPICE10';
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, AppInsets.statusBar(context), 0, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ScreenHeader(title: 'Promotions'),
            // Content frame starts at y156 - 5px below the 104-tall header.
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildReferralCard(),
                  const SizedBox(height: 18),
                  _buildPromoCodeSection(),
                  const SizedBox(height: 18),
                  _buildAvailablePromosSection(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 358x172 `#f3f3f3` r20 card: code block, 40-tall action pills, caption.
  Widget _buildReferralCard() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              const Text('Your referral code', style: _fieldLabel),
              const SizedBox(height: 2),
              const Text('SARA-4F7K', style: _referralCode),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: <Widget>[
              // 158x40 white pill (no stroke) + 8 gap + 160x40 outlined pill.
              SizedBox(
                width: 158,
                child: PillButton(
                  label: 'Copied',
                  height: 40,
                  labelStyle: _pillLabel,
                  onPressed: _copyCode,
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: AppButton(
                  label: 'Share',
                  variant: AppButtonVariant.outline,
                  height: 40,
                  labelStyle: _pillLabel,
                  onPressed: () {},
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Text(
            'Share your code and you both get credit after their first order.',
            style: _caption,
          ),
        ],
      ),
    );
  }

  /// `Promo code` heading, the r16 input + `Apply` row, and the error line.
  Widget _buildPromoCodeSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Promo code',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 6),
        Row(
          children: <Widget>[
            Expanded(
              child: SizedBox(
                height: 52,
                child: TextField(
                  controller: _promoController,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                  decoration: InputDecoration(
                    // 52 tall = 16.5 + 19px line + 16.5 (Figma text y16.5).
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16.5,
                    ),
                    border: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(AppRadius.lg),
                      borderSide: const BorderSide(color: AppColors.ink),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 96,
              child: AppButton(
                label: 'Apply',
                height: 52,
                labelStyle: _pillLabel,
                onPressed: _applyPromo,
              ),
            ),
          ],
        ),
        if (_showExpiredError) ...<Widget>[
          const SizedBox(height: 6),
          const Text('This code has expired.', style: _error),
        ],
      ],
    );
  }

  /// `Available promos`: two 60-tall rows split by a 1px `#e6e6e6` divider.
  Widget _buildAvailablePromosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Available promos',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 4),
        _PromoRow(
          title: 'Free delivery on your next order',
          expiry: 'Expires 31 Oct 2026',
          onUse: () {},
        ),
        const SizedBox(height: 4),
        Container(height: 1, width: double.infinity, color: AppColors.hairline),
        const SizedBox(height: 4),
        _PromoRow(
          title: 'Catering deposit credit',
          expiry: 'Expires 30 Nov 2026',
          onUse: () {},
        ),
      ],
    );
  }
}

/// One `Promo · …` row: 16/600 title over a 12/500 `#6b6b6b` expiry with the
/// 14/600 `Use` action pinned to the right of the 358-wide row.
class _PromoRow extends StatelessWidget {
  const _PromoRow({
    required this.title,
    required this.expiry,
    required this.onUse,
  });

  final String title;
  final String expiry;
  final VoidCallback onUse;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 60,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                const SizedBox(height: 2),
                Text(
                  expiry,
                  style: const TextStyle(
                    fontSize: 12,
                    height: 15 / 12,
                    fontWeight: FontWeight.w500,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          GestureDetector(
            behavior: HitTestBehavior.opaque,
            onTap: onUse,
            child: const Text('Use', style: _useLabel),
          ),
        ],
      ),
    );
  }
}
