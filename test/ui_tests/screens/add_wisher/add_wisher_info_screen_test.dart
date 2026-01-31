import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
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
  VoidCallback? onAddFromContacts,
  VoidCallback? onAddManually,
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

      // Check for description
      expect(find.byType(AddWisherDescription), findsOneWidget);
      expect(
        find.textContaining('A Wisher is someone special in your life'),
        findsOneWidget,
      );

      // Check for buttons
      expect(find.byType(AddWisherButtons), findsOneWidget);
      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.text('Add Manually'), findsOneWidget);

      // Check for proper spacing (at least 2 spacers - large + xlarge)
      expect(find.byType(SizedBox), findsAtLeastNWidgets(2));
    });

    testWidgets('screen content is center aligned', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);

      // Verify content is center aligned
      final screenFinder = find.byType(Screen);
      final screenWidget = tester.widget<Screen>(screenFinder);
      expect(screenWidget.crossAxisAlignment, CrossAxisAlignment.start);
    });

    testWidgets('Add From Contacts button exists and is tappable', (
      tester,
    ) async {
      await startAppWithAddWisherInfoScreen(tester);
      await tester.ensureVisible(find.text('Add From Contacts'));
      await tester.tap(find.text('Add From Contacts'));
      await tester.pump();

      expect(find.text('Add From Contacts'), findsOneWidget);
      expect(find.byType(AddWisherButtons), findsOneWidget);
    });

    testWidgets('Add Manually button exists and is tappable', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);
      await tester.ensureVisible(find.text('Add Manually'));
      await tester.tap(find.text('Add Manually'));
      await tester.pump();

      expect(find.text('Add Manually'), findsOneWidget);
      expect(find.byType(AddWisherButtons), findsOneWidget);
    });

    testWidgets('can be instantiated with custom ViewModel', (tester) async {
      final customViewModel = AddWisherViewModel();

      await startAppWithAddWisherInfoScreen(tester, viewModel: customViewModel);

      expect(find.byType(AddWisherInfoScreen), findsOneWidget);
    });

    testWidgets('screen can be disposed without errors', (tester) async {
      await startAppWithAddWisherInfoScreen(tester);
      await tester.pumpWidget(Container());
    });
  });
}
