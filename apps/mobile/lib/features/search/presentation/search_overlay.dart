import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/glass_tab_bar.dart';
import '../../home/data/catalog.dart';

/// Full-page search that grows out of the bottom bar.
///
/// [progress] runs 0 -> 1 after the bar's search pill has stretched across
/// the bar: the pill's rectangle rises from the bottom of the screen to fill
/// it, its corners square off, the dark pill turns into the white page, and
/// the field settles at the top. Results appear as it lands. Closing plays
/// the same motion backwards.
class SearchOverlay extends StatefulWidget {
  const SearchOverlay({
    super.key,
    required this.progress,
    required this.onClose,
  });

  final Animation<double> progress;
  final VoidCallback onClose;

  @override
  State<SearchOverlay> createState() => _SearchOverlayState();
}

class _SearchOverlayState extends State<SearchOverlay> {
  final TextEditingController _query = TextEditingController();
  final FocusNode _focus = FocusNode();

  /// Remembered for the session.
  static final List<String> _recent = <String>[
    'Basmati rice',
    'Goat curry cut',
    'Gulab jamun',
  ];

  @override
  void initState() {
    super.initState();
    widget.progress.addStatusListener(_status);
    _query.addListener(() => setState(() {}));
  }

  void _status(AnimationStatus s) {
    if (s == AnimationStatus.completed) _focus.requestFocus();
    if (s == AnimationStatus.reverse) _focus.unfocus();
  }

  @override
  void dispose() {
    widget.progress.removeStatusListener(_status);
    _query.dispose();
    _focus.dispose();
    super.dispose();
  }

  void _search(String q) {
    final String v = q.trim();
    if (v.isEmpty) return;
    setState(() {
      _recent
        ..remove(v)
        ..insert(0, v);
      if (_recent.length > 6) _recent.removeLast();
    });
  }

  void _use(String q) {
    HapticFeedback.selectionClick();
    _query.text = q;
    _query.selection = TextSelection.collapsed(offset: q.length);
  }

  @override
  Widget build(BuildContext context) {
    final Size screen = MediaQuery.sizeOf(context);
    final double top = AppInsets.statusBar(context);
    final Rect from = Rect.fromLTWH(
      GlassTabBar.side,
      screen.height - GlassTabBar.bottom - GlassTabBar.height,
      screen.width - GlassTabBar.side * 2,
      GlassTabBar.height,
    );
    final Rect to = Offset.zero & screen;

    return AnimatedBuilder(
      animation: widget.progress,
      builder: (BuildContext context, Widget? body) {
        final double t = widget.progress.value;
        final double rise = Curves.easeInOutCubicEmphasized.transform(t);
        // Colour turns over the middle of the rise; content arrives last.
        final double paint = Curves.easeInOut.transform(
          ((t - 0.15) / 0.55).clamp(0.0, 1.0),
        );
        final double content = Curves.easeOut.transform(
          ((t - 0.55) / 0.45).clamp(0.0, 1.0),
        );
        final Rect r = Rect.lerp(from, to, rise)!;
        final double radius = GlassTabBar.height / 2 * (1 - rise);

        final Color bg = Color.lerp(
          BarColors.search,
          AppColors.surface,
          paint,
        )!;
        final Color ink = Color.lerp(Colors.white, AppColors.ink, paint)!;
        final Color hint = Color.lerp(
          BarColors.searchText,
          AppColors.inkMuted,
          paint,
        )!;
        final double headerTop = 8 + (top - 4) * rise;

        return Stack(
          children: <Widget>[
            // Dim the page behind while the panel rises.
            Positioned.fill(
              child: IgnorePointer(
                child: ColoredBox(
                  color: Colors.black.withValues(alpha: 0.18 * (1 - paint)),
                ),
              ),
            ),
            Positioned.fromRect(
              rect: r,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(radius),
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: bg,
                    border: Border.all(
                      color: BarColors.searchRim.withValues(alpha: 1 - paint),
                      width: 1.5,
                    ),
                    borderRadius: BorderRadius.circular(radius),
                  ),
                  // Lay out at full-screen size and let the rising rect
                  // reveal it, so nothing reflows mid-flight.
                  child: OverflowBox(
                    alignment: Alignment.topLeft,
                    minWidth: r.width,
                    maxWidth: r.width,
                    minHeight: screen.height,
                    maxHeight: screen.height,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        SizedBox(height: headerTop),
                        _header(rise, paint, ink, hint),
                        Expanded(
                          child: Opacity(
                            opacity: content,
                            child: Transform.translate(
                              offset: Offset(0, 24 * (1 - content)),
                              child: body,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: _body(),
    );
  }

  Widget _header(double rise, double paint, Color ink, Color hint) {
    // At rise 0 this row is the pill's contents (icon + "Search" 18px in);
    // by the end it is a back button and a grey search field.
    final double back = 40 * rise;
    return SizedBox(
      height: 48,
      child: Row(
        children: <Widget>[
          SizedBox(width: 6 + 6 * rise),
          SizedBox(
            width: back,
            child: back < 20
                ? null
                : IconButton(
                    tooltip: 'Close search',
                    padding: EdgeInsets.zero,
                    onPressed: widget.onClose,
                    icon: Icon(Icons.arrow_back_rounded, color: ink),
                  ),
          ),
          SizedBox(width: 4 * rise),
          Expanded(
            child: Container(
              height: 48,
              margin: EdgeInsets.only(right: 12 * rise),
              padding: const EdgeInsets.only(left: 12, right: 4),
              decoration: BoxDecoration(
                color: AppColors.surfaceAlt.withValues(alpha: paint),
                borderRadius: BorderRadius.circular(24),
              ),
              child: Row(
                children: <Widget>[
                  Icon(Icons.search_rounded, size: 24, color: ink),
                  const SizedBox(width: 8),
                  Expanded(
                    child: TextField(
                      controller: _query,
                      focusNode: _focus,
                      textInputAction: TextInputAction.search,
                      onSubmitted: _search,
                      cursorColor: AppColors.accent,
                      style: TextStyle(
                        color: ink,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        isCollapsed: true,
                        filled: false,
                        border: InputBorder.none,
                        hintText: rise < 0.5
                            ? 'Search'
                            : 'Groceries, stores, caterers',
                        hintStyle: TextStyle(
                          color: hint,
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ),
                  if (_query.text.isNotEmpty)
                    IconButton(
                      tooltip: 'Clear',
                      onPressed: _query.clear,
                      icon: Icon(Icons.cancel_rounded, size: 20, color: hint),
                    ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _body() {
    final String q = _query.text.trim().toLowerCase();
    return q.isEmpty ? _suggestions() : _results(q);
  }

  Widget _suggestions() {
    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        16,
        16,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: <Widget>[
        if (_recent.isNotEmpty) ...<Widget>[
          const _Heading('Recent searches'),
          for (final String r in _recent)
            _Row(
              leading: const Icon(
                Icons.history_rounded,
                color: AppColors.inkMuted,
              ),
              title: r,
              onTap: () => _use(r),
            ),
          const SizedBox(height: 16),
        ],
        const _Heading('Top categories'),
        const SizedBox(height: 8),
        GridView.count(
          crossAxisCount: 4,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
          childAspectRatio: 0.92,
          children: <Widget>[
            for (final Category c in categories.take(8))
              _CategoryTile(category: c, onTap: () => _use(c.label)),
          ],
        ),
      ],
    );
  }

  Widget _results(String q) {
    final List<Store> s = stores
        .where(
          (Store x) =>
              x.name.toLowerCase().contains(q) ||
              x.tagline.toLowerCase().contains(q),
        )
        .toList();
    final List<Product> p = products
        .where(
          (Product x) =>
              x.name.toLowerCase().contains(q) ||
              x.store.toLowerCase().contains(q),
        )
        .toList();

    if (s.isEmpty && p.isEmpty) {
      return Padding(
        padding: const EdgeInsets.all(24),
        child: Text(
          'No results for "${_query.text.trim()}". Try a store, '
          'a dish or an ingredient.',
          style: const TextStyle(fontSize: 15, color: AppColors.inkMuted),
        ),
      );
    }

    return ListView(
      padding: EdgeInsets.fromLTRB(
        16,
        12,
        16,
        24 + MediaQuery.viewInsetsOf(context).bottom,
      ),
      keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
      children: <Widget>[
        if (s.isNotEmpty) ...<Widget>[
          _Heading('Stores (${s.length})'),
          for (final Store x in s)
            _Row(
              leading: _Thumb(emoji: x.art.first, tint: x.tint),
              title: x.name,
              query: q,
              subtitle: '${x.rating} ★ · ${x.minutes} min · ${x.feeLabel}',
              onTap: () {
                _search(_query.text);
                Navigator.of(context).pushNamed('/store');
              },
            ),
          const SizedBox(height: 12),
        ],
        if (p.isNotEmpty) ...<Widget>[
          _Heading('Items (${p.length})'),
          for (final Product x in p)
            _Row(
              leading: _Thumb(emoji: x.emoji, tint: x.tint),
              title: x.name,
              query: q,
              subtitle: '${x.size} · ${x.store}',
              trailing: Text(
                money(x.price),
                style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                  color: AppColors.ink,
                ),
              ),
              onTap: () {
                _search(_query.text);
                Navigator.of(context).pushNamed('/product');
              },
            ),
        ],
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.text);

  final String text;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
          letterSpacing: -0.3,
          color: AppColors.ink,
        ),
      ),
    );
  }
}

class _Row extends StatelessWidget {
  const _Row({
    required this.leading,
    required this.title,
    required this.onTap,
    this.subtitle,
    this.trailing,
    this.query = '',
  });

  final Widget leading;
  final String title;
  final String? subtitle;
  final Widget? trailing;
  final VoidCallback onTap;

  /// Highlighted in [title] where it matches.
  final String query;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(10),
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Row(
          children: <Widget>[
            SizedBox(width: 44, child: Center(child: leading)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  _highlighted(),
                  if (subtitle != null)
                    Text(
                      subtitle!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 13,
                        color: AppColors.inkMuted,
                      ),
                    ),
                ],
              ),
            ),
            ?trailing,
          ],
        ),
      ),
    );
  }

  Widget _highlighted() {
    const TextStyle base = TextStyle(
      fontSize: 15,
      fontWeight: FontWeight.w500,
      color: AppColors.ink,
    );
    final int i = query.isEmpty ? -1 : title.toLowerCase().indexOf(query);
    if (i < 0) {
      return Text(
        title,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: base,
      );
    }
    return Text.rich(
      TextSpan(
        style: base,
        children: <InlineSpan>[
          TextSpan(text: title.substring(0, i)),
          TextSpan(
            text: title.substring(i, i + query.length),
            style: const TextStyle(
              fontWeight: FontWeight.w700,
              color: AppColors.accentDark,
            ),
          ),
          TextSpan(text: title.substring(i + query.length)),
        ],
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _Thumb extends StatelessWidget {
  const _Thumb({required this.emoji, required this.tint});

  final String emoji;
  final Color tint;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: tint,
        borderRadius: BorderRadius.circular(10),
      ),
      alignment: Alignment.center,
      child: Text(emoji, style: const TextStyle(fontSize: 24)),
    );
  }
}

class _CategoryTile extends StatelessWidget {
  const _CategoryTile({required this.category, required this.onTap});

  final Category category;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(14),
      child: Ink(
        decoration: BoxDecoration(
          color: AppColors.canvas,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(category.emoji, style: const TextStyle(fontSize: 30)),
            const SizedBox(height: 4),
            Text(
              category.label,
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: AppColors.ink,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
