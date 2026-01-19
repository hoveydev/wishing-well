import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('AppMenuBar', () {
    Widget createTestWidget(AppMenuBar menuBar) => MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(appBar: menuBar),
    );

    group('Main Menu Bar', () {
      testWidgets('renders with title and account icon', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(type: AppMenuBarType.main, action: () {}),
          ),
        );

        expect(find.text('WishingWell'), findsOneWidget);
        expect(find.byIcon(Icons.account_circle), findsOneWidget);
      });

      testWidgets('calls action when account button tapped', (tester) async {
        bool actionCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(
              type: AppMenuBarType.main,
              action: () {
                actionCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.account_circle));
        expect(actionCalled, true);
      });

      testWidgets('renders logo in leading position', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(type: AppMenuBarType.main, action: () {}),
          ),
        );

        expect(find.byType(FittedBox), findsWidgets);
      });
    });

    group('Close Menu Bar', () {
      testWidgets('renders with close icon in actions', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(type: AppMenuBarType.close, action: () {}),
          ),
        );

        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.text('WishingWell'), findsNothing);
      });

      testWidgets('calls action when close button tapped', (tester) async {
        bool actionCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(
              type: AppMenuBarType.close,
              action: () {
                actionCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.close));
        expect(actionCalled, true);
      });
    });

    group('Dismiss Menu Bar', () {
      testWidgets('renders with dismiss icon in leading', (tester) async {
        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(type: AppMenuBarType.dismiss, action: () {}),
          ),
        );

        expect(find.byIcon(Icons.keyboard_arrow_down), findsOneWidget);
        expect(find.text('WishingWell'), findsNothing);
      });

      testWidgets('calls action when dismiss button tapped', (tester) async {
        bool actionCalled = false;

        await tester.pumpWidget(
          createTestWidget(
            AppMenuBar(
              type: AppMenuBarType.dismiss,
              action: () {
                actionCalled = true;
              },
            ),
          ),
        );

        await tester.tap(find.byIcon(Icons.keyboard_arrow_down));
        expect(actionCalled, true);
      });
    });

    group('PreferredSize', () {
      testWidgets('has correct preferred height', (tester) async {
        final menuBar = AppMenuBar(type: AppMenuBarType.main, action: () {});

        expect(menuBar.preferredSize.height, 48);
      });
    });
  });
}
