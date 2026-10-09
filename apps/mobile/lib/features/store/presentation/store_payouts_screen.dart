import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StorePayoutsScreen extends StatefulWidget {
  const StorePayoutsScreen({super.key});

  @override
  State<StorePayoutsScreen> createState() => _StorePayoutsScreenState();
}

class _StorePayoutsScreenState extends State<StorePayoutsScreen> {
  // Mock payout ledger entries
  final List<Map<String, dynamic>> _payouts = const [
    {
      'date': 'Tuesday, 6 Oct 2026',
      'ref': 'po_1Nw82910Grocerra',
      'gross': r'$4,820.00',
      'fee': r'-$216.90',
      'net': r'$4,603.10',
      'status': 'Deposited',
      'ordersCount': 92,
    },
    {
      'date': 'Friday, 2 Oct 2026',
      'ref': 'po_1Nv71842Grocerra',
      'gross': r'$5,340.50',
      'fee': r'-$240.32',
      'net': r'$5,100.18',
      'status': 'Deposited',
      'ordersCount': 104,
    },
    {
      'date': 'Tuesday, 29 Sep 2026',
      'ref': 'po_1Nu60911Grocerra',
      'gross': r'$4,110.00',
      'fee': r'-$184.95',
      'net': r'$3,925.05',
      'status': 'Deposited',
      'ordersCount': 78,
    },
    {
      'date': 'Friday, 25 Sep 2026',
      'ref': 'po_1Nt50820Grocerra',
      'gross': r'$3,890.00',
      'fee': r'-$175.05',
      'net': r'$3,714.95',
      'status': 'Deposited',
      'ordersCount': 74,
    },
    {
      'date': 'Tuesday, 22 Sep 2026',
      'ref': 'po_1Ns40719Grocerra',
      'gross': r'$4,520.00',
      'fee': r'-$203.40',
      'net': r'$4,316.60',
      'status': 'Deposited',
      'ordersCount': 86,
    },
  ];

  void _showTaxStatementDialog() {
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
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: const Icon(
                        Icons.receipt_long_outlined,
                        color: AppColors.accent,
                        size: 22,
                      ),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Merchant Tax Statement (CSV)',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'ATO BAS GST summary and Stripe Connect settlements',
                            style: TextStyle(
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
                  child: Column(
                    children: [
                      _buildStatementRow('File Name', 'grocerra_tax_statement_fy26.csv'),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildStatementRow('Period', 'FY 2026-27 YTD'),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildStatementRow('Gross Sales', r'$22,680.50'),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildStatementRow('Grocerra Platform Fees', r'-$1,020.62'),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildStatementRow('GST Component', r'$2,061.86'),
                      const Divider(height: 16, color: AppColors.hairline),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Status',
                            style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
                          ),
                          const SizedBox(width: 8),
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.accent.withOpacity(0.12),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: const Text(
                              'Download Completed',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.w700,
                                color: AppColors.accent,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShadButton(
                      backgroundColor: AppColors.accent,
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Done', style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600)),
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

  Widget _buildStatementRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
        ),
        const SizedBox(width: 12),
        Flexible(
          child: Text(
            value,
            style: const TextStyle(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
            textAlign: TextAlign.end,
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Top Header & Action Bar
          _buildHeader(),
          const SizedBox(height: 20),

          // 2. 4 Core Financial KPI Cards
          _buildKpiCards(),
          const SizedBox(height: 20),

          // 3. Stripe Connect Account Banner
          _buildStripeCard(),
          const SizedBox(height: 20),

          // 4. Payout Transfers Ledger Table
          _buildLedgerCard(),
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
                  'Payouts & Financial Earnings',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Automated rolling 2-day payouts via Stripe Express to your nominated Australian bank account',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Download Tax Statement Button
          ShadButton.outline(
            onPressed: _showTaxStatementDialog,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.download_rounded, size: 16, color: AppColors.ink),
                SizedBox(width: 8),
                Text(
                  'Download Tax Statement (CSV)',
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
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
            // KPI 1: Available Balance
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.account_balance_wallet_outlined,
              iconColor: AppColors.accent,
              iconBgColor: AppColors.accent.withOpacity(0.12),
              title: 'Available Balance',
              value: r'$2,418.50',
              badgeText: '● Auto-transferring Tuesday',
              badgeColor: AppColors.accent,
              subtext: 'Rolling settlement into ANZ',
            ),

            // KPI 2: Pending Processing
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.hourglass_top_outlined,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFF0284C7).withOpacity(0.12),
              title: 'Pending Processing',
              value: r'$684.20',
              badgeText: "Today's unsettled orders",
              badgeColor: const Color(0xFF0284C7),
              subtext: 'Capturing on customer delivery',
            ),

            // KPI 3: Month-to-Date Net
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.trending_up_rounded,
              iconColor: const Color(0xFF10B981),
              iconBgColor: const Color(0xFF10B981).withOpacity(0.12),
              title: 'Month-to-Date Net',
              value: r'$18,940.00',
              badgeText: '+22.4% vs last month',
              badgeColor: const Color(0xFF10B981),
              subtext: 'Net after 4.5% platform fee',
            ),

            // KPI 4: Grocerra Commission
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.percent_rounded,
              iconColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFF7C3AED).withOpacity(0.12),
              title: 'Grocerra Commission',
              value: '4.5%',
              badgeText: 'Lowest merchant fee in AU',
              badgeColor: const Color(0xFF7C3AED),
              subtext: 'Flat transparent tier + GST',
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

  Widget _buildStripeCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          // Left Stripe Account Info
          Expanded(
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF635BFF),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Text(
                    'Stripe Connect',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'ANZ Business Classic Account (ending in ···· 4821)',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                      SizedBox(height: 2),
                      Text(
                        'ABN 84 921 402 189 · Verified Active & Halal Certified Merchant',
                        style: TextStyle(
                          fontSize: 12,
                          color: AppColors.inkMuted,
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right Status & Action
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text(
                  'Connected & Healthy',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.accent,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              ShadButton.outline(
                onPressed: () {},
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Manage on Stripe', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600)),
                    SizedBox(width: 6),
                    Icon(Icons.open_in_new_rounded, size: 14, color: AppColors.inkMuted),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLedgerCard() {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Payout Transfers Ledger',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text(
                      'Historical 2-day settlement transfers deposited to your business bank account',
                      style: TextStyle(
                        fontSize: 12,
                        color: AppColors.inkMuted,
                      ),
                    ),
                  ],
                ),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: AppColors.canvas,
                    borderRadius: BorderRadius.circular(6),
                    border: Border.all(color: AppColors.hairline),
                  ),
                  child: Text(
                    '${_payouts.length} Transfers',
                    style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkMuted),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 1, color: AppColors.hairline),

          // Horizontal scroll table guard with 1080px guaranteed width
          LayoutBuilder(
            builder: (context, constraints) {
              const minTableWidth = 1080.0;
              final tableWidth = constraints.maxWidth > minTableWidth ? constraints.maxWidth : minTableWidth;

              return SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: tableWidth,
                  child: Column(
                    children: [
                      _buildTableHeader(),
                      const Divider(height: 1, color: AppColors.hairline),
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: _payouts.length,
                        separatorBuilder: (_, __) => const Divider(height: 1, color: AppColors.hairline),
                        itemBuilder: (context, index) {
                          return _buildPayoutRow(_payouts[index]);
                        },
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildTableHeader() {
    return Container(
      color: AppColors.canvas,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      child: const Row(
        children: [
          SizedBox(
            width: 220,
            child: Text(
              'Payout Date',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
          SizedBox(
            width: 240,
            child: Text(
              'Transfer Reference',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
          SizedBox(
            width: 160,
            child: Text(
              'Gross Sales',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
          SizedBox(
            width: 160,
            child: Text(
              'Commission (4.5%)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
          SizedBox(
            width: 160,
            child: Text(
              r'Net Paid ($ AUD)',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
          SizedBox(
            width: 140,
            child: Text(
              'Status',
              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPayoutRow(Map<String, dynamic> item) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
      child: Row(
        children: [
          // Payout Date
          SizedBox(
            width: 220,
            child: Text(
              item['date'] as String,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),

          // Transfer Reference (monospace)
          SizedBox(
            width: 240,
            child: Text(
              item['ref'] as String,
              style: const TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                fontFamily: 'monospace',
                color: AppColors.inkMuted,
              ),
            ),
          ),

          // Gross Sales
          SizedBox(
            width: 160,
            child: Text(
              item['gross'] as String,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: AppColors.ink,
              ),
            ),
          ),

          // Commission (4.5%)
          SizedBox(
            width: 160,
            child: Text(
              item['fee'] as String,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Color(0xFFDC2626),
              ),
            ),
          ),

          // Net Paid ($ AUD)
          SizedBox(
            width: 160,
            child: Text(
              item['net'] as String,
              style: const TextStyle(
                fontSize: 13.5,
                fontWeight: FontWeight.w800,
                color: AppColors.accent,
              ),
            ),
          ),

          // Status Badge
          SizedBox(
            width: 140,
            child: Align(
              alignment: Alignment.centerLeft,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.accent.withOpacity(0.12),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.check_circle_rounded, size: 12, color: AppColors.accent),
                    const SizedBox(width: 4),
                    Text(
                      item['status'] as String,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
