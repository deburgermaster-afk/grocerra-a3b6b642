import 'package:flutter/material.dart';

import '../../../core/navigation/app_nav.dart';

import '../../../core/theme/app_theme.dart';
import '../../../core/widgets/app_button.dart';
import '../../../core/widgets/app_icon.dart';
import '../../../core/widgets/app_insets.dart';

/// Runtime states of the C14 tracking screen. The three Figma frames are
/// one screen, not three routes:
///
/// * [heading] - `6:17` · Tracking · Heading your way
/// * [almost] - `6:112` · Tracking · Almost here
/// * [live] - `6:197` · Tracking · Live location sharing (modal sheet)
enum TrackingStage { heading, almost, live }

/// Figma `C14.01 / C14.02 / C14.03 · Tracking` — exact 390×844 frame ports.
///
/// Full-bleed mock map (block grid, route polyline, markers) with floating
/// close / share / Help controls, the bottom status sheet and — in the
/// [TrackingStage.live] state — the 50% scrim plus the live-location sheet.
///
/// The frames expose no CTA that moves between the three states, so a tap
/// on the status card advances [heading] -> [almost] -> [live]; the live
/// sheet buttons return to [heading] (the map `6:197` shows underneath).
class TrackingScreen extends StatefulWidget {
  const TrackingScreen({super.key});

  static const String routeName = '/tracking';

  /// Optional `Navigator.pushNamed('/tracking', arguments: ...)`.
  static TrackingStage stageFrom(Object? arguments) =>
      arguments is TrackingStage ? arguments : TrackingStage.heading;

  @override
  State<TrackingScreen> createState() => _TrackingScreenState();
}

class _TrackingScreenState extends State<TrackingScreen> {
  /// Height of the tracking sheet in Figma (node 12002:182) - the toast and
  /// the locate button hang 16px above it.
  static const double _sheetHeight = 291;

  TrackingStage _stage = TrackingStage.heading;
  bool _toastVisible = true;
  bool _resolvedStage = false;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // `ModalRoute` is only reachable once the widget is mounted.
    if (!_resolvedStage) {
      _resolvedStage = true;
      _stage = TrackingScreen.stageFrom(
        ModalRoute.of(context)?.settings.arguments,
      );
    }
  }

  void _advanceStage() {
    setState(() {
      switch (_stage) {
        case TrackingStage.heading:
          _stage = TrackingStage.almost;
        case TrackingStage.almost:
          _stage = TrackingStage.live;
        case TrackingStage.live:
          break;
      }
    });
  }

  void _closeLiveSheet() => setState(() => _stage = TrackingStage.heading);

  @override
  Widget build(BuildContext context) {
    final double topInset = AppInsets.statusBar(context);

    return Scaffold(
      backgroundColor: AppColors.mapCanvas,
      body: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          _buildMap(),
          // Figma y56 = 47px status bar + 9.
          Positioned(
            left: 0,
            right: 0,
            top: topInset + 9,
            child: _buildTopControls(context),
          ),
          if (_stage == TrackingStage.heading && _toastVisible)
            Positioned(
              left: 16,
              bottom: _sheetHeight + 16,
              width: 266,
              child: _buildToast(),
            ),
          if (_stage != TrackingStage.live)
            Positioned(
              right: 16,
              bottom: _sheetHeight + 16,
              child: _buildLocateButton(),
            ),
          Positioned(left: 0, right: 0, bottom: 0, child: _buildSheet(context)),
          if (_stage == TrackingStage.live) ...<Widget>[
            Positioned.fill(child: ColoredBox(color: AppColors.scrim)),
            Positioned(
              left: 0,
              right: 0,
              bottom: 0,
              child: _buildLiveSheet(context),
            ),
          ],
        ],
      ),
    );
  }

  // ---- Map ---------------------------------------------------------------

  Widget _buildMap() {
    return Positioned.fill(
      child: Stack(
        clipBehavior: Clip.hardEdge,
        children: <Widget>[
          const ColoredBox(color: AppColors.mapCanvas),
          for (int column = 0; column < _blockColumns.length; column++)
            for (int row = 0; row < _blockRows.length; row++)
              Positioned(
                left: _blockColumns[column],
                top: _blockRows[row],
                width: 112,
                height: 128,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _blockColors[column][row],
                    borderRadius: BorderRadius.circular(AppRadius.sm),
                  ),
                ),
              ),
          ..._buildRoute(),
          ..._buildMarkers(),
        ],
      ),
    );
  }

  /// Route polyline (nodes 6:43-6:46 / 6:138-6:139): 5px black r2 bars.
  List<Widget> _buildRoute() {
    final List<_Segment> segments = _stage == TrackingStage.almost
        ? _routeAlmost
        : _routeFull;

    return segments
        .map<Widget>(
          (_Segment segment) => Positioned(
            left: segment.left,
            top: segment.top,
            width: segment.width,
            height: segment.height,
            child: const DecoratedBox(
              decoration: BoxDecoration(
                color: AppColors.ink,
                borderRadius: BorderRadius.all(Radius.circular(2)),
              ),
            ),
          ),
        )
        .toList();
  }

  /// Store / courier / pin markers (40 black circles with a 3px white
  /// ring), plus the courier halo, location dot and ETA bubble in the
  /// `almost` state.
  List<Widget> _buildMarkers() {
    if (_stage == TrackingStage.almost) {
      return <Widget>[
        _mapMarker(left: 70, top: 400, icon: 'bike'),
        // Location halo 110 (node 6:145) + 20 dot (node 6:146).
        const Positioned(
          left: 195,
          top: 245,
          width: 110,
          height: 110,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.liveDotHalo,
              shape: BoxShape.circle,
            ),
          ),
        ),
        const Positioned(
          left: 240,
          top: 290,
          width: 20,
          height: 20,
          child: DecoratedBox(
            decoration: BoxDecoration(
              color: AppColors.liveDot,
              shape: BoxShape.circle,
              border: Border.fromBorderSide(
                BorderSide(color: AppColors.surface, width: 3),
              ),
            ),
          ),
        ),
        _etaBubble(),
      ];
    }

    return _markersFull
        .map<Widget>(
          (_Marker marker) =>
              _mapMarker(left: marker.left, top: marker.top, icon: marker.icon),
        )
        .toList();
  }

  Positioned _mapMarker({
    required double left,
    required double top,
    required String icon,
  }) {
    return Positioned(
      left: left,
      top: top,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: const BoxDecoration(
          color: AppColors.ink,
          shape: BoxShape.circle,
          border: Border.fromBorderSide(
            BorderSide(color: AppColors.surface, width: 3),
          ),
        ),
        child: AppIcon(icon, size: 20, color: AppColors.surface),
      ),
    );
  }

  /// `1 min` bubble 59×29 r12 (node 6:147).
  Positioned _etaBubble() {
    return const Positioned(
      left: 150,
      top: 350,
      child: DecoratedBox(
        decoration: BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.all(Radius.circular(12)),
          boxShadow: AppShadows.mapBubble,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          child: Text(
            '1 min',
            style: TextStyle(
              fontSize: 14,
              height: 17 / 14,
              fontWeight: FontWeight.w600,
              color: AppColors.ink,
            ),
          ),
        ),
      ),
    );
  }

  // ---- Floating map controls ---------------------------------------------

  /// Close at x16, share at x266 and the 60-wide `Help` pill at x314
  /// (nodes 6:62 / 6:65 / 6:68).
  Widget _buildTopControls(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: <Widget>[
          _mapIconButton(
            icon: 'x',
            onTap: () => popOrFallback(context, '/orders'),
          ),
          const Spacer(),
          _mapIconButton(icon: 'share', onTap: () {}),
          const SizedBox(width: 8),
          GestureDetector(
            onTap: () => Navigator.of(context).pushNamed('/order-issue'),
            child: Container(
              height: 40,
              padding: const EdgeInsets.symmetric(horizontal: 14),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: AppColors.surface,
                borderRadius: BorderRadius.circular(20),
                boxShadow: AppShadows.mapControl,
              ),
              child: const Text('Help', style: helpLabel),
            ),
          ),
        ],
      ),
    );
  }

  /// 40×40 white circle over the map (nodes 6:62 / 6:65).
  Widget _mapIconButton({required String icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 40,
        height: 40,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.mapControl,
        ),
        child: AppIcon(icon, size: 18, color: AppColors.ink),
      ),
    );
  }

  /// Live-location toast 266×56 r14 (node 6:104) - `heading` state only.
  Widget _buildToast() {
    return Container(
      height: 56,
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.ink,
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const Expanded(
            child: Text(
              'Your live location will be shared with Ahmed to help them find you',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: toastText,
            ),
          ),
          const SizedBox(width: 10),
          GestureDetector(
            onTap: () => setState(() => _toastVisible = false),
            child: const SizedBox(
              width: 16,
              height: 16,
              child: Center(
                child: AppIcon('x', size: 16, color: AppColors.surface),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Recentre button 48×48 (node 6:108).
  Widget _buildLocateButton() {
    return GestureDetector(
      onTap: () {},
      child: Container(
        width: 48,
        height: 48,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surface,
          shape: BoxShape.circle,
          boxShadow: AppShadows.mapBubble,
        ),
        child: const AppIcon('locate', size: 22),
      ),
    );
  }

  // ---- Status sheet -------------------------------------------------------

  /// The bottom sheet from `6:17` / `6:112`. Tapping it advances the stage.
  Widget _buildSheet(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: _advanceStage,
      child: Container(
        width: 390,
        padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
        decoration: const BoxDecoration(
          color: AppColors.surface,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          boxShadow: AppShadows.sheetTop,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            // Handle 36×4 r2 centred (node `8004:80`).
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 36,
                  height: 4,
                  decoration: const BoxDecoration(
                    color: AppColors.hairline,
                    borderRadius: BorderRadius.all(Radius.circular(2)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Text(_title, style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 12),
            Text(_subtitle, style: statusSubtitle),
            const SizedBox(height: 12),
            _buildProgress(),
            const SizedBox(height: 12),
            Text(
              'Latest arrival by 6:25 PM',
              style: Theme.of(context).textTheme.bodySmall,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _buildCourierRow(),
            const SizedBox(height: 12),
            _buildMessageRow(),
          ],
        ),
      ),
    );
  }

  /// Four 85×4 r2 segments (node `8004:84`): three filled while heading,
  /// all four once almost here.
  Widget _buildProgress() {
    final int filled = _stage == TrackingStage.almost ? 4 : 3;

    return Row(
      children: <Widget>[
        for (int i = 0; i < 4; i++) ...<Widget>[
          if (i > 0) const SizedBox(width: 6),
          Container(
            width: 85,
            height: 4,
            decoration: BoxDecoration(
              color: i < filled ? AppColors.ink : AppColors.hairline,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
        ],
      ],
    );
  }

  /// Courier row: 48 initials avatar, name + rating, 48 black call button
  /// (node `8004:91`).
  Widget _buildCourierRow() {
    return Row(
      children: <Widget>[
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.surfaceAlt,
            shape: BoxShape.circle,
          ),
          child: Text('AK', style: Theme.of(context).textTheme.titleMedium),
        ),
        const SizedBox(width: 12),
        const Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text('Ahmed K. · 7NLR004', style: courierName),
              SizedBox(height: 2),
              Row(
                children: <Widget>[
                  AppIcon('star', size: 13),
                  SizedBox(width: 4),
                  Text('4.9 · Toyota Corolla', style: ratingText),
                ],
              ),
            ],
          ),
        ),
        Container(
          width: 48,
          height: 48,
          alignment: Alignment.center,
          decoration: const BoxDecoration(
            color: AppColors.ink,
            shape: BoxShape.circle,
          ),
          child: const AppIcon('phone', size: 22, color: AppColors.surface),
        ),
      ],
    );
  }

  /// Message + Tip pills 44 tall r22 (node `8004:103`).
  Widget _buildMessageRow() {
    return Row(
      children: <Widget>[
        Expanded(
          child: Container(
            height: 44,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: AppColors.surfaceAlt,
              borderRadius: BorderRadius.circular(22),
            ),
            child: const Row(
              children: <Widget>[
                AppIcon('msg', size: 18),
                SizedBox(width: 8),
                Text('Send a message', style: messageLabel),
              ],
            ),
          ),
        ),
        const SizedBox(width: 10),
        Container(
          width: 80,
          height: 44,
          padding: const EdgeInsets.symmetric(horizontal: 16),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(22),
          ),
          child: const Row(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              AppIcon('tip', size: 18),
              SizedBox(width: 6),
              Text('Tip', style: tipLabel),
            ],
          ),
        ),
      ],
    );
  }

  // ---- Live location sheet (C14.03) --------------------------------------

  /// `6:253`: 390×324 white sheet, r24 top, over a 50% black scrim.
  Widget _buildLiveSheet(BuildContext context) {
    return Container(
      width: 390,
      padding: const EdgeInsets.fromLTRB(16, 28, 16, 28),
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: <Widget>[
          const Text(
            'Live location sharing',
            textAlign: TextAlign.center,
            style: liveTitle,
          ),
          const SizedBox(height: 14),
          const Text(
            'This helps your courier find where to drop off your order. To protect your privacy, your location is only shared when the courier is 3 minutes away and stops when your order is delivered.',
            textAlign: TextAlign.center,
            style: liveBody,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Keep sharing for this order',
            height: 52,
            // H05 inventory: `Keep sharing for this order → C04.01 · Home`.
            // Wipe the stack: `route.isFirst` kept the root under the pushed
            // home, so Back landed on a duplicate /home (same fix as C13.01's
            // `Back to home`).
            onPressed: () => Navigator.of(
              context,
            ).pushNamedAndRemoveUntil('/home', (Route<dynamic> route) => false),
          ),
          const SizedBox(height: 14),
          _SheetSecondaryButton(
            label: 'Don’t share for this order',
            onTap: _closeLiveSheet,
          ),
          const SizedBox(height: 14),
          AppButton(
            label: 'Never share with courier',
            variant: AppButtonVariant.text,
            height: 52,
            onPressed: _closeLiveSheet,
          ),
        ],
      ),
    );
  }

  String get _title => switch (_stage) {
    TrackingStage.heading || TrackingStage.live => 'Heading your way…',
    TrackingStage.almost => 'Almost here!',
  };

  String get _subtitle => switch (_stage) {
    TrackingStage.heading || TrackingStage.live => 'Arriving at 6:15 PM',
    TrackingStage.almost => 'Time to meet Ahmed at the door',
  };

  // ---- Figma text styles that have no theme token -------------------------
  /// Sheet subtitle `App / Regular / 15`, `#6b6b6b` (node `8004:83`).
  static const TextStyle statusSubtitle = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  /// Courier name `App / Semi Bold / 17` (node `8004:95`).
  static const TextStyle courierName = TextStyle(
    fontSize: 17,
    height: 21 / 17,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Courier rating `App / Regular / 13`, `#6b6b6b` (node `8004:99`).
  static const TextStyle ratingText = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  /// `Send a message` label `App / Regular / 15`, `#6b6b6b` (node
  /// `8004:107`).
  static const TextStyle messageLabel = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );

  /// `Tip` label `App / Semi Bold / 15` (node `8004:112`).
  static const TextStyle tipLabel = TextStyle(
    fontSize: 15,
    height: 18 / 15,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// `Help` pill label `App / Semi Bold / 14` (node 6:69).
  static const TextStyle helpLabel = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Toast copy `App / Regular / 13`, white (node 6:105).
  static const TextStyle toastText = TextStyle(
    fontSize: 13,
    height: 16 / 13,
    fontWeight: FontWeight.w400,
    color: AppColors.surface,
  );

  /// Sheet title `App / Semi Bold / 17`, centred (node 6:254).
  static const TextStyle liveTitle = TextStyle(
    fontSize: 17,
    height: 21 / 17,
    fontWeight: FontWeight.w600,
    color: AppColors.ink,
  );

  /// Sheet copy `App / Regular / 14`, `#6b6b6b`, centred (node 6:255).
  static const TextStyle liveBody = TextStyle(
    fontSize: 14,
    height: 17 / 14,
    fontWeight: FontWeight.w400,
    color: AppColors.inkMuted,
  );
}

/// The `#f3f3f3` sheet button (node 6:258). `AppButton` has no variant with
/// that fill and a black 16/600 label, so this screen renders it directly.
class _SheetSecondaryButton extends StatelessWidget {
  const _SheetSecondaryButton({required this.label, required this.onTap});

  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: AppColors.surfaceAlt,
          borderRadius: BorderRadius.circular(AppRadius.button),
        ),
        child: Text(label, style: Theme.of(context).textTheme.titleMedium),
      ),
    );
  }
}

/// One 5px route bar (nodes 6:43-6:46 / 6:138-6:139).
class _Segment {
  const _Segment(this.left, this.top, this.width, this.height);

  final double left;
  final double top;
  final double width;
  final double height;
}

/// One 40×40 map marker (nodes 6:47 / 6:51 / 6:56).
class _Marker {
  const _Marker(this.left, this.top, this.icon);

  final double left;
  final double top;
  final String icon;
}

const List<double> _blockColumns = <double>[-10, 118, 246, 374];
const List<double> _blockRows = <double>[-20, 126, 272, 418, 564, 710];

/// Block fills column by column (nodes 6:19-6:42): `#e8e8e8` neutral,
/// `#dbe5f2` blue, `#dbeddb` green.
const List<List<Color>> _blockColors = <List<Color>>[
  <Color>[
    AppColors.mapBlock,
    AppColors.mapBlockBlue,
    AppColors.mapBlockGreen,
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlock,
  ],
  <Color>[
    AppColors.mapBlockBlue,
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlockGreen,
    AppColors.mapBlock,
    AppColors.mapBlockBlue,
  ],
  <Color>[
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlockBlue,
    AppColors.mapBlock,
  ],
  <Color>[
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlock,
    AppColors.mapBlockBlue,
    AppColors.mapBlock,
    AppColors.mapBlockGreen,
  ],
];

/// Route + markers for `6:17` / `6:197` (store -> courier -> pin).
const List<_Segment> _routeFull = <_Segment>[
  _Segment(53.5, 397.5, 149, 5),
  _Segment(197.5, 287.5, 5, 115),
  _Segment(197.5, 287.5, 135, 5),
  _Segment(327.5, 167.5, 5, 125),
];

const List<_Marker> _markersFull = <_Marker>[
  _Marker(36, 380, 'bag'),
  _Marker(180, 330, 'bike'),
  _Marker(310, 150, 'pin'),
];

/// Route for `6:112` (courier -> the live location dot).
const List<_Segment> _routeAlmost = <_Segment>[
  _Segment(87.5, 417.5, 165, 5),
  _Segment(247.5, 297.5, 5, 125),
];
