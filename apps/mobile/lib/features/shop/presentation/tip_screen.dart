import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import 'checkout_totals.dart';
import 'placing_order_sheet.dart';

/// Checkout step 4 — `Add a tip`.
///
/// The reference's tip step: courier illustration, the "100% goes to your
/// courier" copy (info icon opens the explainer sheet), percentage chips
/// with live dollar amounts, and `Order and Pay`, which raises the placing
/// order sheet. Percentages are computed from the live order total through
/// [CheckoutTotals].
class TipScreen extends StatefulWidget {
  const TipScreen({super.key});

  static const String routeName = '/checkout/tip';

  @override
  State<TipScreen> createState() => _TipScreenState();
}

class _TipScreenState extends State<TipScreen> {
  static const List<double> _percents = <double>[0.15, 0.18, 0.20, 0.25];

  /// Chip selection: 0–3 the percentages, 4 the custom amount.
  int _selected = 1;

  /// Custom tip in dollars, set by the "Enter other amount" sheet.
  double? _customTip;

  /// The order total before discounts — what the percentages apply to.
  double get _base => CheckoutTotals.subtotal;

  double _tipFor(int index) =>
      double.parse((_base * _percents[index]).toStringAsFixed(2));

  double get _tip {
    if (_selected == 4) {
      return _customTip ?? 0;
    }
    return _tipFor(_selected);
  }

  double get _payTotal => CheckoutTotals.total + _tip;

  void _pick(int index) {
    if (index == 4) {
      _openOtherAmount();
      return;
    }
    setState(() => _selected = index);
  }

  Future<void> _openOtherAmount() async {
    final double? amount = await showOtherAmountSheet(
      context,
      orderTotal: CheckoutTotals.subtotal,
      initial: _customTip,
    );
    if (amount == null || !mounted) {
      return;
    }
    setState(() {
      _customTip = amount;
      _selected = 4;
    });
  }

  void _showTipInfo() {
    showModalBottomSheet<void>(
      context: context,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
      ),
      builder: (BuildContext ctx) => SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 24, 24, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              const Text(
                'Say thanks with a tip',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 18,
                  height: 22 / 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 16),
              const Text(
                'Tipping is an optional way to say thanks. 100% of your tip '
                'goes to your courier, and you can change the amount up to '
                '1 hour after delivery.',
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 12),
              const Text(
                'The percentages you see are based on your order total, '
                'before any discounts or promotions.',
                style: TextStyle(
                  fontSize: 14,
                  height: 20 / 14,
                  fontWeight: FontWeight.w400,
                  color: AppColors.ink,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: () => Navigator.of(ctx).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _order() async {
    final bool placed = await showPlacingOrderSheet(context);
    if (!placed || !mounted) {
      return;
    }
    // Order confirmed: empty the demo cart and land on the receipt screen
    // with no way back into the checkout stack.
    CartStore.instance.clear();
    Navigator.of(
      context,
    ).pushNamedAndRemoveUntil('/order-confirmation', (Route<dynamic> _) => false);
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        children: <Widget>[
          SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(0, topInset, 0, 150),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _buildHeader(context),
                _buildIllustration(),
                _buildCopy(),
                _buildChips(),
              ],
            ),
          ),
          Positioned(
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: const BoxDecoration(
                color: AppColors.surface,
                boxShadow: AppShadows.topBar,
              ),
              padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
              child: FilledButton(
                onPressed: _order,
                child: Text(
                  'Order and Pay · ${CheckoutTotals.usd(_payTotal)}',
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Header — plain back arrow like the reference flow, title below.
  Widget _buildHeader(BuildContext context) {
    return Container(
      height: 104,
      padding: const EdgeInsets.fromLTRB(8, 4, 16, 0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          IconButton(
            tooltip: 'Back',
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(
              Icons.arrow_back_rounded,
              size: 26,
              color: AppColors.ink,
            ),
          ),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              'Add a tip',
              style: TextStyle(
                fontSize: 30,
                height: 36 / 30,
                letterSpacing: -0.6,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Courier illustration: the prototype stands in the reference's art
  /// with the app's emoji-on-tint language.
  Widget _buildIllustration() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        height: 180,
        decoration: const BoxDecoration(
          color: Color(0xFFE8F5E4),
          borderRadius: BorderRadius.all(Radius.circular(AppRadius.xl)),
        ),
        child: Stack(
          children: <Widget>[
            const Center(child: Text('🛵', style: TextStyle(fontSize: 68))),
            const Positioned(left: 44, bottom: 34, child: Text('🛍️', style: TextStyle(fontSize: 30))),
            const Positioned(right: 52, top: 36, child: Text('📍', style: TextStyle(fontSize: 26))),
            const Positioned(left: 78, top: 30, child: Text('💨', style: TextStyle(fontSize: 22))),
          ],
        ),
      ),
    );
  }

  Widget _buildCopy() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Text(
              '100% of your tip goes to your courier. Tips are based on your '
              'order total of ${CheckoutTotals.usd(_base)} before any '
              'discounts and promotions.',
              style: const TextStyle(
                fontSize: 14,
                height: 18 / 14,
                fontWeight: FontWeight.w400,
                color: AppColors.inkMuted,
              ),
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            padding: EdgeInsets.zero,
            constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
            icon: const Icon(
              Icons.info_outline,
              size: 18,
              color: AppColors.inkMuted,
            ),
            onPressed: _showTipInfo,
          ),
        ],
      ),
    );
  }

  /// Percentage chips: percent over live amount, selected one black; `Edit`
  /// opens the custom-amount sheet.
  Widget _buildChips() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
      child: Row(
        children: <Widget>[
          for (int i = 0; i < _percents.length; i++) ...<Widget>[
            if (i != 0) const SizedBox(width: 8),
            Expanded(
              child: _TipChip(
                percent: '${(_percents[i] * 100).round()}%',
                amount: CheckoutTotals.usd(_tipFor(i)),
                selected: _selected == i,
                onTap: () => _pick(i),
              ),
            ),
          ],
          const SizedBox(width: 8),
          Expanded(
            child: _TipChip(
              percent: 'Edit',
              amount: _customTip != null
                  ? CheckoutTotals.usd(_customTip!)
                  : null,
              selected: _selected == 4,
              onTap: () => _pick(4),
            ),
          ),
        ],
      ),
    );
  }
}

/// The reference's `Enter other amount` sheet: a big currency field over
/// the order total, with a Save that hands the amount back to the caller.
/// Returns null when dismissed without saving.
Future<double?> showOtherAmountSheet(
  BuildContext context, {
  required double orderTotal,
  double? initial,
}) {
  return showModalBottomSheet<double>(
    context: context,
    backgroundColor: AppColors.surface,
    isScrollControlled: true,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
    ),
    builder: (BuildContext ctx) => SafeArea(
      child: _OtherAmountSheet(orderTotal: orderTotal, initial: initial),
    ),
  );
}

class _OtherAmountSheet extends StatefulWidget {
  const _OtherAmountSheet({required this.orderTotal, this.initial});

  final double orderTotal;
  final double? initial;

  @override
  State<_OtherAmountSheet> createState() => _OtherAmountSheetState();
}

class _OtherAmountSheetState extends State<_OtherAmountSheet> {
  late final TextEditingController _controller = TextEditingController(
    text: widget.initial != null ? widget.initial!.toStringAsFixed(2) : '',
  );

  bool get _valid {
    final double? v = double.tryParse(_controller.text);
    return v != null && v > 0;
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _save() {
    final double? v = double.tryParse(_controller.text);
    if (v == null || v <= 0) {
      return;
    }
    Navigator.of(context).pop(double.parse(v.toStringAsFixed(2)));
  }

  @override
  Widget build(BuildContext context) {
    return StatefulBuilder(
      builder: (BuildContext context, void Function(void Function()) setSheet) {
        void onChanged(String _) => setSheet(() {});

        return Padding(
          padding: EdgeInsets.only(
            left: 16,
            right: 16,
            top: 8,
            bottom: 16 + MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              // Sheet header: back, title, close.
              Row(
                children: <Widget>[
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.arrow_back,
                      size: 22,
                      color: AppColors.ink,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Enter other amount',
                    style: TextStyle(
                      fontSize: 16,
                      height: 19 / 16,
                      fontWeight: FontWeight.w600,
                      color: AppColors.ink,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    padding: EdgeInsets.zero,
                    icon: const Icon(
                      Icons.close,
                      size: 22,
                      color: AppColors.ink,
                    ),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              // Big currency input with a clear button.
              TextField(
                controller: _controller,
                autofocus: true,
                onChanged: onChanged,
                keyboardType:
                    const TextInputType.numberWithOptions(decimal: true),
                inputFormatters: <TextInputFormatter>[
                  FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d{0,2}')),
                ],
                style: const TextStyle(
                  fontSize: 34,
                  height: 40 / 34,
                  fontWeight: FontWeight.w700,
                  color: AppColors.ink,
                ),
                decoration: InputDecoration(
                  filled: false,
                  contentPadding: EdgeInsets.zero,
                  hintText: '0.00',
                  prefixIcon: const Padding(
                    padding: EdgeInsets.only(right: 4),
                    child: SizedBox(
                      width: 20,
                      child: Center(
                        child: Text(
                          '\$',
                          style: TextStyle(
                            fontSize: 34,
                            fontWeight: FontWeight.w700,
                            color: AppColors.ink,
                          ),
                        ),
                      ),
                    ),
                  ),
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 28,
                    minHeight: 40,
                  ),
                  suffixIcon: _controller.text.isEmpty
                      ? null
                      : IconButton(
                          icon: const Icon(
                            Icons.close,
                            size: 22,
                            color: AppColors.inkMuted,
                          ),
                          onPressed: () {
                            _controller.clear();
                            onChanged('');
                          },
                        ),
                  border: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hairline),
                  ),
                  enabledBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.hairline),
                  ),
                  focusedBorder: const UnderlineInputBorder(
                    borderSide: BorderSide(color: AppColors.ink, width: 1.5),
                  ),
                ),
              ),
              const SizedBox(height: 12),
              Text(
                'Order total: ${CheckoutTotals.usd(widget.orderTotal)}',
                style: const TextStyle(
                  fontSize: 14,
                  height: 17 / 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.inkMuted,
                ),
              ),
              const SizedBox(height: 20),
              FilledButton(
                onPressed: _valid ? _save : null,
                style: FilledButton.styleFrom(
                  backgroundColor: _valid
                      ? AppColors.ink
                      : AppColors.surfaceAlt,
                  foregroundColor: _valid
                      ? AppColors.surface
                      : AppColors.inkMuted,
                ),
                child: const Text('Save'),
              ),
            ],
          ),
        );
      },
    );
  }
}

/// One tip chip: percent over amount (or `Edit`), black fill when picked.
class _TipChip extends StatelessWidget {
  const _TipChip({
    required this.percent,
    required this.selected,
    required this.onTap,
    this.amount,
  });

  final String percent;
  final String? amount;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        decoration: BoxDecoration(
          color: selected ? AppColors.ink : AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.md),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              percent,
              style: TextStyle(
                fontSize: 13,
                height: 16 / 13,
                fontWeight: FontWeight.w700,
                color: selected ? AppColors.surface : AppColors.ink,
              ),
            ),
            if (amount != null) ...<Widget>[
              const SizedBox(height: 1),
              Text(
                amount!,
                style: TextStyle(
                  fontSize: 11,
                  height: 14 / 11,
                  fontWeight: FontWeight.w500,
                  color: selected
                      ? const Color(0xCCFFFFFF)
                      : AppColors.inkMuted,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
