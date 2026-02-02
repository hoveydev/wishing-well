import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppMenuBar', () {
    Widget createTestWidget(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: child,
    );

    group(TestGroups.rendering, () {
      group('Main Menu Bar', () {
        testWidgets('renders with title and account icon', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(type: AppMenuBarType.main, action: () {}),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          TestHelpers.expectTextOnce('WishingWell');
          expect(find.byIcon(Icons.account_circle), findsOneWidget);
        });

        testWidgets('renders logo in leading position', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(type: AppMenuBarType.main, action: () {}),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byType(FittedBox), findsWidgets);
        });
      });

      group('Close Menu Bar', () {
        testWidgets('renders with close icon in actions', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(type: AppMenuBarType.close, action: () {}),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(Icons.close), findsOneWidget);
          expect(find.text('WishingWell'), findsNothing);
        });
      });

      group('Dismiss Menu Bar', () {
        testWidgets('renders with dismiss icon in leading', (
          WidgetTester tester,
        ) async {
          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(type: AppMenuBarType.dismiss, action: () {}),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
          expect(find.text('WishingWell'), findsNothing);
        });
      });
    });

    group(TestGroups.interaction, () {
      group('Main Menu Bar', () {
        testWidgets('calls action when account button is tapped', (
          WidgetTester tester,
        ) async {
          bool actionCalled = false;

          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(
                  type: AppMenuBarType.main,
                  action: () {
                    actionCalled = true;
                  },
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(
            tester,
            find.byIcon(Icons.account_circle),
          );

          expect(actionCalled, isTrue);
        });
      });

      group('Close Menu Bar', () {
        testWidgets('calls action when close button is tapped', (
          WidgetTester tester,
        ) async {
          bool actionCalled = false;

          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(
                  type: AppMenuBarType.close,
                  action: () {
                    actionCalled = true;
                  },
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(tester, find.byIcon(Icons.close));

          expect(actionCalled, isTrue);
        });
      });

      group('Dismiss Menu Bar', () {
        testWidgets('calls action when dismiss button is tapped', (
          WidgetTester tester,
        ) async {
          bool actionCalled = false;

          await tester.pumpWidget(
            createTestWidget(
              Scaffold(
                appBar: AppMenuBar(
                  type: AppMenuBarType.dismiss,
                  action: () {
                    actionCalled = true;
                  },
                ),
              ),
            ),
          );
          await TestHelpers.pumpAndSettle(tester);

          await TestHelpers.tapAndSettle(
            tester,
            find.byIcon(Icons.keyboard_arrow_down),
          );

          expect(actionCalled, isTrue);
        });
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct preferred height', (WidgetTester tester) async {
        final menuBar = AppMenuBar(type: AppMenuBarType.main, action: () {});

        expect(menuBar.preferredSize.height, 48);
      });
    });
  });
}
