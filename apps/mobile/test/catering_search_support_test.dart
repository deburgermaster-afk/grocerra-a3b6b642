import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:grocerra_customer/core/theme/app_theme.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_confirmation_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_deposit_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_orders_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_quote_review_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_request_details_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_routes.dart';
import 'package:grocerra_customer/features/catering/presentation/catering_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/custom_menu_screen.dart';
import 'package:grocerra_customer/features/catering/presentation/quote_event_screen.dart';
import 'package:grocerra_customer/features/home/presentation/home_screen.dart';
import 'package:grocerra_customer/features/search/presentation/filter_modal_sheet.dart';
import 'package:grocerra_customer/features/search/presentation/search_routes.dart';
import 'package:grocerra_customer/features/search/presentation/search_results_screen.dart';
import 'package:grocerra_customer/features/search/presentation/search_screen.dart';
import 'package:grocerra_customer/features/support/presentation/order_issue_choose_screen.dart';
import 'package:grocerra_customer/features/support/presentation/order_issue_details_screen.dart';
import 'package:grocerra_customer/features/support/presentation/order_issue_submitted_screen.dart';
import 'package:grocerra_customer/features/support/presentation/support_routes.dart';

Widget _wrap(Widget child) {
  return MaterialApp(
    theme: AppTheme.light(),
    home: child,
  );
}

void main() {
  group('Section D: Search Flow Tests', () {
    testWidgets('SearchScreen renders search input and categories', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const SearchScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Recent Searches'), findsOneWidget);
      expect(find.text('Explore by Category'), findsOneWidget);
      expect(find.text('Halal Meat'), findsOneWidget);
    });

    testWidgets('SearchResultsScreen displays products and tab toggle', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const SearchResultsScreen(initialQuery: 'Halal Lamb')));
      await tester.pumpAndSettle();

      expect(find.textContaining('Products'), findsWidgets);
      expect(find.textContaining('Stores'), findsWidgets);
      expect(find.text('100% Halal Certified'), findsWidgets);
    });

    testWidgets('FilterModalSheet opens and toggles halal switch', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(
        Builder(
          builder: (BuildContext context) {
            return ElevatedButton(
              onPressed: () => showModalBottomSheet<void>(
                context: context,
                isScrollControlled: true,
                builder: (_) => const FilterModalSheet(),
              ),
              child: const Text('Open Filter'),
            );
          },
        ),
      ));
      await tester.tap(find.text('Open Filter'));
      await tester.pumpAndSettle();

      expect(find.text('Filters & Sort'), findsOneWidget);
      expect(find.text('100% Halal Certified Only'), findsOneWidget);
    });
  });

  group('Section C: Catering Flow Tests', () {
    testWidgets('CateringScreen renders header and quote CTA', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const CateringScreen(),
          ...cateringRoutes,
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('Feeding a crowd?'), findsOneWidget);
      expect(find.text('Request a quote'), findsOneWidget);
    });

    testWidgets('CateringScreen displays How it works and popular events', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Feeding a crowd?'), findsOneWidget);
      expect(find.text('How it works'), findsOneWidget);
      expect(find.text('Tell us about your event'), findsOneWidget);
      expect(find.text('Popular for events'), findsOneWidget);
      expect(find.text('Biryani'), findsOneWidget);
    });

    testWidgets('QuoteEventScreen renders planning chips and Next button', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const QuoteEventScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Request a quote'), findsOneWidget);
      expect(find.text('What are you planning?'), findsOneWidget);
      expect(find.text('Wedding'), findsOneWidget);
      expect(find.text('Event date'), findsOneWidget);
      expect(find.text('Next'), findsOneWidget);
    });

    testWidgets('CustomMenuScreen renders food options and halal notice', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CustomMenuScreen()));
      await tester.pumpAndSettle();

      expect(find.text('What would you like?'), findsOneWidget);
      expect(find.text('Biryani'), findsOneWidget);
      expect(find.text('Dietary needs'), findsOneWidget);
      expect(find.text('All food is halal.'), findsOneWidget);
      expect(find.text('Send request'), findsOneWidget);
    });

    testWidgets('CateringConfirmationScreen shows quote request sent status', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringConfirmationScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Request sent'), findsOneWidget);
      expect(find.text("You'll get quotes within 24 hours."), findsOneWidget);
      expect(find.text('#CR-20418'), findsOneWidget);
      expect(find.text('View request'), findsOneWidget);
      expect(find.text('Back to home'), findsOneWidget);
    });

    testWidgets('CateringQuoteReviewScreen displays quote details and accept button', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringQuoteReviewScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Your catering quote'), findsOneWidget);
      expect(find.text('Madina Halal Catering'), findsOneWidget);
      expect(find.text('Goat biryani'), findsOneWidget);
      expect(find.text('\$1,240'), findsOneWidget);
      expect(find.text('Accept quote'), findsOneWidget);
    });

    testWidgets('CateringDepositScreen displays order summary and Apple Pay', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringDepositScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Order summary'), findsOneWidget);
      expect(find.text('Madina Halal Catering'), findsOneWidget);
      expect(find.text('Apple Pay'), findsOneWidget);
      expect(find.text('Pay deposit'), findsOneWidget);
    });

    testWidgets('CateringRequestDetailsScreen renders live order tracking', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringRequestDetailsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Catering Request Details'), findsOneWidget);
      expect(find.text('Request #CR-20418'), findsOneWidget);
      expect(find.text('Request sent'), findsOneWidget);
      expect(find.text('Quote ready for review'), findsOneWidget);
    });

    testWidgets('CateringConfirmationScreen navigates to View Request screen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const CateringConfirmationScreen(),
          ...cateringRoutes,
        },
      ));
      await tester.pumpAndSettle();

      expect(find.text('View request'), findsOneWidget);
      await tester.tap(find.text('View request'));
      await tester.pumpAndSettle();

      expect(find.text('Catering Request Details'), findsOneWidget);
    });

    testWidgets('CateringOrdersScreen renders upcoming and past orders', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const CateringOrdersScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Catering orders'), findsOneWidget);
      expect(find.text('Upcoming'), findsOneWidget);
      expect(find.text('Past'), findsOneWidget);
      expect(find.text('Wedding · 80 guests'), findsOneWidget);
      expect(find.text('Confirmed'), findsOneWidget);
    });

    testWidgets('CateringScreen header orders icon button navigates to CateringOrdersScreen', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(
        theme: AppTheme.light(),
        routes: <String, WidgetBuilder>{
          '/': (BuildContext context) => const CateringScreen(),
          ...cateringRoutes,
        },
      ));
      await tester.pumpAndSettle();

      final Finder ordersBtn = find.byTooltip('Catering Requests');
      expect(ordersBtn, findsOneWidget);
      await tester.tap(ordersBtn);
      await tester.pumpAndSettle();

      expect(find.text('Catering orders'), findsOneWidget);
    });
  });

  group('Section E: Support & Order Issue Flow Tests', () {
    testWidgets('OrderIssueChooseScreen shows issue categories', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const OrderIssueChooseScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Order Help & Refund'), findsOneWidget);
      expect(find.text('Missing Item from Delivery Bag'), findsOneWidget);
      expect(find.text('Australian Consumer Law Guarantee'), findsOneWidget);
    });

    testWidgets('OrderIssueDetailsScreen allows description and method', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const OrderIssueDetailsScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Step 2 · Claim Details'), findsOneWidget);
      expect(find.text('1. Which items had this issue?'), findsOneWidget);
      expect(find.text('Submit Claim & Request Refund'), findsOneWidget);
    });

    testWidgets('OrderIssueSubmittedScreen shows resolution SLA', (WidgetTester tester) async {
      await tester.pumpWidget(_wrap(const OrderIssueSubmittedScreen()));
      await tester.pumpAndSettle();

      expect(find.text('Claim Submitted!'), findsOneWidget);
      expect(find.text('Back to Home'), findsOneWidget);
    });
  });

  group('Route Registry Tests', () {
    test('All sections have registered routes', () {
      expect(cateringRoutes.isNotEmpty, isTrue);
      expect(searchRoutes.isNotEmpty, isTrue);
      expect(supportRoutes.isNotEmpty, isTrue);
    });
  });
}
