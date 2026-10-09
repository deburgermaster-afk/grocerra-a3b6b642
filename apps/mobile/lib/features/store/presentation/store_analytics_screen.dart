import 'dart:math' as math;
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class StoreAnalyticsScreen extends StatefulWidget {
  const StoreAnalyticsScreen({super.key});

  @override
  State<StoreAnalyticsScreen> createState() => _StoreAnalyticsScreenState();
}

class _StoreAnalyticsScreenState extends State<StoreAnalyticsScreen> {
  String _selectedTimeframe = 'Today'; // 'Today', 'This Week', 'This Month', 'Custom'

  // Metric values based on timeframe
  String get _grossSales {
    switch (_selectedTimeframe) {
      case 'This Week':
        return r'$9,840.00';
      case 'This Month':
        return r'$38,450.00';
      default:
        return r'$1,482.50';
    }
  }

  String get _grossSalesTrend {
    switch (_selectedTimeframe) {
      case 'This Week':
        return '+14.2% vs last week';
      case 'This Month':
        return '+22.8% vs last month';
      default:
        return '+18.4% vs yesterday';
    }
  }

  String get _fulfilledOrders {
    switch (_selectedTimeframe) {
      case 'This Week':
        return '184 Orders';
      case 'This Month':
        return '720 Orders';
      default:
        return '28 Orders';
    }
  }

  String get _avgTicket {
    switch (_selectedTimeframe) {
      case 'This Week':
        return r'Avg Ticket: $53.47';
      case 'This Month':
        return r'Avg Ticket: $53.40';
      default:
        return r'Avg Ticket: $52.94';
    }
  }

  String get _avgPackSpeed => '7.2 mins';

  void _showExportDialog() {
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
                        Icons.file_download_outlined,
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
                            'Store Analytics CSV Exported',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Report generated and ready for accounting & ATO reconciliation',
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
                      _buildExportRow('File Name', 'madina_store_analytics_20261009.csv'),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildExportRow('Timeframe', _selectedTimeframe),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildExportRow('Total Orders', _fulfilledOrders),
                      const Divider(height: 16, color: AppColors.hairline),
                      _buildExportRow('Gross Total', _grossSales),
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

  Widget _buildExportRow(String label, String value) {
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

          // 2. 4 Core KPI Metric Cards
          _buildKpiCards(),
          const SizedBox(height: 20),

          // 3. Visual Charts & Analytical Breakdowns
          _buildChartsSection(),
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
                  'Analytics & Performance',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.4,
                    color: AppColors.ink,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Real-time store metrics, fulfillment efficiency, and category sales breakdown',
                  style: TextStyle(
                    fontSize: 13,
                    color: AppColors.inkMuted,
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: Timeframe Segmented Tabs + Export Button
          Wrap(
            spacing: 12,
            crossAxisAlignment: WrapCrossAlignment.center,
            children: [
              // Timeframe Tabs Container
              Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildTimeframeTab('Today'),
                    _buildTimeframeTab('This Week'),
                    _buildTimeframeTab('This Month'),
                    _buildTimeframeTab('Custom'),
                  ],
                ),
              ),

              // Export CSV Button
              ShadButton.outline(
                onPressed: _showExportDialog,
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(Icons.file_download_outlined, size: 16, color: AppColors.ink),
                    SizedBox(width: 8),
                    Text(
                      'Export CSV Report',
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
        ],
      ),
    );
  }

  Widget _buildTimeframeTab(String label) {
    final isSelected = _selectedTimeframe == label;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedTimeframe = label;
        });
      },
      borderRadius: BorderRadius.circular(6),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surface : Colors.transparent,
          borderRadius: BorderRadius.circular(6),
          border: isSelected ? Border.all(color: AppColors.hairline) : null,
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.04),
                    blurRadius: 4,
                    offset: const Offset(0, 1),
                  ),
                ]
              : null,
        ),
        child: Text(
          label,
          style: TextStyle(
            fontSize: 12,
            fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
            color: isSelected ? AppColors.accent : AppColors.inkMuted,
          ),
        ),
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
            // KPI 1: Gross Sales (with sparkline curve matching mockup)
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.attach_money_rounded,
              iconColor: AppColors.accent,
              iconBgColor: AppColors.accent.withOpacity(0.12),
              title: 'Gross Sales',
              value: _grossSales,
              badgeText: _grossSalesTrend,
              badgeColor: AppColors.accent,
              subtext: 'Across 28 orders completed',
              showSparkline: true,
            ),

            // KPI 2: Fulfilled Orders
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF0284C7),
              iconBgColor: const Color(0xFF0284C7).withOpacity(0.12),
              title: 'Fulfilled Orders',
              value: _fulfilledOrders,
              badgeText: _avgTicket,
              badgeColor: const Color(0xFF0284C7),
              subtext: '100% on-time fulfillment',
            ),

            // KPI 3: Avg Pack Speed
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.timer_outlined,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFD97706).withOpacity(0.12),
              title: 'Avg Pack Speed',
              value: _avgPackSpeed,
              badgeText: 'Target <10m (Fast)',
              badgeColor: const Color(0xFFD97706),
              subtext: 'Packing time from accept to seal',
            ),

            // KPI 4: Courier Dispatch (Uber & DoorDash ONLY)
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.local_shipping_outlined,
              iconColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFF7C3AED).withOpacity(0.12),
              title: 'Courier Dispatch',
              value: 'Uber & DoorDash',
              badgeText: 'Uber 58% · DoorDash 42%',
              badgeColor: const Color(0xFF7C3AED),
              subtext: '28 orders dispatched smoothly',
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
    bool showSparkline = false,
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
              if (showSparkline) ...[
                const SizedBox(width: 8),
                CustomPaint(
                  size: const Size(36, 18),
                  painter: _MiniSparklinePainter(),
                ),
              ],
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

  Widget _buildChartsSection() {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isDesktop = constraints.maxWidth > 900;

        return Column(
          children: [
            // Row 1: Hourly Smooth Area Wave Chart + Sales by Category Donut Chart
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(flex: 6, child: _buildHourlyWaveCard()),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: _buildCategoryDonutCard()),
                ],
              )
            else ...[
              _buildHourlyWaveCard(),
              const SizedBox(height: 20),
              _buildCategoryDonutCard(),
            ],

            const SizedBox(height: 20),

            // Row 2: Courier Performance + Top Products Leaderboard
            if (isDesktop)
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(child: _buildCourierPerformanceCard()),
                  const SizedBox(width: 20),
                  Expanded(child: _buildTopProductsCard()),
                ],
              )
            else ...[
              _buildCourierPerformanceCard(),
              const SizedBox(height: 20),
              _buildTopProductsCard(),
            ],
          ],
        );
      },
    );
  }

  // Card 1: Hourly Order Volume Smooth Bezier Area Wave Chart (Matching Mockup Image)
  Widget _buildHourlyWaveCard() {
    return Container(
      padding: const EdgeInsets.all(20),
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
              const Text(
                'Hourly Order Volume',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: AppColors.canvas,
                  borderRadius: BorderRadius.circular(6),
                  border: Border.all(color: AppColors.hairline),
                ),
                child: const Text(
                  '28 Orders Total',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: AppColors.inkMuted),
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),

          // Smooth Wave Chart Area with Peak Callout Labels
          SizedBox(
            height: 175,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;

                return Stack(
                  children: [
                    // Canvas Chart with horizontal grid lines and gradient wave
                    Positioned.fill(
                      child: CustomPaint(
                        painter: _HourlyWaveChartPainter(),
                      ),
                    ),

                    // Peak 1 Callout Label: 12 PM - 1 PM
                    Positioned(
                      left: (w * 0.32) - 38,
                      top: 4,
                      child: const Text(
                        '12 PM - 1 PM',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),

                    // Peak 2 Callout Label: 6 PM - 8 PM
                    Positioned(
                      left: (w * 0.77) - 34,
                      top: 8,
                      child: const Text(
                        '6 PM - 8 PM',
                        style: TextStyle(
                          fontSize: 11.5,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                  ],
                );
              },
            ),
          ),
          const SizedBox(height: 12),

          // X-Axis Time Markers matching mockup image: 9 AM, 12 PM, 3 PM, 6 PM, 9 PM
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('9 AM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.inkMuted)),
                Text('12 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.inkMuted)),
                Text('3 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.inkMuted)),
                Text('6 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.inkMuted)),
                Text('9 PM', style: TextStyle(fontSize: 11.5, fontWeight: FontWeight.w500, color: AppColors.inkMuted)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card 2: Sales by Category Donut Chart (Matching Mockup Image)
  Widget _buildCategoryDonutCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Sales by Category',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 22),

          Row(
            children: [
              // Circular Donut Ring with revenue in hole
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    CustomPaint(
                      size: const Size(130, 130),
                      painter: _CategoryDonutPainter(),
                    ),
                    const Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          r'$1,348.20',
                          style: TextStyle(
                            fontSize: 13.5,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.3,
                            color: AppColors.ink,
                          ),
                        ),
                        SizedBox(height: 2),
                        Text(
                          'Revenue',
                          style: TextStyle(
                            fontSize: 10.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 22),

              // Donut Legend matching mockup image
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildDonutLegendItem(AppColors.accent, '52% Halal Butcher'),
                    const SizedBox(height: 12),
                    _buildDonutLegendItem(const Color(0xFF0D9488), '34% South Asian Pantry'),
                    const SizedBox(height: 12),
                    _buildDonutLegendItem(const Color(0xFFF59E0B), '14% Fresh Produce'),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          const Text(
            'Revenue automatically synchronized with in-store catalog SKU telemetry',
            style: TextStyle(fontSize: 11, color: AppColors.inkMuted),
          ),
        ],
      ),
    );
  }

  Widget _buildDonutLegendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(2.5),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            text,
            style: const TextStyle(
              fontSize: 12.5,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
      ],
    );
  }

  // Card 3: Courier Performance (Uber & DoorDash ONLY)
  Widget _buildCourierPerformanceCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Courier Dispatch Performance',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Active 3PL delivery partner efficiency (Uber Direct & DoorDash Drive)',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 20),

          // Uber Direct Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'Uber',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Uber Direct',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '16 orders fulfilled · 58% dispatch share',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '4.8m avg dispatch',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '99.4% on-time',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // DoorDash Drive Card
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: const Color(0xFFFF3008),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: const Center(
                    child: Text(
                      'DD',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'DoorDash Drive',
                        style: TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: AppColors.ink,
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        '12 orders fulfilled · 42% dispatch share',
                        style: TextStyle(
                          fontSize: 11,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ],
                  ),
                ),
                const Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '5.1m avg dispatch',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                      ),
                    ),
                    SizedBox(height: 2),
                    Text(
                      '98.9% on-time',
                      style: TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.accent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Card 4: Top Velocity Products Leaderboard
  Widget _buildTopProductsCard() {
    final topProducts = [
      {
        'rank': 1,
        'name': 'Fresh Halal Baby Goat Curry Cut',
        'volume': '38 kg sold',
        'sales': r'$722.00',
        'tag': 'Butcher',
      },
      {
        'rank': 2,
        'name': 'Daawat Traditional Basmati Rice 5kg',
        'volume': '24 bags sold',
        'sales': r'$384.00',
        'tag': 'Pantry',
      },
      {
        'rank': 3,
        'name': 'Shan Biryani Masala 50g',
        'volume': '45 packs sold',
        'sales': r'$135.00',
        'tag': 'Spices',
      },
      {
        'rank': 4,
        'name': 'Fresh Mint & Coriander Bunches',
        'volume': '32 bunches sold',
        'sales': r'$64.00',
        'tag': 'Produce',
      },
      {
        'rank': 5,
        'name': 'Aashirvaad Superior MP Atta 10kg',
        'volume': '18 bags sold',
        'sales': r'$252.00',
        'tag': 'Flour',
      },
    ];

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Top Velocity Products Today',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          const Text(
            'Highest turnover items across all completed customer deliveries',
            style: TextStyle(
              fontSize: 12,
              color: AppColors.inkMuted,
            ),
          ),
          const SizedBox(height: 16),

          ...topProducts.map((prod) {
            return Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              decoration: const BoxDecoration(
                border: Border(bottom: BorderSide(color: Color(0xFFF1F5F9))),
              ),
              child: Row(
                children: [
                  Container(
                    width: 22,
                    height: 22,
                    decoration: BoxDecoration(
                      color: (prod['rank'] as int) == 1
                          ? AppColors.accent
                          : const Color(0xFFF1F5F9),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${prod['rank']}',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: (prod['rank'] as int) == 1
                              ? Colors.white
                              : AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          prod['name'] as String,
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: AppColors.ink,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          prod['volume'] as String,
                          style: const TextStyle(
                            fontSize: 11,
                            color: AppColors.inkMuted,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    prod['sales'] as String,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}

// -------------------------------------------------------------
// Custom Chart Painters matching Mockup Image
// -------------------------------------------------------------

/// Smooth Bezier Curve Area Wave Chart with horizontal grid lines
class _HourlyWaveChartPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    // 1. Draw subtle horizontal grid lines
    final gridPaint = Paint()
      ..color = const Color(0xFFE2E8F0)
      ..strokeWidth = 1.0;

    final gridSteps = [0.22, 0.45, 0.68, 0.92];
    for (final step in gridSteps) {
      final y = h * step;
      canvas.drawLine(Offset(0, y), Offset(w, y), gridPaint);
    }

    // 2. Build smooth cubic bezier curve
    // Key milestones matching mockup:
    // x = 0: baseline (~0.90 * h)
    // x = 0.32: Lunch peak 1 (~0.18 * h)
    // x = 0.54: Afternoon valley (~0.65 * h)
    // x = 0.76: Dinner peak 2 (~0.20 * h)
    // x = 1.0: Evening baseline (~0.90 * h)
    final path = Path();
    path.moveTo(0, h * 0.90);

    // Rising to Lunch Peak 1
    path.cubicTo(
      w * 0.14, h * 0.86,
      w * 0.22, h * 0.18,
      w * 0.32, h * 0.18,
    );

    // Falling into Afternoon Trough
    path.cubicTo(
      w * 0.40, h * 0.18,
      w * 0.46, h * 0.65,
      w * 0.54, h * 0.65,
    );

    // Rising to Dinner Peak 2
    path.cubicTo(
      w * 0.62, h * 0.65,
      w * 0.68, h * 0.20,
      w * 0.77, h * 0.20,
    );

    // Falling to Closing
    path.cubicTo(
      w * 0.84, h * 0.20,
      w * 0.92, h * 0.86,
      w, h * 0.90,
    );

    // 3. Draw Gradient Fill Area
    final fillPath = Path.from(path);
    fillPath.lineTo(w, h);
    fillPath.lineTo(0, h);
    fillPath.close();

    final fillPaint = Paint()
      ..shader = ui.Gradient.linear(
        Offset(0, h * 0.15),
        Offset(0, h),
        [
          AppColors.accent.withOpacity(0.42),
          AppColors.accent.withOpacity(0.18),
          AppColors.accent.withOpacity(0.01),
        ],
        [0.0, 0.5, 1.0],
      )
      ..style = PaintingStyle.fill;

    canvas.drawPath(fillPath, fillPaint);

    // 4. Draw Emerald Stroke Line
    final strokePaint = Paint()
      ..color = AppColors.accent
      ..strokeWidth = 2.6
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;

    canvas.drawPath(path, strokePaint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Circular Donut Chart with gap spacing for 3 categories
class _CategoryDonutPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = (size.width / 2) - 10;
    const strokeWidth = 16.0;

    final paint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round;

    const gap = 0.08;
    const availableAngle = (2 * math.pi) - (gap * 3);

    // Start at top (-pi / 2)
    var startAngle = -math.pi / 2;

    // Segment 1: Halal Butcher (52%)
    final sweep1 = availableAngle * 0.52;
    paint.color = AppColors.accent;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep1,
      false,
      paint,
    );
    startAngle += sweep1 + gap;

    // Segment 2: South Asian Pantry (34%)
    final sweep2 = availableAngle * 0.34;
    paint.color = const Color(0xFF0D9488);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep2,
      false,
      paint,
    );
    startAngle += sweep2 + gap;

    // Segment 3: Fresh Produce (14%)
    final sweep3 = availableAngle * 0.14;
    paint.color = const Color(0xFFF59E0B);
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      startAngle,
      sweep3,
      false,
      paint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

/// Mini Sparkline Wave for Gross Sales KPI Card
class _MiniSparklinePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final path = Path();
    path.moveTo(0, size.height * 0.7);
    path.cubicTo(
      size.width * 0.25, size.height * 0.6,
      size.width * 0.40, size.height * 0.2,
      size.width * 0.60, size.height * 0.4,
    );
    path.cubicTo(
      size.width * 0.75, size.height * 0.5,
      size.width * 0.85, size.height * 0.1,
      size.width, size.height * 0.1,
    );

    final paint = Paint()
      ..color = AppColors.accent
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2.0
      ..strokeCap = StrokeCap.round;

    canvas.drawPath(path, paint);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
