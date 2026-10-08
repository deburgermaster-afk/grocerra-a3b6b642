import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocerra_customer/app.dart';
import 'package:grocerra_customer/core/services/session_manager.dart';
import 'package:grocerra_customer/core/widgets/glass_tab_bar.dart';
import 'package:grocerra_customer/features/auth/presentation/auth_success_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/kit/auth_theme.dart';
import 'package:grocerra_customer/features/auth/presentation/kit/motion.dart';
import 'package:grocerra_customer/features/auth/presentation/new_password_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/onboarding_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/sign_in_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/sign_up_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/splash_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/verify_code_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/welcome_screen.dart';
import 'package:grocerra_customer/features/search/presentation/search_overlay.dart';

/// These tests run without Supabase configuration, i.e. the demo build:
/// every auth call short-circuits to success, so the whole flow is walkable.
Future<void> pumpPastSplash(WidgetTester tester) async {
  tester.view.physicalSize = const Size(390, 844);
  tester.view.devicePixelRatio = 1;
  addTearDown(tester.view.reset);

  await tester.pumpWidget(const GrocerraApp());
  await tester.pump(const Duration(milliseconds: 1700));
  await tester.pumpAndSettle();
}

Future<void> tapText(WidgetTester tester, String text) async {
  final Finder f = find.text(text).last;
  await tester.ensureVisible(f);
  await tester.pumpAndSettle();
  await tester.tap(f);
  await tester.pumpAndSettle();
}

Future<void> pumpToWelcome(WidgetTester tester) async {
  await pumpPastSplash(tester);
  await tapText(tester, 'Skip');
}

Future<void> pumpToSignIn(WidgetTester tester) async {
  await pumpToWelcome(tester);
  await tapText(tester, 'Sign in');
}

void main() {
  setUpAll(() async {
    // Measure with the real Geist so layout overflows are real ones.
    final FontLoader geist = FontLoader('Geist')
      ..addFont(rootBundle.load('assets/fonts/Geist-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Geist-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Geist-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Geist-Bold.ttf'));
    await geist.load();
    final FontLoader inter = FontLoader('Inter')
      ..addFont(rootBundle.load('assets/fonts/Inter-Regular.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Medium.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-SemiBold.ttf'))
      ..addFont(rootBundle.load('assets/fonts/Inter-Bold.ttf'));
    await inter.load();
  });

  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
    AuthThemeMode.notifier.value = ThemeMode.dark;
    // Floating art and the blinking caret loop forever; switch them off so
    // pumpAndSettle can settle.
    Motion.ambient = false;
  });

  testWidgets('app boots into the splash wordmark', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const GrocerraApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.bySemanticsLabel('GROCERRA'), findsOneWidget);

    await tester.pump(const Duration(milliseconds: 1700));
    await tester.pumpAndSettle();
  });

  testWidgets('first launch shows onboarding with Continue and Skip', (
    WidgetTester tester,
  ) async {
    await pumpPastSplash(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(
      find.text('Fresh halal groceries from stores you trust'),
      findsOneWidget,
    );
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Continue walks the slides, Get started opens Welcome', (
    WidgetTester tester,
  ) async {
    await pumpPastSplash(tester);

    await tapText(tester, 'Continue');
    expect(
      find.text('Catering for every gathering, big or small'),
      findsOneWidget,
    );
    await tapText(tester, 'Continue');
    expect(
      find.text('Track every order live, from store to door'),
      findsOneWidget,
    );

    await tapText(tester, 'Get started');
    expect(find.byType(WelcomeScreen), findsOneWidget);
    expect(find.text('Create account'), findsOneWidget);
    expect(find.text('Sign in'), findsOneWidget);
  });

  testWidgets('onboarding is skipped once seen', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues(<String, Object>{
      'grocerra.onboarding_seen': true,
    });
    await pumpPastSplash(tester);

    expect(find.byType(WelcomeScreen), findsOneWidget);
  });

  testWidgets('Sign in validates empty credentials', (
    WidgetTester tester,
  ) async {
    await pumpToSignIn(tester);
    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Hey,\nWelcome\nBack'), findsOneWidget);

    await tapText(tester, 'Sign in');

    expect(find.text('Enter a valid email address'), findsOneWidget);
    expect(find.text('Enter your password'), findsOneWidget);
  });

  testWidgets('Sign up flags mismatched passwords and rates strength', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    await tapText(tester, 'Create account');
    expect(find.byType(SignUpScreen), findsOneWidget);

    final Finder fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ayesha Khan');
    await tester.enterText(fields.at(1), 'ayesha@example.com');
    await tester.enterText(fields.at(2), 'Correct-Horse-9');
    await tester.enterText(fields.at(3), 'something-else');
    await tester.pumpAndSettle();
    expect(find.text('Strong'), findsOneWidget);

    await tapText(tester, 'Sign up');
    expect(find.text("Passwords don't match"), findsOneWidget);
  });

  testWidgets('new account: sign up, verify code, success', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    await tapText(tester, 'Create account');

    final Finder fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Ayesha Khan');
    await tester.enterText(fields.at(1), 'ayesha@example.com');
    await tester.enterText(fields.at(2), 'Correct-Horse-9');
    await tester.enterText(fields.at(3), 'Correct-Horse-9');
    await tapText(tester, 'Sign up');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(VerifyCodeScreen), findsOneWidget);
    expect(find.textContaining('6-digit code'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '123456');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();

    expect(find.byType(AuthSuccessScreen), findsOneWidget);
    expect(find.text('Email verified'), findsOneWidget);
  });

  testWidgets('reset: forgot password, code, new password', (
    WidgetTester tester,
  ) async {
    await pumpToSignIn(tester);
    await tapText(tester, 'Forgot password?');
    expect(find.text('Forgot\nPassword?'), findsOneWidget);

    await tester.enterText(find.byType(TextField).first, 'ayesha@example.com');
    await tapText(tester, 'Send code');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Check\nYour Email'), findsOneWidget);

    await tester.enterText(find.byType(TextField).last, '654321');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.byType(NewPasswordScreen), findsOneWidget);

    final Finder fields = find.byType(TextField);
    await tester.enterText(fields.at(0), 'Brand-New-Pass-1');
    await tester.enterText(fields.at(1), 'Brand-New-Pass-1');
    await tapText(tester, 'Save');
    await tester.pump(const Duration(seconds: 1));
    await tester.pumpAndSettle();
    expect(find.text('Password updated'), findsOneWidget);
  });

  testWidgets('theme toggle flips the flow between dark and light', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    Brightness brightness() =>
        Theme.of(tester.element(find.text('Create account'))).brightness;
    expect(brightness(), Brightness.dark);

    await tester.tap(find.bySemanticsLabel('Switch to light mode'));
    await tester.pumpAndSettle();
    expect(brightness(), Brightness.light);
    expect(AuthThemeMode.notifier.value, ThemeMode.light);
  });

  testWidgets('home filters narrow the store list', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    await tapText(tester, 'Explore as guest');
    expect(find.text('Featured on Grocerra'), findsOneWidget);
    final Finder feed = find
        .byWidgetPredicate(
          (Widget w) =>
              w is Scrollable && w.axisDirection == AxisDirection.down,
        )
        .first;
    await tester.scrollUntilVisible(
      find.text('All stores (7)'),
      300,
      scrollable: feed,
    );
    expect(find.text('All stores (7)'), findsOneWidget);

    // Back to the top, then keep only stores with an offer running.
    await tester.drag(feed, const Offset(0, 3000));
    await tester.pumpAndSettle();
    await tester.tap(find.text('Offers'));
    await tester.pumpAndSettle();
    await tester.scrollUntilVisible(
      find.text('All stores (4)'),
      300,
      scrollable: feed,
    );
    expect(find.text('All stores (4)'), findsOneWidget);
  });

  testWidgets('bar has three tabs; search stretches then rises full page', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    await tapText(tester, 'Explore as guest');
    expect(find.byType(GlassTabBar), findsOneWidget);
    expect(find.bySemanticsLabel('Browse'), findsNothing);
    expect(find.bySemanticsLabel('Orders'), findsNothing);

    await tester.tap(find.bySemanticsLabel('Catering'));
    await tester.pumpAndSettle();

    await tester.tap(find.byType(SearchPill));
    await tester.pump(GlassTabBar.expand);
    await tester.pumpAndSettle();
    expect(find.byType(SearchOverlay), findsOneWidget);
    expect(find.text('Recent searches'), findsOneWidget);
    expect(find.text('Top categories'), findsOneWidget);

    await tester.enterText(
      find.descendant(
        of: find.byType(SearchOverlay),
        matching: find.byType(TextField),
      ),
      'basmati',
    );
    await tester.pumpAndSettle();
    expect(find.text('Items (1)'), findsOneWidget);

    await tester.tap(find.byTooltip('Close search'));
    await tester.pumpAndSettle();
    expect(find.byType(SearchOverlay), findsNothing);
    expect(find.bySemanticsLabel('Home'), findsOneWidget);
  });

  test('no cached session means signed out at launch', () async {
    expect(await SessionManager.restore(), isFalse);
    expect(SessionManager.account, isNull);
  });

  testWidgets('profile shows a guest with a way to sign in', (
    WidgetTester tester,
  ) async {
    await pumpToWelcome(tester);
    await tapText(tester, 'Explore as guest');
    await tester.tap(find.bySemanticsLabel('Profile'));
    await tester.pumpAndSettle();

    expect(find.text('Browsing as guest'), findsOneWidget);
    expect(find.text('Sign out'), findsNothing);
    await tester.tap(find.widgetWithText(FilledButton, 'Sign in'));
    await tester.pumpAndSettle();
    expect(find.byType(WelcomeScreen), findsOneWidget);
  });
}
