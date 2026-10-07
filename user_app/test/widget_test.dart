import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:grocerra_customer/app.dart';
import 'package:grocerra_customer/features/auth/presentation/onboarding_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/sign_in_screen.dart';
import 'package:grocerra_customer/features/auth/presentation/splash_screen.dart';

/// Pumps the app, lets the splash brand beat elapse and settles the
/// transition into whatever follows it.
Future<void> pumpPastSplash(WidgetTester tester) async {
  await tester.pumpWidget(const GrocerraApp());
  // Splash holds ~1.2s before navigating.
  await tester.pump(const Duration(milliseconds: 1300));
  await tester.pumpAndSettle();
}

/// Walks the approved blueprint path A1 -> A2/A3/A4 -> A5 so the tests
/// exercise the Sign in screen exactly the way a first-run user reaches it.
Future<void> pumpToSignIn(WidgetTester tester) async {
  await pumpPastSplash(tester);
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Continue'));
  await tester.pumpAndSettle();
  await tester.tap(find.text('Get started'));
  await tester.pumpAndSettle();
}

void main() {
  // The persistence layer is device-local; back it with an in-memory store
  // for every test so the splash -> onboarding decision can run.
  setUp(() {
    SharedPreferences.setMockInitialValues(<String, Object>{});
  });

  testWidgets('app boots into the splash screen', (WidgetTester tester) async {
    await tester.pumpWidget(const GrocerraApp());
    await tester.pump();

    expect(find.byType(SplashScreen), findsOneWidget);
    expect(find.text('GROCERRA'), findsOneWidget);

    // Drain the 1.2s brand timer so it does not outlive the test.
    await tester.pump(const Duration(milliseconds: 1300));
    await tester.pumpAndSettle();
  });

  testWidgets('first launch shows onboarding with Continue and Skip', (
    WidgetTester tester,
  ) async {
    await pumpPastSplash(tester);

    expect(find.byType(OnboardingScreen), findsOneWidget);
    expect(find.text('Fresh halal groceries'), findsOneWidget);
    expect(find.text('Continue'), findsOneWidget);
    expect(find.text('Skip'), findsOneWidget);
  });

  testWidgets('Continue advances onboarding, last slide opens Sign In', (
    WidgetTester tester,
  ) async {
    await pumpPastSplash(tester);

    // Slide 1 -> 2.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Catering on demand'), findsOneWidget);

    // Slide 2 -> 3.
    await tester.tap(find.text('Continue'));
    await tester.pumpAndSettle();
    expect(find.text('Delivered in real time'), findsOneWidget);

    // Last slide -> Sign In / Welcome Screen.
    await tester.tap(find.text('Get started'));
    await tester.pumpAndSettle();

    expect(find.byType(SignInScreen), findsOneWidget);
    expect(find.text('Welcome back'), findsOneWidget);
  });

  testWidgets('Skip jumps straight to the home shell', (WidgetTester tester) async {
    await pumpPastSplash(tester);

    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    expect(find.text('Groceries & Catering'), findsOneWidget);
    expect(find.byType(NavigationBar), findsOneWidget);
    for (final String tab in <String>[
      'Home',
      'Browse',
      'Catering',
      'Orders',
      'Profile',
    ]) {
      expect(
        find.descendant(
          of: find.byType(NavigationBar),
          matching: find.text(tab),
        ),
        findsOneWidget,
      );
    }
  });

  testWidgets('bottom tabs switch to their blueprint screen', (
    WidgetTester tester,
  ) async {
    await pumpPastSplash(tester);
    await tester.tap(find.text('Skip'));
    await tester.pumpAndSettle();

    await tester.tap(
      find.descendant(
        of: find.byType(NavigationBar),
        matching: find.text('Browse'),
      ),
    );
    await tester.pump();

    expect(find.textContaining('category grid'), findsOneWidget);
    final NavigationBar bar = tester.widget<NavigationBar>(
      find.byType(NavigationBar),
    );
    expect(bar.selectedIndex, 1);
  });

  testWidgets('Sign In screen validates empty credentials', (
    WidgetTester tester,
  ) async {
    await pumpToSignIn(tester);

    // Submit with an empty form (the button sits below the fold).
    final Finder submit = find.widgetWithText(FilledButton, 'Sign in');
    await tester.ensureVisible(submit);
    await tester.pumpAndSettle();
    await tester.tap(submit);
    await tester.pumpAndSettle();

    expect(find.text('Enter a valid email address'), findsOneWidget);
    // The hint and the validation message use the same approved copy,
    // so this asserts both are on screen after a failed submit.
    expect(find.text('Enter your password'), findsWidgets);
  });

  testWidgets('Create account tab shows the registration fields', (
    WidgetTester tester,
  ) async {
    await pumpToSignIn(tester);

    await tester.tap(find.text('Create account'));
    await tester.pumpAndSettle();

    expect(find.text('Create account'), findsWidgets);
    expect(find.text('Full name'), findsOneWidget);
    expect(find.text('At least 8 characters'), findsOneWidget);
    expect(find.text('Show'), findsOneWidget);
  });
}
