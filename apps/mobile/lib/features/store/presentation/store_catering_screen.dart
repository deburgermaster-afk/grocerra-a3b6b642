import 'package:flutter/material.dart';
import 'package:shadcn_ui/shadcn_ui.dart';
import '../../../../core/theme/app_theme.dart';

class CateringInquiryItem {
  final String id;
  final String customerName;
  final String eventType;
  final int guestCount;
  final String suburb;
  final String eventDate;
  final double quotedAmount;
  final double depositAmount;
  final double depositPercentage;
  final String status; // 'new', 'quoted', 'confirmed'
  final List<String> packageItems;
  final String dietaryNotes;
  bool quoteSent;

  CateringInquiryItem({
    required this.id,
    required this.customerName,
    required this.eventType,
    required this.guestCount,
    required this.suburb,
    required this.eventDate,
    required this.quotedAmount,
    required this.depositAmount,
    this.depositPercentage = 0.30,
    required this.status,
    required this.packageItems,
    this.dietaryNotes = '100% Halal Certified',
    this.quoteSent = false,
  });
}

class StoreCateringScreen extends StatefulWidget {
  const StoreCateringScreen({super.key});

  @override
  State<StoreCateringScreen> createState() => _StoreCateringScreenState();
}

class _StoreCateringScreenState extends State<StoreCateringScreen> {
  String _selectedTab = 'all'; // 'all', 'new', 'quoted', 'confirmed'
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();

  late List<CateringInquiryItem> _inquiries;
  late List<CateringInquiryItem> _confirmedEvents;

  @override
  void initState() {
    super.initState();
    _inquiries = [
      CateringInquiryItem(
        id: 'CAT-892',
        customerName: 'Tariq Mahmood',
        eventType: 'Eid Family Gathering',
        guestCount: 65,
        suburb: 'Coburg VIC',
        eventDate: 'Saturday, 18 Oct 2026 · 1:00 PM',
        quotedAmount: 1150.00,
        depositAmount: 345.00,
        depositPercentage: 0.30,
        status: 'new',
        quoteSent: false,
        packageItems: [
          '1x Whole Roast Stuffed Baby Lamb with Fragrant Basmati Rice',
          '65x Tandoori Chicken Tikka Skewers & Fresh Garlic Naan',
          '65x Shahi Kheer & Chilled Mint Zeera Raita Bowls',
        ],
        dietaryNotes: '100% Halal Certified · Nut-free for 5 guests',
      ),
      CateringInquiryItem(
        id: 'CAT-890',
        customerName: 'Zoya Ahmed',
        eventType: 'Wedding Walima Reception',
        guestCount: 180,
        suburb: 'Broadmeadows VIC',
        eventDate: 'Sunday, 26 Oct 2026 · 6:30 PM',
        quotedAmount: 3850.00,
        depositAmount: 1155.00,
        depositPercentage: 0.30,
        status: 'quoted',
        quoteSent: true,
        packageItems: [
          '180x Royal Dum Mutton Biryani (Deg Style Live Station)',
          '180x Chicken Reshmi Kebabs & Fresh Tandoori Roghni Naan',
          '180x Hot Gulab Jamun & Kashmiri Pink Chai Samovar Service',
        ],
        dietaryNotes: '100% Hand-Slaughtered Halal · Live Tandoor on-site setup',
      ),
      CateringInquiryItem(
        id: 'CAT-888',
        customerName: 'Farhan Siddiqui',
        eventType: 'Corporate Halal Luncheon',
        guestCount: 45,
        suburb: 'Preston VIC',
        eventDate: 'Friday, 14 Nov 2026 · 12:00 PM',
        quotedAmount: 3450.00,
        depositAmount: 1035.00,
        depositPercentage: 0.30,
        status: 'quoted',
        quoteSent: true,
        packageItems: [
          'Premium Stainless Buffet Chafing Warmer Setup',
          '45x Mughlai Chicken Karahi & Slow-Cooked Beef Nihari',
          '45x Fresh Mango Lassi Bottles & Pistachio Rasmalai',
        ],
        dietaryNotes: '100% Halal Certified · Individual executive boxed cutlery',
      ),
    ];

    _confirmedEvents = [
      CateringInquiryItem(
        id: 'CAT-875',
        customerName: 'Hamza Malik',
        eventType: 'Aqiqah Celebration',
        guestCount: 50,
        suburb: 'Brunswick VIC',
        eventDate: 'Sunday, 05 Oct 2026 · 1:30 PM',
        quotedAmount: 950.00,
        depositAmount: 285.00,
        depositPercentage: 0.30,
        status: 'confirmed',
        quoteSent: true,
        packageItems: [
          '1x Aqiqah Whole Goat Deg with Saffron Rice',
          '50x Chicken Seekh Kebabs & Salad',
        ],
      ),
      CateringInquiryItem(
        id: 'CAT-870',
        customerName: 'Ayesha Khan',
        eventType: 'Engagement Party',
        guestCount: 100,
        suburb: 'Craigieburn VIC',
        eventDate: 'Saturday, 11 Oct 2026 · 7:00 PM',
        quotedAmount: 2200.00,
        depositAmount: 660.00,
        depositPercentage: 0.30,
        status: 'confirmed',
        quoteSent: true,
        packageItems: [
          '100x Chicken Biryani Portions & Raita',
          '100x Mixed Appetizer Platters & Samosas',
        ],
      ),
      CateringInquiryItem(
        id: 'CAT-865',
        customerName: 'Usman Ghani',
        eventType: 'Nikah Ceremony',
        guestCount: 120,
        suburb: 'Fawkner VIC',
        eventDate: 'Saturday, 18 Oct 2026 · 5:00 PM',
        quotedAmount: 2600.00,
        depositAmount: 780.00,
        depositPercentage: 0.30,
        status: 'confirmed',
        quoteSent: true,
        packageItems: [
          '120x Mutton Pulao & Chicken Tikka Boti',
          '120x Roghni Naan & Halwa Puri Morning Box',
        ],
      ),
      CateringInquiryItem(
        id: 'CAT-860',
        customerName: 'Bilal Ahmed',
        eventType: 'Community Iftar Feast',
        guestCount: 80,
        suburb: 'Roxburgh Park VIC',
        eventDate: 'Friday, 24 Oct 2026 · 6:45 PM',
        quotedAmount: 1600.00,
        depositAmount: 480.00,
        depositPercentage: 0.30,
        status: 'confirmed',
        quoteSent: true,
        packageItems: [
          '80x Boxed Iftar Packs with Dates, Pakoras, Fruit Chaat',
          '80x Chicken Biryani Single Servings',
        ],
      ),
    ];
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _showCreateQuoteDialog() {
    final customerCtrl = TextEditingController();
    final eventTypeCtrl = TextEditingController();
    final guestsCtrl = TextEditingController();
    final suburbCtrl = TextEditingController();
    final amountCtrl = TextEditingController();
    final packageCtrl = TextEditingController();

    showDialog(
      context: context,
      builder: (ctx) {
        return Dialog(
          backgroundColor: Colors.transparent,
          child: Container(
            width: 580,
            padding: const EdgeInsets.all(24),
            decoration: BoxDecoration(
              color: AppColors.surface,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.hairline),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.08),
                  blurRadius: 24,
                  offset: const Offset(0, 8),
                ),
              ],
            ),
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Dialog Header
                  Row(
                    children: [
                      Container(
                        width: 44,
                        height: 44,
                        decoration: BoxDecoration(
                          color: AppColors.accent.withOpacity(0.12),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: const Icon(
                          Icons.room_service_outlined,
                          color: AppColors.accent,
                          size: 24,
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Create Custom Catering Quote',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.w700,
                                color: AppColors.ink,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'Generate and send a bespoke bulk catering package quote to customer',
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

                  // Customer Name
                  const Text(
                    'Customer Name',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: customerCtrl,
                    decoration: InputDecoration(
                      hintText: 'e.g. Salman Akhtar',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                      filled: true,
                      fillColor: AppColors.canvas,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.hairline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.hairline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 14),

                  // Event Type & Guest Count
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Event Type / Occasion',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: eventTypeCtrl,
                              decoration: InputDecoration(
                                hintText: 'e.g. Wedding Walima Reception',
                                hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                                filled: true,
                                fillColor: AppColors.canvas,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Guest Count',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: guestsCtrl,
                              keyboardType: TextInputType.number,
                              decoration: InputDecoration(
                                hintText: 'e.g. 100 Guests',
                                hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                                filled: true,
                                fillColor: AppColors.canvas,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Suburb & Price
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Event Suburb / Location',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: suburbCtrl,
                              decoration: InputDecoration(
                                hintText: 'e.g. Coburg VIC',
                                hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                                filled: true,
                                fillColor: AppColors.canvas,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 14),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Estimated Quote (\$ AUD)',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                            ),
                            const SizedBox(height: 6),
                            TextField(
                              controller: amountCtrl,
                              decoration: InputDecoration(
                                hintText: r'$2,200.00',
                                hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                                filled: true,
                                fillColor: AppColors.canvas,
                                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: const BorderSide(color: AppColors.hairline),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 14),

                  // Menu / Package Items
                  const Text(
                    'Package Items & Menu Details',
                    style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                  ),
                  const SizedBox(height: 6),
                  TextField(
                    controller: packageCtrl,
                    maxLines: 2,
                    decoration: InputDecoration(
                      hintText: 'e.g. 2x Mutton Biryani Deg, 100x Seekh Kebabs, Salad & Raita',
                      hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                      filled: true,
                      fillColor: AppColors.canvas,
                      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.hairline),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                        borderSide: const BorderSide(color: AppColors.hairline),
                      ),
                    ),
                  ),
                  const SizedBox(height: 24),

                  // Dialog Actions
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ShadButton.outline(
                        onPressed: () => Navigator.of(ctx).pop(),
                        child: const Text('Cancel', style: TextStyle(color: AppColors.ink)),
                      ),
                      const SizedBox(width: 12),
                      ShadButton(
                        backgroundColor: AppColors.accent,
                        onPressed: () {
                          if (customerCtrl.text.isNotEmpty) {
                            final rawAmount = double.tryParse(
                                  amountCtrl.text.replaceAll(RegExp(r'[^0-9.]'), ''),
                                ) ??
                                1500.00;
                            final guests = int.tryParse(
                                  guestsCtrl.text.replaceAll(RegExp(r'[^0-9]'), ''),
                                ) ??
                                50;

                            setState(() {
                              _inquiries.insert(
                                0,
                                CateringInquiryItem(
                                  id: 'CAT-${DateTime.now().millisecondsSinceEpoch.toString().substring(8)}',
                                  customerName: customerCtrl.text.trim(),
                                  eventType: eventTypeCtrl.text.isNotEmpty ? eventTypeCtrl.text.trim() : 'Private Gathering',
                                  guestCount: guests,
                                  suburb: suburbCtrl.text.isNotEmpty ? suburbCtrl.text.trim() : 'Melbourne VIC',
                                  eventDate: 'Upcoming Weekend',
                                  quotedAmount: rawAmount,
                                  depositAmount: rawAmount * 0.30,
                                  depositPercentage: 0.30,
                                  status: 'new',
                                  quoteSent: false,
                                  packageItems: packageCtrl.text.isNotEmpty
                                      ? [packageCtrl.text.trim()]
                                      : ['Custom Catering Menu Selection'],
                                ),
                              );
                            });
                          }
                          Navigator.of(ctx).pop();
                        },
                        child: const Text(
                          'Save & Send Quote',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w600),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  void _showEditPackageDialog(CateringInquiryItem item) {
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
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Flexible(
                      child: FittedBox(
                        fit: BoxFit.scaleDown,
                        alignment: Alignment.centerLeft,
                        child: Text(
                          'Edit Package: Inquiry #${item.id}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: AppColors.ink),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close, size: 20, color: AppColors.inkMuted),
                      onPressed: () => Navigator.of(ctx).pop(),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  'Customer: ${item.customerName} · ${item.eventType}',
                  style: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
                ),
                const SizedBox(height: 18),
                const Text('Package Items List', style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink)),
                const SizedBox(height: 8),
                ...item.packageItems.map(
                  (pkg) => Padding(
                    padding: const EdgeInsets.only(bottom: 6),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Icon(Icons.check_circle_outline, size: 16, color: AppColors.accent),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(pkg, style: const TextStyle(fontSize: 12, color: AppColors.ink)),
                        ),
                      ],
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ShadButton.outline(
                      onPressed: () => Navigator.of(ctx).pop(),
                      child: const Text('Close', style: TextStyle(color: AppColors.ink)),
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
    // Filter inquiries
    List<CateringInquiryItem> displayList = [];
    if (_selectedTab == 'confirmed') {
      displayList = _confirmedEvents;
    } else {
      displayList = _inquiries.where((item) {
        if (_selectedTab == 'new') return !item.quoteSent;
        if (_selectedTab == 'quoted') return item.quoteSent;
        return true;
      }).toList();
    }

    if (_searchQuery.isNotEmpty) {
      final q = _searchQuery.toLowerCase();
      displayList = displayList.where((item) {
        return item.customerName.toLowerCase().contains(q) ||
            item.eventType.toLowerCase().contains(q) ||
            item.suburb.toLowerCase().contains(q) ||
            item.id.toLowerCase().contains(q);
      }).toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Page Header & + Create Custom Quote Button
          _buildHeader(),
          const SizedBox(height: 20),

          // 2. 4 Summary KPI Metric Cards
          _buildKpiCards(),
          const SizedBox(height: 20),

          // 3. Filter Tabs & Search Bar
          _buildFilterTabsAndSearch(),
          const SizedBox(height: 18),

          // 4. Catering Inquiries Cards List
          _buildInquiriesList(displayList),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Left: Title & Subtitle
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  spacing: 12,
                  children: [
                    const FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Catering Inquiries & Custom Quotes',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.w800,
                          letterSpacing: -0.4,
                          color: AppColors.ink,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.accent.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Text(
                        'Store Manager',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    'Manage bulk food orders for weddings, family events, and festivals across Melbourne',
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 16),

          // Right: + Create Custom Quote Action Button
          ShadButton(
            backgroundColor: AppColors.accent,
            onPressed: _showCreateQuoteDialog,
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(Icons.add_rounded, size: 18, color: Colors.white),
                SizedBox(width: 6),
                Text(
                  '+ Create Custom Quote',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                    fontSize: 14,
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
            // KPI 1: Active Inquiries
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.event_note_outlined,
              iconColor: const Color(0xFF2563EB),
              iconBgColor: const Color(0xFFEFF6FF),
              title: 'Active Inquiries',
              value: '3 Inquiries',
              subtitle: 'Awaiting package finalization',
            ),
            // KPI 2: Total Quoted Value
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.monetization_on_outlined,
              iconColor: AppColors.accent,
              iconBgColor: const Color(0xFFF0FDF4),
              title: 'Total Quoted Value',
              value: r'$8,450.00',
              subtitle: 'Pipeline across Melbourne',
            ),
            // KPI 3: Confirmed Events
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.check_circle_outline,
              iconColor: const Color(0xFF7C3AED),
              iconBgColor: const Color(0xFFF5F3FF),
              title: 'Confirmed Events',
              value: '4 Events',
              subtitle: '30% deposit locked in',
            ),
            // KPI 4: Avg Event Size
            _buildKpiCard(
              width: cardWidth,
              icon: Icons.groups_outlined,
              iconColor: const Color(0xFFD97706),
              iconBgColor: const Color(0xFFFFFBEB),
              title: 'Avg Event Size',
              value: '72 Guests',
              subtitle: 'Capacity: up to 250 pax',
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
    required String subtitle,
  }) {
    return Container(
      width: width,
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 4,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Flexible(
                child: FittedBox(
                  fit: BoxFit.scaleDown,
                  alignment: Alignment.centerLeft,
                  child: Text(
                    title,
                    style: const TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                      color: AppColors.inkMuted,
                    ),
                  ),
                ),
              ),
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: iconBgColor,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Icon(icon, size: 18, color: iconColor),
              ),
            ],
          ),
          const SizedBox(height: 12),
          FittedBox(
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
          const SizedBox(height: 4),
          FittedBox(
            fit: BoxFit.scaleDown,
            alignment: Alignment.centerLeft,
            child: Text(
              subtitle,
              style: const TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w500,
                color: AppColors.inkMuted,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilterTabsAndSearch() {
    final tabs = [
      {'id': 'all', 'label': 'All Inquiries (3)'},
      {'id': 'new', 'label': 'New / Unquoted (1)'},
      {'id': 'quoted', 'label': 'Quote Sent (2)'},
      {'id': 'confirmed', 'label': 'Confirmed (4)'},
    ];

    return Wrap(
      alignment: WrapAlignment.spaceBetween,
      crossAxisAlignment: WrapCrossAlignment.center,
      spacing: 16,
      runSpacing: 12,
      children: [
        // Tabs
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: tabs.map((tab) {
            final isSelected = _selectedTab == tab['id'];
            return InkWell(
              onTap: () {
                setState(() {
                  _selectedTab = tab['id']!;
                });
              },
              borderRadius: BorderRadius.circular(8),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                decoration: BoxDecoration(
                  color: isSelected ? AppColors.ink : AppColors.surface,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isSelected ? AppColors.ink : AppColors.hairline,
                  ),
                ),
                child: Text(
                  tab['label']!,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                    color: isSelected ? Colors.white : AppColors.ink,
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        // Search Input
        ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 320),
          child: TextField(
            controller: _searchController,
            onChanged: (val) {
              setState(() {
                _searchQuery = val;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search customer or suburb...',
              hintStyle: const TextStyle(fontSize: 13, color: AppColors.inkMuted),
              prefixIcon: const Icon(Icons.search, size: 18, color: AppColors.inkMuted),
              filled: true,
              fillColor: AppColors.surface,
              contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.hairline),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(color: AppColors.hairline),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildInquiriesList(List<CateringInquiryItem> items) {
    if (items.isEmpty) {
      return Container(
        width: double.infinity,
        padding: const EdgeInsets.all(40),
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.hairline),
        ),
        child: const Column(
          children: [
            Icon(Icons.inbox_outlined, size: 48, color: AppColors.inkMuted),
            SizedBox(height: 12),
            Text(
              'No catering inquiries found',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600, color: AppColors.ink),
            ),
            SizedBox(height: 4),
            Text(
              'Try adjusting your filter or search query',
              style: TextStyle(fontSize: 13, color: AppColors.inkMuted),
            ),
          ],
        ),
      );
    }

    return Column(
      children: items.map((item) => _buildInquiryCard(item)).toList(),
    );
  }

  String _formatCurrency(double amount) {
    final parts = amount.toStringAsFixed(2).split('.');
    final whole = parts[0];
    final dec = parts[1];
    final chars = whole.split('').reversed.toList();
    final buffer = <String>[];
    for (int i = 0; i < chars.length; i++) {
      if (i > 0 && i % 3 == 0) {
        buffer.add(',');
      }
      buffer.add(chars[i]);
    }
    return '${buffer.reversed.join()}.$dec';
  }

  Widget _buildInquiryCard(CateringInquiryItem item) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.hairline),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.02),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Row 1: Header title & Quoted Price / Deposit
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.start,
            spacing: 16,
            runSpacing: 12,
            children: [
              // Left: Title, customer, guest & suburb
              ConstrainedBox(
                constraints: const BoxConstraints(minWidth: 280, maxWidth: 640),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Wrap(
                      spacing: 8,
                      runSpacing: 4,
                      crossAxisAlignment: WrapCrossAlignment.center,
                      children: [
                        _buildStatusBadge(item),
                        FittedBox(
                          fit: BoxFit.scaleDown,
                          alignment: Alignment.centerLeft,
                          child: Text(
                            'Inquiry #${item.id} · ${item.customerName} (${item.eventType})',
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 6),
                    FittedBox(
                      fit: BoxFit.scaleDown,
                      alignment: Alignment.centerLeft,
                      child: Text(
                        '${item.guestCount} Guests · Suburb: ${item.suburb}',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w500,
                          color: AppColors.inkMuted,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Right: Total Quote & Deposit
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      '\$${_formatCurrency(item.quotedAmount)} AUD',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.ink,
                        letterSpacing: -0.4,
                      ),
                    ),
                  ),
                  const SizedBox(height: 2),
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    alignment: Alignment.centerRight,
                    child: Text(
                      'Deposit: \$${_formatCurrency(item.depositAmount)} (${(item.depositPercentage * 100).toInt()}%)',
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: AppColors.accentDark,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),

          // Row 2: Event Date & Menu / Package Details Container
          Container(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: AppColors.canvas,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: AppColors.hairline),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Wrap(
                  spacing: 16,
                  runSpacing: 6,
                  children: [
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.calendar_today_outlined, size: 14, color: AppColors.inkMuted),
                        const SizedBox(width: 6),
                        Text(
                          item.eventDate,
                          style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.ink),
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(Icons.verified_outlined, size: 14, color: AppColors.accent),
                        const SizedBox(width: 6),
                        Text(
                          item.dietaryNotes,
                          style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Package Highlights & Catering Inclusions:',
                  style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.inkMuted),
                ),
                const SizedBox(height: 6),
                ...item.packageItems.map(
                  (pkg) => Padding(
                    padding: const EdgeInsets.only(bottom: 4),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('• ', style: TextStyle(fontSize: 13, color: AppColors.accent, fontWeight: FontWeight.bold)),
                        Expanded(
                          child: Text(
                            pkg,
                            style: const TextStyle(fontSize: 12, color: AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),

          // Row 3: Action Buttons
          Wrap(
            alignment: WrapAlignment.spaceBetween,
            crossAxisAlignment: WrapCrossAlignment.center,
            spacing: 12,
            runSpacing: 10,
            children: [
              // Left: Info note
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    item.quoteSent ? Icons.check_circle_rounded : Icons.info_outline,
                    size: 15,
                    color: item.quoteSent ? AppColors.accent : AppColors.inkMuted,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    item.quoteSent
                        ? 'Customer notified via in-app push notification'
                        : 'Awaiting quote package dispatch to Grocerra app',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: item.quoteSent ? AppColors.accentDark : AppColors.inkMuted,
                    ),
                  ),
                ],
              ),

              // Right: Action Buttons
              Wrap(
                spacing: 10,
                runSpacing: 8,
                children: [
                  if (item.id == 'CAT-892')
                    ShadButton.outline(
                      onPressed: () => _showEditPackageDialog(item),
                      child: const Text(
                        'Edit Package',
                        style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    )
                  else
                    ShadButton.outline(
                      onPressed: () => _showEditPackageDialog(item),
                      child: const Text(
                        'View Package Details',
                        style: TextStyle(color: AppColors.ink, fontWeight: FontWeight.w600, fontSize: 13),
                      ),
                    ),
                  if (item.quoteSent)
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF0FDF4),
                        borderRadius: BorderRadius.circular(6),
                        border: Border.all(color: const Color(0xFFBBF7D0)),
                      ),
                      child: Text(
                        '✓ Quote Sent (\$${_formatCurrency(item.quotedAmount)})',
                        style: const TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: AppColors.accentDark,
                        ),
                      ),
                    )
                  else
                    ShadButton(
                      backgroundColor: AppColors.accent,
                      onPressed: () {
                        setState(() {
                          item.quoteSent = true;
                        });
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.send_rounded, size: 15, color: Colors.white),
                          SizedBox(width: 6),
                          Text(
                            'Send Quote to App',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                            ),
                          ),
                        ],
                      ),
                    ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(CateringInquiryItem item) {
    if (item.status == 'confirmed') {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF5F3FF),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFDDD6FE)),
        ),
        child: const Text(
          'CONFIRMED',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF7C3AED)),
        ),
      );
    }

    if (item.quoteSent) {
      return Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFF0FDF4),
          borderRadius: BorderRadius.circular(4),
          border: Border.all(color: const Color(0xFFBBF7D0)),
        ),
        child: const Text(
          'QUOTE SENT',
          style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: AppColors.accentDark),
        ),
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
      decoration: BoxDecoration(
        color: const Color(0xFFEFF6FF),
        borderRadius: BorderRadius.circular(4),
        border: Border.all(color: const Color(0xFFBFDBFE)),
      ),
      child: const Text(
        'NEW INQUIRY',
        style: TextStyle(fontSize: 10, fontWeight: FontWeight.w700, color: Color(0xFF2563EB)),
      ),
    );
  }
}
