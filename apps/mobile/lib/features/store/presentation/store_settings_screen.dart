import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StoreSettingsScreen extends StatefulWidget {
  const StoreSettingsScreen({super.key});

  @override
  State<StoreSettingsScreen> createState() => _StoreSettingsScreenState();
}

class _StoreSettingsScreenState extends State<StoreSettingsScreen> {
  // Store status
  bool _isStoreOpen = true;

  // Rush Pause state
  String? _activeRushPause; // null, '15m', '30m', '60m', 'day'

  // Prep Buffer state
  String _activePrepBuffer = '0m'; // '0m', '5m', '10m', '15m'

  // Delivery Partners state
  bool _uberDirectActive = true;
  bool _doordashDriveActive = true;

  // Thermal Printer state
  bool _autoPrintOrders = true;
  bool _printWeightSlips = true;
  bool _testSlipPrinted = false;

  void _triggerRushPause(String durationKey, String label) {
    setState(() {
      _activeRushPause = durationKey;
    });
  }

  void _clearRushPause() {
    setState(() {
      _activeRushPause = null;
    });
  }

  void _setPrepBuffer(String bufferKey) {
    setState(() {
      _activePrepBuffer = bufferKey;
    });
  }

  void _triggerTestPrint() {
    setState(() {
      _testSlipPrinted = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.only(bottom: 40),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header
          _buildHeader(),
          const SizedBox(height: 20),

          // 2. Emergency Rush Mode Pause Card
          _buildEmergencyRushPauseCard(),
          const SizedBox(height: 20),

          // 3. Prep Time Buffer Card
          _buildPrepBufferCard(),
          const SizedBox(height: 20),

          // 4. On-Demand Delivery Fleet Partners (Uber Direct & DoorDash Drive ONLY)
          _buildDeliveryPartnersCard(),
          const SizedBox(height: 20),

          // 5. Thermal ESC/POS Hardware Card
          _buildThermalHardwareCard(),
          const SizedBox(height: 20),

          // 6. Weekly Trading Hours & Schedule Card
          _buildTradingHoursCard(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title & Subtitle
          const Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Store Operating Controls & Settings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Emergency rush pauses, kitchen buffer times, dispatch partners, and thermal printer setup',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Master Store Open/Closed Toggle
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: _isStoreOpen ? const Color(0xFFECFDF5) : const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: _isStoreOpen ? const Color(0xFFA7F3D0) : const Color(0xFFFECACA),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  _isStoreOpen ? '● Store Open for Online Orders' : '○ Store Closed for Orders',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: _isStoreOpen ? AppColors.accentDark : AppColors.danger,
                  ),
                ),
                const SizedBox(width: 10),
                ShadSwitch(
                  value: _isStoreOpen,
                  onChanged: (val) => setState(() => _isStoreOpen = val),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildEmergencyRushPauseCard() {
    final bool isPaused = _activeRushPause != null;

    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: const Color(0xFFFEF2F2),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFFFECACA)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: AppColors.danger.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(Icons.pause_circle_outline, color: AppColors.danger, size: 22),
                    ),
                    const SizedBox(width: 12),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Emergency Rush Mode Pause',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w800,
                              color: Color(0xFF991B1B),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Temporarily pause incoming customer orders during overwhelming counter rushes',
                            style: TextStyle(
                              fontSize: 12.5,
                              color: Color(0xFF7F1D1D),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              if (isPaused)
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                  decoration: BoxDecoration(
                    color: AppColors.danger,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    'Active: ${_activeRushPause == '15m' ? '15m' : _activeRushPause == '30m' ? '30m' : _activeRushPause == '60m' ? '60m' : 'Day'} Rush Pause Active',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 18),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildPauseButton(
                durationKey: '15m',
                label: 'Pause 15 Mins',
                isActive: _activeRushPause == '15m',
              ),
              _buildPauseButton(
                durationKey: '30m',
                label: 'Pause 30 Mins',
                isActive: _activeRushPause == '30m',
              ),
              _buildPauseButton(
                durationKey: '60m',
                label: 'Pause 60 Mins',
                isActive: _activeRushPause == '60m',
              ),
              _buildPauseButton(
                durationKey: 'day',
                label: 'Pause Rest of Day',
                isActive: _activeRushPause == 'day',
                isCritical: true,
              ),
              if (isPaused)
                ShadButton.outline(
                  onPressed: _clearRushPause,
                  child: const Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.play_arrow, size: 16, color: AppColors.accentDark),
                      SizedBox(width: 6),
                      Text(
                        'Resume Orders Now',
                        style: TextStyle(color: AppColors.accentDark, fontWeight: FontWeight.w700, fontSize: 12.5),
                      ),
                    ],
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPauseButton({
    required String durationKey,
    required String label,
    required bool isActive,
    bool isCritical = false,
  }) {
    return ShadButton(
      backgroundColor: isActive
          ? AppColors.danger
          : (isCritical ? const Color(0xFFB91C1C) : Colors.white),
      onPressed: () => _triggerRushPause(durationKey, label),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 12.5,
          fontWeight: FontWeight.w700,
          color: isActive || isCritical ? Colors.white : const Color(0xFF991B1B),
        ),
      ),
    );
  }

  Widget _buildPrepBufferCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Kitchen & Butcher Prep Buffer',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Adds extra prep minutes to driver arrival dispatch during peak rushes to protect cold chain SLA',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: _activePrepBuffer == '0m' ? AppColors.canvas : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(
                    color: _activePrepBuffer == '0m' ? AppColors.hairline : const Color(0xFFFDE68A),
                  ),
                ),
                child: Text(
                  _activePrepBuffer == '0m'
                      ? 'Normal Pace Active'
                      : '+${_activePrepBuffer == '5m' ? '5' : _activePrepBuffer == '10m' ? '10' : '15'} min Buffer Active',
                  style: TextStyle(
                    fontSize: 11.5,
                    fontWeight: FontWeight.w700,
                    color: _activePrepBuffer == '0m' ? AppColors.inkMuted : const Color(0xFF92400E),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 10,
            runSpacing: 8,
            children: [
              _buildBufferChip(
                bufferKey: '0m',
                label: 'Normal (+0 mins)',
                sublabel: 'Standard SLA',
              ),
              _buildBufferChip(
                bufferKey: '5m',
                label: '+5 mins (Rainy Rush)',
                sublabel: 'High order volume',
              ),
              _buildBufferChip(
                bufferKey: '10m',
                label: '+10 mins (Peak Butcher)',
                sublabel: 'Heavy meat cutting delay',
              ),
              _buildBufferChip(
                bufferKey: '15m',
                label: '+15 mins (Heavy Rush)',
                sublabel: 'Maximum kitchen queue buffer',
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildBufferChip({
    required String bufferKey,
    required String label,
    required String sublabel,
  }) {
    final bool isSelected = _activePrepBuffer == bufferKey;

    return InkWell(
      onTap: () => _setPrepBuffer(bufferKey),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFFECFDF5) : AppColors.canvas,
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: isSelected ? AppColors.accent : AppColors.hairline,
            width: isSelected ? 1.5 : 1,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  isSelected ? Icons.check_circle : Icons.radio_button_unchecked,
                  size: 15,
                  color: isSelected ? AppColors.accent : AppColors.inkMuted,
                ),
                const SizedBox(width: 8),
                Text(
                  label,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: isSelected ? AppColors.accentDark : AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 2),
            Padding(
              padding: const EdgeInsets.only(left: 23),
              child: Text(
                sublabel,
                style: const TextStyle(
                  fontSize: 11,
                  color: AppColors.inkMuted,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDeliveryPartnersCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'On-Demand Delivery Fleet Partners',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Enterprise courier dispatch API connections — 100% managed by Uber Direct and DoorDash Drive fleets',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 18),

          // Uber Direct & DoorDash Drive Cards
          LayoutBuilder(
            builder: (context, constraints) {
              final isWide = constraints.maxWidth > 700;
              final cardWidth = isWide ? (constraints.maxWidth - 16) / 2 : constraints.maxWidth;

              return Wrap(
                spacing: 16,
                runSpacing: 14,
                children: [
                  // Partner 1: Uber Direct
                  _buildPartnerCard(
                    width: cardWidth,
                    name: 'Uber Direct Courier Dispatch',
                    badgeText: 'Primary Courier',
                    etaSla: 'Uber Direct ETA: 8-12m',
                    radius: '15km delivery radius',
                    isActive: _uberDirectActive,
                    onToggle: (val) => setState(() => _uberDirectActive = val),
                    icon: Icons.directions_car_filled_outlined,
                  ),

                  // Partner 2: DoorDash Drive
                  _buildPartnerCard(
                    width: cardWidth,
                    name: 'DoorDash Drive Courier Dispatch',
                    badgeText: 'Secondary Fleet',
                    etaSla: 'DoorDash Drive ETA: 10-15m',
                    radius: '12km delivery radius',
                    isActive: _doordashDriveActive,
                    onToggle: (val) => setState(() => _doordashDriveActive = val),
                    icon: Icons.electric_moped_outlined,
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildPartnerCard({
    required double width,
    required String name,
    required String badgeText,
    required String etaSla,
    required String radius,
    required bool isActive,
    required ValueChanged<bool> onToggle,
    required IconData icon,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.canvas,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: AppColors.hairline),
                      ),
                      child: Icon(icon, size: 20, color: AppColors.ink),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            name,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            radius,
                            style: const TextStyle(
                              fontSize: 11.5,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              ShadSwitch(
                value: isActive,
                onChanged: onToggle,
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Divider(height: 1, color: AppColors.hairline),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  badgeText,
                  style: const TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accentDark,
                  ),
                ),
              ),
              Text(
                etaSla,
                style: const TextStyle(
                  fontSize: 11.5,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildThermalHardwareCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thermal ESC/POS Hardware',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Bluetooth / LAN thermal slip printer for prep kitchen and driver handoff bags',
                      style: TextStyle(
                        fontSize: 12.5,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 12),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: const Color(0xFFECFDF5),
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: const Color(0xFFA7F3D0)),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.check_circle, size: 14, color: AppColors.accentDark),
                    SizedBox(width: 6),
                    Text(
                      'Online',
                      style: TextStyle(
                        fontSize: 11.5,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Printer Connection Row
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Row(
                  children: [
                    Icon(Icons.print_outlined, size: 20, color: AppColors.ink),
                    SizedBox(width: 12),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Epson TM-T88VI (LAN Connected · 192.168.1.140)',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          '80mm standard roll · Auto-cutter enabled · ESC/POS protocol',
                          style: TextStyle(
                            fontSize: 11.5,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
                ShadButton(
                  backgroundColor: AppColors.accent,
                  onPressed: _triggerTestPrint,
                  child: Text(
                    _testSlipPrinted ? '✓ Test Slip Sent to TM-T88VI' : 'Test Print Slip',
                    style: const TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Toggles
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Auto-print incoming orders on tablet chime',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Immediately cuts an order prep ticket as soon as payment is confirmed',
                      style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              ShadSwitch(
                value: _autoPrintOrders,
                onChanged: (val) => setState(() => _autoPrintOrders = val),
              ),
            ],
          ),
          const SizedBox(height: 12),
          const Divider(height: 1, color: AppColors.hairline),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Print dual bag slips with catch-weight audit',
                      style: TextStyle(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      'Generates QR bag verification labels for chilled and ambient grocery bags',
                      style: TextStyle(fontSize: 11.5, color: AppColors.inkMuted),
                    ),
                  ],
                ),
              ),
              ShadSwitch(
                value: _printWeightSlips,
                onChanged: (val) => setState(() => _printWeightSlips = val),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTradingHoursCard() {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Weekly Trading Hours & Operating Schedule',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Defines store availability in the Grocerra Customer App and automatic store open/close triggers',
            style: TextStyle(
              fontSize: 12.5,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 16),

          // Schedule Rows
          Container(
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            child: const Column(
              children: [
                _ScheduleRow(day: 'Monday – Friday', hours: '08:00 AM – 09:00 PM', status: 'Standard'),
                Divider(height: 1, color: AppColors.hairline),
                _ScheduleRow(day: 'Saturday', hours: '08:00 AM – 09:00 PM', status: 'Standard'),
                Divider(height: 1, color: AppColors.hairline),
                _ScheduleRow(day: 'Sunday', hours: '09:00 AM – 08:00 PM', status: 'Modified'),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Notice Banner
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF3C7),
              borderRadius: BorderRadius.circular(6),
              border: Border.all(color: const Color(0xFFFDE68A)),
            ),
            child: const Row(
              children: [
                Icon(Icons.info_outline, size: 16, color: Color(0xFF92400E)),
                SizedBox(width: 10),
                Expanded(
                  child: Text(
                    'Special Holiday / Eid Schedule: Extended trading to 11:00 PM on Friday',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF92400E),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _ScheduleRow extends StatelessWidget {
  final String day;
  final String hours;
  final String status;

  const _ScheduleRow({
    required this.day,
    required this.hours,
    required this.status,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            day,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
          Row(
            children: [
              Text(
                hours,
                style: const TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(width: 16),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: status == 'Standard' ? const Color(0xFFECFDF5) : const Color(0xFFFEF3C7),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  status,
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.w700,
                    color: status == 'Standard' ? AppColors.accentDark : const Color(0xFF92400E),
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
