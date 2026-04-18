import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_button.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  group('EditWisherButton', () {
    late EditWisherViewModel viewModel;

    setUp(() {
      viewModel = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders save changes button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(EditWisherButton), findsOneWidget);
      });

      testWidgets('renders AppButton widget', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppButton), findsOneWidget);
      });

      testWidgets('button has save changes label text', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Save Changes'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct column layout', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final columnFinder = find.descendant(
          of: find.byType(EditWisherButton),
          matching: find.byType(Column),
        );
        expect(columnFinder, findsOneWidget);
      });

      testWidgets('passes viewModel to constructor', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherButton(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final buttonWidget = tester.widget<EditWisherButton>(
          find.byType(EditWisherButton),
        );
        expect(buttonWidget.viewModel, viewModel);
      });

      testWidgets('tapping Save Changes button calls tapSaveButton', (
        WidgetTester tester,
      ) async {
        final loadingController = StatusOverlayController();

        // Make a change so noChanges check does not short-circuit
        viewModel.updateFirstName('NewName');

        final goRouter = GoRouter(
          initialLocation: '/test',
          routes: [
            GoRoute(
              path: '/test',
              builder: (context, state) =>
                  Scaffold(body: EditWisherButton(viewModel: viewModel)),
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
              routerConfig: goRouter,
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save Changes'));
        await tester.pump();

        // tapSaveButton was called — loading controller should have been
        // triggered, so it should no longer be idle.
        expect(loadingController.isIdle, isFalse);
      });
    });
  });
}
