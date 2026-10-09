import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StoreIssuesScreen extends StatefulWidget {
  const StoreIssuesScreen({super.key});

  @override
  State<StoreIssuesScreen> createState() => _StoreIssuesScreenState();
}

class _StoreIssuesScreenState extends State<StoreIssuesScreen> {
  String _activeTab = 'all'; // 'all', 'missing', 'damaged', 'resolved'

  // Interactive resolution state
  bool _bilalRefundApproved = false;
  bool _fatimaForwardedToDoorDash = false;

  void _showDisputeModal(String orderId, String customerName) {
    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 520,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 20,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.shield_outlined,
                        color: AppColors.danger,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Dispute Claim: Order #$orderId',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            'Customer: $customerName · Packing audit counter-evidence',
                            style: const TextStyle(
                              fontSize: 12,
                              color: AppColors.inkMuted,
                            ),
                          ),
                        ],
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AppColors.inkMuted),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: const Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Pack Station Digital Proof',
                        style: TextStyle(fontSize: 13, fontWeight: FontWeight.w700, color: AppColors.ink),
                      ),
                      SizedBox(height: 8),
                      Text(
                        '• Terminal operator marked all items checked & packed at 12:42 PM\n'
                        '• 2 sealed bags verified by barcode scan\n'
                        '• Uber Direct driver accepted sealed bags at 12:47 PM',
                        style: TextStyle(fontSize: 12, color: AppColors.inkMuted, height: 1.5),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShadButton.outline(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Cancel', style: TextStyle(color: AppColors.ink)),
                    ),
                    const SizedBox(width: 10),
                    ShadButton(
                      backgroundColor: AppColors.accent,
                      onPressed: () {
                        Navigator.of(ctx).pop();
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Counter-evidence submitted to Grocerra Support for Order #$orderId')),
                        );
                      },
                      child: const Text('Submit Counter Evidence', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header & Open Inquiries Badge
          _buildHeader(),
          const SizedBox(height: 20),

          // 2. 4 Summary KPI Metric Cards
          _buildKpiCards(),
          const SizedBox(height: 20),

          // 3. Status Tabs
          _buildStatusTabs(),
          const SizedBox(height: 16),

          // 4. Complaints & Issues Cards
          _buildIssuesList(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(18),
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
                  'Order Complaints & Refund Requests',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Resolve missing item claims and damaged goods with 1-tap customer refunds',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Open Inquiries Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF2F2),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFFFECACA)),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.error_outline_rounded, size: 16, color: AppColors.danger),
                SizedBox(width: 8),
                Text(
                  '2 Open Customer Inquiries',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: AppColors.danger,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildKpiCards() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final cardWidth = (constraints.maxWidth - 48) / 4;
        return Wrap(
          spacing: 16,
          runSpacing: 16,
          children: [
            // KPI 1: Open Disputes
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.report_problem_outlined,
              iconColor: AppColors.danger,
              iconBgColor: const Color(0xFFFEF2F2),
              title: 'Open Disputes',
              value: '2 Issues',
              badgeText: 'Action required <2h',
              badgeColor: AppColors.danger,
              subtext: 'Requires store response',
            ),

            // KPI 2: Dispute Rate
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.verified_outlined,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFF0284C7).withOpacity(0.12),
              title: 'Dispute Rate',
              value: '0.28%',
              badgeText: 'Target <1.5%',
              badgeColor: const Color(0xFF0284C7),
              subtext: 'Well below platform threshold',
            ),

            // KPI 3: Total Refunded (MTD)
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.receipt_long_outlined,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFD97706).withOpacity(0.12),
              title: 'Total Refunded (MTD)',
              value: r'$42.50',
              badgeText: '0.2% of gross sales',
              badgeColor: const Color(0xFFD97706),
              subtext: 'Stripe Express customer payouts',
            ),

            // KPI 4: Courier Liability
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.local_shipping_outlined,
              iconColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFF7C3AED).withOpacity(0.12),
              title: 'Courier Liability',
              value: '78%',
              badgeText: 'Covered by 3PL',
              badgeColor: const Color(0xFF7C3AED),
              subtext: 'Uber Direct & DoorDash Drive',
            ),
          ],
        );
      },
    );
  }

  Widget _buildKpiCard({
    required double width,
    required IconData icon,
    required Color iconColor,
    required Color iconBgColor,
    required String title,
    required String value,
    required String badgeText,
    required Color badgeColor,
    required String subtext,
  }) {
    return Container(
      width: width < 220 ? 220 : width,
      padding: const EdgeInsets.all(18),
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
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.inkMuted,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 32,
                height: 32,
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    value,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Wrap(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: badgeColor.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  badgeText,
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w700,
                    color: badgeColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            subtext,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatusTabs() {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _buildTabItem('all', 'All Claims (2)'),
          _buildTabItem('missing', 'Missing Items (1)'),
          _buildTabItem('damaged', 'Transit Damage (1)'),
          _buildTabItem('resolved', 'Resolved (14)'),
        ],
      ),
    );
  }

  Widget _buildTabItem(String key, String label) {
    final isSelected = _activeTab == key;
    return InkWell(
      onTap: () => setState(() => _activeTab = key),
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.canvas : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: AppColors.hairline) : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12.5,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.ink : AppColors.inkMuted,
          ),
        ),
      ),
    );
  }

  Widget _buildIssuesList() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        children: [
          // Case 1: Bilal T. (Missing Item)
          if (_activeTab == 'all' || _activeTab == 'missing')
            _buildBilalCaseCard(),

          if ((_activeTab == 'all' || _activeTab == 'missing') &&
              (_activeTab == 'all' || _activeTab == 'damaged'))
            const Divider(height: 1, color: AppColors.hairline),

          // Case 2: Fatima S. (Transit Damage)
          if (_activeTab == 'all' || _activeTab == 'damaged')
            _buildFatimaCaseCard(),

          // Case 3: Tariq M. (Resolved)
          if (_activeTab == 'resolved')
            _buildResolvedCaseCard(),
        ],
      ),
    );
  }

  // Case 1: Bilal T. Missing Item
  Widget _buildBilalCaseCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Order #8476 · Bilal T.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFEF2F2),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFECACA)),
                      ),
                      child: const Text(
                        'Missing Item Reported',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF991B1B),
                        ),
                      ),
                    ),
                    const Text(
                      'Delivered Today 12:55 PM (Uber Direct)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Customer says: "1x Shan Biryani Masala (\$2.45) was not in bag #2."',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Packing Station Log: 4 items packed in 2 sealed bags at 12:42 PM.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right action buttons
          if (_bilalRefundApproved)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.accent.withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: AppColors.accent.withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: AppColors.accent),
                  SizedBox(width: 6),
                  Text(
                    '✓ Refund Approved (\$2.45)',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: AppColors.accent),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ShadButton(
                  backgroundColor: AppColors.accent,
                  onPressed: () {
                    setState(() {
                      _bilalRefundApproved = true;
                    });
                  },
                  child: const Text('Approve \$2.45 Refund', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
                ShadButton.outline(
                  onPressed: () => _showDisputeModal('8476', 'Bilal T.'),
                  child: const Text('Dispute Claim', style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Case 2: Fatima S. Transit Damage
  Widget _buildFatimaCaseCard() {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: [
                    const Text(
                      'Order #8468 · Fatima S.',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFFFFBEB),
                        borderRadius: BorderRadius.circular(4),
                        border: Border.all(color: const Color(0xFFFDE68A)),
                      ),
                      child: const Text(
                        'Bag Packaging Torn',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF92400E),
                        ),
                      ),
                    ),
                    const Text(
                      'Delivered Yesterday 5:20 PM (DoorDash Drive)',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Customer photo uploaded: Outer chilled meat bag punctured during courier transit.',
                  style: TextStyle(
                    fontSize: 13.5,
                    fontStyle: FontStyle.italic,
                    color: AppColors.ink,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Courier Telemetry: DoorDash Drive courier recorded hard braking event en-route.',
                  style: TextStyle(
                    fontSize: 12,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right action buttons
          if (_fatimaForwardedToDoorDash)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0284C7).withOpacity(0.12),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: const Color(0xFF0284C7).withOpacity(0.3)),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.check_circle_rounded, size: 16, color: Color(0xFF0284C7)),
                  SizedBox(width: 6),
                  Text(
                    '✓ Forwarded to DoorDash Drive',
                    style: TextStyle(fontSize: 12.5, fontWeight: FontWeight.w700, color: Color(0xFF0284C7)),
                  ),
                ],
              ),
            )
          else
            Wrap(
              spacing: 8,
              runSpacing: 6,
              children: [
                ShadButton.outline(
                  onPressed: () {
                    setState(() {
                      _fatimaForwardedToDoorDash = true;
                    });
                  },
                  child: const Text(
                    'Courier Liable (Forward to DoorDash)',
                    style: TextStyle(color: Color(0xFFDC2626), fontWeight: FontWeight.w700),
                  ),
                ),
                ShadButton(
                  backgroundColor: AppColors.accent,
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Issued \$10.00 store credit to Fatima S.')),
                    );
                  },
                  child: const Text('Store Credit \$10', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
                ),
              ],
            ),
        ],
      ),
    );
  }

  // Case 3: Tariq M. Resolved
  Widget _buildResolvedCaseCard() {
    return const Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 10,
                  runSpacing: 4,
                  crossAxisAlignment: WrapCrossAlignment.center,
                  children: const [
                    Text(
                      'Order #8452 · Tariq M.',
                      style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700, color: AppColors.ink),
                    ),
                    Text(
                      'Delivered Monday 6:15 PM (Uber Direct)',
                      style: TextStyle(fontSize: 12, color: AppColors.inkMuted),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Text(
                  'Customer out-of-stock compensation. Processed automatically via Stripe Express.',
                  style: TextStyle(fontSize: 13, color: AppColors.ink),
                ),
              ],
            ),
          ),
          SizedBox(width: 16),
          Text(
            '✓ Resolved · Refunded \$12.50',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.accent),
          ),
        ],
      ),
    );
  }
}
