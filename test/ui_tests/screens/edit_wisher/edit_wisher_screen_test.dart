import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/edit_wisher/components/edit_wisher_button.dart';
import 'package:wishing_well/features/edit_wisher/components/edit_wisher_header.dart';
import 'package:wishing_well/features/edit_wisher/edit_wisher_screen.dart';
import 'package:wishing_well/features/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

void main() {
  group('EditWisherScreen', () {
    late EditWisherViewModel viewModel;
    late LoadingController loadingController;
    late GoRouter router;

    setUp(() {
      viewModel = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );
      loadingController = LoadingController();
      router = GoRouter(
        initialLocation: '/edit-wisher/1',
        routes: [
          GoRoute(
            path: '/edit-wisher/1',
            builder: (context, state) => EditWisherScreen(viewModel: viewModel),
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

        expect(find.byType(EditWisherScreen), findsOneWidget);
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

      testWidgets('renders EditWisherHeader', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherHeader), findsOneWidget);
      });

      testWidgets('renders EditWisherButton', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherButton), findsOneWidget);
      });

      testWidgets('renders Save Changes button label', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Save Changes'), findsOneWidget);
      });

      testWidgets('renders screen header text', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Edit Wisher Details'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('screen has spaceBetween main axis alignment', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final screenWidget = tester.widget<Screen>(find.byType(Screen));
        expect(screenWidget.mainAxisAlignment, MainAxisAlignment.spaceBetween);
      });

      testWidgets('screen has stretch cross axis alignment', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final screenWidget = tester.widget<Screen>(find.byType(Screen));
        expect(screenWidget.crossAxisAlignment, CrossAxisAlignment.stretch);
      });

      testWidgets('passes viewModel to header', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final headerWidget = tester.widget<EditWisherHeader>(
          find.byType(EditWisherHeader),
        );
        expect(headerWidget.viewModel, viewModel);
      });

      testWidgets('passes viewModel to button', (WidgetTester tester) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        final buttonWidget = tester.widget<EditWisherButton>(
          find.byType(EditWisherButton),
        );
        expect(buttonWidget.viewModel, viewModel);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('renders with router configuration', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherScreen), findsOneWidget);
      });
    });
  });
}
