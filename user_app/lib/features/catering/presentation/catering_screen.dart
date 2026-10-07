import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

/// Placeholder for the blueprint screens *Catering*, *Request a quote*,
/// *Catering Quote Summary* and *Catering Orders*.
class CateringScreen extends StatelessWidget {
  const CateringScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Catering',
      blueprintScreen: 'Catering / Request a quote',
      wiringNote:
          'Plan an event, request a quote (event type, date, headcount, '
          'cuisine), quote summary with deposit rules, catering orders and '
          'order details. Backend: edge fn: catering (quotes, deposits, '
          'balances).',
    );
  }
}
