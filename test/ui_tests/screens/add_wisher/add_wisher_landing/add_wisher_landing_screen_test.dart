import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_buttons.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_description.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingScreen', () {
    late AddWisherLandingViewModel viewModel;
    late StatusOverlayController loadingController;
    late GoRouter router;

    setUp(() {
      viewModel = _createViewModel();
      loadingController = StatusOverlayController();
      router = GoRouter(
        initialLocation: '/add-wisher',
        routes: [
          GoRoute(
            path: '/add-wisher',
            builder: (context, state) =>
                AddWisherLandingScreen(viewModel: viewModel),
            routes: [
              GoRoute(
                path: 'details',
                name: Routes.addWisherDetails.name,
                builder: (context, state) =>
                    const Scaffold(body: Text('Manual Add Wisher')),
              ),
            ],
          ),
        ],
      );
    });

    Widget createTestWidget() =>
        ChangeNotifierProvider<StatusOverlayController>.value(
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
        final customViewModel = _createViewModel();
        final customRouter = GoRouter(
          initialLocation: '/add-wisher',
          routes: [
            GoRoute(
              path: '/add-wisher',
              builder: (context, state) =>
                  AddWisherLandingScreen(viewModel: customViewModel),
              routes: [
                GoRoute(
                  path: 'details',
                  name: Routes.addWisherDetails.name,
                  builder: (context, state) =>
                      const Scaffold(body: Text('Manual Add Wisher')),
                ),
              ],
            ),
          ],
        );

        await tester.pumpWidget(
          ChangeNotifierProvider<StatusOverlayController>.value(
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

      testWidgets('tapping Add Manually still routes to details', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createTestWidget());
        await TestHelpers.pumpAndSettle(tester);

        await TestHelpers.tapAndSettle(tester, find.text('Add Manually'));

        expect(find.text('Manual Add Wisher'), findsOneWidget);
      });

      testWidgets(
        'tapping Add From Contacts stays neutral when picker is cancelled',
        (WidgetTester tester) async {
          await tester.pumpWidget(createTestWidget());
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(
            tester,
            find.text('Add From Contacts'),
          );

          expect(loadingController.isIdle, isTrue);
          expect(find.byType(AddWisherLandingScreen), findsOneWidget);
        },
      );
    });
  });
}

AddWisherLandingViewModel _createViewModel() => AddWisherLandingViewModel(
  contactAccess: _ScreenTestContactAccess(),
  contactBatchImporter: _ScreenTestBatchImporter(),
);

class _ScreenTestContactAccess extends AddWisherContactAccess {
  _ScreenTestContactAccess()
    : super(
        requestPermission: () async => true,
        pickContactId: () async => null,
        loadContact: (_) async => null,
      );

  @override
  Future<AddWisherContactAccessResult> selectContacts() async =>
      const AddWisherContactAccessCancelled();
}

class _ScreenTestBatchImporter extends AddWisherContactBatchImporter {
  _ScreenTestBatchImporter()
    : super(
        authRepository: MockAuthRepository(),
        imageRepository: MockImageRepository(),
        wisherRepository: MockWisherRepository(),
      );

  @override
  Future<AddWisherContactImportResult> importDrafts(
    List<AddWisherContactImportDraft> drafts,
  ) async => AddWisherContactImportResult(entries: const []);
}
