import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';

/// Figma `B6 · Checkout v2 · Top` — exact 390×844 frame port.
///
/// Scrollable screen with fixed glass header (back, title) and a bottom
/// action bar. The floating tab bar is owned by `HomeShell`; we pad the
/// bottom by `AppInsets.tabBar`.
class CheckoutTopScreen extends StatefulWidget {
  const CheckoutTopScreen();

  static const String routeName = '/checkout';

  @override
  State<CheckoutTopScreen> createState() => _CheckoutTopScreenState();
}

class _CheckoutTopScreenState extends State<CheckoutTopScreen> {
  int _mode = 0; // 0 = Delivery, 1 = Pickup
  int _selectedTimeOption = 1; // 0=Priority, 1=Standard, 2=Schedule

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, topInset, 0, AppInsets.tabBar),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            _buildHeader(),
            _buildModeSelector(),
            _buildMap(),
            _buildDetailsSection(),
            _buildDeliveryTime(),
            _buildTimeOptions(),
            _buildBottomActionBar(),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      height: 112,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Back button 40×40 #f3f3f3
          Align(
            alignment: Alignment.centerLeft,
            child: Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt,
                borderRadius: BorderRadius.circular(20),
              ),
              child: IconButton(
                padding: EdgeInsets.zero,
                icon: const Icon(Icons.arrow_back, size: 24, color: AppColors.ink),
                onPressed: () => Navigator.of(context).maybePop(),
              ),
            ),
          ),
          const SizedBox(height: 12),
          Text(
            'Checkout',
            style: const TextStyle(
              fontSize: 30,
              height: 36 / 30,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildModeSelector() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(24),
        ),
        child: Row(
          children: <Widget>[
            // Delivery segment
            Expanded(
              child: _ModeSegment(
                label: 'Delivery',
                selected: _mode == 0,
                onTap: () => setState(() => _mode = 0),
              ),
            ),
            // Pickup segment
            Expanded(
              child: _ModeSegment(
                label: 'Pickup',
                selected: _mode == 1,
                onTap: () => setState(() => _mode = 1),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMap() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Container(
        width: 358,
        height: 168,
        decoration: BoxDecoration(
          color: const Color(0xFFEAEAEA),
          borderRadius: BorderRadius.circular(AppRadius.xl),
        ),
        child: Stack(
          children: <Widget>[
            // Map placeholder visual
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  Container(
                    width: 36,
                    height: 36,
                    decoration: const BoxDecoration(
                      color: AppColors.ink,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Container(
                        width: 10,
                        height: 10,
                        decoration: const BoxDecoration(
                          color: AppColors.surface,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Container(
                    width: 4,
                    height: 12,
                    color: AppColors.ink,
                  ),
                ],
              ),
            ),
            // "Edit pin" button
            Positioned(
              bottom: 12,
              left: 133.5,
              child: Container(
                width: 91,
                height: 38,
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(19),
                ),
                alignment: Alignment.center,
                child: const Text(
                  'Edit pin',
                  style: TextStyle(
                    fontSize: 15,
                    height: 18 / 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDetailsSection() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Column(
        children: <Widget>[
          _DetailRow(
            icon: Icons.location_on,
            title: '24 Maple Street, Apt 3B',
            subtitle: 'Melbourne VIC 3000',
            onTap: () => Navigator.of(context).pushNamed('/delivery-address'),
          ),
          _buildDivider(),
          _DetailRow(
            icon: Icons.home,
            title: 'Meet at my door',
            subtitle: 'Add delivery instructions',
            onTap: () {},
          ),
          _buildDivider(),
          _DetailRow(
            icon: Icons.phone,
            title: 'Sara Ahmed · 0412 345 678',
            subtitle: 'Courier will call on arrival',
            onTap: () {},
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() {
    return Container(
      height: 1,
      color: AppColors.hairline,
      margin: const EdgeInsets.symmetric(horizontal: 16),
    );
  }

  Widget _buildDeliveryTime() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          const Icon(Icons.access_time, size: 24, color: AppColors.ink),
          const SizedBox(width: 14),
          const Text(
            'Delivery time',
            style: TextStyle(
              fontSize: 16,
              height: 19 / 16,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          Spacer(),
          Text(
            '7:31–7:54 PM',
            style: const TextStyle(
              fontSize: 16,
              height: 19 / 16,
              fontWeight: FontWeight.w400,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeOptions() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: _TimeOptionCard(
              label: 'Priority',
              time: '7:26–7:43 PM',
              description: 'Direct to you. Top-rated couriers',
              surcharge: '+\$4.49',
              selected: _selectedTimeOption == 0,
              onTap: () => setState(() => _selectedTimeOption = 0),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeOptionCard(
              label: 'Standard',
              time: '7:31–7:54 PM',
              description: 'Included with your order',
              surcharge: null,
              selected: _selectedTimeOption == 1,
              onTap: () => setState(() => _selectedTimeOption = 1),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _TimeOptionCard(
              label: 'Schedule',
              time: 'Earliest: 8:00 PM',
              description: 'Pick a time that works for you',
              surcharge: null,
              selected: _selectedTimeOption == 2,
              onTap: () => setState(() => _selectedTimeOption = 2),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBottomActionBar() {
    return Container(
      width: 390,
      color: AppColors.surface,
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 16),
      child: Column(
        children: <Widget>[
          // Savings banner 390×38 #f3f3f3
          Container(
            height: 38,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(19),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: <Widget>[
                const Icon(Icons.local_offer, size: 18, color: AppColors.ink),
                const SizedBox(width: 12),
                const Text(
                  'Saving \$2.50 with promotions',
                  style: TextStyle(
                    fontSize: 14,
                    height: 17 / 14,
                    fontWeight: FontWeight.w500,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Place order button 358×56 black
          Row(
            children: <Widget>[
              // Total column
              SizedBox(
                width: 71,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    const Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 12,
                        height: 15 / 12,
                        fontWeight: FontWeight.w500,
                        color: AppColors.inkMuted,
                      ),
                    ),
                    const SizedBox(height: 4),
                    const Text(
                      '\$62.36',
                      style: TextStyle(
                        fontSize: 20,
                        height: 24 / 20,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 16),
              // Place order button
              Expanded(
                child: FilledButton(
                  onPressed: () => Navigator.of(context).pushNamed('/checkout/summary'),
                  child: const Text(
                    'Place order',
                    style: TextStyle(
                      fontSize: 16,
                      height: 19 / 16,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _ModeSegment extends StatelessWidget {
  const _ModeSegment({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 40,
        margin: const EdgeInsets.all(4),
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: selected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 15,
            height: 18 / 15,
            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
            color: selected ? AppColors.ink : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.title,
    required this.subtitle,
    this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final Widget row = Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: Row(
        children: <Widget>[
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(24),
            ),
            child: Icon(icon, size: 24, color: AppColors.ink),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 16,
                    height: 19 / 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    fontSize: 13,
                    height: 16 / 13,
                    fontWeight: FontWeight.w400,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const Icon(Icons.chevron_right, size: 20, color: AppColors.ink),
        ],
      ),
    );

    if (onTap != null) {
      return InkWell(onTap: onTap, child: row);
    }
    return row;
  }
}

class _TimeOptionCard extends StatelessWidget {
  const _TimeOptionCard({
    required this.label,
    required this.time,
    required this.description,
    required this.surcharge,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final String time;
  final String description;
  final String? surcharge;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 150,
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: selected ? const Color(0xFFD6EBD6) : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.xl),
          border: Border.all(
            color: selected ? const Color(0xFF05944F) : Colors.transparent,
            width: selected ? 2 : 0,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                height: 19 / 14,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              time,
              style: const TextStyle(
                fontSize: 13,
                height: 16 / 13,
                fontWeight: FontWeight.w400,
                color: AppColors.inkMuted,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                height: 16 / 13,
                fontWeight: FontWeight.w400,
                color: AppColors.inkMuted,
              ),
            ),
            if (surcharge != null) ...<Widget>[
              Spacer(),
              Text(
                surcharge!,
                style: const TextStyle(
                  fontSize: 13,
                  height: 16 / 13,
                  fontWeight: FontWeight.w400,
                  color: AppColors.inkMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}