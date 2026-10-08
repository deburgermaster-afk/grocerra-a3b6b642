import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../core/services/session_store.dart';
import 'kit/auth_theme.dart';
import 'kit/auth_widgets.dart';
import 'kit/motion.dart';
import 'kit/scenes.dart';
import 'welcome_screen.dart';

/// Three-slide introduction (reference: "Build apps without writing any
/// code" onboarding). Illustrated scene, headline, page dots, Continue, and
/// Skip in the corner. The scene's pieces sit at different depths, so a
/// swipe slides them past each other.
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _Slide {
  const _Slide(this.title, this.scene);

  final String title;
  final List<ScenePiece> Function() scene;
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static final List<_Slide> _slides = <_Slide>[
    const _Slide('Fresh groceries from stores you trust', Scenes.groceries),
    const _Slide('Catering for every gathering, big or small', Scenes.catering),
    const _Slide('Track every order live, from store to door', Scenes.tracking),
  ];

  bool get _last => _page == _slides.length - 1;

  Future<void> _finish() async {
    await SessionStore.setOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context)
        .pushReplacement(FadeThroughRoute<void>(page: const WelcomeScreen()));
  }

  void _continue() {
    if (_last) {
      _finish();
      return;
    }
    _controller.nextPage(
      duration: const Duration(milliseconds: 620),
      curve: Curves.easeInOutCubic,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);

    return Scaffold(
      backgroundColor: p.background,
      body: Stack(
        children: <Widget>[
          const Positioned.fill(child: AuthBackdrop()),
          SafeArea(
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 52,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Row(
                      children: <Widget>[
                        const ThemeToggle(),
                        const Spacer(),
                        Pressable(
                          semanticLabel: 'Skip',
                          pressedScale: 0.92,
                          onTap: _finish,
                          child: Padding(
                            padding: const EdgeInsets.all(8),
                            child: Row(
                              children: <Widget>[
                                Text('Skip', style: AuthType.small(p.ink)),
                                const SizedBox(width: 2),
                                Icon(
                                  Icons.chevron_right_rounded,
                                  size: 20,
                                  color: p.ink,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: PageView.builder(
                    controller: _controller,
                    itemCount: _slides.length,
                    onPageChanged: (int i) {
                      HapticFeedback.selectionClick();
                      setState(() => _page = i);
                    },
                    itemBuilder: (BuildContext context, int i) =>
                        AnimatedBuilder(
                          animation: _controller,
                          builder: (BuildContext context, Widget? _) {
                            final double page =
                                _controller.hasClients &&
                                    _controller.position.haveDimensions
                                ? _controller.page!
                                : _page.toDouble();
                            return _SlideView(
                              slide: _slides[i],
                              offset: i - page,
                            );
                          },
                        ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(24, 0, 24, 20),
                  child: Column(
                    children: <Widget>[
                      Align(
                        alignment: Alignment.centerLeft,
                        child: _Dots(count: _slides.length, index: _page),
                      ),
                      const SizedBox(height: 28),
                      AuthButton(
                        label: _last ? 'Get started' : 'Continue',
                        onPressed: _continue,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SlideView extends StatelessWidget {
  const _SlideView({required this.slide, required this.offset});

  final _Slide slide;

  /// Distance from the settled position in pages (-1..1 while visible).
  final double offset;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    final double away = offset.abs().clamp(0.0, 1.0);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 12),
              child: Scene(pieces: slide.scene(), parallax: offset),
            ),
          ),
          Opacity(
            opacity: 1 - away * 0.8,
            child: Transform.translate(
              offset: Offset(offset * 60, 0),
              child: Text(slide.title, style: AuthType.hero(p.ink)),
            ),
          ),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Dots extends StatelessWidget {
  const _Dots({required this.count, required this.index});

  final int count;
  final int index;

  @override
  Widget build(BuildContext context) {
    final AuthPalette p = AuthPalette.of(context);
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        for (int i = 0; i < count; i++)
          AnimatedContainer(
            duration: const Duration(milliseconds: 420),
            curve: Curves.easeOutBack,
            margin: const EdgeInsets.only(right: 6),
            width: i == index ? 22 : 6,
            height: 6,
            decoration: BoxDecoration(
              color: i == index ? p.ink : p.faint,
              borderRadius: BorderRadius.circular(3),
            ),
          ),
      ],
    );
  }
}
