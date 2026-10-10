import 'dart:ui' as ui;

import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/screen_header.dart';

/// Figma `C26.02 · Delete account` — exact 390×844 frame port.
///
/// White frame: 104-tall header, then 358-wide content at y156 — the
/// identity-confirmed banner, the consequences list, the `DELETE`
/// confirmation field and the `Keep my account` text action — above the
/// pinned glass bar (108 tall, `#ffffffcc` with a top radius) carrying the
/// red `Delete account` CTA.
class DeleteAccountScreen extends StatefulWidget {
  const DeleteAccountScreen({super.key});

  static const String routeName = '/profile/legal/delete';

  @override
  State<DeleteAccountScreen> createState() => _DeleteAccountScreenState();
}

class _DeleteAccountScreenState extends State<DeleteAccountScreen> {
  /// `App / Semi Bold / 14 / Line Auto` - the banner line.
  static const TextStyle _bannerLabel = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// `App / Medium / 14 / Line Auto` - the consequences intro.
  static const TextStyle _intro = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  /// `App / Medium / 16 / Line Auto` (19px line box) - the bullet items.
  static const TextStyle _bullet = TextStyle(
    fontSize: 16,
    height: 19 / 16,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  final TextEditingController _confirmController = TextEditingController(
    text: 'DELETE',
  );

  @override
  void dispose() {
    _confirmController.dispose();
    super.dispose();
  }

  /// Confirm only accepts the exact `DELETE` phrase (local mock).
  void _confirmDelete() {
    if (_confirmController.text.trim().toUpperCase() != 'DELETE') {
      return;
    }
    popOrFallback(context, '/profile');
  }

  void _keepAccount() {
    popOrFallback(context, '/profile');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          const SizedBox.expand(),
          SingleChildScrollView(
            // The 108-tall glass bar pins from y736.
            padding: EdgeInsets.fromLTRB(
              0,
              AppInsets.statusBar(context),
              0,
              132,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                const ScreenHeader(title: 'Delete account'),
                // Content frame starts at y156 - 5px below the header.
                const SizedBox(height: 5),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      _buildIdentityBanner(),
                      const SizedBox(height: 16),
                      _buildConsequences(),
                      const SizedBox(height: 16),
                      _buildConfirmField(),
                      const SizedBox(height: 16),
                      _buildKeepButton(),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildBar()),
        ],
      ),
    );
  }

  /// `Identity confirmed` - 358x41 r16 `#f3f3f3` banner with the 8px
  /// `#047a43` dot and a 14/600 line.
  Widget _buildIdentityBanner() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.all(Radius.circular(AppRadius.lg)),
      ),
      child: const Row(
        children: <Widget>[
          _Dot(size: 8, color: AppColors.accentLink),
          SizedBox(width: 10),
          Text('Signed in again to confirm it’s you', style: _bannerLabel),
        ],
      ),
    );
  }

  /// `Consequences`: intro line plus four 6px-spaced bullet items.
  Widget _buildConsequences() {
    const List<String> items = <String>[
      'Your order history and receipts',
      'Saved stores, products and caterers',
      'Saved addresses and payment methods',
      'Your referral code and promotions',
    ];
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Text(
          'This is permanent and can’t be undone. You will lose:',
          style: _intro,
        ),
        for (final String item in items) ...<Widget>[
          const SizedBox(height: 6),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 6),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                const _Dot(size: 6, color: AppColors.inkMuted),
                const SizedBox(width: 12),
                Expanded(child: Text(item, style: _bullet)),
              ],
            ),
          ),
        ],
      ],
    );
  }

  /// `Field · Confirm` - 12/500 label over the 358x52 r16 input with the
  /// 1px black stroke.
  Widget _buildConfirmField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Type DELETE to confirm',
          style: Theme.of(context).textTheme.labelMedium,
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 52,
          child: TextField(
            controller: _confirmController,
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
                borderRadius: BorderRadius.circular(AppRadius.lg),
                borderSide: const BorderSide(color: AppColors.ink),
              ),
            ),
          ),
        ),
      ],
    );
  }

  /// `Keep my account` - a full-width 14/600 centered text action.
  Widget _buildKeepButton() {
    return AppButton(
      label: 'Keep my account',
      variant: AppButtonVariant.text,
      height: 17,
      labelStyle: const TextStyle(
        fontSize: 14,
        height: 17 / 14,
        fontWeight: FontWeight.w600,
      ),
      onPressed: _keepAccount,
    );
  }

  /// `Place order bar · glass` (C26.02 `1:2595`): 390x108, `#ffffffcc`
  /// fill, 1px `#ffffff8c` stroke, 28 top radius, `Elevation · 2` shadow and
  /// a 24px background blur (invisible over the white frame, kept for
  /// fidelity) wrapping the 356x56 red CTA.
  Widget _buildBar() {
    // Shadow lives on an unclipped wrapper: ClipRRect would otherwise cut
    // the drop shadow off around the rounded top corners.
    return Container(
      height: 108,
      decoration: const BoxDecoration(boxShadow: AppShadows.e2),
      child: ClipRRect(
        borderRadius: const BorderRadius.vertical(
          top: Radius.circular(AppRadius.button),
        ),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 24, sigmaY: 24),
          child: Container(
            height: 108,
            // 1px stroke + 16 padding puts the button at Figma (17,17).
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 34),
            decoration: const BoxDecoration(
              color: AppColors.glassBar,
              border: Border.fromBorderSide(
                BorderSide(color: AppColors.glassBarStroke),
              ),
              borderRadius: BorderRadius.vertical(
                top: Radius.circular(AppRadius.button),
              ),
            ),
            child: PillButton(
              label: 'Delete account',
              fill: AppColors.danger,
              stroke: AppColors.ink,
              labelColor: AppColors.surface,
              height: 56,
              onPressed: _confirmDelete,
            ),
          ),
        ),
      ),
    );
  }
}

/// The 6px / 8px Figma discs used by the banner and the bullets.
class _Dot extends StatelessWidget {
  const _Dot({required this.size, required this.color});

  final double size;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(size / 2),
      ),
    );
  }
}
