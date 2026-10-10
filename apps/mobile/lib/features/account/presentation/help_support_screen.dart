import 'package:flutter/material.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/pill_button.dart';
import '../../../core/widgets/screen_header.dart';

/// Figma `C25.01 · Help & Support` — exact 390×844 frame port.
///
/// White frame: 104-tall header, then 358-wide content at y156 — the
/// `Search help` pill, the topic accordion (`Orders` open with its FAQ
/// answers, `Refunds` / `Catering` / `Account` collapsed behind 1px
/// dividers) and the `Still need help?` contact pair.
class HelpSupportScreen extends StatefulWidget {
  const HelpSupportScreen({super.key});

  static const String routeName = '/profile/help';

  @override
  State<HelpSupportScreen> createState() => _HelpSupportScreenState();
}

class _HelpSupportScreenState extends State<HelpSupportScreen> {
  /// `App / Semi Bold / 15 / Line Auto` - the contact pill labels.
  static const TextStyle _pillLabel = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w600,
  );

  /// `App / Regular / 15` - the `Search help` placeholder (pure black on
  /// C25.01, not the muted B1 placeholder).
  static const TextStyle _searchHint = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w400,
    color: AppColors.ink,
  );

  /// `App / Semi Bold / 14 / Line Auto` - FAQ questions.
  static const TextStyle _question = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// `App / Medium / 12 / Line Auto` - FAQ answers.
  static const TextStyle _answer = TextStyle(
    fontSize: 12,
    height: 15 / 12,
    fontWeight: FontWeight.w500,
    color: AppColors.inkMuted,
  );

  /// Topic titles: `App / Semi Bold / 16`. `Orders` and `Catering` are
  /// `#6b6b6b`, `Refunds` and `Account` are black (nodes `1:2488` … `1:2510`).
  static const TextStyle _topicOpen = TextStyle(
    fontSize: 16,
    height: 19 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.inkMuted,
  );
  static const TextStyle _topicIdle = TextStyle(
    fontSize: 16,
    height: 19 / 16,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// The four topics. `Orders` carries the two FAQs the frame shows; the
  /// other three reuse the same mock FAQ pattern so the accordion works
  /// without a backend (Figma only designs the expanded `Orders` state).
  static const List<_Topic> _topics = <_Topic>[
    _Topic(
      style: _topicOpen,
      faqs: <List<String>>[
        <String>[
          'Where is my order?',
          'Open Orders and tap Track order to follow your courier live.',
        ],
        <String>[
          'Can I change my order?',
          'Contact the store from the tracking screen before it is packed.',
        ],
      ],
    ),
    _Topic(
      style: _topicIdle,
      faqs: <List<String>>[
        <String>['How do I get a refund?', 'Report the order from Orders and we will review it.'],
        <String>['How long do refunds take?', 'Approved refunds return to your card in 3-5 days.'],
      ],
    ),
    _Topic(
      style: _topicOpen,
      faqs: <List<String>>[
        <String>['How do I request a quote?', 'Open Catering and send a caterer your event details.'],
        <String>['Can I change my guest count?', 'Yes - reply to the quote before you accept it.'],
      ],
    ),
    _Topic(
      style: _topicIdle,
      faqs: <List<String>>[
        <String>['How do I edit my details?', 'Open Profile and tap Personal details to update them.'],
        <String>['How do I reset my password?', 'Use Forgot password on the sign-in screen.'],
      ],
    ),
  ];

  static const List<String> _topicTitles = <String>[
    'Orders',
    'Refunds',
    'Catering',
    'Account',
  ];

  /// Mock state: `Orders` is the open topic in the frame.
  int _openTopic = 0;

  void _toggleTopic(int index) {
    setState(() => _openTopic = _openTopic == index ? -1 : index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(0, AppInsets.statusBar(context), 0, 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            const ScreenHeader(title: 'Help & Support'),
            // Content frame starts at y156 - 5px below the 104-tall header.
            const SizedBox(height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _buildSearch(),
                  const SizedBox(height: 18),
                  _buildTopics(),
                  const SizedBox(height: 18),
                  _buildStillNeedHelp(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// 358x48 `#f3f3f3` r24 search pill: 22px `icon/search` at x16, black
  /// 15/400 placeholder at x48.
  Widget _buildSearch() {
    return Container(
      height: 48,
      padding: const EdgeInsets.symmetric(horizontal: 16),
      decoration: const BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.all(Radius.circular(24)),
      ),
      child: Row(
        children: <Widget>[
          const AppIcon('search', size: 22, color: AppColors.ink),
          const SizedBox(width: 10),
          Expanded(
            child: TextField(
              decoration: const InputDecoration(
                hintText: 'Search help',
                hintStyle: _searchHint,
                filled: false,
                isDense: true,
                contentPadding: EdgeInsets.zero,
                border: InputBorder.none,
              ),
              style: _searchHint,
            ),
          ),
        ],
      ),
    );
  }

  /// `Topics`: 56-tall rows separated by 1px `#e6e6e6` dividers, with the
  /// open topic's FAQ block directly under its row (padding bottom 14).
  Widget _buildTopics() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        for (int i = 0; i < _topics.length; i++) ...<Widget>[
          if (i > 0)
            Container(height: 1, width: double.infinity, color: AppColors.hairline),
          _buildTopicRow(i),
          if (_openTopic == i) _buildAnswers(_topics[i]),
        ],
      ],
    );
  }

  Widget _buildTopicRow(int index) {
    final bool open = _openTopic == index;
    return InkWell(
      onTap: () => _toggleTopic(index),
      child: SizedBox(
        height: 56,
        child: Row(
          children: <Widget>[
            Expanded(
              child: Text(
                _topicTitles[index],
                maxLines: 1,
                overflow: TextOverflow.clip,
                style: _topics[index].style,
              ),
            ),
            // Open: 18px `icon/chev` down glyph; closed: 20px `icon/right`.
            open
                ? const AppIcon('down', size: 18, color: AppColors.ink)
                : const AppIcon('right', size: 20, color: AppColors.ink),
          ],
        ),
      ),
    );
  }

  Widget _buildAnswers(_Topic topic) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          for (int i = 0; i < topic.faqs.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(height: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(topic.faqs[i][0], style: _question),
                const SizedBox(height: 2),
                Text(topic.faqs[i][1], style: _answer),
              ],
            ),
          ],
        ],
      ),
    );
  }

  /// `Still need help?`: 20/700 heading over the 174 + 8 + 176 button pair.
  Widget _buildStillNeedHelp() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text(
          'Still need help?',
          style: Theme.of(context).textTheme.titleLarge,
        ),
        const SizedBox(height: 8),
        Row(
          children: <Widget>[
            SizedBox(
              width: 174,
              child: PillButton(
                label: 'Chat with us',
                fill: AppColors.surfaceAlt,
                height: 48,
                labelStyle: _pillLabel,
                onPressed: () {},
              ),
            ),
            const SizedBox(width: 8),
            SizedBox(
              width: 176,
              child: AppButton(
                label: 'Email support',
                variant: AppButtonVariant.outline,
                height: 48,
                labelStyle: _pillLabel,
                onPressed: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// One help topic: its title paint plus the FAQ pairs shown when it is open.
class _Topic {
  const _Topic({required this.style, required this.faqs});

  final TextStyle style;

  /// `[question, answer]` pairs.
  final List<List<String>> faqs;
}
