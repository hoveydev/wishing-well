import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/input/app_input.dart';
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
  });
}
