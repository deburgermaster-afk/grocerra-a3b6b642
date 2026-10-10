import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';

/// `C23.01 · Notifications` — the grouped notification feed (Orders /
/// Catering / Account) entered from the Home bell.
///
/// Ported frame-for-frame from the Figma flow (390×844): a 40px circular
/// back button with a right-aligned "Mark all read" action, the 30px title
/// beneath it, then the grouped rows. Row colouring follows the design
/// exactly — unread rows carry a green dot and a semibold title, and the
/// per-row ink/grey mixes (e.g. Catering's ink timestamps) are intentional
/// copies of the frame.
class NotificationScreen extends StatefulWidget {
  const NotificationScreen({super.key});

  static const String routeName = '/notifications';

  @override
  State<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends State<NotificationScreen> {
  /// Groups exactly as laid out in `C23.01`: label, then its rows with a
  /// hairline divider between them (none after the last row).
  final List<_NotifGroup> _groups = <_NotifGroup>[
    _NotifGroup(
      label: 'Orders',
      entries: <_Notif>[
        _Notif(
          title: 'Your order is on the way',
          subtitle: 'Madina Halal Meats · arriving by 6:15 PM',
          time: '2 min',
          unread: true,
        ),
        _Notif(title: 'Order delivered', subtitle: 'Order #MHM-48103', time: 'Sep 28'),
      ],
    ),
    _NotifGroup(
      label: 'Catering',
      entries: <_Notif>[
        _Notif(
          title: 'New quote received',
          subtitle: 'Wedding · 80 guests',
          time: '1 h',
          unread: true,
          subtitleInk: true,
          timeInk: true,
        ),
        _Notif(
          title: 'Request sent',
          subtitle: 'Caterers reply within 24 hours',
          time: 'Yesterday',
          titleInk: true,
          timeInk: true,
        ),
      ],
    ),
    _NotifGroup(
      label: 'Account',
      labelInk: true,
      entries: <_Notif>[
        _Notif(
          title: 'Account created',
          subtitle: 'Add a payment method to check out faster',
          time: 'Sep 12',
          timeInk: true,
        ),
      ],
    ),
  ];

  void _markAllRead() {
    setState(() {
      for (final _NotifGroup group in _groups) {
        for (final _Notif entry in group.entries) {
          entry.unread = false;
        }
      }
    });
  }

  void _open(_Notif entry) {
    if (!entry.unread) return;
    setState(() => entry.unread = false);
  }

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Padding(
        padding: EdgeInsets.only(top: topInset),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Header: back + "Mark all read" row, title underneath.
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Row(
                    children: <Widget>[
                      RoundIconButton(
                        tooltip: 'Back',
                        icon: Icons.chevron_left,
                        onTap: () => Navigator.of(context).maybePop(),
                      ),
                      const Spacer(),
                      _MarkAllRead(onTap: _markAllRead),
                    ],
                  ),
                  const SizedBox(height: 12),
                  const Text(
                    'Notifications',
                    style: TextStyle(
                      fontSize: 30,
                      height: 36 / 30,
                      fontWeight: FontWeight.w700,
                      letterSpacing: -0.6,
                      color: AppColors.ink,
                    ),
                  ),
                ],
              ),
            ),
            // Content starts 5px under the header, on the 16px gutters.
            Expanded(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(16, 5, 16, 0),
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      for (int i = 0; i < _groups.length; i++) ...<Widget>[
                        if (i > 0) const SizedBox(height: 18),
                        _GroupView(
                          group: _groups[i],
                          onOpen: _open,
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// One section — "Orders" / "Catering" / "Account" — with its rows.
class _GroupView extends StatelessWidget {
  const _GroupView({required this.group, required this.onOpen});

  final _NotifGroup group;
  final ValueChanged<_Notif> onOpen;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          group.label,
          style: TextStyle(
            fontSize: 20,
            height: 24 / 20,
            fontWeight: FontWeight.w700,
            color: group.labelInk ? AppColors.ink : AppColors.inkMuted,
          ),
        ),
        for (int i = 0; i < group.entries.length; i++) ...<Widget>[
          const SizedBox(height: 2),
          if (i > 0) ...<Widget>[
            const SizedBox(height: 2),
            const _Divider(),
            const SizedBox(height: 2),
          ],
          _NotifRow(entry: group.entries[i], onTap: () => onOpen(group.entries[i])),
        ],
      ],
    );
  }
}

class _NotifRow extends StatelessWidget {
  const _NotifRow({required this.entry, required this.onTap});

  final _Notif entry;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final _Notif n = entry;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Unread dot sits 6px below the text top, per the frame.
            Padding(
              padding: const EdgeInsets.only(top: 6),
              child: Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color: n.unread ? AppColors.success : AppColors.hairline,
                  borderRadius: BorderRadius.circular(4),
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    n.title,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 15,
                      height: 18 / 15,
                      fontWeight: n.unread ? FontWeight.w600 : FontWeight.w500,
                      color: n.titleInk ? AppColors.ink : AppColors.inkMuted,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    n.subtitle,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12,
                      height: 15 / 12,
                      fontWeight: FontWeight.w500,
                      color: n.subtitleInk ? AppColors.ink : AppColors.inkMuted,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            Text(
              n.time,
              style: TextStyle(
                fontSize: 12,
                height: 15 / 12,
                fontWeight: FontWeight.w500,
                color: n.timeInk ? AppColors.ink : AppColors.inkMuted,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// The right-aligned header action (`C23.01`: 14/600 ink).
class _MarkAllRead extends StatelessWidget {
  const _MarkAllRead({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onTap,
      style: TextButton.styleFrom(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 6),
        minimumSize: Size.zero,
        tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        foregroundColor: AppColors.ink,
      ),
      child: const Text(
        'Mark all read',
        style: TextStyle(
          fontSize: 14,
          height: 17 / 14,
          fontWeight: FontWeight.w600,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _Divider extends StatelessWidget {
  const _Divider();

  @override
  Widget build(BuildContext context) =>
      Container(width: double.infinity, height: 1, color: AppColors.hairline);
}

class _NotifGroup {
  _NotifGroup({
    required this.label,
    required this.entries,
    this.labelInk = false,
  });

  final String label;
  final List<_Notif> entries;

  /// The frame renders the Account label in ink while the other two are
  /// muted — copied as-is.
  final bool labelInk;
}

class _Notif {
  _Notif({
    required this.title,
    required this.subtitle,
    required this.time,
    this.unread = false,
    this.titleInk = false,
    this.subtitleInk = false,
    this.timeInk = false,
  });

  final String title;
  final String subtitle;
  final String time;

  /// Cleared by tapping the row or "Mark all read".
  bool unread;

  /// Per-row colour overrides copied from the frame (Catering/Account mix
  /// ink and muted rows).
  final bool titleInk;
  final bool subtitleInk;
  final bool timeInk;
}
