import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_field.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/components/add_wisher_details_inputs.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('AddWisherDetailsInputs', () {
    late AddWisherDetailsViewModel viewModel;

    setUp(() {
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: MockWisherRepository(),
        authRepository: MockAuthRepository(),
        imageRepository: MockImageRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    testWidgets('renders two AppInput widgets', (WidgetTester tester) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppInput), findsNWidgets(2));
    });

    testWidgets('editing first name keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      await tester.enterText(find.byType(TextField).first, 'John');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(viewModel.hasAlert, isFalse);
    });

    testWidgets('editing last name keeps the form valid', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      await tester.enterText(find.byType(TextField).last, 'Doe');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(viewModel.hasAlert, isFalse);
    });

    testWidgets('leaving both names empty does not show an inline alert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      viewModel.updateFirstName('');
      viewModel.updateLastName('');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.error.type, AddWisherDetailsErrorType.none);
      expect(viewModel.hasAlert, isFalse);
      expect(find.byType(AppInlineAlert), findsNothing);
    });

    testWidgets('whitespace-only names do not show an inline alert', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      final textFields = find.byType(TextField);
      await tester.enterText(textFields.first, '   ');
      await tester.enterText(textFields.last, '   ');
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.isFormValid, isTrue);
      expect(find.byType(AppInlineAlert), findsNothing);
    });

    testWidgets('renders AppDatePickerField for birthday', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppDatePickerField), findsOneWidget);
    });

    testWidgets('renders two AppMultiSelectField widgets', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(find.byType(AppMultiSelectField), findsNWidgets(2));
    });

    testWidgets('passing birthday to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testDate = DateTime(2000, 5, 15);
      viewModel.updateBirthday(testDate);

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.birthday, testDate);
    });

    testWidgets('passing gift occasions to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testOccasions = ['christmas', 'easter'];
      viewModel.updateGiftOccasions(testOccasions);

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.giftOccasions, testOccasions);
    });

    testWidgets('passing gift interests to viewModel updates field', (
      WidgetTester tester,
    ) async {
      final testInterests = ['books', 'jewelry'];
      viewModel.updateGiftInterests(testInterests);

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      expect(viewModel.giftInterests, testInterests);
    });

    testWidgets('gift occasions display with localized labels', (
      WidgetTester tester,
    ) async {
      viewModel.updateGiftOccasions(['christmas', 'hanukkah']);

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Verify that the fields are populated and the items would have
      // correct labels
      final multiSelectFields = find.byType(AppMultiSelectField);
      expect(multiSelectFields, findsNWidgets(2));
    });

    testWidgets('gift interests display with localized labels', (
      WidgetTester tester,
    ) async {
      viewModel.updateGiftInterests(['books', 'art', 'jewelry']);

      await tester.pumpWidget(
        createScreenComponentTestWidget(
          AddWisherDetailsInputs(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Verify that the fields are populated with correct values
      expect(viewModel.giftInterests, ['books', 'art', 'jewelry']);
    });

    testWidgets(
      'empty values do not render alert when only optional fields are empty',
      (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(
            AddWisherDetailsInputs(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        final textFields = find.byType(TextField);
        await tester.enterText(textFields.first, 'John');
        await tester.enterText(textFields.last, 'Doe');
        await TestHelpers.pumpAndSettle(tester);

        // Optional fields are empty but form is valid
        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.birthday, isNull);
        expect(viewModel.giftOccasions, isEmpty);
        expect(viewModel.giftInterests, isEmpty);
      },
    );
  });
}
