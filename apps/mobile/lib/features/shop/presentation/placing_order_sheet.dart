import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/cart/cart_controller.dart';
import '../../../core/cart/cart_item.dart';
import '../../../core/theme/app_theme.dart';

/// Checkout step 5 — the reference's `Placing order…` confirmation sheet.
///
/// Shows what is about to be ordered and gives the shopper a few seconds
/// to back out: the black CTA counts down `Looks good (00:08)` and places
/// the order itself when it reaches zero. Returns `true` when the order is
/// placed (or the CTA is tapped early), `false` on `Go back`.
Future<bool> showPlacingOrderSheet(BuildContext context) async {
  final bool? placed = await showModalBottomSheet<bool>(
    context: context,
    isDismissible: false,
    enableDrag: false,
    backgroundColor: AppColors.surface,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
    ),
    builder: (BuildContext ctx) => const _PlacingOrderSheet(),
  );
  return placed ?? false;
}

class _PlacingOrderSheet extends StatefulWidget {
  const _PlacingOrderSheet();

  @override
  State<_PlacingOrderSheet> createState() => _PlacingOrderSheetState();
}

class _PlacingOrderSheetState extends State<_PlacingOrderSheet> {
  int _left = 8;
  Timer? _timer;
  bool _resolved = false;

  @override
  void initState() {
    super.initState();
    _timer = Timer.periodic(const Duration(seconds: 1), (Timer t) {
      if (!mounted) {
        t.cancel();
        return;
      }
      if (_left == 0) {
        t.cancel();
        _place();
      } else {
        setState(() => _left--);
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }

  void _place() {
    if (_resolved || !mounted) {
      return;
    }
    _resolved = true;
    Navigator.of(context).pop(true);
  }

  void _goBack() {
    if (_resolved || !mounted) {
      return;
    }
    _resolved = true;
    Navigator.of(context).pop(false);
  }

  @override
  Widget build(BuildContext context) {
    final List<CartItem> items = CartStore.instance.items;

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 24, 16, 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: <Widget>[
            const Text(
              'Placing order…',
              style: TextStyle(
                fontSize: 20,
                height: 24 / 20,
                fontWeight: FontWeight.w700,
                color: AppColors.ink,
              ),
            ),
            const SizedBox(height: 16),
            const Row(
              children: <Widget>[
                Icon(Icons.schedule, size: 20, color: AppColors.ink),
                SizedBox(width: 10),
                Text(
                  'Standard delivery: 10–20 min(s)',
                  style: TextStyle(
                    fontSize: 14,
                    height: 17 / 14,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(height: 1, color: AppColors.hairline),
            const SizedBox(height: 14),
            const Row(
              children: <Widget>[
                Icon(
                  Icons.shopping_bag_outlined,
                  size: 18,
                  color: AppColors.ink,
                ),
                SizedBox(width: 10),
                Text(
                  'Madina Halal Meats',
                  style: TextStyle(
                    fontSize: 15,
                    height: 18 / 15,
                    fontWeight: FontWeight.w600,
                    color: AppColors.ink,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            // The lines about to be placed, capped so the sheet stays
            // thumb-height on a full cart.
            ConstrainedBox(
              constraints: const BoxConstraints(maxHeight: 210),
              child: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    for (final CartItem item in items)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            SizedBox(
                              width: 16,
                              child: Text(
                                '${item.quantity}',
                                style: const TextStyle(
                                  fontSize: 14,
                                  height: 17 / 14,
                                  fontWeight: FontWeight.w500,
                                  color: AppColors.ink,
                                ),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: <Widget>[
                                  Text(
                                    item.name,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      height: 18 / 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.ink,
                                    ),
                                  ),
                                  if (item.detail != null) ...<Widget>[
                                    const SizedBox(height: 2),
                                    Text(
                                      item.detail!,
                                      style: const TextStyle(
                                        fontSize: 13,
                                        height: 16 / 13,
                                        fontWeight: FontWeight.w400,
                                        color: AppColors.inkMuted,
                                      ),
                                    ),
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            FilledButton(
              onPressed: _place,
              child: Text(
                'Looks good (00:${_left.toString().padLeft(2, '0')})',
              ),
            ),
            const SizedBox(height: 4),
            TextButton(
              onPressed: _goBack,
              child: const Text(
                'Go back',
                style: TextStyle(
                  fontSize: 15,
                  height: 18 / 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
