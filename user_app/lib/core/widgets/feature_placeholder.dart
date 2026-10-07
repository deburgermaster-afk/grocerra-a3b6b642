import 'package:flutter/material.dart';

/// Scaffold used by feature screens that are still to be built out from the
/// `User App - Frontend` blueprint. Keeps the app runnable end-to-end while
/// each screen is implemented against its own wiring.
class FeaturePlaceholder extends StatelessWidget {
  const FeaturePlaceholder({
    super.key,
    required this.title,
    required this.blueprintScreen,
    required this.wiringNote,
  });

  final String title;

  /// Name of the screen in the Reevake blueprint this placeholder will become.
  final String blueprintScreen;

  /// Controls/backend the real screen must expose, from the blueprint wiring.
  final String wiringNote;

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        Text(title, style: theme.textTheme.headlineMedium),
        const SizedBox(height: 16),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text('Blueprint screen', style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(blueprintScreen, style: theme.textTheme.titleMedium),
                const SizedBox(height: 16),
                Text('Wiring to build', style: theme.textTheme.bodySmall),
                const SizedBox(height: 4),
                Text(wiringNote, style: theme.textTheme.bodyMedium),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
