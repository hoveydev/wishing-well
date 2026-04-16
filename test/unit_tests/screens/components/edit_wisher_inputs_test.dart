import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_inputs.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('EditWisherInputs', () {
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
      testWidgets('renders two AppInput widgets', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInput), findsNWidgets(2));
      });

      testWidgets('renders first name input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInput).first, findsOneWidget);
      });

      testWidgets('renders last name input', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInput).last, findsOneWidget);
      });

      testWidgets('pre-populates first name from wisher', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice'), findsOneWidget);
      });

      testWidgets('pre-populates last name from wisher', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Test'), findsOneWidget);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('passes viewModel to constructor', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final inputsWidget = tester.widget<EditWisherInputs>(
          find.byType(EditWisherInputs),
        );
        expect(inputsWidget.viewModel, viewModel);
      });

      testWidgets('does not show alert initially', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isFalse);
      });

      testWidgets('onChanged for first name calls updateFirstName', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final firstNameField = find.byType(AppInput).first;
        await tester.enterText(firstNameField, 'NewFirstName');
        await tester.pump();

        expect(viewModel.isFormValid, isTrue);
      });

      testWidgets('onChanged for last name calls updateLastName', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final lastNameField = find.byType(AppInput).last;
        await tester.enterText(lastNameField, 'NewLastName');
        await tester.pump();

        expect(viewModel.isFormValid, isTrue);
      });

      testWidgets('shows error message when viewModel has alert', (
        WidgetTester tester,
      ) async {
        // Trigger a validation error first
        viewModel.updateFirstName('');
        viewModel.updateLastName('');

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.hasAlert, isTrue);
        // AppInlineAlert should be shown
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows firstNameRequired error message', (
        WidgetTester tester,
      ) async {
        viewModel.updateFirstName('');
        viewModel.updateLastName('Smith');

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.error.type, EditWisherErrorType.firstNameRequired);
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows lastNameRequired error message', (
        WidgetTester tester,
      ) async {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('');

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(viewModel.error.type, EditWisherErrorType.lastNameRequired);
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows unknown error message', (WidgetTester tester) async {
        // Use a repo that fails on update to get the unknown error type
        final errorRepo = MockWisherRepository(
          updateWisherResult: Result.error(Exception('fail')),
        );
        final vmWithError = EditWisherViewModel(
          wisherRepository: errorRepo,
          imageRepository: MockImageRepository(),
          wisherId: '1',
        );
        addTearDown(vmWithError.dispose);
        addTearDown(errorRepo.dispose);

        // Trigger update error via tapSaveButton using GoRouter context
        final goRouter = GoRouter(
          initialLocation: '/t',
          routes: [
            GoRoute(
              path: '/t',
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => LoadingController(),
                child: Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () => vmWithError.tapSaveButton(context),
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: goRouter,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);
        // Make a change so noChanges check does not short-circuit
        vmWithError.updateFirstName('NewName');
        await tester.tap(find.text('Save'));
        await tester.pump();

        // Now render the inputs with the viewModel that has the unknown error
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: vmWithError),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(vmWithError.error.type, EditWisherErrorType.unknown);
        expect(find.byType(AppInlineAlert), findsOneWidget);
      });

      testWidgets('shows noChanges error message', (WidgetTester tester) async {
        // Trigger noChanges error by tapping save without any changes
        final goRouter = GoRouter(
          initialLocation: '/t',
          routes: [
            GoRoute(
              path: '/t',
              builder: (context, state) => ChangeNotifierProvider(
                create: (_) => LoadingController(),
                child: Scaffold(
                  body: Builder(
                    builder: (context) => ElevatedButton(
                      onPressed: () => viewModel.tapSaveButton(context),
                      child: const Text('Save'),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
            theme: AppTheme.lightTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: goRouter,
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // No changes made — triggers noChanges
        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(viewModel.error.type, EditWisherErrorType.noChanges);

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            EditWisherInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(AppInlineAlert), findsOneWidget);
        expect(find.text('No changes were made.'), findsOneWidget);
      });
    });
  });
}
