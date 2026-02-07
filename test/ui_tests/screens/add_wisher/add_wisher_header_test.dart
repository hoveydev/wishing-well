import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_header.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  group('AddWisherHeader', () {
    group(TestGroups.rendering, () {
      testWidgets('renders header text correctly', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherHeader);
        TestHelpers.expectTextOnce('Add a Wisher');
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('has correct accessibility properties', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        TestHelpers.expectWidgetOnce(AddWisherHeader);
        expect(tester.takeException(), isNull);
      });

      testWidgets('renders without errors', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(const AddWisherHeader()),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(tester.takeException(), isNull);
      });
    });
  });
}
