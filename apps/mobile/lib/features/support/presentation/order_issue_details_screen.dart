import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import 'order_issue_submitted_screen.dart';

/// Figma `E2 · Dispute Details & Photo Evidence` (390×844)
///
/// Detailed dispute submission:
/// - Item selection checkboxes
/// - Photo attachment of butcher scale tag or packaging
/// - Note input for Melbourne customer support
/// - Refund destination selection (Instant Wallet Credit vs Original Card)
class OrderIssueDetailsScreen extends StatefulWidget {
  const OrderIssueDetailsScreen({super.key});

  static const String routeName = '/order-issue/details';

  @override
  State<OrderIssueDetailsScreen> createState() => _OrderIssueDetailsScreenState();
}

class _OrderIssueDetailsScreenState extends State<OrderIssueDetailsScreen> {
  final Set<String> _selectedItems = <String>{'Fresh Halal Baby Goat (Curry Cut)'};
  final TextEditingController _notesController = TextEditingController();
  bool _hasPhoto = false;
  int _refundMethod = 0; // 0 = Instant Wallet Credit, 1 = Card
  bool _isSubmitting = false;

  static const List<_DisputeItem> _items = <_DisputeItem>[
    _DisputeItem(
      name: 'Fresh Halal Baby Goat (Curry Cut)',
      variant: '1 kg Tray • Scale weighed',
      price: '\$24.99 AUD',
    ),
    _DisputeItem(
      name: 'Halal Skinless Chicken Breast Fillets',
      variant: '1 kg Tray • Scale weighed',
      price: '\$14.50 AUD',
    ),
  ];

  @override
  void dispose() {
    _notesController.dispose();
    super.dispose();
  }

  void _submit() {
    if (_selectedItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please select at least one affected item.')),
      );
      return;
    }

    setState(() => _isSubmitting = true);
    Future<void>.delayed(const Duration(milliseconds: 900), () {
      if (!mounted) return;
      setState(() => _isSubmitting = false);
      Navigator.of(context).pushNamedAndRemoveUntil(
        OrderIssueSubmittedScreen.routeName,
        (Route<dynamic> r) => r.isFirst,
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);
    final Map<String, dynamic> args = (ModalRoute.of(context)?.settings.arguments as Map<String, dynamic>?) ?? <String, dynamic>{};
    final String category = (args['category'] as String?) ?? 'Catch-Weight Discrepancy';

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
                  const SizedBox(width: 12),
                  const Expanded(
                    child: Text(
                      'Step 2 · Claim Details',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.ink,
                        letterSpacing: -0.3,
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Form
            Expanded(
              child: ListView(
                padding: const EdgeInsets.fromLTRB(16, 18, 16, 100),
                children: <Widget>[
                  // Category Header Chip
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceAlt,
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: Row(
                      children: <Widget>[
                        const Icon(Icons.info_outline_rounded, size: 18, color: AppColors.ink),
                        const SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'Reason: $category',
                            style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: AppColors.ink),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 1. Select Items
                  const Text(
                    '1. Which items had this issue?',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.hairline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Column(
                      children: _items.map((_DisputeItem item) {
                        final bool isSelected = _selectedItems.contains(item.name);
                        return CheckboxListTile(
                          value: isSelected,
                          activeColor: AppColors.ink,
                          title: Text(
                            item.name,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w700,
                              color: isSelected ? AppColors.ink : AppColors.inkMuted,
                            ),
                          ),
                          subtitle: Text(
                            '${item.variant} • ${item.price}',
                            style: const TextStyle(fontSize: 12, color: AppColors.inkMuted),
                          ),
                          onChanged: (bool? val) {
                            setState(() {
                              if (val == true) {
                                _selectedItems.add(item.name);
                              } else {
                                _selectedItems.remove(item.name);
                              }
                            });
                          },
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Photo Evidence
                  const Text(
                    '2. Attach Photo Evidence',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  GestureDetector(
                    onTap: () {
                      setState(() => _hasPhoto = !_hasPhoto);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text(_hasPhoto ? 'Photo of butcher scale label attached.' : 'Photo removed.'),
                          duration: const Duration(seconds: 1),
                        ),
                      );
                    },
                    child: Container(
                      padding: const EdgeInsets.all(20),
                      decoration: BoxDecoration(
                        color: _hasPhoto ? const Color(0xFFF0FDF4) : AppColors.surfaceAlt,
                        borderRadius: BorderRadius.circular(18),
                        border: Border.all(
                          color: _hasPhoto ? const Color(0xFF10B981) : AppColors.hairline,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            _hasPhoto ? Icons.check_circle_rounded : Icons.camera_alt_outlined,
                            size: 22,
                            color: _hasPhoto ? const Color(0xFF166534) : AppColors.ink,
                          ),
                          const SizedBox(width: 10),
                          Text(
                            _hasPhoto
                                ? 'Scale Tag Photo Attached (Tap to change)'
                                : 'Take photo of scale tag / items',
                            style: TextStyle(
                              fontSize: 13,
                              fontWeight: FontWeight.w700,
                              color: _hasPhoto ? const Color(0xFF166534) : AppColors.ink,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. Details
                  const Text(
                    '3. Description of Issue',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: _notesController,
                    maxLines: 3,
                    decoration: const InputDecoration(
                      hintText: 'e.g. Scale label showed 750g but charged for 1.1kg on checkout...',
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Preferred Resolution
                  const Text(
                    '4. Preferred Refund Method',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: AppColors.ink,
                    ),
                  ),
                  const SizedBox(height: 10),
                  Material(
                    color: AppColors.surface,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                      side: const BorderSide(color: AppColors.hairline),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: RadioGroup<int>(
                      groupValue: _refundMethod,
                      onChanged: (int? val) => setState(() => _refundMethod = val ?? 0),
                      child: const Column(
                        children: <Widget>[
                          RadioListTile<int>(
                            value: 0,
                            activeColor: AppColors.ink,
                            title: Text('Instant Grocerra Wallet Credit', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            subtitle: Text('Available immediately for next order', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                          ),
                          Divider(height: 1, indent: 16, endIndent: 16, color: AppColors.hairline),
                          RadioListTile<int>(
                            value: 1,
                            activeColor: AppColors.ink,
                            title: Text('Refund to Original Payment Card', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13)),
                            subtitle: Text('Direct Stripe refund (1-3 business days)', style: TextStyle(fontSize: 11, color: AppColors.inkMuted)),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),

            // Sticky Bottom CTA
            Container(
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 20),
              decoration: const BoxDecoration(
                color: AppColors.surface,
                border: Border(top: BorderSide(color: AppColors.hairline)),
              ),
              child: FilledButton(
                onPressed: _isSubmitting ? null : _submit,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.danger,
                ),
                child: _isSubmitting
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(color: AppColors.surface, strokeWidth: 2),
                      )
                    : const Text('Submit Claim & Request Refund'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DisputeItem {
  const _DisputeItem({
    required this.name,
    required this.variant,
    required this.price,
  });

  final String name;
  final String variant;
  final String price;
}
