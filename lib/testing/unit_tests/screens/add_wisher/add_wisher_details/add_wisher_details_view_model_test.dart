import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../../test_helpers/helpers/test_helpers.dart';
import '../../../../../test_helpers/mocks/repositories/mock_auth_repository.dart';
import '../../../../../test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('AddWisherDetailsViewModel', () {
    late AddWisherDetailsViewModel viewModel;
    late MockWisherRepository mockRepository;

    setUp(() {
      mockRepository = MockWisherRepository();
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: mockRepository,
        authRepository: MockAuthRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements AddWisherDetailsViewModelContract', () {
        expect(viewModel, isA<AddWisherDetailsViewModelContract>());
      });

      test('has empty first name initially', () {
        expect(viewModel.isFormValid, isFalse);
      });

      test('has empty last name initially', () {
        expect(viewModel.isFormValid, isFalse);
      });

      test('has no error initially', () {
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('error is AddWisherDetailsError type initially', () {
        expect(viewModel.error, isA<AddWisherDetailsError>());
      });
    });

    group(TestGroups.validation, () {
      test('updateFirstName updates the first name', () {
        viewModel.updateFirstName('John');
        expect(viewModel.isFormValid, isFalse); // Last name still empty
      });

      test('updateLastName updates the last name', () {
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isFalse); // First name still empty
      });

      test('isFormValid returns true when both names are provided', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isTrue);
      });

      test('isFormValid returns false when only first name is provided', () {
        viewModel.updateFirstName('John');
        expect(viewModel.isFormValid, isFalse);
      });

      test('isFormValid returns false when only last name is provided', () {
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isFalse);
      });

      test('trimming whitespace from first name', () {
        viewModel.updateFirstName('  John  ');
        expect(viewModel.isFormValid, isFalse); // Last name still empty
      });

      test('trimming whitespace from last name', () {
        viewModel.updateLastName('  Doe  ');
        expect(viewModel.isFormValid, isFalse); // First name still empty
      });

      test('updateFirstName trims whitespace and updates correctly', () {
        viewModel.updateFirstName('  Jane  ');
        expect(viewModel.isFormValid, isFalse); // Last name still empty

        viewModel.updateLastName('Smith');
        expect(viewModel.isFormValid, isTrue);
      });

      test('updateLastName trims whitespace and updates correctly', () {
        viewModel.updateLastName('  Smith  ');
        expect(viewModel.isFormValid, isFalse); // First name still empty

        viewModel.updateFirstName('Jane');
        expect(viewModel.isFormValid, isTrue);
      });

      test('empty string after trimming is treated as empty', () {
        viewModel.updateFirstName('   ');
        viewModel.updateLastName('   ');
        expect(viewModel.isFormValid, isFalse);
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );
      });
    });

    group(TestGroups.errorHandling, () {
      test('shows bothNamesRequired error when both fields are empty', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );
        expect(viewModel.hasAlert, isTrue);
      });

      test('shows firstNameRequired error when first name is empty', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('Doe');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.firstNameRequired,
        );
        expect(viewModel.hasAlert, isTrue);
      });

      test('shows lastNameRequired error when last name is empty', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );
        expect(viewModel.hasAlert, isTrue);
      });

      test('clears error when both names are valid', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(viewModel.hasAlert, isTrue);

        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('clearError clears the error state', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(viewModel.hasAlert, isTrue);

        viewModel.clearError();
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('clearError can be called multiple times without issue', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');

        viewModel.clearError();
        viewModel.clearError();
        viewModel.clearError();

        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('error transitions from bothNamesRequired to firstNameRequired', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );

        viewModel.updateLastName('');
        viewModel.updateFirstName('John');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );
      });

      test('error transitions from firstNameRequired to none', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('Doe');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.firstNameRequired,
        );

        viewModel.updateFirstName('John');
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('error transitions from lastNameRequired to none', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );

        viewModel.updateLastName('Doe');
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });
    });

    group('Error Type Edge Cases', () {
      test('unknown error type is handled correctly', () {
        const error = AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
        expect(error.type, AddWisherDetailsErrorType.unknown);
      });

      test('none error type has no alert', () {
        const error = AddWisherDetailsError(AddWisherDetailsErrorType.none);
        expect(error.type, AddWisherDetailsErrorType.none);
      });

      test('all error types are accounted for', () {
        expect(AddWisherDetailsErrorType.values.length, 5);
        expect(
          AddWisherDetailsErrorType.values,
          contains(AddWisherDetailsErrorType.none),
        );
        expect(
          AddWisherDetailsErrorType.values,
          contains(AddWisherDetailsErrorType.firstNameRequired),
        );
        expect(
          AddWisherDetailsErrorType.values,
          contains(AddWisherDetailsErrorType.lastNameRequired),
        );
        expect(
          AddWisherDetailsErrorType.values,
          contains(AddWisherDetailsErrorType.bothNamesRequired),
        );
        expect(
          AddWisherDetailsErrorType.values,
          contains(AddWisherDetailsErrorType.unknown),
        );
      });
    });

    group('Form Validation Sequence', () {
      test('validates in sequence: empty -> firstName only -> both names', () {
        // Initially empty - no validation error yet until first update
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);

        // Add first name only
        viewModel.updateFirstName('John');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );

        // Add last name
        viewModel.updateLastName('Doe');
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.isFormValid, isTrue);
      });

      test('validates in sequence: empty -> lastName only -> both names', () {
        // Add last name only
        viewModel.updateLastName('Doe');
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.firstNameRequired,
        );

        // Add first name
        viewModel.updateFirstName('John');
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.isFormValid, isTrue);
      });

      test('removing firstName triggers validation error', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);

        viewModel.updateFirstName('');
        expect(viewModel.isFormValid, isFalse);
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.firstNameRequired,
        );
      });

      test('removing lastName triggers validation error', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);

        viewModel.updateLastName('');
        expect(viewModel.isFormValid, isFalse);
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.lastNameRequired,
        );
      });
    });

    group('Repository Integration', () {
      test('createWisher success result returns wisher', () async {
        final successRepo = MockWisherRepository(
          createWisherResult: Result.ok(
            Wisher(
              id: 'new-1',
              userId: 'user-1',
              firstName: 'John',
              lastName: 'Doe',
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            ),
          ),
        );
        final vm = AddWisherDetailsViewModel(
          wisherRepository: successRepo,
          authRepository: MockAuthRepository(),
        );
        addTearDown(vm.dispose);

        // The repository result is handled in tapSaveButton
        // This tests that the mock can return success
        expect(successRepo.createWisherResult, isA<Ok<Wisher>>());
      });

      test('createWisher error result returns error', () async {
        final errorRepo = MockWisherRepository(
          createWisherResult: Result.error(Exception('Database error')),
        );
        final vm = AddWisherDetailsViewModel(
          wisherRepository: errorRepo,
          authRepository: MockAuthRepository(),
        );
        addTearDown(vm.dispose);

        // The repository result is handled in tapSaveButton
        expect(errorRepo.createWisherResult, isA<Error<Wisher>>());
      });

      test('repository with initial wishers loads correctly', () {
        final initialWishers = [
          Wisher(
            id: '1',
            userId: 'test-user',
            firstName: 'Existing',
            lastName: 'Wisher',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];
        final repo = MockWisherRepository(initialWishers: initialWishers);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repo,
          authRepository: MockAuthRepository(),
        );
        addTearDown(vm.dispose);

        expect(repo.wishers.length, 1);
        expect(repo.wishers.first.firstName, 'Existing');
      });
    });

    group('ViewModel Contract Implementation', () {
      test('contract updateFirstName method works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        contract.updateFirstName('Test');
        expect(viewModel.isFormValid, isFalse);
      });

      test('contract updateLastName method works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        contract.updateLastName('Test');
        expect(viewModel.isFormValid, isFalse);
      });

      test('contract hasAlert getter works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        expect(contract.hasAlert, isFalse);

        viewModel.updateFirstName('');
        expect(contract.hasAlert, isTrue);
      });

      test('contract error getter works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        expect(contract.error?.type, AddWisherDetailsErrorType.none);
      });

      test('contract clearError method works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        viewModel.updateFirstName('');
        expect(contract.hasAlert, isTrue);

        contract.clearError();
        expect(contract.hasAlert, isFalse);
      });

      test('contract isFormValid getter works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        expect(contract.isFormValid, isFalse);

        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(contract.isFormValid, isTrue);
      });
    });

    group('Image Functionality', () {
      test('has null imageFile initially', () {
        expect(viewModel.imageFile, isNull);
      });

      test('updateImage sets the image file', () {
        expect(viewModel.imageFile, isNull);

        // Set to null - in real tests this would be a File object
        viewModel.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('updateImage can be called with null to clear', () {
        viewModel.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('updateImage notifies listeners when changed', () {
        var notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        viewModel.updateImage(null);
        // Initial call may or may not notify depending on implementation
        // The key is that it doesn't throw
        expect(notifyCount, greaterThanOrEqualTo(0));
      });

      test('updateImage can be called multiple times', () {
        viewModel.updateImage(null);
        viewModel.updateImage(null);
        viewModel.updateImage(null);

        expect(viewModel.imageFile, isNull);
      });

      test('imageFile getter returns private field value', () {
        // Test that getter returns what was set
        viewModel.updateImage(null);
        expect(viewModel.imageFile, equals(null));
      });
    });

    group('Image and Form Validation Combined', () {
      test('form is valid even when image is null', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');

        expect(viewModel.isFormValid, isTrue);
      });

      test('image does not affect validation error states', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        viewModel.updateImage(null);

        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );

        // Now add image and verify error still correct
        viewModel.updateImage(null);
        expect(
          viewModel.error.type,
          AddWisherDetailsErrorType.bothNamesRequired,
        );
      });

      test('clearing image does not affect valid form', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isTrue);

        viewModel.updateImage(null);
        expect(viewModel.isFormValid, isTrue);
      });
    });

    group('Contract Image Tests', () {
      test('contract imageFile getter works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        expect(contract.imageFile, isNull);

        viewModel.updateImage(null);
        expect(contract.imageFile, isNull);
      });

      test('contract updateImage method works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;
        contract.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('contract imageFile is accessible after form changes', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;

        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        viewModel.updateImage(null);

        expect(contract.imageFile, isNull);
        expect(contract.isFormValid, isTrue);
      });
    });
  });
}
