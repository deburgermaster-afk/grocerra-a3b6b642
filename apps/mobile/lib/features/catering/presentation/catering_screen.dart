import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/glowing_effects.dart';

/// Screen #23: Catering Landing & Quote Request Flow
/// Covers package discovery, headcount estimates, dietary preferences (Halal, Vegetarian),
/// and custom quote submissions with deposit terms, upgraded with glowing micro-animations.
class CateringScreen extends StatefulWidget {
  const CateringScreen({super.key});

  @override
  State<CateringScreen> createState() => _CateringScreenState();
}

class _CateringScreenState extends State<CateringScreen> {
  final List<_CateringPackage> _packages = const <_CateringPackage>[
    _CateringPackage(
      title: 'Mughlai Royal Dawat',
      caterer: 'Karachi Feast & Catering',
      pricePerHeadCents: 3500, // $35.00 AUD
      minGuests: 25,
      description:
          'Mutton Biryani, Chicken Tikka, Seekh Kebabs, Roghani Naan, Raita, Kheer.',
      imageUrl:
          'https://images.unsplash.com/photo-1589302168068-964664d93dc0?w=600&q=80',
      isHalalCertified: true,
    ),
    _CateringPackage(
      title: 'Bengali Biye Feast',
      caterer: 'Dhaka Heritage Caterers',
      pricePerHeadCents: 3800, // $38.00 AUD
      minGuests: 30,
      description:
          'Kacchi Biryani, Chicken Roast, Shorshe Ilish, Borhani, Firni & Jorda.',
      imageUrl:
          'https://images.unsplash.com/photo-1544025162-d76694265947?w=600&q=80',
      isHalalCertified: true,
    ),
    _CateringPackage(
      title: 'Pure Veg Royal Thali',
      caterer: 'Mumbai Sweets & Banquet',
      pricePerHeadCents: 2600, // $26.00 AUD
      minGuests: 20,
      description:
          'Paneer Butter Masala, Dal Makhani, Veg Pulao, Butter Naan, Gulab Jamun.',
      imageUrl:
          'https://images.unsplash.com/photo-1599488615731-7e5c2823ff28?w=600&q=80',
      isHalalCertified: false,
    ),
  ];

  void _openQuoteRequestModal() {
    showModalBottomSheet<void>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (BuildContext ctx) => const _CateringQuoteModal(),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      appBar: AppBar(
        title: const Text(
          'South Asian Catering',
          style: TextStyle(
            fontWeight: FontWeight.w800,
            fontSize: 20,
            letterSpacing: -0.4,
          ),
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 8, 16, 100),
        children: <Widget>[
          // Hero Glowing Banner with Rotating GlowRing
          GlowCard(
            borderRadius: 24,
            borderWidth: 1.5,
            glowColor: const Color(0xFFF59E0B),
            backgroundColor: const Color(0xFF0F172A),
            enableBorderGlow: true,
            enableAmbientShadow: true,
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: const <Widget>[
                    GlowBadge(
                      label: 'EVENT FEASTS · MELBOURNE',
                      showPulseDot: true,
                      glowColor: Color(0xFFF59E0B),
                      backgroundColor: Color(0x33F59E0B),
                      textColor: Color(0xFFFBBF24),
                    ),
                    GlowRing(
                      size: 52,
                      strokeWidth: 3.0,
                      glowColor: Color(0xFFF59E0B),
                      secondaryColor: Color(0xFF78350F),
                      child: Icon(
                        Icons.restaurant_menu_rounded,
                        color: Color(0xFFFBBF24),
                        size: 22,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 14),
                const Text(
                  'Authentic Feasts for 20 to 500+ Guests',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    letterSpacing: -0.5,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Weddings, Eid, Diwali, corporate banquets & family gatherings. 100% Certified Halal meats & verified local Melbourne caterers.',
                  style: TextStyle(
                    color: Colors.grey.shade400,
                    fontSize: 13,
                    height: 1.35,
                  ),
                ),
                const SizedBox(height: 18),
                GlowButton(
                  label: 'Request a Free Custom Quote',
                  icon: Icons.request_quote_rounded,
                  glowColor: const Color(0xFFF59E0B),
                  backgroundColor: const Color(0xFFD97706),
                  textColor: Colors.white,
                  onTap: _openQuoteRequestModal,
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          // Packages Section
          const Text(
            'Curated Catering Packages',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: AppColors.ink,
              letterSpacing: -0.4,
            ),
          ),
          const SizedBox(height: 12),

          ...List<Widget>.generate(_packages.length, (int index) {
            final _CateringPackage pkg = _packages[index];
            return StaggeredReveal(
              index: index,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 16),
                child: GlowCard(
                  borderRadius: 22,
                  borderWidth: 1.2,
                  glowColor: pkg.isHalalCertified
                      ? const Color(0xFF10B981)
                      : const Color(0xFFF59E0B),
                  enableBorderGlow: false,
                  enableAmbientShadow: true,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Stack(
                        children: <Widget>[
                          ClipRRect(
                            borderRadius: const BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                            child: Image.network(
                              pkg.imageUrl,
                              height: 140,
                              width: double.infinity,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                BuildContext context,
                                Object error,
                                StackTrace? stackTrace,
                              ) => Container(
                                height: 140,
                                color: Colors.grey.shade200,
                                child: const Icon(
                                  Icons.restaurant_rounded,
                                  size: 48,
                                  color: Colors.grey,
                                ),
                              ),
                            ),
                          ),
                          if (pkg.isHalalCertified)
                            Positioned(
                              top: 12,
                              left: 12,
                              child: const GlowBadge(
                                label: 'HALAL CERTIFIED',
                                showPulseDot: true,
                                glowColor: Color(0xFF10B981),
                                backgroundColor: Color(0xE6064E3B),
                                textColor: Colors.white,
                              ),
                            ),
                        ],
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
                                      fontSize: 17,
                                      fontWeight: FontWeight.w800,
                                      color: AppColors.ink,
                                      letterSpacing: -0.3,
                                    ),
                                  ),
                                ),
                                Text(
                                  '\$${(pkg.pricePerHeadCents / 100).toStringAsFixed(0)} / head',
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: AppColors.accentDark,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'by ${pkg.caterer} • Min ${pkg.minGuests} guests',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              pkg.description,
                              style: TextStyle(
                                fontSize: 13,
                                color: Colors.grey.shade800,
                                height: 1.3,
                              ),
                            ),
                            const SizedBox(height: 14),
                            ScalePressable(
                              onTap: _openQuoteRequestModal,
                              child: Container(
                                height: 44,
                                decoration: BoxDecoration(
                                  color: const Color(0xFF0F172A),
                                  borderRadius: BorderRadius.circular(14),
                                  border: Border.all(
                                    color: const Color(0xFF10B981)
                                        .withValues(alpha: 0.5),
                                  ),
                                ),
                                child: const Center(
                                  child: Text(
                                    'Customise This Menu & Get Quote',
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.w700,
                                      fontSize: 13,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _CateringQuoteModal extends StatefulWidget {
  const _CateringQuoteModal();

  @override
  State<_CateringQuoteModal> createState() => _CateringQuoteModalState();
}

class _CateringQuoteModalState extends State<_CateringQuoteModal> {
  String _eventType = 'Wedding / Reception';
  int _guestCount = 50;
  bool _requireHalal = true;
  bool _requireVegOptions = true;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(28)),
      ),
      padding: EdgeInsets.only(
        top: 16,
        left: 20,
        right: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 28,
      ),
      child: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Center(
                child: Container(
                  width: 44,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(2.5),
                  ),
                ),
              ),
              const SizedBox(height: 14),
              const Text(
                'Request a Catering Proposal',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: AppColors.ink,
                  letterSpacing: -0.4,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Direct proposals sent from verified Melbourne caterers within 24 hours.',
                style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
              ),
              const SizedBox(height: 18),

              // Event Type Dropdown
              const Text(
                'Event Type',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 6),
              DropdownButtonFormField<String>(
                initialValue: _eventType,
                decoration: InputDecoration(
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 12,
                  ),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                items: const <String>[
                  'Wedding / Reception',
                  'Milad / Religious Gathering',
                  'Birthday / Family Dawat',
                  'Corporate Event / Banquet',
                  'Community Feast',
                ].map((String val) {
                  return DropdownMenuItem<String>(
                    value: val,
                    child: Text(val, style: const TextStyle(fontSize: 14)),
                  );
                }).toList(),
                onChanged: (String? val) {
                  if (val != null) setState(() => _eventType = val);
                },
              ),

              const SizedBox(height: 16),

              // Guest Count Slider
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    'Guest Count',
                    style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFFDCFCE7),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Text(
                      '$_guestCount guests',
                      style: const TextStyle(
                        fontWeight: FontWeight.w800,
                        color: Color(0xFF065F46),
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
              Slider(
                value: _guestCount.toDouble(),
                min: 20,
                max: 300,
                divisions: 28,
                activeColor: AppColors.accentDark,
                onChanged: (double val) =>
                    setState(() => _guestCount = val.toInt()),
              ),

              const SizedBox(height: 8),

              // Dietary Checkboxes
              CheckboxListTile(
                title: const Text(
                  '100% Certified Halal Meats Required',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                value: _requireHalal,
                activeColor: AppColors.accentDark,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? val) =>
                    setState(() => _requireHalal = val ?? true),
              ),
              CheckboxListTile(
                title: const Text(
                  'Include Vegetarian / Vegan Options',
                  style: TextStyle(fontSize: 13, fontWeight: FontWeight.w600),
                ),
                value: _requireVegOptions,
                activeColor: AppColors.accentDark,
                dense: true,
                contentPadding: EdgeInsets.zero,
                onChanged: (bool? val) =>
                    setState(() => _requireVegOptions = val ?? true),
              ),

              const SizedBox(height: 12),

              // Deposit notice
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F5F9),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFFE2E8F0)),
                ),
                child: const Text(
                  'Catering terms: 50% deposit required upon accepting a quote. 90% refund if cancelled >48h prior.',
                  style: TextStyle(fontSize: 11, color: Color(0xFF475569)),
                ),
              ),

              const SizedBox(height: 18),

              GlowButton(
                label: 'Send Quote Request',
                icon: Icons.send_rounded,
                glowColor: const Color(0xFF10B981),
                backgroundColor: const Color(0xFF0F172A),
                textColor: Colors.white,
                onTap: () {
                  Navigator.of(context).pop();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text(
                        'Quote requested for $_guestCount guests ($_eventType)!',
                      ),
                      backgroundColor: AppColors.accentDark,
                    ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _CateringPackage {
  const _CateringPackage({
    required this.title,
    required this.caterer,
    required this.pricePerHeadCents,
    required this.minGuests,
    required this.description,
    required this.imageUrl,
    required this.isHalalCertified,
  });

  final String title;
  final String caterer;
  final int pricePerHeadCents;
  final int minGuests;
  final String description;
  final String imageUrl;
  final bool isHalalCertified;
}
