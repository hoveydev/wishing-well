import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_field.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_inputs.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('EditWisherInputs', () {
    late EditWisherViewModel viewModel;

    setUp(() {
      viewModel = EditWisherViewModel(
        wisherRepository: MockWisherRepository(),
        imageRepository: MockImageRepository(),
        wisherId: '1',
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    testWidgets('renders two AppInput widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppInput), findsNWidgets(2));
    });

    testWidgets('editing first name keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      await tester.enterText(find.byType(TextField).first, 'Jane');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(viewModel.hasAlert, isFalse);
    });

    testWidgets('editing last name keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      await tester.enterText(find.byType(TextField).last, 'Smith');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(viewModel.hasAlert, isFalse);
    });

    testWidgets('renders AppDatePickerField for birthday', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppDatePickerField), findsOneWidget);
    });

    testWidgets('renders two AppMultiSelectField widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppMultiSelectField), findsNWidgets(2));
    });

    testWidgets('passing birthday to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testDate = DateTime(1995, 3, 20);
      viewModel.updateBirthday(testDate);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.birthday, testDate);
    });

    testWidgets('passing gift occasions to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testOccasions = ['christmas', 'hanukkah'];
      viewModel.updateGiftOccasions(testOccasions);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.giftOccasions, testOccasions);
    });

    testWidgets('passing gift interests to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testInterests = ['art', 'jewelry'];
      viewModel.updateGiftInterests(testInterests);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.giftInterests, testInterests);
    });

    testWidgets('gift occasions selection is reflected in viewModel state', (
      WidgetTester tester,
    ) async {
      viewModel.updateGiftOccasions(['mothers_day', 'fathers_day']);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.giftOccasions, ['mothers_day', 'fathers_day']);
    });

    testWidgets('gift interests selection is reflected in viewModel state', (
      WidgetTester tester,
    ) async {
      viewModel.updateGiftInterests(['clothing', 'beauty', 'food_and_drink']);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Verify that the fields are populated with correct values
      expect(viewModel.giftInterests, ['clothing', 'beauty', 'food_and_drink']);
    });

    testWidgets('optional fields can be cleared', (WidgetTester tester) async {
      viewModel.updateBirthday(DateTime(1990, 3, 15));
      viewModel.updateGiftOccasions(['christmas']);
      viewModel.updateGiftInterests(['books']);

      await tester.pumpWidget(
        createScreenComponentTestWidget(EditWisherInputs(viewModel: viewModel)),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Clear optional fields
      viewModel.updateBirthday(null);
      viewModel.updateGiftOccasions([]);
      viewModel.updateGiftInterests([]);
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.birthday, isNull);
      expect(viewModel.giftOccasions, isEmpty);
      expect(viewModel.giftInterests, isEmpty);
    });
  });
}
