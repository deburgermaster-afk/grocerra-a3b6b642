import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_confirmation_screen.dart';

/// Figma `C3 · Request a quote — Details` (390×844)
///
/// Second step of request a quote:
/// - Step tabs: "Event" | "Menu & details" (active)
/// - "What would you like?": Biryani, Goat curry, Kebabs, Sides, Desserts
/// - "Dietary needs": Vegetarian options, Gluten-free, Nut-free ("All food is halal.")
/// - "Service": Delivery only, Delivery + setup
/// - "Notes (optional)": Allergies, serving times, spice level...
/// - "Send request" CTA -> C4
class CustomMenuScreen extends StatefulWidget {
  const CustomMenuScreen({super.key});

  static const String routeName = '/catering/custom-menu';

  @override
  State<CustomMenuScreen> createState() => _CustomMenuScreenState();
}

class _CustomMenuScreenState extends State<CustomMenuScreen> {
  final Set<String> _selectedItems = <String>{'Biryani', 'Goat curry', 'Kebabs', 'Desserts'};
  final Set<String> _selectedDietary = <String>{};
  String _selectedService = 'Delivery + setup';
  final TextEditingController _notesController = TextEditingController();

  static const List<String> _foodPreferences = <String>[
    'Biryani',
    'Goat curry',
    'Kebabs',
    'Sides',
    'Desserts',
  ];

  static const List<String> _dietaryNeeds = <String>[
    'Vegetarian options',
    'Gluten-free',
    'Nut-free',
  ];

  static const List<String> _serviceOptions = <String>[
    'Delivery only',
    'Delivery + setup',
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final Map<String, dynamic> args =
        (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ??
            <String, dynamic>{};

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SafeArea(
        top: false,
        child: Column(
          children: <Widget>[
            // Navigation Bar
            Container(
              padding: EdgeInsets.fromLTRB(16, topInset, 16, 8),
              decoration: const BoxDecoration(
                color: AppColors.surface,
              ),
              child: Row(
                children: <Widget>[
                  RoundIconButton(
                    icon: Icons.arrow_back_rounded,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const Expanded(
                    child: Center(
                      child: Text(
                        'Request a quote',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                          letterSpacing: -0.3,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 44),
                ],
              ),
            ),

            // Step Progress Tab Bar: Event | Menu & details
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Event',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkMuted,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 2.5,
                          color: const Color(0xFFE4E4E7),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Menu & details',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Container(
                          height: 2.5,
                          color: AppColors.ink,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Form Fields
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  // 1. What would you like?
                  const Text(
                    'What would you like?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _foodPreferences.map((String item) {
                      final bool isSelected = _selectedItems.contains(item);
                      return FilterChip(
                        label: Text(item),
                        selected: isSelected,
                        selectedColor: AppColors.ink,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.ink : const Color(0xFFE4E4E7),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        showCheckmark: false,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedItems.add(item);
                            } else {
                              _selectedItems.remove(item);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 2. Dietary needs
                  const Text(
                    'Dietary needs',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _dietaryNeeds.map((String opt) {
                      final bool isSelected = _selectedDietary.contains(opt);
                      return FilterChip(
                        label: Text(opt),
                        selected: isSelected,
                        selectedColor: AppColors.ink,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.ink : const Color(0xFFE4E4E7),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        showCheckmark: false,
                        onSelected: (bool selected) {
                          setState(() {
                            if (selected) {
                              _selectedDietary.add(opt);
                            } else {
                              _selectedDietary.remove(opt);
                            }
                          });
                        },
                      );
                    }).toList(),
                  ),
                  const SizedBox(height: 6),
                  Row(
                    children: const <Widget>[
                      Icon(Icons.check_circle_rounded, size: 14, color: Color(0xFF15803D)),
                      SizedBox(width: 6),
                      Text(
                        'All food is halal.',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.inkMuted,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // 3. Service
                  const Text(
                    'Service',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 12),
                  Wrap(
                    spacing: 8,
                    runSpacing: 10,
                    children: _serviceOptions.map((String opt) {
                      final bool isSelected = _selectedService == opt;
                      return ChoiceChip(
                        label: Text(opt),
                        selected: isSelected,
                        selectedColor: AppColors.ink,
                        backgroundColor: AppColors.surface,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : AppColors.ink,
                          fontWeight: FontWeight.w600,
                          fontSize: 13,
                        ),
                        side: BorderSide(
                          color: isSelected ? AppColors.ink : const Color(0xFFE4E4E7),
                        ),
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                        showCheckmark: false,
                        onSelected: (bool selected) {
                          if (selected) setState(() => _selectedService = opt);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 4. Notes (optional)
                  const Text(
                    'Notes (optional)',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 4,
                    decoration: InputDecoration(
                      hintText: 'Allergies, serving times, spice level...',
                      hintStyle: const TextStyle(color: AppColors.inkMuted, fontSize: 14),
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.all(16),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: Color(0xFFE4E4E7)),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(16),
                        borderSide: const BorderSide(color: AppColors.ink, width: 1.5),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Bottom CTA: Send request
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CateringConfirmationScreen.routeName,
                    arguments: <String, dynamic>{
                      ...args,
                      'items': _selectedItems.toList(),
                      'service': _selectedService,
                      'notes': _notesController.text,
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: const Text(
                  'Send request',
                  style: TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
