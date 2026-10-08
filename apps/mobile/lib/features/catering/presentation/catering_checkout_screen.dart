import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_deposit_screen.dart';

/// Figma `C6 · Catering checkout — Top` (390×844)
///
/// Checkout logistics setup screen:
/// - Segmented toggle: "Delivery & setup" | "Pickup"
/// - Map preview box with pin & "Edit pin"
/// - Venue location & loading dock instructions
/// - Setup instructions
/// - Contact details (Sara Ahmed · 0412 345 678)
/// - Event time slot (Sat, 24 Oct · 6:00 PM) with Standard / Early setup
/// - Sticky bottom bar: Due today $372 -> "Continue" CTA to C7
class CateringCheckoutScreen extends StatefulWidget {
  const CateringCheckoutScreen({super.key});

  static const String routeName = '/catering/checkout';

  @override
  State<CateringCheckoutScreen> createState() => _CateringCheckoutScreenState();
}

class _CateringCheckoutScreenState extends State<CateringCheckoutScreen> {
  int _fulfillmentMode = 0; // 0 = Delivery & setup, 1 = Pickup
  int _setupOption = 0; // 0 = Standard, 1 = Early

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
              padding: EdgeInsets.fromLTRB(16, topInset, 16, 12),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(bottom: BorderSide(color: AppColors.hairline)),
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
                        'Catering checkout',
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

            // Scrollable logistics content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  // Segmented control: Delivery & setup | Pickup
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF4F4F5),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: <Widget>[
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _fulfillmentMode = 0),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _fulfillmentMode == 0 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _fulfillmentMode == 0
                                    ? const <BoxShadow>[
                                        BoxShadow(
                                          color: Color(0x0F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Delivery & setup',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _fulfillmentMode == 0 ? AppColors.ink : AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: GestureDetector(
                            onTap: () => setState(() => _fulfillmentMode = 1),
                            child: Container(
                              padding: const EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                color: _fulfillmentMode == 1 ? Colors.white : Colors.transparent,
                                borderRadius: BorderRadius.circular(10),
                                boxShadow: _fulfillmentMode == 1
                                    ? const <BoxShadow>[
                                        BoxShadow(
                                          color: Color(0x0F000000),
                                          blurRadius: 4,
                                          offset: Offset(0, 2),
                                        ),
                                      ]
                                    : null,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                'Pickup',
                                style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontSize: 13,
                                  color: _fulfillmentMode == 1 ? AppColors.ink : AppColors.inkMuted,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Map Preview Box with Pin
                  Container(
                    height: 150,
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: const Color(0xFFF1F5F9),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Stack(
                      alignment: Alignment.center,
                      children: <Widget>[
                        // Subtle grid background simulating map
                        Positioned.fill(
                          child: Opacity(
                            opacity: 0.15,
                            child: Image.network(
                              'https://images.unsplash.com/photo-1524661135-423995f22d0b?w=600&q=80',
                              fit: BoxFit.cover,
                              errorBuilder: (_, _, _) => const SizedBox.shrink(),
                            ),
                          ),
                        ),
                        Column(
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            Container(
                              padding: const EdgeInsets.all(8),
                              decoration: const BoxDecoration(
                                color: AppColors.ink,
                                shape: BoxShape.circle,
                              ),
                              child: const Icon(Icons.location_on_rounded, color: Colors.white, size: 20),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(14),
                                boxShadow: const <BoxShadow>[
                                  BoxShadow(
                                    color: Color(0x14000000),
                                    blurRadius: 8,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: const Text(
                                'Edit pin',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 16),

                  // Logistics Info Rows
                  _buildLogisticsRow(
                    icon: Icons.location_on_outlined,
                    title: '12 Queen St, Melbourne',
                    subtitle: 'Event venue · Loading dock at rear',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildLogisticsRow(
                    icon: Icons.meeting_room_outlined,
                    title: 'Meet at venue entrance',
                    subtitle: 'Add setup instructions',
                    onTap: () {},
                  ),
                  const SizedBox(height: 12),
                  _buildLogisticsRow(
                    icon: Icons.person_outline_rounded,
                    title: 'Sara Ahmed · 0412 345 678',
                    subtitle: 'Caterer will call on arrival',
                    onTap: () {},
                  ),

                  const SizedBox(height: 20),

                  // Event Time & Setup Slot
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Row(
                          children: const <Widget>[
                            Icon(Icons.access_time_rounded, size: 18, color: AppColors.ink),
                            SizedBox(width: 8),
                            Text(
                              'Event',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            Spacer(),
                            Text(
                              'Sat, 24 Oct · 6:00 PM',
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w600,
                                color: AppColors.ink,
                              ),
                            ),
                          ],
                        ),
                        const SizedBox(height: 14),
                        Row(
                          children: <Widget>[
                            ChoiceChip(
                              label: const Text('Standard'),
                              selected: _setupOption == 0,
                              selectedColor: AppColors.ink,
                              labelStyle: TextStyle(
                                color: _setupOption == 0 ? Colors.white : AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                              showCheckmark: false,
                              onSelected: (bool val) => setState(() => _setupOption = 0),
                            ),
                            const SizedBox(width: 8),
                            ChoiceChip(
                              label: const Text('Early'),
                              selected: _setupOption == 1,
                              selectedColor: AppColors.ink,
                              labelStyle: TextStyle(
                                color: _setupOption == 1 ? Colors.white : AppColors.ink,
                                fontWeight: FontWeight.w700,
                                fontSize: 12,
                              ),
                              showCheckmark: false,
                              onSelected: (bool val) => setState(() => _setupOption = 1),
                            ),
                          ],
                        ),
                        const SizedBox(height: 10),
                        const Text(
                          'Delivery & setup \$150 included in total',
                          style: TextStyle(
                            fontSize: 12,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom Bar
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: Row(
                children: <Widget>[
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: const <Widget>[
                      Text(
                        'Due today',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.inkMuted,
                        ),
                      ),
                      Text(
                        '\$372',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          color: AppColors.ink,
                        ),
                      ),
                    ],
                  ),
                  const Spacer(),
                  FilledButton(
                    onPressed: () {
                      Navigator.of(context).pushNamed(
                        CateringDepositScreen.routeName,
                        arguments: args,
                      );
                    },
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      minimumSize: const Size(140, 48),
                      padding: const EdgeInsets.symmetric(horizontal: 36, vertical: 14),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
                    ),
                    child: const Text(
                      'Continue',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 15),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  static Widget _buildLogisticsRow({
    required IconData icon,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE4E4E7)),
        ),
        child: Row(
          children: <Widget>[
            Icon(icon, size: 20, color: AppColors.ink),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 12,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.inkMuted),
          ],
        ),
      ),
    );
  }
}
