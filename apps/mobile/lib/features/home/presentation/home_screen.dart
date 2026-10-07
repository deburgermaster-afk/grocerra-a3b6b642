import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';

/// Placeholder for the blueprint screen *Groceries & Catering Home*.
///
/// Wiring to build against: address selector, notifications, cart pill,
/// Groceries / Catering entry tiles, category rail, stores near you and the
/// five-tab floating navigation. Backend: `User App - Backend`
/// (Supabase gateway + edge functions of the *User app*).
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
      children: <Widget>[
        Text(
          'Groceries & Catering',
          style: Theme.of(context).textTheme.headlineMedium,
        ),
        const SizedBox(height: 4),
        Text(
          'Fresh South Asian essentials and event feasts',
          style: Theme.of(context).textTheme.bodySmall,
        ),
        const SizedBox(height: 16),
        TextField(
          decoration: const InputDecoration(
            hintText: 'Search groceries, stores, caterers...',
            prefixIcon: Icon(Icons.search),
          ),
        ),
        const SizedBox(height: 16),
        Row(
          children: <Widget>[
            Expanded(child: _EntryTile(title: 'Groceries', tint: AppColors.accentDark)),
            const SizedBox(width: 12),
            const Expanded(child: _EntryTile(title: 'Catering', tint: AppColors.ink)),
          ],
        ),
        const SizedBox(height: 24),
        Text('Shop groceries', style: Theme.of(context).textTheme.titleLarge),
        const SizedBox(height: 8),
        Text('Stores near you', style: Theme.of(context).textTheme.titleLarge),
      ],
    );
  }
}

class _EntryTile extends StatelessWidget {
  const _EntryTile({required this.title, required this.tint});

  final String title;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 132,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(20),
      ),
      alignment: Alignment.bottomLeft,
      child: Text(
        title,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
