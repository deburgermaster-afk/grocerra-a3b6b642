import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/screen_header.dart';
import 'delete_account_screen.dart';

/// Figma `C26.01 · Legal & account` — exact 390×844 frame port.
///
/// White frame with the `GROCERRA` wordmark at y56, the header pushed down
/// to y75, then 358-wide content at y184: the `Legal` list, the `Sign out`
/// pill and the `Delete account` block that pushes [DeleteAccountScreen].
class LegalScreen extends StatelessWidget {
  const LegalScreen({super.key});

  static const String routeName = '/profile/legal';

  /// Figma `GROCERRA wordmark` (`1:2560`) - 18/700 with 14% tracking
  /// (= 2.52px), 22px line box, pure black.
  static const TextStyle _wordmark = TextStyle(
    fontSize: 18,
    height: 22 / 18,
    fontWeight: FontWeight.w700,
    letterSpacing: 2.52,
    color: AppColors.ink,
  );

  /// `App / Medium / 12 / Line Auto` in black - the delete-account copy
  /// (node `1:2557`).
  static const TextStyle _deleteCopy = TextStyle(
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.ink,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, AppInsets.statusBar(context), 0, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Wordmark sits 9px below the 47px status bar (y56) and is laid
            // out in a 19px box so the header still starts at Figma y75.
            const SizedBox(height: 9),
            const SizedBox(
              height: 19,
              child: Padding(
                padding: EdgeInsets.only(left: 16),
                child: Text('GROCERRA', style: _wordmark),
              ),
            ),
            const ScreenHeader(title: 'Legal & account'),
            // Content frame starts at y184 - 5px below the header.
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildLegalSection(context),
                  const SizedBox(height: 18),
                  _buildAccountSection(context),
                  const SizedBox(height: 18),
                  _buildDeleteSection(context),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// `Section · Legal`: heading + three 56-tall rows on a 4px rhythm.
  Widget _buildLegalSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Legal', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 4),
        _LegalRow(title: 'Terms of Service', onTap: () {}),
        const SizedBox(height: 4),
        _buildDivider(),
        const SizedBox(height: 4),
        _LegalRow(title: 'Privacy Policy', onTap: () {}),
        const SizedBox(height: 4),
        _buildDivider(),
        const SizedBox(height: 4),
        _LegalRow(title: 'Open-source licences', onTap: () {}),
      ],
    );
  }

  /// `Section · Account`: heading + the 358x56 `#f3f3f3` `Sign out` pill.
  Widget _buildAccountSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Account', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        // Figma `Sign out` (`1:2553`) is a `#f3f3f3` fill, no stroke. Without
      // the fill this pill defaults to white-on-white and disappears.
      PillButton(
        label: 'Sign out',
        fill: AppColors.surfaceAlt,
        height: 56,
        onPressed: () {},
      ),
      ],
    );
  }

  /// `Section · Delete account`. The heading (node `1:2556`) paints white on
  /// the white frame in Figma, so it is kept for layout only; the body is
  /// 12/500 black over two lines and the CTA is the 56-tall outlined pill
  /// that pushes the confirmation screen.
  Widget _buildDeleteSection(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Delete account',
          style: Theme.of(context)
              .textTheme
              .titleLarge!
              .copyWith(color: AppColors.surface),
        ),
        const SizedBox(height: 8),
        const Text(
          'Permanently delete your account and data. This can’t be undone.',
          style: _deleteCopy,
        ),
        const SizedBox(height: 8),
        AppButton(
          label: 'Delete account',
          variant: AppButtonVariant.outline,
          height: 56,
          onPressed: () =>
              Navigator.of(context).pushNamed(DeleteAccountScreen.routeName),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      width: double.infinity,
      color: AppColors.hairline,
    );
  }
}

/// One `Row · …`: 16/600 title stretched over 330px with the 20px
/// `icon/right` chevron pinned to the right of the 358-wide row.
class _LegalRow extends StatelessWidget {
  const _LegalRow({required this.title, required this.onTap});

  final String title;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: SizedBox(
        height: 56,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: Theme.of(context).textTheme.titleMedium,
              ),
            ),
            const AppIcon('right', size: 20, color: AppColors.ink),
          ],
        ),
      ),
    );
  }
}
