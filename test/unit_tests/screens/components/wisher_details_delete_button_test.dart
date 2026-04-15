import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_delete_button.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WisherDetailsDeleteButton', () {
    group(TestGroups.rendering, () {
      testWidgets('renders delete button with correct label', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          buildMaterialAppHome(WisherDetailsDeleteButton(onPressed: () {})),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Delete Wisher'), findsOneWidget);
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('calls onPressed when tapped', (WidgetTester tester) async {
        var called = false;
        await tester.pumpWidget(
          buildMaterialAppHome(
            WisherDetailsDeleteButton(
              onPressed: () {
                called = true;
              },
            ),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);
        await tester.tap(find.text('Delete Wisher'));
        await tester.pump();
        expect(called, isTrue);
      });
    });
  });
}
