import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherLandingHeader', () {
    group(TestGroups.rendering, () {
      testWidgets('renders header text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingHeader);
        TestHelpers.expectTextOnce('Add a Wisher');
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct accessibility properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherLandingHeader);
        expect(tester.takeException(), isNull);
      });

      testWidgets('renders without errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherLandingHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(tester.takeException(), isNull);
      });
    });
  });
}
