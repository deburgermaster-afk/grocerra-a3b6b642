import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The page header shared by the Figma profile sub-pages (`C22.01`
/// Promotions, `C25.01` Help & Support, `C26.01` Legal & account, `C26.02`
/// Delete account):
///
/// * 8/16 padding around the block,
/// * a plain back control (no circle fill - the app's standing back-button
///   treatment across every section),
/// * a 12px gap, then the `H1` 30/700 -2% title (`headlineMedium`).
///
/// [action] renders the optional right-aligned 14/600 link that sits 10px
/// into the back-button row (`Mark all read` on C23.01, node `1:2424`).
class ScreenHeader extends StatelessWidget {
  const ScreenHeader({super.key, required this.title, this.action, this.onAction});

  /// `H1` screen title (30/700, -2% tracking).
  final String title;

  /// Optional right-aligned action label.
  final String? action;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              IconButton(
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints.tightFor(
                  width: 40,
                  height: 40,
                ),
                icon: const Icon(Icons.arrow_back_rounded, size: 24),
                onPressed: () => Navigator.of(context).pop(),
                tooltip: 'Back',
              ),
              if (action != null) ...<Widget>[
                const Spacer(),
                // Figma `Mark all read` top sits 10px below the top of the
                // 40px back row (y65 vs the row at y55).
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: GestureDetector(
                    behavior: HitTestBehavior.opaque,
                    onTap: onAction,
                    child: Text(
                      action!,
                      style: const TextStyle(
                        fontSize: 14,
                        height: 17 / 14,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ],
            ],
          ),
          const SizedBox(height: 12),
          Text(title, style: Theme.of(context).textTheme.headlineMedium),
        ],
      ),
    );
  }
}
