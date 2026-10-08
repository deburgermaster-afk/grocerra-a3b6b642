import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_orders_screen.dart';
import 'catering_request_details_screen.dart';
import 'quote_event_screen.dart';

/// Figma `C1 · Catering` (390×844)
///
/// Catering landing screen from the official design:
/// - Feeding a crowd? Hero banner with "Request a quote" CTA
/// - "How it works" 3-step guide
/// - "Popular for events" category cards (Biryani, Curries, Kebabs)
/// - Active booking tracker banner & package browser
class CateringScreen extends StatelessWidget {
  const CateringScreen({super.key});

  static const String routeName = '/catering';

  static const List<_CateringPackage> _packages = <_CateringPackage>[
    _CateringPackage(
      title: 'Mughlai Royal Dawat',
      caterer: 'Karachi Feast & Catering',
      pricePerHead: '\$35 / head',
      minGuests: 25,
      menuHighlights: 'Mutton Biryani, Chicken Tikka, Seekh Kebabs, Roghani Naan, Raita & Kheer',
      imageUrl: 'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&q=80',
      isHalal: true,
    ),
    _CateringPackage(
      title: 'Bengali Biye Feast',
      caterer: 'Dhaka Heritage Caterers',
      pricePerHead: '\$38 / head',
      minGuests: 30,
      menuHighlights: 'Kacchi Biryani, Chicken Roast, Shorshe Ilish, Borhani, Firni & Jorda',
      imageUrl: 'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
      isHalal: true,
    ),
    _CateringPackage(
      title: 'Pure Veg Royal Thali',
      caterer: 'Mumbai Sweets & Banquet',
      pricePerHead: '\$26 / head',
      minGuests: 20,
      menuHighlights: 'Paneer Butter Masala, Dal Makhani, Veg Pulao, Butter Naan & Gulab Jamun',
      imageUrl: 'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&q=80',
      isHalal: false,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(16, topInset, 16, AppInsets.tabBar + 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header
            Row(
              children: <Widget>[
                if (Navigator.of(context).canPop()) ...<Widget>[
                  RoundIconButton(
                    icon: Icons.arrow_back,
                    tooltip: 'Back',
                    onTap: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 12),
                ],
                const Expanded(
                  child: Text(
                    'Catering',
                    style: TextStyle(
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.5,
                      color: AppColors.ink,
                    ),
                  ),
                ),
                RoundIconButton(
                  icon: Icons.receipt_long_rounded,
                  tooltip: 'Catering Requests',
                  onTap: () => Navigator.of(context).pushNamed(CateringOrdersScreen.routeName),
                ),
                const SizedBox(width: 8),
                RoundIconButton(
                  icon: Icons.search,
                  tooltip: 'Search caterers',
                  onTap: () => Navigator.of(context).pushNamed('/search'),
                ),
              ],
            ),
            const SizedBox(height: 14),

            // Active Request tracker banner
            Material(
              color: const Color(0xFFF0FDF4),
              borderRadius: BorderRadius.circular(16),
              child: InkWell(
                borderRadius: BorderRadius.circular(16),
                onTap: () => Navigator.of(context).pushNamed(CateringRequestDetailsScreen.routeName),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: const Color(0xFFBBF7D0)),
                  ),
                  child: Row(
                    children: <Widget>[
                      Container(
                        width: 9,
                        height: 9,
                        decoration: const BoxDecoration(
                          color: Color(0xFF15803D),
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 10),
                      const Expanded(
                        child: Text(
                          'Active Request #CAT-8821 · Walima',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF15803D),
                          ),
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Text(
                        'View Request',
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.w700,
                          color: Color(0xFF15803D),
                        ),
                      ),
                      const Icon(
                        Icons.chevron_right_rounded,
                        size: 18,
                        color: Color(0xFF15803D),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Figma C1 Hero Banner: "Feeding a crowd?"
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(22),
              decoration: BoxDecoration(
                color: const Color(0xFF18181B),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  const Text(
                    'Feeding a crowd?',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 22,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.4,
                    ),
                  ),
                  const SizedBox(height: 8),
                  const Text(
                    'Get quotes from halal caterers for weddings, Eid, birthdays and corporate events.',
                    style: TextStyle(
                      color: Color(0xFFA1A1AA),
                      fontSize: 14,
                      height: 1.4,
                    ),
                  ),
                  const SizedBox(height: 20),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushNamed(QuoteEventScreen.routeName),
                    style: FilledButton.styleFrom(
                      backgroundColor: Colors.white,
                      foregroundColor: const Color(0xFF18181B),
                      padding: const EdgeInsets.symmetric(horizontal: 22, vertical: 12),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Request a quote',
                      style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 28),

            // Figma C1: How it works
            const Text(
              'How it works',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),
            _buildHowItWorksStep(
              stepNumber: '1',
              title: 'Tell us about your event',
              description: 'Date, guests and menu preferences',
            ),
            const SizedBox(height: 14),
            _buildHowItWorksStep(
              stepNumber: '2',
              title: 'Compare quotes',
              description: 'Caterers reply within 24 hours',
            ),
            const SizedBox(height: 14),
            _buildHowItWorksStep(
              stepNumber: '3',
              title: 'Confirm and pay',
              description: 'Pay a deposit once you accept',
            ),

            const SizedBox(height: 28),

            // Figma C1: Popular for events
            const Text(
              'Popular for events',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),
            Row(
              children: <Widget>[
                Expanded(child: _buildPopularCategoryCard('Biryani', 'Serves 10+')),
                const SizedBox(width: 10),
                Expanded(child: _buildPopularCategoryCard('Curries', 'Serves 10+')),
                const SizedBox(width: 10),
                Expanded(child: _buildPopularCategoryCard('Kebabs', 'Serves 8+')),
              ],
            ),

            const SizedBox(height: 28),

            // Featured Banquet Packages
            const Text(
              'Popular Banquet Packages',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: AppColors.ink,
                letterSpacing: -0.3,
              ),
            ),
            const SizedBox(height: 14),
            ..._packages.map((_CateringPackage pkg) => _buildPackageCard(context, pkg)),
          ],
        ),
      ),
    );
  }

  static Widget _buildHowItWorksStep({
    required String stepNumber,
    required String title,
    required String description,
  }) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: const Color(0xFFF4F4F5),
            shape: BoxShape.circle,
            border: Border.all(color: const Color(0xFFE4E4E7)),
          ),
          alignment: Alignment.center,
          child: Text(
            stepNumber,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 13,
              color: AppColors.ink,
            ),
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                title,
                style: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                description,
                style: const TextStyle(
                  fontSize: 13,
                  color: AppColors.inkMuted,
                  height: 1.3,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static Widget _buildPopularCategoryCard(String title, String subtitle) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFE4E4E7)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              fontSize: 14,
              color: AppColors.ink,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            subtitle,
            style: const TextStyle(
              fontSize: 11,
              color: AppColors.inkMuted,
            ),
          ),
        ],
      ),
    );
  }

  static Widget _buildPackageCard(BuildContext context, _CateringPackage pkg) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Container(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: AppColors.hairline),
        ),
        clipBehavior: Clip.antiAlias,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Image.network(
              pkg.imageUrl,
              height: 140,
              width: double.infinity,
              fit: BoxFit.cover,
              errorBuilder: (_, _, _) => Container(
                height: 140,
                color: AppColors.surfaceAlt,
                child: const Icon(Icons.restaurant, color: AppColors.inkMuted, size: 36),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Expanded(
                        child: Text(
                          pkg.title,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                      Text(
                        pkg.pricePerHead,
                        style: const TextStyle(
                          fontSize: 14,
                          fontWeight: FontWeight.w800,
                          color: AppColors.accentDark,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${pkg.caterer} · Min ${pkg.minGuests} guests',
                    style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                  ),
                  const SizedBox(height: 12),
                  FilledButton(
                    onPressed: () => Navigator.of(context).pushNamed(QuoteEventScreen.routeName),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.ink,
                      minimumSize: const Size(double.infinity, 44),
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
                    ),
                    child: const Text('Get Quote for this Package'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CateringPackage {
  const _CateringPackage({
    required this.title,
    required this.caterer,
    required this.pricePerHead,
    required this.minGuests,
    required this.menuHighlights,
    required this.imageUrl,
    required this.isHalal,
  });

  final String title;
  final String caterer;
  final String pricePerHead;
  final int minGuests;
  final String menuHighlights;
  final String imageUrl;
  final bool isHalal;
}
