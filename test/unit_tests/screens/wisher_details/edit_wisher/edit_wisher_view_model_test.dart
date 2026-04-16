import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('EditWisherViewModel', () {
    late MockWisherRepository mockRepository;
    late MockImageRepository mockImageRepository;
    late EditWisherViewModel viewModel;

    setUp(() {
      mockRepository = MockWisherRepository();
      mockImageRepository = MockImageRepository();
      viewModel = EditWisherViewModel(
        wisherRepository: mockRepository,
        imageRepository: mockImageRepository,
        wisherId: '1',
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements EditWisherViewModelContract', () {
        expect(viewModel, isA<EditWisherViewModelContract>());
      });

      test('loads wisher from repository on construction', () {
        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Alice');
      });

      test('isLoading is false after construction', () {
        expect(viewModel.isLoading, isFalse);
      });

      test('pre-populates firstName from loaded wisher', () {
        expect(viewModel.isFormValid, isTrue);
      });

      test('has no error initially', () {
        expect(viewModel.error.type, EditWisherErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('returns null wisher when ID not found', () {
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: 'nonexistent',
        );
        addTearDown(vm.dispose);
        expect(vm.wisher, isNull);
      });

      test('imageFile is null initially', () {
        expect(viewModel.imageFile, isNull);
      });

      test('existingImageUrl matches wisher profilePicture initially', () {
        expect(viewModel.existingImageUrl, viewModel.wisher?.profilePicture);
      });

      test('isFormValid is true when wisher has name pre-populated', () {
        expect(viewModel.isFormValid, isTrue);
      });
    });

    group(TestGroups.validation, () {
      test('updateFirstName updates form validity', () {
        viewModel.updateFirstName('');
        expect(viewModel.isFormValid, isFalse);

        viewModel.updateFirstName('NewName');
        expect(viewModel.isFormValid, isTrue);
      });

      test('updateLastName updates form validity', () {
        viewModel.updateLastName('');
        expect(viewModel.isFormValid, isFalse);

        viewModel.updateLastName('NewName');
        expect(viewModel.isFormValid, isTrue);
      });

      test('trims whitespace from firstName', () {
        viewModel.updateFirstName('  Jane  ');
        viewModel.updateLastName('Doe');
        expect(viewModel.isFormValid, isTrue);
      });

      test('whitespace-only firstName is invalid', () {
        viewModel.updateFirstName('   ');
        expect(viewModel.isFormValid, isFalse);
      });
    });

    group(TestGroups.errorHandling, () {
      test('shows bothNamesRequired when both are empty', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(viewModel.error.type, EditWisherErrorType.bothNamesRequired);
        expect(viewModel.hasAlert, isTrue);
      });

      test('shows firstNameRequired when only first name is empty', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('Doe');
        expect(viewModel.error.type, EditWisherErrorType.firstNameRequired);
      });

      test('shows lastNameRequired when only last name is empty', () {
        viewModel.updateFirstName('John');
        viewModel.updateLastName('');
        expect(viewModel.error.type, EditWisherErrorType.lastNameRequired);
      });

      test('clears error when both names are valid', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        expect(viewModel.hasAlert, isTrue);

        viewModel.updateFirstName('John');
        viewModel.updateLastName('Doe');
        expect(viewModel.error.type, EditWisherErrorType.none);
        expect(viewModel.hasAlert, isFalse);
      });

      test('clearError resets error state', () {
        viewModel.updateFirstName('');
        expect(viewModel.hasAlert, isTrue);

        viewModel.clearError();
        expect(viewModel.hasAlert, isFalse);
      });
    });

    group('Image Functionality', () {
      test('updateImage sets imageFile', () {
        expect(viewModel.imageFile, isNull);
        viewModel.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('clearImage nulls both imageFile and existingImageUrl', () {
        viewModel.clearImage();
        expect(viewModel.imageFile, isNull);
        expect(viewModel.existingImageUrl, isNull);
      });

      test('updateImage notifies listeners', () {
        var count = 0;
        viewModel.addListener(() => count++);
        viewModel.updateImage(null);
        expect(count, greaterThan(0));
      });

      test('clearImage notifies listeners', () {
        var count = 0;
        viewModel.addListener(() => count++);
        viewModel.clearImage();
        expect(count, greaterThan(0));
      });
    });

    group('Repository Integration', () {
      test('reacts to repository changes', () async {
        expect(viewModel.wisher?.firstName, 'Alice');

        final updatedAlice = Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alicia',
          lastName: 'Test',
          createdAt: DateTime(2024),
          updatedAt: DateTime.now(),
        );

        await mockRepository.updateWisher(updatedAlice);

        expect(viewModel.wisher?.firstName, 'Alicia');
      });

      test('updateWisherResult error is returned correctly', () {
        final errorRepo = MockWisherRepository(
          updateWisherResult: Result.error(Exception('update failed')),
        );
        expect(errorRepo.updateWisherResult, isA<Error<Wisher>>());
        errorRepo.dispose();
      });
    });

    group('Listener Management', () {
      test('removes repository listener on dispose', () {
        var count = 0;
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        vm.addListener(() => count++);
        vm.dispose();

        mockRepository.notifyListeners();
        expect(count, 0);
      });
    });

    group('Error Type Coverage', () {
      test('all error types are accounted for', () {
        expect(EditWisherErrorType.values.length, 7);
        expect(
          EditWisherErrorType.values,
          containsAll([
            EditWisherErrorType.none,
            EditWisherErrorType.firstNameRequired,
            EditWisherErrorType.lastNameRequired,
            EditWisherErrorType.bothNamesRequired,
            EditWisherErrorType.invalidImage,
            EditWisherErrorType.unknown,
            EditWisherErrorType.noChanges,
          ]),
        );
      });

      test('EditWisherError holds its type', () {
        const error = EditWisherError(EditWisherErrorType.unknown);
        expect(error.type, EditWisherErrorType.unknown);
      });

      test('noChanges error type exists', () {
        expect(EditWisherErrorType.noChanges, isA<EditWisherErrorType>());
      });
    });

    group('Contract Implementation', () {
      test('contract wisher getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.wisher, isNotNull);
      });

      test('contract isLoading getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.isLoading, isFalse);
      });

      test('contract imageFile getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.imageFile, isNull);
      });

      test('contract existingImageUrl getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.existingImageUrl, isNull);
      });

      test('contract hasAlert getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.hasAlert, isFalse);
      });

      test('contract error getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.error?.type, EditWisherErrorType.none);
      });

      test('contract isFormValid getter works', () {
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.isFormValid, isTrue);
      });

      test('contract updateFirstName method works', () {
        final contract = viewModel as EditWisherViewModelContract;
        contract.updateFirstName('');
        expect(viewModel.isFormValid, isFalse);
      });

      test('contract updateLastName method works', () {
        final contract = viewModel as EditWisherViewModelContract;
        contract.updateLastName('');
        expect(viewModel.isFormValid, isFalse);
      });

      test('contract updateImage method works', () {
        final contract = viewModel as EditWisherViewModelContract;
        contract.updateImage(null);
        expect(viewModel.imageFile, isNull);
      });

      test('contract clearImage method works', () {
        final contract = viewModel as EditWisherViewModelContract;
        contract.clearImage();
        expect(viewModel.imageFile, isNull);
        expect(viewModel.existingImageUrl, isNull);
      });

      test('contract clearError method works', () {
        viewModel.updateFirstName('');
        final contract = viewModel as EditWisherViewModelContract;
        expect(contract.hasAlert, isTrue);
        contract.clearError();
        expect(contract.hasAlert, isFalse);
      });
    });

    group('tapSaveButton', () {
      late LoadingController loadingController;

      setUpAll(() {
        // Initialize dotenv for AppConfig.profilePicturesBucket access
        dotenv.loadFromString(
          mergeWith: {'STORAGE_PROFILE_PICTURES_BUCKET': 'test-bucket'},
          isOptional: true,
        );
      });

      Widget buildTestWidget(EditWisherViewModel vm) {
        final goRouter = GoRouter(
          initialLocation: '/test',
          routes: [
            GoRoute(
              path: '/test',
              builder: (context, state) => Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => vm.tapSaveButton(context),
                    child: const Text('Save'),
                  ),
                ),
              ),
            ),
          ],
        );

        return ChangeNotifierProvider<LoadingController>.value(
          value: loadingController,
          child: MaterialApp.router(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            routerConfig: goRouter,
          ),
        );
      }

      setUp(() {
        loadingController = LoadingController();
      });

      testWidgets('with invalid form does not call updateWisher', (
        WidgetTester tester,
      ) async {
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);

        // Make form invalid
        vm.updateFirstName('');
        vm.updateLastName('');

        final initialWishers = mockRepository.wishers
            .map((w) => w.firstName)
            .toList();

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        // Wishers should be unchanged
        expect(
          mockRepository.wishers.map((w) => w.firstName).toList(),
          initialWishers,
        );
        expect(loadingController.isIdle, isTrue);
      });

      testWidgets('with no changes sets noChanges error without loading', (
        WidgetTester tester,
      ) async {
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);

        // No changes made — same name as Alice Test loaded from repo
        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(vm.error.type, EditWisherErrorType.noChanges);
        expect(loadingController.isIdle, isTrue);
      });

      testWidgets('with null wisher shows error', (WidgetTester tester) async {
        // Use a wisherId that doesn't exist so _wisher is null
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: 'nonexistent',
        );
        addTearDown(vm.dispose);

        // Manually set valid names even though wisher is null
        vm.updateFirstName('John');
        vm.updateLastName('Doe');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        // Should be in error state due to null userId
        expect(loadingController.isError, isTrue);
      });

      testWidgets('with valid form and success shows success overlay', (
        WidgetTester tester,
      ) async {
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);

        // Make a change so noChanges check does not short-circuit
        vm.updateFirstName('Alicia');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(loadingController.isSuccess, isTrue);
      });

      testWidgets('with valid form and update error shows error overlay', (
        WidgetTester tester,
      ) async {
        final errorRepo = MockWisherRepository(
          updateWisherResult: Result.error(Exception('update failed')),
        );
        final vm = EditWisherViewModel(
          wisherRepository: errorRepo,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);
        addTearDown(errorRepo.dispose);

        // Make a change so noChanges check does not short-circuit
        vm.updateFirstName('Alicia');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(loadingController.isError, isTrue);
        expect(vm.error.type, EditWisherErrorType.unknown);
      });

      testWidgets('clearError resets after tapSaveButton error', (
        WidgetTester tester,
      ) async {
        final errorRepo = MockWisherRepository(
          updateWisherResult: Result.error(Exception('fail')),
        );
        final vm = EditWisherViewModel(
          wisherRepository: errorRepo,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);
        addTearDown(errorRepo.dispose);

        // Make a change so noChanges check does not short-circuit
        vm.updateFirstName('Alicia');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pump();

        expect(vm.error.type, EditWisherErrorType.unknown);

        vm.clearError();
        expect(vm.hasAlert, isFalse);
      });

      testWidgets('with imageFile set uploads image on save', (
        WidgetTester tester,
      ) async {
        final vm = EditWisherViewModel(
          wisherRepository: mockRepository,
          imageRepository: mockImageRepository,
          wisherId: '1',
        );
        addTearDown(vm.dispose);

        // Set a local image file to trigger the upload path
        final tempFile = File('${Directory.systemTemp.path}/test_upload.jpg');
        vm.updateImage(tempFile);

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        // Pump multiple times for all async operations
        // (upload, update, preload)
        await tester.pump();
        await tester.pump(const Duration(milliseconds: 100));
        await tester.pump(const Duration(milliseconds: 100));

        // With successful upload, loading shows success
        expect(loadingController.isSuccess, isTrue);
      });

      testWidgets(
        'with imageFile set and upload returns null preserves existing image',
        (WidgetTester tester) async {
          final repositoryWithProfilePicture = MockWisherRepository(
            initialWishers: [
              Wisher(
                id: '1',
                userId: 'test-user',
                firstName: 'Alice',
                lastName: 'Test',
                profilePicture: 'https://example.com/existing.jpg',
                createdAt: DateTime(2024),
                updatedAt: DateTime(2024),
              ),
            ],
          );
          final nullUploadRepo = _NullUploadImageRepository();
          final vm = EditWisherViewModel(
            wisherRepository: repositoryWithProfilePicture,
            imageRepository: nullUploadRepo,
            wisherId: '1',
          );
          addTearDown(vm.dispose);

          final tempFile = File(
            '${Directory.systemTemp.path}/test_upload_null.jpg',
          );
          vm.updateImage(tempFile);

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.text('Save'));
          await tester.pump();

          expect(loadingController.isSuccess, isTrue);
          expect(
            repositoryWithProfilePicture.wishers.first.profilePicture,
            'https://example.com/existing.jpg',
          );
        },
      );

      testWidgets(
        'with imageFile that fails ImageValidationException shows error',
        (WidgetTester tester) async {
          final throwingRepo = _ThrowingImageRepository();
          final vm = EditWisherViewModel(
            wisherRepository: mockRepository,
            imageRepository: throwingRepo,
            wisherId: '1',
          );
          addTearDown(vm.dispose);

          final tempFile = File(
            '${Directory.systemTemp.path}/invalid_image.jpg',
          );
          vm.updateImage(tempFile);

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.text('Save'));
          await tester.pump();

          expect(loadingController.isError, isTrue);
          expect(vm.error.type, EditWisherErrorType.invalidImage);
        },
      );

      testWidgets(
        'with unexpected exception after loading.show shows error not spinner',
        (WidgetTester tester) async {
          final unexpectedRepo = _UnexpectedThrowingImageRepository();
          final vm = EditWisherViewModel(
            wisherRepository: mockRepository,
            imageRepository: unexpectedRepo,
            wisherId: '1',
          );
          addTearDown(vm.dispose);

          final tempFile = File(
            '${Directory.systemTemp.path}/test_unexpected.jpg',
          );
          vm.updateImage(tempFile);

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.text('Save'));
          await tester.pump();

          expect(loadingController.isError, isTrue);
          expect(vm.error.type, EditWisherErrorType.unknown);
        },
      );
    });
  });
}

/// Mock that returns null for upload (simulating upload failure without error)
class _NullUploadImageRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
  }) async => null;
}

/// Mock image repository that throws ImageValidationException
class _ThrowingImageRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
  }) async {
    throw ImageValidationException('Invalid image format for testing');
  }
}

/// Mock image repository that throws an unexpected non-validation exception
class _UnexpectedThrowingImageRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
  }) async {
    throw Exception('Unexpected network error');
  }
}
