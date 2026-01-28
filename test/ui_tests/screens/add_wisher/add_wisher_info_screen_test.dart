import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_buttons.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_description.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_info_screen.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

dynamic startAppWithAddWisherInfoScreen(
  WidgetTester tester, {
  AddWisherViewModel? viewModel,
}) async {
  final controller = LoadingController();
  final ChangeNotifierProvider app =
      ChangeNotifierProvider<LoadingController>.value(
        value: controller,
        child: MaterialApp(
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: AddWisherInfoScreen(
            viewModel: viewModel ?? AddWisherViewModel(),
          ),
        ),
      );
  await tester.pumpWidget(app);
  await tester.pumpAndSettle();
}

void main() {
  group('add wisher info screen tests', () {
    testWidgets('Renders Screen With All Elements', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);

      // Check for header
      expect(find.byType(AddWisherHeader), findsOneWidget);
      expect(find.text('Add Wisher'), findsOneWidget);

      // Check for description
      expect(find.byType(AddWisherDescription), findsOneWidget);
      expect(
        find.textContaining('A wisher is someone special in your life'),
        findsOneWidget,
      );

      // Check for buttons
      expect(find.byType(AddWisherButtons), findsOneWidget);
      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.text('Add Manually'), findsOneWidget);
    });

    testWidgets('dismiss button is present', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);

      // Check that dismiss button type is present
      expect(find.byType(AppMenuBar), findsOneWidget);
    });

    testWidgets('onAddFromContacts callback is triggered', (tester) async {
      var callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () => callbackTriggered = true,
              onAddManually: () {},
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add From Contacts'));
      await tester.pump();

      expect(callbackTriggered, true);
    });

    testWidgets('onAddManually callback is triggered', (tester) async {
      var callbackTriggered = false;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          localizationsDelegates: const [
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: AddWisherButtons(
              onAddFromContacts: () {},
              onAddManually: () => callbackTriggered = true,
            ),
          ),
        ),
      );

      await tester.tap(find.text('Add Manually'));
      await tester.pump();

      expect(callbackTriggered, true);
    });

    testWidgets('can be instantiated with custom ViewModel', (tester) async {
      final customViewModel = AddWisherViewModel();

      await startAppWithAddWisherInfoScreen(tester, viewModel: customViewModel);

      expect(find.byType(AddWisherInfoScreen), findsOneWidget);
    });

    testWidgets('screen uses proper structure and spacing', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);

      // Check for proper Screen component structure
      expect(find.byType(Screen), findsOneWidget);

      // Check that main components are present in the correct order
      final screenFinder = find.byType(Screen);
      final screenWidget = tester.widget<Screen>(screenFinder);

      // Verify crossAxisAlignment is set correctly
      expect(screenWidget.crossAxisAlignment, CrossAxisAlignment.start);

      // Check for spacers between components
      expect(find.byType(SizedBox), findsWidgets);
    });

    testWidgets('all components have proper localization', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);

      // Verify all text is properly localized
      expect(find.text('Add Wisher'), findsOneWidget);
      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.text('Add Manually'), findsOneWidget);
      expect(find.textContaining('wisher is someone special'), findsOneWidget);
    });

    testWidgets('screen can be disposed without errors', (tester) async {
      final viewModel = AddWisherViewModel();

      await startAppWithAddWisherInfoScreen(tester, viewModel: viewModel);

      expect(() => viewModel.dispose(), returnsNormally);
    });
  });
}
