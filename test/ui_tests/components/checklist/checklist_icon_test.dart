import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/checklist/checklist_icon.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  group('ChecklistIcon', () {
    testWidgets('renders with correct properties', (tester) async {
      const iconColor = Colors.blue;
      const bgColor = Colors.white;
      const borderColor = Colors.black;

      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistIcon(
              iconColor: iconColor,
              bgColor: bgColor,
              borderColor: borderColor,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      expect(containerFinder, findsOneWidget);

      final container = tester.widget<Container>(containerFinder);
      final decoration = container.decoration as BoxDecoration;

      expect(decoration.color, bgColor);
      expect(decoration.shape, BoxShape.circle);

      final border = decoration.border as Border;
      expect(border.top.color, borderColor);
    });

    testWidgets('renders with check icon when icon is provided', (
      tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistIcon(
              iconColor: Colors.blue,
              bgColor: Colors.white,
              borderColor: Colors.black,
              icon: Icons.check,
            ),
          ),
        ),
      );

      expect(find.byIcon(Icons.check), findsOneWidget);

      final iconWidget = tester.widget<Icon>(find.byIcon(Icons.check));
      expect(iconWidget.size, 14.0);
      expect(iconWidget.color, Colors.blue);
    });

    testWidgets('renders icon widget even when icon is null', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistIcon(
              iconColor: Colors.blue,
              bgColor: Colors.white,
              borderColor: Colors.black,
            ),
          ),
        ),
      );

      final iconWidget = tester.widget<Icon>(find.byType(Icon));
      expect(iconWidget.icon, isNull);
    });

    testWidgets('has correct dimensions', (tester) async {
      await tester.pumpWidget(
        MaterialApp(
          theme: AppTheme.lightTheme,
          home: const Scaffold(
            body: ChecklistIcon(
              iconColor: Colors.blue,
              bgColor: Colors.white,
              borderColor: Colors.black,
              icon: Icons.check,
            ),
          ),
        ),
      );

      final containerFinder = find.byType(Container);
      final size = tester.getSize(containerFinder);

      expect(size.width, 18.0);
      expect(size.height, 18.0);
    });
  });
}
