import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';

/// Floating navigation: a frosted pill of icon tabs with a raised white pill
/// under the selected one, and a long dark search pill beside it.
///
/// The selected pill glides between tabs on a spring. When [searchExpanded]
/// turns on, the search pill stretches right-to-left across the whole bar
/// while the tabs shrink away; `HomeShell` then lifts it into full-page
/// search.
class GlassTabBar extends StatefulWidget {
  const GlassTabBar({
    super.key,
    required this.index,
    required this.onSelect,
    required this.onSearchTap,
    this.searchExpanded = false,
  });

  final int index;
  final ValueChanged<int> onSelect;
  final VoidCallback onSearchTap;
  final bool searchExpanded;

  static const List<TabSpec> tabs = <TabSpec>[
    TabSpec('Home', 'assets/icons/ic_home.svg'),
    TabSpec('Catering', 'assets/icons/ic_chef.svg'),
    TabSpec('Profile', 'assets/icons/ic_user.svg'),
  ];

  /// Geometry shared with the search overlay so it can take off from
  /// exactly where the bar sits.
  static const double height = 64;
  static const double side = 12;
  static const double bottom = 11;

  /// How long the search pill takes to stretch across the bar.
  static const Duration expand = Duration(milliseconds: 340);

  @override
  State<GlassTabBar> createState() => _GlassTabBarState();
}

class TabSpec {
  const TabSpec(this.label, this.iconAsset);

  final String label;
  final String iconAsset;
}

/// Colours read off the reference: warm frosted white, warm grey glyphs,
/// near-black search pill.
abstract final class BarColors {
  static const Color glass = Color(0xCCF7F5F3);
  static const Color rim = Color(0xE6FFFFFF);
  static const Color selected = Color(0xFFFFFFFF);
  static const Color idle = Color(0xFFA19B95);
  static const Color active = Color(0xFF1B1B1A);
  static const Color search = Color(0xFF2B2B29);
  static const Color searchRim = Color(0xFF8F8C88);
  static const Color searchText = Color(0xFFB9B5B0);
}

abstract final class _Geo {
  static const double gap = 10;
  static const double inset = 6;
  static const double narrow = 50;

  /// How much wider the selected tab is than the others.
  static const double extra = 22;

  static double get tabsWidth =>
      inset * 2 + narrow * GlassTabBar.tabs.length + extra;
}

class _GlassTabBarState extends State<GlassTabBar>
    with SingleTickerProviderStateMixin {
  /// Position of the selected pill, in tab slots, on a spring so it
  /// overshoots a touch and settles.
  late final AnimationController _slot = AnimationController.unbounded(
    vsync: this,
    value: widget.index.toDouble(),
  );

  static const SpringDescription _spring = SpringDescription(
    mass: 1,
    stiffness: 260,
    damping: 22,
  );

  static const Curve _curve = Curves.easeInOutCubicEmphasized;

  @override
  void didUpdateWidget(GlassTabBar old) {
    super.didUpdateWidget(old);
    if (old.index != widget.index) {
      _slot.animateWith(
        SpringSimulation(
          _spring,
          _slot.value,
          widget.index.toDouble(),
          _slot.velocity,
        ),
      );
    }
  }

  @override
  void dispose() {
    _slot.dispose();
    super.dispose();
  }

  void _select(int i) {
    if (i != widget.index) HapticFeedback.selectionClick();
    widget.onSelect(i);
  }

  @override
  Widget build(BuildContext context) {
    final bool open = widget.searchExpanded;
    return Positioned(
      left: GlassTabBar.side,
      right: GlassTabBar.side,
      bottom: GlassTabBar.bottom,
      height: GlassTabBar.height,
      child: Stack(
        children: <Widget>[
          // Tabs shrink toward the left edge and fade as search takes over.
          AnimatedPositioned(
            duration: GlassTabBar.expand,
            curve: _curve,
            left: 0,
            top: 0,
            bottom: 0,
            width: open ? 0 : _Geo.tabsWidth,
            child: AnimatedOpacity(
              duration: GlassTabBar.expand,
              opacity: open ? 0 : 1,
              child: _glass(
                child: OverflowBox(
                  alignment: Alignment.centerLeft,
                  minWidth: _Geo.tabsWidth,
                  maxWidth: _Geo.tabsWidth,
                  child: _tabs(),
                ),
              ),
            ),
          ),
          // Search pill: its left edge travels right-to-left to the start of
          // the bar.
          AnimatedPositioned(
            duration: GlassTabBar.expand,
            curve: _curve,
            left: open ? 0 : _Geo.tabsWidth + _Geo.gap,
            right: 0,
            top: 0,
            bottom: 0,
            child: SearchPill(onTap: open ? null : widget.onSearchTap),
          ),
        ],
      ),
    );
  }

  Widget _glass({required Widget child}) {
    return DecoratedBox(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(GlassTabBar.height / 2),
        boxShadow: const <BoxShadow>[
          BoxShadow(
            color: Color(0x1A3B2F25),
            blurRadius: 30,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(GlassTabBar.height / 2),
        child: BackdropFilter(
          filter: ui.ImageFilter.blur(sigmaX: 18, sigmaY: 18),
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: BarColors.glass,
              borderRadius: BorderRadius.circular(GlassTabBar.height / 2),
              border: Border.all(color: BarColors.rim, width: 1.5),
            ),
            child: child,
          ),
        ),
      ),
    );
  }

  Widget _tabs() {
    final int n = GlassTabBar.tabs.length;
    return Padding(
      padding: const EdgeInsets.all(_Geo.inset),
      child: AnimatedBuilder(
        animation: _slot,
        builder: (BuildContext context, Widget? _) {
          // Slot widths and the pill position read the same spring value,
          // so the slots breathe in step with the gliding pill.
          final double s = _slot.value;
          double weight(int i) => (1 - (s - i).abs()).clamp(0.0, 1.0);
          return Stack(
            children: <Widget>[
              Positioned(
                left: s * _Geo.narrow,
                top: 0,
                bottom: 0,
                width: _Geo.narrow + _Geo.extra,
                child: Container(
                  decoration: BoxDecoration(
                    color: BarColors.selected,
                    borderRadius: BorderRadius.circular(GlassTabBar.height / 2),
                    boxShadow: const <BoxShadow>[
                      BoxShadow(
                        color: Color(0x143B2F25),
                        blurRadius: 12,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: <Widget>[
                  for (int i = 0; i < n; i++)
                    SizedBox(
                      width: _Geo.narrow + _Geo.extra * weight(i),
                      child: _TabButton(
                        spec: GlassTabBar.tabs[i],
                        selected: i == widget.index,
                        onTap: () => _select(i),
                      ),
                    ),
                ],
              ),
            ],
          );
        },
      ),
    );
  }
}

/// The dark search pill. Also drawn by the search overlay at the start of
/// its rise, so the hand-off is invisible.
class SearchPill extends StatelessWidget {
  const SearchPill({super.key, required this.onTap});

  final VoidCallback? onTap;

  static const BoxDecoration decoration = BoxDecoration(
    color: BarColors.search,
    borderRadius: BorderRadius.all(Radius.circular(GlassTabBar.height / 2)),
    border: Border.fromBorderSide(
      BorderSide(color: BarColors.searchRim, width: 1.5),
    ),
    boxShadow: <BoxShadow>[
      BoxShadow(
        color: Color(0x33000000),
        blurRadius: 24,
        offset: Offset(0, 10),
      ),
    ],
  );

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Search',
      child: _Squish(
        enabled: onTap != null,
        onTap: onTap ?? () {},
        child: Container(
          decoration: decoration,
          padding: const EdgeInsets.only(left: 18, right: 12),
          child: const Row(
            children: <Widget>[
              Icon(Icons.search_rounded, size: 24, color: Colors.white),
              SizedBox(width: 8),
              Expanded(
                child: Text(
                  'Search',
                  maxLines: 1,
                  overflow: TextOverflow.fade,
                  softWrap: false,
                  style: TextStyle(
                    color: BarColors.searchText,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TabButton extends StatelessWidget {
  const _TabButton({
    required this.spec,
    required this.selected,
    required this.onTap,
  });

  final TabSpec spec;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      selected: selected,
      label: spec.label,
      child: _Squish(
        key: ValueKey<String>('tab-${spec.label}'),
        onTap: onTap,
        child: Center(
          child: TweenAnimationBuilder<Color?>(
            duration: const Duration(milliseconds: 280),
            tween: ColorTween(
              end: selected ? BarColors.active : BarColors.idle,
            ),
            builder: (BuildContext context, Color? color, Widget? _) =>
                SvgPicture.asset(
                  spec.iconAsset,
                  width: 26,
                  height: 26,
                  colorFilter: ColorFilter.mode(color!, BlendMode.srcIn),
                ),
          ),
        ),
      ),
    );
  }
}

/// Sinks under the finger and springs back, so every tap feels physical.
class _Squish extends StatefulWidget {
  const _Squish({
    super.key,
    required this.child,
    required this.onTap,
    this.enabled = true,
  });

  final Widget child;
  final VoidCallback onTap;
  final bool enabled;

  @override
  State<_Squish> createState() => _SquishState();
}

class _SquishState extends State<_Squish> {
  bool _down = false;

  @override
  Widget build(BuildContext context) {
    if (!widget.enabled) return widget.child;
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTapDown: (_) => setState(() => _down = true),
      onTapCancel: () => setState(() => _down = false),
      onTapUp: (_) => setState(() => _down = false),
      onTap: () {
        HapticFeedback.lightImpact();
        widget.onTap();
      },
      child: AnimatedScale(
        scale: _down ? 0.93 : 1,
        duration: Duration(milliseconds: _down ? 90 : 320),
        curve: _down ? Curves.easeOut : Curves.easeOutBack,
        child: widget.child,
      ),
    );
  }
}
