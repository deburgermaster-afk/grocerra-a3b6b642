import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';
import '../../../core/widgets/tag_pill.dart';

/// Figma `C21.01 · Favourites` (`1:2292`) and its empty twin
/// (`1:2345`) - exact 390x844 frame ports in one stateful screen.
///
/// Pushed from Profile (`/profile/favourites`). The frame has no tab bar, so
/// only the safe-area bottom is padded. Pass `arguments: true` to open on the
/// empty state (`1:2345`); the default opens with the two saved stores
/// (`1:2292`). The Products/Caterers tabs and a list emptied by unfavouriting
/// both render the empty state.
class FavouritesScreen extends StatefulWidget {
  const FavouritesScreen({super.key});

  static const routeName = '/profile/favourites';

  @override
  State<FavouritesScreen> createState() => _FavouritesScreenState();
}

class _FavouritesScreenState extends State<FavouritesScreen> {
  /// 0 = Stores, 1 = Products, 2 = Caterers (`1:2305` / `1:2307` / `1:2309`).
  int _tab = 0;

  // Copied out of the const seed so `arguments: true` can clear it at runtime.
  final List<_FavStore> _stores = List<_FavStore>.of(
    _FavouritesScreenState._seed,
  );

  static const List<_FavStore> _seed = <_FavStore>[
    _FavStore(
      image: 'fav_store_madina.png',
      name: 'Madina Halal Meats',
      description: 'Halal meats, rice, spices, dairy & more',
      rating: '4.8',
      mutedRating: false,
      reviews: '(320) · About 60 min',
      delivery: r'$5.99 delivery',
    ),
    _FavStore(
      image: 'fav_store_dhaka.png',
      name: 'Dhaka Fresh Grocers',
      description: 'Fresh fish, rice, spices and sweets.',
      rating: '4.7',
      // The second card paints its rating `#6b6b6b` (`1:2336`).
      mutedRating: true,
      reviews: '(210) · About 45 min',
      delivery: r'$4.99 delivery',
    ),
  ];

  bool _readArgs = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `ModalRoute` is only reachable after the first dependency pass; guard
    // because the callback can fire again on inherited-widget changes.
    if (_readArgs) return;
    _readArgs = true;
    if (ModalRoute.of(context)?.settings.arguments == true) {
      _stores.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool showList = _tab == 0 && _stores.isNotEmpty;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: SingleChildScrollView(
        padding: EdgeInsets.fromLTRB(
          16,
          AppInsets.statusBar(context) + 8,
          16,
          24 + MediaQuery.paddingOf(context).bottom,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            IconButton(
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints.tightFor(
                width: 40,
                height: 40,
              ),
              icon: const Icon(Icons.arrow_back_rounded, size: 24),
              onPressed: () => popOrFallback(context, '/profile'),
              tooltip: 'Back',
            ),
            const SizedBox(height: 12),
            Text(
              'Favourites',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
            const SizedBox(height: 13),
            _SegmentedControl(
              selected: _tab,
              onChanged: (int index) => setState(() => _tab = index),
            ),
            const SizedBox(height: 18),
            if (showList) ...<Widget>[
              for (int i = 0; i < _stores.length; i++) ...<Widget>[
                if (i > 0) const SizedBox(height: 18),
                _StoreCard(
                  store: _stores[i],
                  onFavourite: () => setState(() => _stores.removeAt(i)),
                ),
              ],
            ] else ...<Widget>[
              // The empty state drops its bubble 36px below the control.
              const SizedBox(height: 18),
              const _EmptyState(),
            ],
          ],
        ),
      ),
    );
  }
}

class _FavStore {
  const _FavStore({
    required this.image,
    required this.name,
    required this.description,
    required this.rating,
    required this.mutedRating,
    required this.reviews,
    required this.delivery,
  });

  final String image;
  final String name;
  final String description;
  final String rating;
  final bool mutedRating;
  final String reviews;
  final String delivery;
}

/// `Segmented` (`1:2304`): 48-tall `#f3f3f3` r24 track, 4px inset, black
/// active pill with a white 14/600 label.
class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl({required this.selected, required this.onChanged});

  final int selected;
  final ValueChanged<int> onChanged;

  static const List<String> _labels = <String>[
    'Stores',
    'Products',
    'Caterers',
  ];

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: AppColors.surfaceAlt,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Row(
        // Stretch so each segment fills the 40px track height.
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          for (int i = 0; i < _labels.length; i++) ...<Widget>[
            if (i > 0) const SizedBox(width: 4),
            Expanded(
              child: Material(
                color: i == selected ? AppColors.ink : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                child: InkWell(
                  borderRadius: BorderRadius.circular(20),
                  onTap: () => onChanged(i),
                  child: Center(
                    child: Text(
                      _labels[i],
                      style: segmentLabel.copyWith(
                        color: i == selected
                            ? AppColors.surface
                            : AppColors.ink,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }
}

/// `Store card` (`1:2311` / `1:2328`): 112px r16 photo with the white heart
/// button, then name/description/meta/tags.
class _StoreCard extends StatelessWidget {
  const _StoreCard({required this.store, required this.onFavourite});

  final _FavStore store;
  final VoidCallback onFavourite;

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    return Row(
      // Figma `Store card` centers its children (info block sits at y4.5).
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        // Photo with the 28px heart button pinned 6px from its top-right.
        SizedBox(
          width: 112,
          height: 112,
          child: Stack(
            children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  'assets/icons/${store.image}',
                  width: 112,
                  height: 112,
                  fit: BoxFit.cover,
                ),
              ),
              Positioned(
                top: 6,
                right: 6,
                child: Material(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(14),
                  child: InkWell(
                    borderRadius: BorderRadius.circular(14),
                    onTap: onFavourite,
                    child: const SizedBox(
                      width: 28,
                      height: 28,
                      child: Center(child: AppIcon('heart', size: 15)),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(store.name, style: text.titleMedium),
              const SizedBox(height: 5),
              Text(store.description, style: text.bodySmall),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  const AppIcon('star', size: 13),
                  const SizedBox(width: 4),
                  Text(
                    store.rating,
                    style: ratingValue.copyWith(
                      color: store.mutedRating
                          ? AppColors.inkMuted
                          : AppColors.ink,
                    ),
                  ),
                  const SizedBox(width: 4),
                  Text(store.reviews, style: text.bodySmall),
                ],
              ),
              const SizedBox(height: 5),
              Row(
                children: <Widget>[
                  const TagPill(
                    label: 'Halal',
                    background: AppColors.accentLink,
                    foreground: AppColors.surface,
                    height: 21,
                    radius: 11,
                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  ),
                  const SizedBox(width: 6),
                  TagPill(
                    label: store.delivery,
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
    );
  }
}

/// `Empty` frame (`1:2345`): heart bubble, centred copy and the `Search` CTA
/// into the Search tab.
class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    final TextTheme text = Theme.of(context).textTheme;

    // Full width so the copy centres against the frame instead of hugging the
    // `crossAxisAlignment.start` parent column.
    return SizedBox(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Container(
            width: 80,
            height: 80,
            alignment: Alignment.center,
            decoration: const BoxDecoration(
              color: AppColors.surfaceAlt,
              shape: BoxShape.circle,
            ),
            child: const AppIcon('heart', size: 28),
          ),
          const SizedBox(height: 24),
          Text('No favourites yet', style: text.titleLarge),
          const SizedBox(height: 12),
          SizedBox(
            width: 300,
            child: Text(
              'Tap the heart on a store or product to save it here.',
              textAlign: TextAlign.center,
              style: emptySubtitle,
            ),
          ),
          const SizedBox(height: 24),
          Material(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(24),
            child: InkWell(
              borderRadius: BorderRadius.circular(24),
              onTap: () => Navigator.of(context).pushNamed('/search'),
              child: const SizedBox(
                width: 160,
                height: 48,
                child: Center(child: Text('Search', style: searchLabel)),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---- Figma text styles that have no theme token ---------------------------

/// Segment label `App / Semi Bold / 14` (`1:2306`).
const TextStyle segmentLabel = TextStyle(
  fontSize: 14,
  height: 17 / 14,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// Rating value `App / Semi Bold / 13` (`1:2319`).
const TextStyle ratingValue = TextStyle(
  fontSize: 13,
  height: 16 / 13,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);

/// Empty-state subtitle `App / Medium / 14`, `#6b6b6b` (`1:2367`).
const TextStyle emptySubtitle = TextStyle(
  fontSize: 14,
  height: 17 / 14,
  fontWeight: FontWeight.w500,
  color: AppColors.inkMuted,
);

/// `Search` CTA label `App / Semi Bold / 15` (`1:2369`).
const TextStyle searchLabel = TextStyle(
  fontSize: 15,
  height: 18 / 15,
  fontWeight: FontWeight.w600,
  color: AppColors.ink,
);
