// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:wishing_well/screens/add_wisher/add_wisher_buttons.dart';
// import 'package:wishing_well/screens/add_wisher/add_wisher_description.dart';
// import 'package:wishing_well/screens/add_wisher/add_wisher_header.dart';
// import 'package:wishing_well/screens/add_wisher/add_wisher_info_screen.dart';
// import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';

// import '../../../../testing_resources/helpers/test_helpers.dart';

void main() {
  //   group('AddWisher Screen Components', () {
  //     group(TestGroups.rendering, () {
  //       testWidgets('AddWisherButtons renders correctly', (
  //         WidgetTester tester,
  //       ) async {
  //         await tester.pumpWidget(
  //           createComponentTestWidget(
  //             AddWisherButtons(
  //onAddFromContacts: () {}, onAddManually: () {}),
  //           ),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         TestHelpers.expectTextOnce('Add From Contacts');
  //         TestHelpers.expectTextOnce('Add Manually');
  //         TestHelpers.expectWidgetOnce(SizedBox); // For spacing
  //       });

  //       testWidgets('AddWisherDescription renders correctly', (
  //         WidgetTester tester,
  //       ) async {
  //         await tester.pumpWidget(
  //           createComponentTestWidget(const AddWisherDescription()),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         // Verify description content exists
  //         expect(find.byType(Text), findsWidgets);
  //         expect(tester.takeException(), isNull);
  //       });

  //       testWidgets('AddWisherHeader renders correctly', (
  //         WidgetTester tester,
  //       ) async {
  //         await tester.pumpWidget(
  //           createComponentTestWidget(const AddWisherHeader()),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         // Verify header content exists
  //         expect(find.byType(Text), findsWidgets);
  //         expect(tester.takeException(), isNull);
  //       });
  //     });

  //     group(TestGroups.interaction, () {
  //       testWidgets('AddWisherButtons - Add From Contacts callback', (
  //         WidgetTester tester,
  //       ) async {
  //         var wasCalled = false;

  //         await tester.pumpWidget(
  //           createComponentTestWidget(
  //             AddWisherButtons(
  //               onAddFromContacts: () => wasCalled = true,
  //               onAddManually: () {},
  //             ),
  //           ),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         await TestHelpers.tapAndSettle(
  //tester, find.text('Add From Contacts'));
  //         expect(wasCalled, isTrue);
  //       });

  //       testWidgets('AddWisherButtons - Add Manually callback', (
  //         WidgetTester tester,
  //       ) async {
  //         var wasCalled = false;

  //         await tester.pumpWidget(
  //           createComponentTestWidget(
  //             AddWisherButtons(
  //               onAddFromContacts: () {},
  //               onAddManually: () => wasCalled = true,
  //             ),
  //           ),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         await TestHelpers.tapAndSettle(tester, find.text('Add Manually'));
  //         expect(wasCalled, isTrue);
  //       });
  //     });

  //     group(TestGroups.behavior, () {
  //       testWidgets('AddWisherInfoScreen integrates all components', (
  //         WidgetTester tester,
  //       ) async {
  //         final viewModel = AddWisherViewModel();

  //         await tester.pumpWidget(
  //           createScreenTestWidget(
  //             child: AddWisherInfoScreen(viewModel: viewModel),
  //           ),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         // Verify all components are present
  //         expect(find.byType(AddWisherHeader), findsOneWidget);
  //         expect(find.byType(AddWisherDescription), findsOneWidget);
  //         expect(find.byType(AddWisherButtons), findsOneWidget);

  //         // Verify no exceptions
  //         expect(tester.takeException(), isNull);

  //         viewModel.dispose();
  //       });

  //       testWidgets('AddWisherButtons button layout', (
  //         WidgetTester tester,
  //       ) async {
  //         await tester.pumpWidget(
  //           createComponentTestWidget(
  //             AddWisherButtons(
  //onAddFromContacts: () {}, onAddManually: () {}),
  //           ),
  //         );
  //         await TestHelpers.pumpAndSettle(tester);

  //         // Verify buttons are in a Column (vertical layout)
  //         final columnFinder = find.byType(Column);
  //         expect(columnFinder, findsOneWidget);

  //         final buttons = find.descendant(
  //           of: columnFinder,
  //           matching: find.byType(ElevatedButton),
  //         );
  //         expect(buttons, findsNWidgets(2));
  //       });
  //     });

  //     group(TestGroups.errorHandling, () {
  //       testWidgets('AddWisherButtons handles null callbacks gracefully', (
  //         WidgetTester tester,
  //       ) async {
  //         // This test verifies the component doesn't crash with
  //         // required callbacks
  //         expect(
  //           () =>
  //               AddWisherButtons(
  //onAddFromContacts: () {}, onAddManually: () {}),
  //           returnsNormally,
  //         );
  //       });

  //       testWidgets(
  //         'AddWisherInfoScreen handles missing dependencies gracefully',
  //         (WidgetTester tester) async {
  //           final viewModel = AddWisherViewModel();

  //           await tester.pumpWidget(
  //             createScreenTestWidget(
  //               child: AddWisherInfoScreen(viewModel: viewModel),
  //             ),
  //           );
  //           await TestHelpers.pumpAndSettle(tester);

  //           // Screen should render without errors even
  //           // if dependencies are missing
  //           expect(tester.takeException(), isNull);

  //           viewModel.dispose();
  //         },
  //       );
  //     });
  //   });
}
