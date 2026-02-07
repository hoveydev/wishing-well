import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/logo/app_logo.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AppLogo', () {
    group(TestGroups.rendering, () {
      testWidgets('renders image asset with correct properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createComponentTestWidget(const AppLogo()));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Image), findsOneWidget);
      });

      testWidgets('renders with default size of 80', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(createComponentTestWidget(const AppLogo()));
        await TestHelpers.pumpAndSettle(tester);

        final imageFinder = find.byType(Image);
        final size = tester.getSize(imageFinder);

        expect(size.width, 80.0);
        expect(size.height, 80.0);
      });

      testWidgets('renders with custom size when provided', (
        WidgetTester tester,
      ) async {
        const customSize = 120.0;
        await tester.pumpWidget(
          createComponentTestWidget(const AppLogo(size: customSize)),
        );
        await TestHelpers.pumpAndSettle(tester);

        final imageFinder = find.byType(Image);
        final size = tester.getSize(imageFinder);

        expect(size.width, customSize);
        expect(size.height, customSize);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('uses correct image path', (WidgetTester tester) async {
        await tester.pumpWidget(createComponentTestWidget(const AppLogo()));
        await TestHelpers.pumpAndSettle(tester);

        final imageWidget = tester.widget<Image>(find.byType(Image));
        expect(imageWidget.image, isA<AssetImage>());
      });
    });
  });
}
