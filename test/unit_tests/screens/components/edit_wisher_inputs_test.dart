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

    testWidgets('renders two AppInput widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppInput), findsNWidgets(2));
    });

    testWidgets('pre-populates first and last names from the wisher', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.text('Alice'), findsOneWidget);
      expect(find.text('Test'), findsOneWidget);
    });

    testWidgets('clearing both names keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, '');
      await tester.enterText(textFields.last, '');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(viewModel.hasAlert, isFalse);
      expect(find.byType(AppInlineAlert), findsNothing);
    });

    testWidgets('editing one field still keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      await tester.enterText(find.byType(AppInput).first, '');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(find.byType(AppInlineAlert), findsNothing);
    });

    testWidgets('shows unknown error message when save fails', (
      WidgetTester tester,
    ) async {
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

      vmWithError.updateFirstName('');
      await tester.tap(find.text('Save'));
      await tester.pump();

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          EditWisherInputs(viewModel: vmWithError),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(vmWithError.error.type, EditWisherErrorType.unknown);
      expect(find.byType(AppInlineAlert), findsOneWidget);
    });

    testWidgets('shows noChanges error message when nothing changed', (
      WidgetTester tester,
    ) async {
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

      await tester.tap(find.text('Save'));
      await tester.pump();

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.error.type, EditWisherErrorType.noChanges);
      expect(find.byType(AppInlineAlert), findsOneWidget);
      expect(find.text('No changes were made.'), findsOneWidget);
    });
  });
}
