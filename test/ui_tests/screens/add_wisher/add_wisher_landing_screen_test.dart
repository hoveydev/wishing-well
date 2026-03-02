import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_buttons.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_description.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingScreen', () {
    late AddWisherLandingViewModel viewModel;
    late LoadingController loadingController;
    late GoRouter router;

    setUp(() {
      viewModel = AddWisherLandingViewModel();
      loadingController = LoadingController();
      router = GoRouter(
        initialLocation: '/add-wisher',
        routes: [
          GoRoute(
            path: '/add-wisher',
            builder: (context, state) =>
                AddWisherLandingScreen(viewModel: viewModel),
          ),
          GoRoute(
            path: '/add-wisher/manual',
            builder: (context, state) =>
                const Scaffold(body: Text('Manual Add Wisher')),
          ),
        ],
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    Widget createTestWidget() =>
        ChangeNotifierProvider<LoadingController>.value(
          value: loadingController,
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: router,
          ),
        );

    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
        TestHelpers.expectWidgetOnce(AddWisherLandingHeader);
        TestHelpers.expectWidgetOnce(AddWisherLandingDescription);
        TestHelpers.expectWidgetOnce(AddWisherLandingButtons);
        TestHelpers.expectTextOnce('Add a Wisher');
        TestHelpers.expectTextOnce('Add From Contacts');
        TestHelpers.expectTextOnce('Add Manually');
      });

      testWidgets('renders description text content', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(
          find.textContaining('A Wisher is someone special'),
          findsOneWidget,
        );
      });

      testWidgets('Add From Contacts button is present', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Add From Contacts'), findsOneWidget);
      });

      testWidgets('Add Manually button is present', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Add Manually'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('can be instantiated with default ViewModel', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
      });

      testWidgets('can be instantiated with custom ViewModel', (
        WidgetTester tester,
      ) async {
        final customViewModel = AddWisherLandingViewModel();
        final customRouter = GoRouter(
          initialLocation: '/add-wisher',
          routes: [
            GoRoute(
              path: '/add-wisher',
              builder: (context, state) =>
                  AddWisherLandingScreen(viewModel: customViewModel),
            ),
            GoRoute(
              path: '/add-wisher/manual',
              builder: (context, state) =>
                  const Scaffold(body: Text('Manual Add Wisher')),
            ),
          ],
        );

        await tester.pumpWidget(
          ChangeNotifierProvider<LoadingController>.value(
            value: loadingController,
            child: MaterialApp.router(
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              routerConfig: customRouter,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingScreen);
        customViewModel.dispose();
      });

      testWidgets('handles ViewModel disposal correctly', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Should render without errors
        expect(tester.takeException(), isNull);

        // Dispose should not cause issues
        await tester.pumpWidget(Container());
      });
    });
  });
}
