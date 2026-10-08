import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'catering_request_details_screen.dart';

/// Figma `C7 · Catering checkout — Summary & payment` (390×844)
///
/// Order summary and deposit payment screen:
/// - Title: "Order summary"
/// - Caterer accordion: Madina Halal Catering (Wedding · 80 guests · 4 items)
/// - Itemized list: Goat biryani, Goat curry, Seekh kebabs, Gulab jamun
/// - Price breakdown:
///   Menu subtotal $1,090
///   Delivery & setup $150
///   Total $1,240
///   Deposit due today (30%) $372
///   Balance due later $868
/// - Payment method: Apple Pay
/// - Add promo code
/// - Sticky bottom bar: Due today $372 -> "Pay deposit" CTA to C8
class CateringDepositScreen extends StatefulWidget {
  const CateringDepositScreen({super.key});

  static const String routeName = '/catering/deposit';

  @override
  State<CateringDepositScreen> createState() => _CateringDepositScreenState();
}

class _CateringDepositScreenState extends State<CateringDepositScreen> {
  bool _itemsExpanded = true;
  String _paymentMethod = 'Apple Pay';

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
                        'Order summary',
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

            // Content
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 16, 16, 24),
                children: <Widget>[
                  // Caterer Summary Box (Expandable)
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: <Widget>[
                        InkWell(
                          onTap: () => setState(() => _itemsExpanded = !_itemsExpanded),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Row(
                              children: <Widget>[
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: const BoxDecoration(
                                    color: Color(0xFFFEF3C7),
                                    shape: BoxShape.circle,
                                  ),
                                  child: const Center(
                                    child: Text('🍲', style: TextStyle(fontSize: 18)),
                                  ),
                                ),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: const <Widget>[
                                      Text(
                                        'Madina Halal Catering',
                                        style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontSize: 14,
                                          color: AppColors.ink,
                                        ),
                                      ),
                                      SizedBox(height: 2),
                                      Text(
                                        'Wedding · 80 guests · 4 items',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: AppColors.inkMuted,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                Icon(
                                  _itemsExpanded
                                      ? Icons.keyboard_arrow_up_rounded
                                      : Icons.keyboard_arrow_down_rounded,
                                  color: AppColors.inkMuted,
                                ),
                              ],
                            ),
                          ),
                        ),
                        if (_itemsExpanded) ...<Widget>[
                          const Divider(height: 1, color: Color(0xFFF4F4F5)),
                          Padding(
                            padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
                            child: Column(
                              children: <Widget>[
                                _buildSummaryItem('Goat biryani', 'Serves 80'),
                                const SizedBox(height: 8),
                                _buildSummaryItem('Goat curry', 'Serves 80'),
                                const SizedBox(height: 8),
                                _buildSummaryItem('Seekh kebabs', '80 pieces'),
                                const SizedBox(height: 8),
                                _buildSummaryItem('Gulab jamun', '80 pieces'),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Transparent Cost Breakdown (AUD)
                  Container(
                    padding: const EdgeInsets.all(18),
                    decoration: BoxDecoration(
                      color: AppColors.surface,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(color: const Color(0xFFE4E4E7)),
                    ),
                    child: Column(
                      children: <Widget>[
                        _buildPriceRow('Menu subtotal', '\$1,090'),
                        const SizedBox(height: 10),
                        _buildPriceRow('Delivery & setup', '\$150'),
                        const Divider(height: 20, color: Color(0xFFF4F4F5)),
                        _buildPriceRow('Total', '\$1,240', isBold: true, fontSize: 16),
                        const SizedBox(height: 10),
                        _buildPriceRow('Deposit due today (30%)', '\$372', highlight: true),
                        const SizedBox(height: 10),
                        _buildPriceRow('Balance due later', '\$868'),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // Payment Method Row
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      setState(() {
                        _paymentMethod =
                            _paymentMethod == 'Apple Pay' ? 'Visa ending in 4242' : 'Apple Pay';
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Row(
                        children: <Widget>[
                          const Icon(Icons.apple, size: 22, color: AppColors.ink),
                          const SizedBox(width: 12),
                          Text(
                            _paymentMethod,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: AppColors.ink,
                            ),
                          ),
                          const Spacer(),
                          const Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.inkMuted),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 12),

                  // Add promo code row
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Promo code feature available at checkout.')),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.surface,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFFE4E4E7)),
                      ),
                      child: Row(
                        children: const <Widget>[
                          Icon(Icons.discount_outlined, size: 20, color: AppColors.inkMuted),
                          SizedBox(width: 12),
                          Text(
                            'Add promo code',
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: AppColors.inkMuted,
                            ),
                          ),
                          Spacer(),
                          Icon(Icons.chevron_right_rounded, size: 20, color: AppColors.inkMuted),
                        ],
                      ),
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
                        CateringRequestDetailsScreen.routeName,
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
                      'Pay deposit',
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

  static Widget _buildSummaryItem(String name, String qty) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          name,
          style: const TextStyle(fontSize: 13, color: AppColors.ink),
        ),
        Text(
          qty,
          style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
        ),
      ],
    );
  }

  static Widget _buildPriceRow(
    String label,
    String value, {
    bool isBold = false,
    bool highlight = false,
    double fontSize = 13,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: <Widget>[
        Text(
          label,
          style: TextStyle(
            fontSize: fontSize,
            color: highlight ? AppColors.accentDark : (isBold ? AppColors.ink : AppColors.inkMuted),
            fontWeight: (isBold || highlight) ? FontWeight.w700 : FontWeight.w500,
          ),
        ),
        Text(
          value,
          style: TextStyle(
            fontSize: fontSize,
            color: highlight ? AppColors.accentDark : AppColors.ink,
            fontWeight: (isBold || highlight) ? FontWeight.w800 : FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
