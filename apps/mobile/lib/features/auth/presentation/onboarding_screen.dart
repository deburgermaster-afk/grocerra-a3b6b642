import 'package:flutter/material.dart';

import '../../../core/config/app_config.dart';
import '../../../core/services/session_store.dart';
import '../../shell/presentation/home_shell.dart';
import 'sign_in_screen.dart';

/// Blueprint `Onboarding - Fresh Halal Groceries`.
///
/// Controls, exactly as wired:
///   * `Skip`    -> opens `Groceries & Catering Home`
///   * `Continue` -> opens `Sign In / Welcome Screen`
class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  static const String routeName = '/onboarding';

  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  final PageController _controller = PageController();
  int _page = 0;

  static const List<_Slide> _slides = <_Slide>[
    _Slide(
      icon: Icons.shopping_bag_outlined,
      title: 'Fresh halal groceries',
      body: 'Meat, rice, spices and more from stores near you.',
    ),
    _Slide(
      icon: Icons.storefront_outlined,
      title: 'Catering on demand',
      body: 'Request quotes from local caterers and track every order.',
    ),
    _Slide(
      icon: Icons.local_shipping_outlined,
      title: 'Delivered in real time',
      body: 'Follow your driver from store to doorstep.',
    ),
  ];

  Future<void> _finish() async {
    await SessionStore.setOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const HomeShell()),
    );
  }

  Future<void> _goToSignIn() async {
    await SessionStore.setOnboardingSeen();
    if (!mounted) return;
    Navigator.of(context).pushReplacement(
      MaterialPageRoute<void>(builder: (_) => const SignInScreen()),
    );
  }

  void _onContinue() {
    if (_page < _slides.length - 1) {
      _controller.nextPage(
        duration: const Duration(milliseconds: 320),
        curve: Curves.easeOutCubic,
      );
    } else {
      _goToSignIn();
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: SafeArea(
        child: Column(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  const Text(
                    AppConfig.appName,
                    style: TextStyle(
                      color: Color(0xFF111114),
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 4,
                    ),
                  ),
                  TextButton(
                    onPressed: _finish,
                    child: const Text(
                      'Skip',
                      style: TextStyle(
                        color: Color(0xFF7A7A85),
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: PageView.builder(
                controller: _controller,
                itemCount: _slides.length,
                onPageChanged: (int index) => setState(() => _page = index),
                itemBuilder: (BuildContext context, int index) {
                  final _Slide slide = _slides[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Container(
                          width: 104,
                          height: 104,
                          decoration: const BoxDecoration(
                            color: Color(0xFFF1F1F3),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(slide.icon, size: 44, color: Color(0xFF111114)),
                        ),
                        const SizedBox(height: 40),
                        Text(
                          slide.title,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF111114),
                            fontSize: 28,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.6,
                          ),
                        ),
                        const SizedBox(height: 14),
                        Text(
                          slide.body,
                          textAlign: TextAlign.center,
                          style: const TextStyle(
                            color: Color(0xFF8A8A93),
                            fontSize: 15,
                            height: 1.45,
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
            // Page dots.
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(_slides.length, (int index) {
                final bool active = index == _page;
                return AnimatedContainer(
                  duration: const Duration(milliseconds: 240),
                  margin: const EdgeInsets.symmetric(horizontal: 5),
                  width: active ? 9 : 7,
                  height: active ? 9 : 7,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: active ? const Color(0xFF111114) : const Color(0xFFD6D6DB),
                  ),
                );
              }),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 24),
              child: FilledButton(
                onPressed: _onContinue,
                child: Text(_page == _slides.length - 1 ? 'Get started' : 'Continue'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Slide {
  const _Slide({required this.icon, required this.title, required this.body});

  final IconData icon;
  final String title;
  final String body;
}
