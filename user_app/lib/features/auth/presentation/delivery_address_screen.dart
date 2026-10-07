import 'package:flutter/material.dart';

import '../../../core/services/session_store.dart';
import '../../shell/presentation/home_shell.dart';

/// Blueprint `Delivery Address`.
///
/// Controls, exactly as wired:
///   * `Back`                   -> navigates back to `Location Permission`
///   * `Search street or suburb`-> free-text address search input
///   * `No saved addresses yet` / `No recent addresses yet` -> empty-state cards
///   * `e.g. Apt 3B`            -> unit / door number input
///   * `Leave at door...`       -> optional delivery instructions
///   * `Save address`           -> saves and opens `Groceries & Catering Home`
class DeliveryAddressScreen extends StatefulWidget {
  const DeliveryAddressScreen({super.key});

  static const String routeName = '/delivery-address';

  @override
  State<DeliveryAddressScreen> createState() => _DeliveryAddressScreenState();
}

class _DeliveryAddressScreenState extends State<DeliveryAddressScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final TextEditingController _address = TextEditingController();
  final TextEditingController _unit = TextEditingController();
  final TextEditingController _instructions = TextEditingController();

  bool _busy = false;

  @override
  void dispose() {
    _address.dispose();
    _unit.dispose();
    _instructions.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _busy = true);

    await SessionStore.saveManualAddress(
      addressLine: _address.text.trim(),
      unit: _unit.text.trim(),
      instructions: _instructions.text.trim(),
    );

    if (!mounted) return;
    Navigator.of(context).pushAndRemoveUntil(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
      (Route<dynamic> route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: <Widget>[
              Row(
                children: <Widget>[
                  IconButton(
                    onPressed: () => Navigator.of(context).maybePop(),
                    icon: const Icon(Icons.arrow_back, color: Color(0xFF111114)),
                    tooltip: 'Back',
                  ),
                  const SizedBox(width: 4),
                  const Text(
                    'Delivery address',
                    style: TextStyle(
                      color: Color(0xFF111114),
                      fontSize: 24,
                      fontWeight: FontWeight.w800,
                      letterSpacing: -0.5,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              TextFormField(
                controller: _address,
                textCapitalization: TextCapitalization.words,
                autofillHints: const <String>[AutofillHints.streetAddressLine1],
                validator: (String? value) =>
                    (value == null || value.trim().length < 3)
                        ? 'Enter a street or suburb'
                        : null,
                decoration: const InputDecoration(
                  hintText: 'Search street or suburb',
                  prefixIcon: Icon(Icons.search, color: Color(0xFF7A7A85)),
                ),
              ),
              const SizedBox(height: 20),

              _EmptyStateCard(
                title: 'No saved addresses yet.',
                subtitle: 'Addresses you save will appear here.',
                icon: Icons.bookmark_border,
              ),
              const SizedBox(height: 12),
              _EmptyStateCard(
                title: 'No recent addresses yet.',
                subtitle: 'Places you deliver to will show up here.',
                icon: Icons.history,
              ),
              const SizedBox(height: 20),

              const _Label('Unit or door number (optional)'),
              TextFormField(
                controller: _unit,
                textCapitalization: TextCapitalization.characters,
                decoration: const InputDecoration(hintText: 'e.g. Apt 3B'),
              ),
              const SizedBox(height: 16),

              const _Label('Delivery instructions (optional)'),
              TextFormField(
                controller: _instructions,
                maxLines: 3,
                decoration: const InputDecoration(
                  hintText: 'Leave at door, ring the bell...',
                  contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 16),
                ),
              ),
              const SizedBox(height: 28),

              FilledButton(
                onPressed: _busy ? null : _save,
                child: _busy
                    ? const SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Save address'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _Label extends StatelessWidget {
  const _Label(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Text(
        text,
        style: const TextStyle(fontSize: 13, color: Color(0xFF7A7A85)),
      ),
    );
  }
}

class _EmptyStateCard extends StatelessWidget {
  const _EmptyStateCard({
    required this.title,
    required this.subtitle,
    required this.icon,
  });

  final String title;
  final String subtitle;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFFF7F7F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: const Color(0xFFE4E4E8)),
      ),
      child: Row(
        children: <Widget>[
          Icon(icon, color: Color(0xFF7A7A85), size: 22),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  title,
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: Color(0xFF111114),
                  ),
                ),
                const SizedBox(height: 3),
                Text(
                  subtitle,
                  style: const TextStyle(fontSize: 12.5, color: Color(0xFF8A8A93)),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
