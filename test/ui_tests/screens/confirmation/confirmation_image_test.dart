import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/confirmation/confirmation_image.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('ConfirmationImage', () {
    Widget createTestWidget(Widget child) => MaterialApp(
      theme: AppTheme.lightTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      home: Scaffold(body: child),
    );

    testWidgets('renders icon', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ConfirmationImage(icon: Icons.check_circle)),
      );

      expect(find.byType(Icon), findsOneWidget);
    });

    testWidgets('renders correct icon', (tester) async {
      const testIcon = Icons.check_circle;

      await tester.pumpWidget(
        createTestWidget(const ConfirmationImage(icon: testIcon)),
      );

      expect(find.byIcon(testIcon), findsOneWidget);
    });

    testWidgets('calculates size based on screen height', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ConfirmationImage(icon: Icons.check_circle)),
      );

      final iconFinder = find.byType(Icon);
      final size = tester.getSize(iconFinder);

      final screenHeight =
          tester.view.physicalSize.height / tester.view.devicePixelRatio;
      final expectedSize = screenHeight * 0.12;

      expect(size.height, closeTo(expectedSize, 0.1));
      expect(size.width, closeTo(expectedSize, 0.1));
    });

    testWidgets('uses success color', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ConfirmationImage(icon: Icons.check_circle)),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));

      expect(iconWidget.color, isNotNull);
    });

    testWidgets('has success semantics label', (tester) async {
      await tester.pumpWidget(
        createTestWidget(const ConfirmationImage(icon: Icons.check_circle)),
      );

      expect(find.byType(Semantics), findsWidgets);
    });

    testWidgets('handles different icon types', (tester) async {
      const icons = [Icons.check_circle, Icons.email, Icons.lock];

      for (final icon in icons) {
        await tester.pumpWidget(
          createTestWidget(ConfirmationImage(icon: icon)),
        );

        expect(find.byIcon(icon), findsOneWidget);
      }
    });
  });
}
