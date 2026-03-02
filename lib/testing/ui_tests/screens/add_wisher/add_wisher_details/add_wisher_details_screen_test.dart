import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/components/add_wisher_details_button.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/components/add_wisher_details_header.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../../../test_helpers/helpers/test_helpers.dart';
import '../../../../../test_helpers/mocks/repositories/mock_auth_repository.dart';
import '../../../../../test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/utils/loading_controller.dart';

void main() {
  group('AddWisherDetailsScreen', () {
    late AddWisherDetailsViewModel viewModel;
    late LoadingController loadingController;
    late GoRouter router;

    setUp(() {
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: MockWisherRepository(),
        authRepository: MockAuthRepository(),
      );
      loadingController = LoadingController();
      router = GoRouter(
        initialLocation: '/add-wisher/manual',
        routes: [
          GoRoute(
            path: '/add-wisher/manual',
            builder: (context, state) =>
                AddWisherDetailsScreen(viewModel: viewModel),
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
      testWidgets('renders screen correctly', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherDetailsScreen);
      });

      testWidgets('renders Screen component', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Screen), findsOneWidget);
      });

      testWidgets('renders AppMenuBar', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppMenuBar), findsOneWidget);
      });

      testWidgets('renders AddWisherDetailsHeader', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AddWisherDetailsHeader), findsOneWidget);
      });

      testWidgets('renders AddWisherDetailsButton', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AddWisherDetailsButton), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('screen has correct main axis alignment', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final screenFinder = find.byType(Screen);
        final screenWidget = tester.widget<Screen>(screenFinder);
        expect(screenWidget.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });

      testWidgets('screen has correct cross axis alignment', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final screenFinder = find.byType(Screen);
        final screenWidget = tester.widget<Screen>(screenFinder);
        expect(screenWidget.crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      testWidgets('passes viewModel to header', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final headerFinder = find.byType(AddWisherDetailsHeader);
        final headerWidget = tester.widget<AddWisherDetailsHeader>(
          headerFinder,
        );
        expect(headerWidget.viewModel, viewModel);
      });

      testWidgets('passes viewModel to button', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final buttonFinder = find.byType(AddWisherDetailsButton);
        final buttonWidget = tester.widget<AddWisherDetailsButton>(
          buttonFinder,
        );
        expect(buttonWidget.viewModel, viewModel);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('screen renders with router configuration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        // Verify the screen renders correctly with router
        expect(find.byType(AddWisherDetailsScreen), findsOneWidget);
      });
    });
  });
}
