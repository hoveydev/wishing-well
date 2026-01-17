import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('AppLogo', () {
    testWidgets('renders image asset', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppLogo()),
        ),
      );

      expect(find.byType(Image), findsOneWidget);
    });

    testWidgets('uses default size of 80', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppLogo()),
        ),
      );

      final imageFinder = find.byType(Image);
      final size = tester.getSize(imageFinder);

      expect(size.width, 80);
      expect(size.height, 80);
    });

    testWidgets('uses custom size when provided', (tester) async {
      const customSize = 120.0;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppLogo(size: customSize)),
        ),
      );

      final imageFinder = find.byType(Image);
      final size = tester.getSize(imageFinder);

      expect(size.width, customSize);
      expect(size.height, customSize);
    });

    testWidgets('uses correct image path', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppLogo()),
        ),
      );

      final imageFinder = find.byType(Image);
      final imageWidget = tester.widget<Image>(imageFinder);

      expect(imageWidget.image, isA<AssetImage>());
    });

    testWidgets('uses BoxFit.contain', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(body: AppLogo()),
        ),
      );

      final imageFinder = find.byType(Image);
      final imageWidget = tester.widget<Image>(imageFinder);

      expect(imageWidget.fit, BoxFit.contain);
    });
  });
}
