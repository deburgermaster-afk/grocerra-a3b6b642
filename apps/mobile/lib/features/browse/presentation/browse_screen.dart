import 'package:flutter/material.dart';

import '../../../core/widgets/feature_placeholder.dart';

/// Placeholder for the blueprint screen *Browse*.
class BrowseScreen extends StatelessWidget {
  const BrowseScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const FeaturePlaceholder(
      title: 'Browse',
      blueprintScreen: 'Browse',
      wiringNote:
          'Search field, category grid (Meat, Rice & Grains, Spices, Dairy, '
          'Fresh Produce, Frozen Meals, Sweets, Lentils & Pulses), catering '
          'entry banner and the five-tab floating navigation.',
    );
  }
}
