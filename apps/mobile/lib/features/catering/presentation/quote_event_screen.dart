import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'custom_menu_screen.dart';

/// Figma `C2 · Request a quote — Event` (390×844)
///
/// First step of request a quote:
/// - Step tabs: "Event" (active) | "Menu & details"
/// - "What are you planning?": Wedding, Birthday, Corporate, Eid / Religious, Other
/// - "Event date": Sat, 24 Oct 2026
/// - "Number of guests": 80 guests
/// - "Event location": 24 Maple Street, Apt 3B
/// - "Next" CTA -> C3
class QuoteEventScreen extends StatefulWidget {
  const QuoteEventScreen({super.key});

  static const String routeName = '/catering/quote-event';

  @override
  State<QuoteEventScreen> createState() => _QuoteEventScreenState();
}

class _QuoteEventScreenState extends State<QuoteEventScreen> {
  String _selectedPlanning = 'Wedding';
  DateTime _eventDate = DateTime(2026, 10, 24);
  int _guestCount = 80;
  final TextEditingController _locationController =
      TextEditingController(text: '24 Maple Street, Apt 3B');

  static const List<String> _planningOptions = <String>[
    'Wedding',
    'Birthday',
    'Corporate',
    'Eid / Religious',
    'Other',
  ];

  @override
  void dispose() {
    _locationController.dispose();
    super.dispose();
  }

  Future<void> _pickDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _eventDate,
      firstDate: DateTime.now().add(const Duration(days: 1)),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _eventDate = picked);
    }
  }

  String _formatDate(DateTime dt) {
    const List<String> weekdays = <String>['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    const List<String> months = <String>['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'];
    return '${weekdays[dt.weekday - 1]}, ${dt.day} ${months[dt.month - 1]} ${dt.year}';
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

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
                  const SizedBox(width: 44), // visual balance
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
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        const Text(
                          'Menu & details',
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
                ],
              ),
            ),

            const SizedBox(height: 8),

            // Form Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  // 1. What are you planning?
                  const Text(
                    'What are you planning?',
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
                    children: _planningOptions.map((String opt) {
                      final bool isSelected = _selectedPlanning == opt;
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
                          if (selected) setState(() => _selectedPlanning = opt);
                        },
                      );
                    }).toList(),
                  ),

                  const SizedBox(height: 24),

                  // 2. Event date
                  const Text(
                    'Event date',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: _pickDate,
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            _formatDate(_eventDate),
                            style: const TextStyle(
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              color: AppColors.ink,
                            ),
                          ),
                          const Icon(Icons.calendar_today_rounded, size: 18, color: AppColors.inkMuted),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 3. Number of guests
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      const Text(
                        'Number of guests',
                        style: TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        '$_guestCount guests',
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Container(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      children: <Widget>[
                        Slider(
                          value: _guestCount.toDouble(),
                          min: 10,
                          max: 300,
                          divisions: 29,
                          activeColor: AppColors.ink,
                          inactiveColor: const Color(0xFFE4E4E7),
                          onChanged: (double val) => setState(() => _guestCount = val.toInt()),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const <Widget>[
                            Text('10 guests', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                            Text('80 guests', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                            Text('300+ guests', style: TextStyle(fontSize: 12, color: AppColors.inkMuted)),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 24),

                  // 4. Event location
                  const Text(
                    'Event location',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _locationController,
                    decoration: InputDecoration(
                      hintText: 'Enter street address, suburb',
                      filled: true,
                      fillColor: AppColors.surface,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
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

            // Bottom CTA: Next
            Container(
              padding: const EdgeInsets.all(16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: FilledButton(
                onPressed: () {
                  Navigator.of(context).pushNamed(
                    CustomMenuScreen.routeName,
                    arguments: <String, dynamic>{
                      'planning': _selectedPlanning,
                      'guestCount': _guestCount,
                      'eventDate': _formatDate(_eventDate),
                      'location': _locationController.text,
                    },
                  );
                },
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.ink,
                  minimumSize: const Size(double.infinity, 52),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(26)),
                ),
                child: const Text(
                  'Next',
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
