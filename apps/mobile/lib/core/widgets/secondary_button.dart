import 'package:flutter/material.dart';

import '../theme/app_theme.dart';

/// The full-width secondary pill from the Figma flow (`Button · Back to
/// home`, C13.01 Actions): 56 tall, radius 28, 1px `#cfcfcf` outline,
/// transparent fill and an ink 16/600 label. Meant to sit under a
/// `FilledButton` primary.
///
/// Plain `OutlinedButton`s inherit the same outline through
/// `AppTheme.outlinedButtonTheme`; this widget adds the pinned 56px height.
class SecondaryButton extends StatelessWidget {
  const SecondaryButton({
    super.key,
    required this.onPressed,
    required this.label,
  });

  final VoidCallback? onPressed;
  final String label;

  @override
  Widget build(BuildContext context) {
    return OutlinedButton(
      onPressed: onPressed,
      style: OutlinedButton.styleFrom(
        foregroundColor: AppColors.ink,
        minimumSize: const Size.fromHeight(56),
        side: const BorderSide(color: AppColors.outline),
        padding: const EdgeInsets.symmetric(horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        textStyle: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
      ),
      child: Text(label),
    );
  }
}
