import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('AddWisherDetailsViewModel', () {
    late MockWisherRepository mockRepository;
    late AddWisherDetailsViewModel viewModel;

    setUp(() {
      mockRepository = MockWisherRepository();
      viewModel = AddWisherDetailsViewModel(
        wisherRepository: mockRepository,
        authRepository: MockAuthRepository(),
        imageRepository: MockImageRepository(),
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements AddWisherDetailsViewModelContract', () {
        expect(viewModel, isA<AddWisherDetailsViewModelContract>());
      });

      test('starts valid with optional names', () {
        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('imageFile starts null', () {
        expect(viewModel.imageFile, isNull);
      });
    });

    group(TestGroups.validation, () {
      test('updateFirstName keeps form valid when last name is empty', () {
        viewModel.updateFirstName('John');

        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);
      });

      test('updateLastName keeps form valid when first name is empty', () {
        viewModel.updateLastName('Doe');

        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);
      });

      test('whitespace-only names are trimmed to empty without error', () {
        viewModel.updateFirstName('   ');
        viewModel.updateLastName('   ');

        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });
    });

    group(TestGroups.errorHandling, () {
      test('clearing names does not create a validation error', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');

        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('clearError is safe when there is no validation error', () {
        viewModel.clearError();

        expect(viewModel.error.type, AddWisherDetailsErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });
    });

    group('Error Type Edge Cases', () {
      test('unknown error type is handled correctly', () {
        const error = AddWisherDetailsError(AddWisherDetailsErrorType.unknown);
        expect(error.type, AddWisherDetailsErrorType.unknown);
      });

      test('all error types are still accounted for', () {
        expect(AddWisherDetailsErrorType.values.length, 6);
        expect(
          AddWisherDetailsErrorType.values,
          containsAll([
            AddWisherDetailsErrorType.none,
            AddWisherDetailsErrorType.firstNameRequired,
            AddWisherDetailsErrorType.lastNameRequired,
            AddWisherDetailsErrorType.bothNamesRequired,
            AddWisherDetailsErrorType.invalidImage,
            AddWisherDetailsErrorType.unknown,
          ]),
        );
      });
    });

    group('Repository Integration', () {
      test('createWisher success result returns wisher', () {
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

        expect(successRepo.createWisherResult, isA<Ok<Wisher>>());
      });

      test('createWisher error result returns error', () {
        final errorRepo = MockWisherRepository(
          createWisherResult: Result.error(Exception('Database error')),
        );

        expect(errorRepo.createWisherResult, isA<Error<Wisher>>());
      });
    });

    group('tapSaveButton duplicate flow', () {
      late LoadingController loadingController;

      Widget buildTestWidget(AddWisherDetailsViewModel vm) =>
          ChangeNotifierProvider<LoadingController>.value(
            value: loadingController,
            child: MaterialApp(
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
              supportedLocales: AppLocalizations.supportedLocales,
              home: Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => vm.tapSaveButton(context),
                    child: const Text('Save'),
                  ),
                ),
              ),
            ),
          );

      setUp(() {
        loadingController = LoadingController();
      });

      testWidgets('cancel keeps manual add flow on details screen', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(
          initialWishers: [
            Wisher(
              id: 'existing-1',
              userId: 'user-1',
              firstName: 'Alex',
              lastName: 'Morgan',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ],
        );
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Alex');
        vm.updateLastName('Morgan');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(loadingController.isWarning, isTrue);
        expect(
          loadingController.message,
          'Alex Morgan is already a registered wisher. Add them anyway?',
        );
        expect(repository.createCallCount, 0);

        loadingController.secondaryActionAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isIdle, isTrue);
        expect(repository.createCallCount, 0);
        expect(repository.wishers, hasLength(1));
        expect(find.text('Save'), findsOneWidget);
      });

      testWidgets('continue saves after normalized duplicate confirmation', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(
          initialWishers: [
            Wisher(
              id: 'existing-1',
              userId: 'user-1',
              firstName: 'Alex',
              lastName: 'Morgan',
              createdAt: DateTime(2024),
              updatedAt: DateTime(2024),
            ),
          ],
        );
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName(' alex ');
        vm.updateLastName(' MORGAN ');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(loadingController.isWarning, isTrue);
        expect(repository.createCallCount, 0);

        loadingController.primaryActionAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(repository.createCallCount, 1);
        expect(loadingController.isSuccess, isTrue);
        expect(loadingController.message, 'alex MORGAN has been added!');
        expect(repository.wishers, hasLength(2));
        expect(repository.wishers.first.firstName, 'alex');
        expect(repository.wishers.first.lastName, 'MORGAN');
      });
    });

    group('ViewModel Contract Implementation', () {
      test('contract update methods allow partial or empty names', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;

        contract.updateFirstName('');
        contract.updateLastName('');

        expect(contract.isFormValid, isTrue);
        expect(contract.hasAlert, isFalse);
      });

      test('contract imageFile getter works', () {
        final contract = viewModel as AddWisherDetailsViewModelContract;

        expect(contract.imageFile, isNull);
      });
    });

    group('Image Functionality', () {
      test('updateImage can be called with null to clear', () {
        viewModel.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('image does not affect optional-name validation', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        viewModel.updateImage(null);

        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);
      });
    });
  });
}

class _RecordingWisherRepository extends MockWisherRepository {
  _RecordingWisherRepository({required super.initialWishers});

  int createCallCount = 0;

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) {
    createCallCount += 1;
    return super.createWisher(
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
    );
  }
}
