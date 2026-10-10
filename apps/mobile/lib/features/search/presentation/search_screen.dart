import 'dart:async';

import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';
import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/round_icon_button.dart';
import '../../../core/widgets/search_field.dart';
import '../../../core/widgets/section_header.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `C05.01 · Search` — five frames that are five states of one screen:
///
/// * `1:1486` Idle    — recent searches + browse categories,
/// * `1:1538` Results — filter chips, result count, product / store rows,
/// * `1:1606` No results — empty state with `Clear filters`,
/// * `1:1639` Error   — empty state with `Try again`,
/// * `1:1671` Loading — filter chips + skeleton rows.
///
/// One query field drives every state: an empty field shows
/// [SearchStatus.idle], typing debounces into [SearchStatus.loading] and then
/// resolves to results / no results against the local mock catalogue, and the
/// mock's failure trigger (`error`) lands on [SearchStatus.error]. The active
/// query is kept while a state is on screen so `Try again` re-runs it verbatim.
class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  static const String routeName = '/search';

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

/// The five C05.01 frames, one per state.
enum SearchStatus { idle, loading, results, noResults, error }

class _SearchScreenState extends State<SearchScreen> {
  /// C05.01 filter chips (`1:1554`) with their Figma widths - the pills hug
  /// their labels, and pinning keeps Flutter's text advance from drifting the
  /// row (same treatment as the B3 category chips).
  static const List<_ChipSpec> _filters = <_ChipSpec>[
    _ChipSpec('All', 50),
    _ChipSpec('Groceries', 98),
    _ChipSpec('Stores', 77),
    _ChipSpec('Caterers', 91),
  ];

  /// C05.01 idle chips (`1:1521`) with their Figma widths - the widths decide
  /// where the wrap breaks, so they must match the frame exactly.
  static const List<_ChipSpec> _categories = <_ChipSpec>[
    _ChipSpec('Meat', 67),
    _ChipSpec('Rice & Grains', 122),
    _ChipSpec('Spices', 78),
    _ChipSpec('Dairy', 68),
    _ChipSpec('Fresh Produce', 130),
    _ChipSpec('Frozen Meals', 123),
    _ChipSpec('Sweets', 83),
    _ChipSpec('Catering', 91),
  ];

  /// C05.01 typed query (`1:1550`): Inter 15/600 black.
  static const TextStyle _queryStyle = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  /// C05.01 placeholder (`1:1498`): Inter 14/400 `#6b6b6b`.
  static const TextStyle _hintStyle = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w400,
    letterSpacing: 0,
    color: AppColors.inkMuted,
  );

  /// C05.01 buttons (`1:1638` `Clear filters`, `1:1670` `Try again`):
  /// Inter 15/600, line auto (18px). `AppButton` supplies the colour.
  static const TextStyle _buttonLabelStyle = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w600,
    letterSpacing: 0,
  );

  final TextEditingController _controller = TextEditingController();

  Timer? _debounce;

  /// Bumped on every run so a slower mock response can never overwrite a
  /// newer one (and so clearing the field drops any in-flight run).
  int _run = 0;

  SearchStatus _status = SearchStatus.idle;

  /// Query of the run currently on screen - kept for `Try again`.
  String _query = '';

  String _filter = 'All';

  _SearchResults? _results;

  List<String> _recents = <String>[
    'goat curry cut',
    'basmati rice',
    'biryani tray',
  ];

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  // ---- Actions -------------------------------------------------------------

  void _onChanged(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) {
      _run++; // drop any in-flight run
      setState(() {
        _status = SearchStatus.idle;
        _query = '';
        _results = null;
        _filter = 'All';
      });
      return;
    }
    _debounce = Timer(const Duration(milliseconds: 300), () => _search(value));
  }

  void _onSubmitted(String value) {
    _debounce?.cancel();
    if (value.trim().isEmpty) return;
    _search(value);
  }

  /// Runs the mock search: [SearchStatus.loading] for a brief delay, then
  /// results / no results / error. [attempt] > 0 is a retry of the same query.
  Future<void> _search(String raw, {int attempt = 0}) async {
    final String query = raw.trim();
    final int run = ++_run;
    setState(() {
      _status = SearchStatus.loading;
      _query = query;
      _results = null;
    });
    await Future<void>.delayed(const Duration(milliseconds: 450));
    if (!mounted || run != _run) return; // superseded by a newer run
    try {
      final _SearchResults results = _mockSearch(
        query,
        attempt: attempt,
        filter: _filter,
      );
      if (!mounted || run != _run) return;
      setState(() {
        _results = results;
        _status = results.total == 0
            ? SearchStatus.noResults
            : SearchStatus.results;
      });
    } on _MockSearchFailure {
      if (!mounted || run != _run) return;
      setState(() {
        _results = null;
        _status = SearchStatus.error;
      });
    }
  }

  /// `Try again` — re-runs the preserved query ([SearchStatus.error] keeps
  /// `_query`, so the retry hits the same search).
  void _retry() => _search(_query, attempt: 1);

  void _selectFilter(String label) {
    if (label == _filter) return;
    setState(() => _filter = label);
    if (_status != SearchStatus.idle && _query.isNotEmpty) {
      _search(_query);
    }
  }

  /// `Clear filters` on the No results frame — back to `All`, then re-runs.
  void _clearFilters() {
    setState(() => _filter = 'All');
    if (_query.isNotEmpty) _search(_query);
  }

  void _useRecent(String term) {
    _debounce?.cancel();
    _controller.text = term;
    _search(term);
  }

  void _clearQuery() {
    _debounce?.cancel();
    _run++;
    _controller.clear();
    setState(() {
      _status = SearchStatus.idle;
      _query = '';
      _results = null;
      _filter = 'All';
    });
  }

  void _clearRecents() => setState(() => _recents = <String>[]);

  // ---- Layout ---------------------------------------------------------------

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          // Figma status bar band is 47px (`AppInsets.statusBar`); the header
          // row starts 4px under it (field y51, back button y55).
          SizedBox(height: AppInsets.statusBar(context) + 4),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: _buildHeader(context),
          ),
          // Header ends y99, every state's content starts y123.
          const SizedBox(height: 24),
          Expanded(child: _buildBody(context)),
        ],
      ),
    );
  }

  /// Back control + 12px gap + 306×48 field (`1:1491` / `1:1494`). The back
  /// control is a plain IconButton (the app's standing back-button treatment).
  Widget _buildHeader(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        IconButton(
          padding: EdgeInsets.zero,
          constraints: const BoxConstraints.tightFor(width: 40, height: 40),
          icon: const Icon(Icons.arrow_back_rounded, size: 24),
          onPressed: () => popOrFallback(context, '/home'),
          tooltip: 'Back',
        ),
        const SizedBox(width: 12),
        Expanded(child: _buildField()),
      ],
    );
  }

  Widget _buildField() {
    return SearchField(
      hintText: 'Search groceries, stores, caterers…',
      controller: _controller,
      // C05.01 glyph is 22px with a 10px gap (text still starts at 48px).
      iconSize: 22,
      gap: 10,
      hintTextStyle: _hintStyle,
      textStyle: _queryStyle,
      onChanged: _onChanged,
      onSubmitted: _onSubmitted,
      // Clear `x` (`1:1551`) only once there is text to clear.
      suffix: _controller.text.isEmpty
          ? null
          : GestureDetector(
              key: const ValueKey<String>('search-clear'),
              behavior: HitTestBehavior.opaque,
              onTap: _clearQuery,
              child: const SizedBox(
                width: 19.2,
                height: 19.2,
                child: Center(
                  child: AppIcon('x', size: 19.2, color: AppColors.ink),
                ),
              ),
            ),
    );
  }

  Widget _buildBody(BuildContext context) {
    switch (_status) {
      case SearchStatus.idle:
        return _buildIdle(context);
      case SearchStatus.loading:
        return _buildLoading();
      case SearchStatus.results:
        return _buildResults(context);
      case SearchStatus.noResults:
        return _buildNoResults();
      case SearchStatus.error:
        return _buildError();
    }
  }

  /// 358-wide scrollable band that every state's content sits in (x16).
  Widget _scrollArea(List<Widget> children) {
    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: children,
      ),
    );
  }

  /// Idle (`1:1486`): `Recent searches` block, 24px gap, `Browse categories`.
  Widget _buildIdle(BuildContext context) {
    return _scrollArea(<Widget>[
      if (_recents.isNotEmpty) ...<Widget>[
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SectionHeader(
              title: 'Recent searches',
              actionTitle: 'Clear',
              onAction: _clearRecents,
            ),
            const SizedBox(height: 4),
            for (final String term in _recents)
              _RecentRow(term: term, onTap: () => _useRecent(term)),
          ],
        ),
        const SizedBox(height: 24),
      ],
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          const SectionHeader(title: 'Browse categories'),
          const SizedBox(height: 10),
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: <Widget>[
              for (final _ChipSpec spec in _categories)
                _Chip(
                  label: spec.label,
                  width: spec.width,
                  selected: false,
                  onTap: () => Navigator.of(context).pushNamed('/store'),
                ),
            ],
          ),
        ],
      ),
    ]);
  }

  /// Filter chip row shown by every non-idle state (`1:1554`).
  Widget _buildFilters() {
    return Row(
      children: <Widget>[
        for (int i = 0; i < _filters.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 8),
          _Chip(
            label: _filters[i].label,
            width: _filters[i].width,
            selected: _filter == _filters[i].label,
            onTap: () => _selectFilter(_filters[i].label),
          ),
        ],
      ],
    );
  }

  /// Results (`1:1538`): chips, count, `Products` preview, `Stores` preview.
  Widget _buildResults(BuildContext context) {
    final _SearchResults results = _results!;
    final List<Widget> children = <Widget>[
      _buildFilters(),
      const SizedBox(height: 16),
      Text(
        '${results.total} result${results.total == 1 ? '' : 's'} '
        'for “$_query”',
        style: Theme.of(context).textTheme.labelMedium,
      ),
      const SizedBox(height: 16),
    ];
    if (results.products.isNotEmpty) {
      children.add(_buildProducts(context, results.products));
      children.add(const SizedBox(height: 16));
    }
    if (results.stores.isNotEmpty) {
      children.add(_buildStores(context, results.stores));
    }
    return _scrollArea(children);
  }

  Widget _buildProducts(BuildContext context, List<_ResultProduct> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        SectionHeader(
          title: 'Products',
          actionTitle: 'See all',
          onAction: () => Navigator.of(context).pushNamed('/browse'),
        ),
        const SizedBox(height: 2),
        for (int i = 0; i < products.length; i++) ...<Widget>[
          if (i > 0) const SizedBox(height: 2),
          _ResultRow(
            product: products[i],
            // Result cards open the existing B4 product route.
            onTap: () => Navigator.of(context).pushNamed('/product'),
            onAdd: () => Navigator.of(context).pushNamed('/product'),
          ),
        ],
      ],
    );
  }

  Widget _buildStores(BuildContext context, List<_ResultStore> stores) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const SectionHeader(title: 'Stores'),
        const SizedBox(height: 10),
        for (final _ResultStore store in stores)
          _StoreResult(
            store: store,
            onTap: () => Navigator.of(context).pushNamed('/store'),
          ),
      ],
    );
  }

  /// Loading (`1:1671`): chips, skeleton count line, four skeleton rows.
  Widget _buildLoading() {
    return _scrollArea(<Widget>[
      _buildFilters(),
      const SizedBox(height: 16),
      const _SkeletonBox(width: 110, height: 14),
      for (int i = 0; i < 4; i++) ...<Widget>[
        const SizedBox(height: 16),
        const _SkeletonRow(),
      ],
    ]);
  }

  /// No results (`1:1606`).
  Widget _buildNoResults() {
    return _scrollArea(<Widget>[
      _buildFilters(),
      _EmptyState(
        icon: 'search',
        iconSize: 22,
        iconColor: AppColors.inkMuted,
        title: 'No matches for “$_query”',
        subtitle: 'Check the spelling or try a different word.',
        subtitleColor: AppColors.inkMuted,
        button: SizedBox(
          width: 180,
          // `Clear filters` (`1:1637`) is the `#f3f3f3` pill variant, which
          // `AppButton` renders as a text button on the grey surface.
          child: Material(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(AppRadius.xxl),
            child: AppButton(
              label: 'Clear filters',
              onPressed: _clearFilters,
              variant: AppButtonVariant.text,
              height: 48,
              labelStyle: _buttonLabelStyle,
            ),
          ),
        ),
      ),
    ]);
  }

  /// Error (`1:1639`).
  Widget _buildError() {
    return _scrollArea(<Widget>[
      _buildFilters(),
      _EmptyState(
        icon: 'x',
        iconSize: 24,
        iconColor: AppColors.ink,
        title: 'Couldn’t load results',
        subtitle: 'Check your connection and try again.',
        subtitleColor: AppColors.danger,
        button: SizedBox(
          width: 180,
          child: AppButton(
            label: 'Try again',
            onPressed: _retry,
            height: 48,
            labelStyle: _buttonLabelStyle,
          ),
        ),
      ),
    ]);
  }
}

// ---- State-level building blocks -------------------------------------------

/// Chip geometry from the C05.01 frames: label + Figma frame width.
class _ChipSpec {
  const _ChipSpec(this.label, this.width);

  final String label;
  final double width;
}

/// The 36px filter / category pill (`1:1522`, `1:1555`): r18, `#f3f3f3`
/// (black when selected), 16/9.5 padding, Inter 14/600. The label comes from
/// the shared [TagPill]; `Material` carries the fill so the ink ripple shows.
class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.width,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final double width;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.ink : AppColors.surfaceAlt,
      borderRadius: BorderRadius.circular(18),
      child: InkWell(
        borderRadius: BorderRadius.circular(18),
        onTap: onTap,
        child: SizedBox(
          width: width,
          child: TagPill(
            label: label,
            height: 36,
            radius: 18,
            fontSize: 14,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 9.5),
            background: Colors.transparent,
            foreground: selected ? AppColors.surface : AppColors.ink,
          ),
        ),
      ),
    );
  }
}

/// Idle recent-search row (`1:1504`): 18px glyph, 12px gap, Inter 15/500,
/// 10px vertical padding (38px row).
class _RecentRow extends StatelessWidget {
  const _RecentRow({required this.term, required this.onTap});

  static const TextStyle _style = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w500,
    letterSpacing: 0,
    color: AppColors.ink,
  );

  final String term;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Row(
          children: <Widget>[
            const AppIcon('search', size: 18, color: AppColors.inkMuted),
            const SizedBox(width: 12),
            Text(term, style: _style),
          ],
        ),
      ),
    );
  }
}

/// Product result row (`1:1568`): 64×64 r14 thumb, 12px gap, three-line
/// info block, 36px `Add` circle.
class _ResultRow extends StatelessWidget {
  const _ResultRow({
    required this.product,
    required this.onTap,
    required this.onAdd,
  });

  final _ResultProduct product;
  final VoidCallback onTap;
  final VoidCallback onAdd;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 6),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: Image.asset(
                'assets/icons/${product.image}',
                width: 64,
                height: 64,
                fit: BoxFit.cover,
                // Missing / offline asset degrades to a neutral tile instead
                // of throwing (same treatment as the D2 results rows).
                errorBuilder: (BuildContext context, Object error,
                        StackTrace? stack) =>
                    Container(
                  width: 64,
                  height: 64,
                  color: AppColors.surfaceAlt,
                ),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(product.name, style: theme.titleMedium),
                  const SizedBox(height: 2),
                  Text(product.store, style: theme.labelMedium),
                  const SizedBox(height: 2),
                  Text(
                    product.price,
                    style: theme.labelSmall?.copyWith(color: AppColors.ink),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // 36px add circle: Figma `plus` glyph, ink-on-grey fill.
            RoundIconButton(
              icon: Icons.add_rounded,
              iconSize: 20,
              onTap: onAdd,
              child: const AppIcon('plus', size: 20),
            ),
          ],
        ),
      ),
    );
  }
}

/// Store result card (`1:1591`): 112×112 r16 image, 14px gap, name /
/// description / rating meta / tag pills.
class _StoreResult extends StatelessWidget {
  const _StoreResult({required this.store, required this.onTap});

  final _ResultStore store;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return InkWell(
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          ClipRRect(
            borderRadius: BorderRadius.circular(AppRadius.lg),
            child: Image.asset(
              'assets/icons/${store.image}',
              width: 112,
              height: 112,
              fit: BoxFit.cover,
              // Missing / offline asset degrades to a neutral tile instead
              // of throwing (same treatment as the D2 results rows).
              errorBuilder: (BuildContext context, Object error,
                      StackTrace? stack) =>
                  Container(
                width: 112,
                height: 112,
                color: AppColors.surfaceAlt,
              ),
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(store.name, style: theme.titleMedium),
                const SizedBox(height: 5),
                Text(store.description, style: theme.bodySmall, maxLines: 2),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    const AppIcon('star', size: 13),
                    const SizedBox(width: 4),
                    Text(
                      store.rating,
                      style: theme.bodySmall?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Text(
                      '${store.reviews} · ${store.eta}',
                      style: theme.bodySmall,
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Row(
                  children: <Widget>[
                    // Figma `1:1602` pill fill is `#047a43` - the shared
                    // `accentLink` / success-deep paint.
                    TagPill(
                      label: store.tags[0],
                      background: AppColors.accentLink,
                      foreground: AppColors.surface,
                      height: 21,
                      radius: 11,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                    const SizedBox(width: 6),
                    TagPill(
                      label: store.tags[1],
                      height: 21,
                      radius: 11,
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Grey / black filled block used by the No results and Error frames:
/// 80px bubble, 24px gap, title, 12px gap, subtitle, 24px gap, button.
class _EmptyState extends StatelessWidget {
  const _EmptyState({
    required this.icon,
    required this.iconSize,
    required this.iconColor,
    required this.title,
    required this.subtitle,
    required this.subtitleColor,
    required this.button,
  });

  final String icon;
  final double iconSize;
  final Color iconColor;
  final String title;
  final String subtitle;
  final Color subtitleColor;
  final Widget button;

  @override
  Widget build(BuildContext context) {
    final TextTheme theme = Theme.of(context).textTheme;
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Chips end y159, the bubble starts y240.
          const SizedBox(height: 81),
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: AppIcon(icon, size: iconSize, color: iconColor),
          ),
          const SizedBox(height: 24),
          Text(title, textAlign: TextAlign.center, style: theme.titleLarge),
          const SizedBox(height: 12),
          Text(
            subtitle,
            textAlign: TextAlign.center,
            style: theme.bodyMedium?.copyWith(
              fontWeight: FontWeight.w500,
              color: subtitleColor,
            ),
          ),
          const SizedBox(height: 24),
          button,
        ],
      ),
    );
  }
}

/// One grey skeleton block of the Loading frame (r6, `#f3f3f3`).
class _SkeletonBox extends StatelessWidget {
  const _SkeletonBox({
    required this.width,
    required this.height,
    this.radius = 6,
  });

  final double width;
  final double height;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      height: height,
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(radius),
      ),
    );
  }
}

/// Skeleton result row (`1:1697`): 64×64 r12 block + three text lines.
class _SkeletonRow extends StatelessWidget {
  const _SkeletonRow();

  @override
  Widget build(BuildContext context) {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          _SkeletonBox(width: 64, height: 64, radius: 12),
          SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                _SkeletonBox(width: 150, height: 14),
                SizedBox(height: 8),
                _SkeletonBox(width: 100, height: 12),
                SizedBox(height: 8),
                _SkeletonBox(width: 70, height: 12),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Mock catalogue ---------------------------------------------------------

class _SearchResults {
  const _SearchResults({
    required this.total,
    required this.products,
    required this.stores,
  });

  /// Matches in the mock catalogue (what the result count reports).
  final int total;

  /// Preview rows to draw — the Figma frame shows the first two products
  /// under `See all`, so the list is sliced the same way.
  final List<_ResultProduct> products;
  final List<_ResultStore> stores;
}

class _ResultProduct {
  const _ResultProduct({
    required this.name,
    required this.store,
    required this.price,
    required this.image,
    required this.keywords,
  });

  final String name;
  final String store;
  final String price;
  final String image;
  final List<String> keywords;
}

class _ResultStore {
  const _ResultStore({
    required this.name,
    required this.description,
    required this.rating,
    required this.reviews,
    required this.eta,
    required this.image,
    required this.tags,
    required this.keywords,
  });

  final String name;
  final String description;
  final String rating;
  final String reviews;
  final String eta;
  final String image;
  final List<String> tags;
  final List<String> keywords;
}

/// Mock failure for the C05.01 Error frame (`1:1639`).
class _MockSearchFailure implements Exception {
  const _MockSearchFailure();
}

const _ResultStore _store = _ResultStore(
  name: 'Madina Halal Meats',
  description: 'Halal meats, rice, spices, dairy & more',
  rating: '4.8',
  reviews: '(320)',
  eta: 'About 60 min',
  image: 'store_madina.png',
  tags: <String>['Halal', r'$5.99 delivery'],
  keywords: <String>[
    'goat',
    'halal',
    'meat',
    'meats',
    'madina',
    'biryani',
    'tray',
    'rice',
    'spices',
    'dairy',
  ],
);

/// Local mock catalogue. Eleven of the entries match `goat`, and with the
/// store that is the `12 results for “goat”` the Figma frame pins.
const List<_ResultProduct> _catalogue = <_ResultProduct>[
  _ResultProduct(
    name: 'Goat Curry Cut',
    store: 'Madina Halal Meats',
    price: r'$16.99 / kg',
    image: 'prod_goat_curry.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Mince',
    store: 'Madina Halal Meats',
    price: r'$15.99 / kg',
    image: 'prod_goat_mince.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Shoulder',
    store: 'Madina Halal Meats',
    price: r'$19.99 / kg',
    image: 'prod_goat_shoulder.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Baby Goat Leg',
    store: 'Madina Halal Meats',
    price: r'$21.50 / kg',
    image: 'prod_baby_goat_leg.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Rib Rack',
    store: 'Madina Halal Meats',
    price: r'$23.00 / kg',
    image: 'prod_goat_shoulder.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Neck Chops',
    store: 'Madina Halal Meats',
    price: r'$17.50 / kg',
    image: 'prod_goat_curry.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Stew Meat',
    store: 'Madina Halal Meats',
    price: r'$18.25 / kg',
    image: 'prod_baby_goat_leg.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Soup Bones',
    store: 'Madina Halal Meats',
    price: r'$9.99 / kg',
    image: 'prod_goat_mince.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Liver',
    store: 'Madina Halal Meats',
    price: r'$14.50 / kg',
    image: 'prod_goat_mince.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Leg Chops',
    store: 'Madina Halal Meats',
    price: r'$20.75 / kg',
    image: 'prod_goat_shoulder.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Goat Sausages',
    store: 'Madina Halal Meats',
    price: r'$12.99 / pack',
    image: 'prod_goat_curry.png',
    keywords: <String>['goat', 'meat', 'halal'],
  ),
  _ResultProduct(
    name: 'Basmati Rice',
    store: 'Madina Halal Meats',
    price: r'$12.50 / 5 kg',
    image: 'cart_rice.png',
    keywords: <String>['rice', 'basmati', 'grains'],
  ),
];

/// The mock search behind the C05.01 states.
///
/// * Mock failure trigger: the query `error` throws on the first attempt so
///   the Error frame (`1:1639`) is reachable; `Try again` re-runs the same
///   query with `attempt: 1`, which succeeds and - nothing in the catalogue
///   matches `error` - lands on No results.
/// * A query matches an item when any of its words appears in the item's
///   name, keywords or description.
/// * [filter] mirrors the chip row: `Groceries` keeps products, `Stores`
///   keeps the store, `Caterers` has no mock entries (so it is empty), and
///   `All` keeps everything.
_SearchResults _mockSearch(
  String query, {
  required int attempt,
  required String filter,
}) {
  if (query.toLowerCase() == 'error' && attempt == 0) {
    throw const _MockSearchFailure();
  }

  final List<String> words = query
      .toLowerCase()
      .split(RegExp(r'\s+'))
      .where((String word) => word.isNotEmpty)
      .toList();

  bool matches(String searchable) {
    if (words.isEmpty) return false;
    final String haystack = searchable.toLowerCase();
    return words.any((String word) => haystack.contains(word));
  }

  final List<_ResultProduct> allProducts = _catalogue
      .where(
        (_ResultProduct product) =>
            matches('${product.name} ${product.keywords.join(' ')}'),
      )
      .toList();
  final bool storeMatches = matches(
    '${_store.name} ${_store.description} ${_store.keywords.join(' ')}',
  );

  final List<_ResultProduct> products =
      (filter == 'All' || filter == 'Groceries')
      ? allProducts
      : <_ResultProduct>[];
  final List<_ResultStore> stores =
      (filter == 'All' || filter == 'Stores') && storeMatches
      ? <_ResultStore>[_store]
      : <_ResultStore>[];

  return _SearchResults(
    total: products.length + stores.length,
    // The frame draws a two-row preview beneath `See all`.
    products: products.take(2).toList(),
    stores: stores.take(1).toList(),
  );
}
