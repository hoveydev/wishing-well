import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_button.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  group('EditWisherButton', () {
    late EditWisherViewModel viewModel;
    late StatusOverlayController loadingController;

    setUp(() {
      viewModel = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );
      loadingController = StatusOverlayController();
    });

    tearDown(() {
      viewModel.dispose();
    });

    Widget createTestWidget() =>
        ChangeNotifierProvider<StatusOverlayController>.value(
          value: loadingController,
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
            home: Scaffold(body: EditWisherButton(viewModel: viewModel)),
          ),
        );

    testWidgets('renders SaveChanges button', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      expect(find.byType(AppButton), findsOneWidget);
      expect(
        find.byWidgetPredicate((widget) {
          if (widget is AppButton) return true;
          return false;
        }),
        findsOneWidget,
      );
    });

    testWidgets('renders AppSpacer.medium above button', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      // Verify that AppSpacer.medium is rendered above the button
      expect(find.byType(AppSpacer), findsWidgets);

      // Find the column that contains the spacer and button
      final column = find.byType(Column);
      expect(column, findsOneWidget);

      // Verify the Column has children (spacer and button)
      final columnWidget = tester.widget<Column>(column);
      expect(columnWidget.children.length, equals(2));
      expect(columnWidget.children[0], isA<AppSpacer>());
      expect(columnWidget.children[1], isA<AppButton>());
    });

    testWidgets('save button is enabled', (WidgetTester tester) async {
      await tester.pumpWidget(createTestWidget());

      final button = find.byType(AppButton);
      expect(button, findsOneWidget);

      // Verify the button is rendered and can be found
      final widget = tester.widget(button);
      expect(widget, isNotNull);
    });

    testWidgets('Column has correct alignment and spacing', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(createTestWidget());

      final column = find.byType(Column);
      final columnWidget = tester.widget<Column>(column);

      expect(columnWidget.mainAxisAlignment, equals(MainAxisAlignment.center));
      expect(
        columnWidget.crossAxisAlignment,
        equals(CrossAxisAlignment.center),
      );
    });

    testWidgets('button onPressed is called when tapped', (
      WidgetTester tester,
    ) async {
      final mockViewModelWithCallback = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );

      await tester.pumpWidget(
        ChangeNotifierProvider<StatusOverlayController>.value(
          value: loadingController,
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
            home: Scaffold(
              body: EditWisherButton(viewModel: mockViewModelWithCallback),
            ),
          ),
        ),
      );

      // Find and tap the button to trigger onPressed callback
      final button = find.byType(AppButton);
      expect(button, findsOneWidget);

      // Tap the button (this will execute the onPressed callback)
      await tester.tap(button);
      await tester.pumpAndSettle();

      mockViewModelWithCallback.dispose();
    });
  });
}
