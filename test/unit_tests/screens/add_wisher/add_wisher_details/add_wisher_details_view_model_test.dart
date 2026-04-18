import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
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

      test('starts valid with no names provided', () {
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

      test(
        'whitespace-only names are trimmed to empty with no inline error',
        () {
          viewModel.updateFirstName('   ');
          viewModel.updateLastName('   ');

          expect(viewModel.isFormValid, isTrue);
          expect(viewModel.error.type, AddWisherDetailsErrorType.none);
          expect(viewModel.hasAlert, isFalse);
        },
      );
    });

    group(TestGroups.errorHandling, () {
      test('clearing names does not set an inline error', () {
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
      late StatusOverlayController loadingController;

      setUpAll(() {
        // Initialize dotenv for AppConfig.profilePicturesBucket used in
        // image upload path.
        dotenv.loadFromString(
          mergeWith: {'STORAGE_PROFILE_PICTURES_BUCKET': 'test-bucket'},
          isOptional: true,
        );
      });

      Widget buildTestWidget(AddWisherDetailsViewModel vm) =>
          ChangeNotifierProvider<StatusOverlayController>.value(
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

      // Two-route GoRouter widget for tests that need context.pop() to work
      // (e.g. success onOk callback navigation).
      Widget buildGoRouterTestWidget(AddWisherDetailsViewModel vm) {
        final goRouter = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Home'),
                    ElevatedButton(
                      onPressed: () => context.push('/save'),
                      child: const Text('Go to Save'),
                    ),
                  ],
                ),
              ),
            ),
            GoRoute(
              path: '/save',
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

        return ChangeNotifierProvider<StatusOverlayController>.value(
          value: loadingController,
          child: MaterialApp.router(
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
        loadingController = StatusOverlayController();
      });

      testWidgets('empty names do not save and do not show loading overlay', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('');
        vm.updateLastName('');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await tester.pumpAndSettle();

        expect(vm.error.type, AddWisherDetailsErrorType.bothNamesRequired);
        expect(loadingController.isIdle, isTrue);
        expect(repository.createCallCount, 0);
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

      // -----------------------------------------------------------------------
      // New coverage tests
      // -----------------------------------------------------------------------

      testWidgets(
        'typing after save-time error clears bothNamesRequired (line 110)',
        (WidgetTester tester) async {
          final authRepository = MockAuthRepository(userId: 'user-1');
          final repository = _RecordingWisherRepository(initialWishers: []);
          final vm = AddWisherDetailsViewModel(
            wisherRepository: repository,
            authRepository: authRepository,
            imageRepository: MockImageRepository(),
          );
          addTearDown(vm.dispose);
          addTearDown(authRepository.dispose);
          addTearDown(repository.dispose);

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          // Tap Save with empty names → sets bothNamesRequired error
          await tester.tap(find.text('Save'));
          await tester.pump();
          expect(vm.error.type, AddWisherDetailsErrorType.bothNamesRequired);

          // Typing a first name calls _validateForm(), which transitions the
          // error from bothNamesRequired → none, triggering notifyListeners at
          // line 110.
          vm.updateFirstName('John');
          expect(vm.error.type, AddWisherDetailsErrorType.none);
        },
      );

      testWidgets('createWisher error shows error overlay (lines 231-238)', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = MockWisherRepository(
          createWisherResult: Result.error(Exception('DB error')),
          initialWishers: [],
        );
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Alice');
        vm.updateLastName('Smith');

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isError, isTrue);
        expect(vm.error.type, AddWisherDetailsErrorType.unknown);
      });

      testWidgets('image upload null result still saves wisher without image'
          ' (lines 169, 175-177, 182)', (WidgetTester tester) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: _NullUploadImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Bob');
        vm.updateLastName('Jones');
        vm.updateImage(
          File('${Directory.systemTemp.path}/add_wisher_test.jpg'),
        );

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await TestHelpers.pumpAndSettle(tester);

        // Upload returned null → warning logged, but wisher is still created
        expect(loadingController.isSuccess, isTrue);
        expect(repository.createCallCount, 1);
      });

      testWidgets('image upload exception shows invalid image error'
          ' (lines 169, 175-177, 187-195)', (WidgetTester tester) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: _ThrowingImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Charlie');
        vm.updateLastName('Brown');
        vm.updateImage(
          File('${Directory.systemTemp.path}/add_wisher_invalid.jpg'),
        );

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isError, isTrue);
        expect(vm.error.type, AddWisherDetailsErrorType.invalidImage);
      });

      testWidgets(
        'image upload success preloads image and shows success overlay'
        ' (lines 169, 175-177, 216, 224)',
        (WidgetTester tester) async {
          final authRepository = MockAuthRepository(userId: 'user-1');
          await authRepository.login(email: 'test@example.com', password: 'pw');
          final repository = _RecordingWisherRepository(initialWishers: []);
          final vm = AddWisherDetailsViewModel(
            wisherRepository: repository,
            authRepository: authRepository,
            imageRepository: MockImageRepository(),
          );
          addTearDown(vm.dispose);
          addTearDown(authRepository.dispose);
          addTearDown(repository.dispose);

          vm.updateFirstName('Dana');
          vm.updateLastName('White');
          vm.updateImage(
            File('${Directory.systemTemp.path}/add_wisher_success.jpg'),
          );

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.text('Save'));
          await TestHelpers.pumpAndSettle(tester);

          // Upload returned a URL → preloadImages called → showSuccess called
          expect(loadingController.isSuccess, isTrue);
          expect(repository.createCallCount, 1);
        },
      );

      testWidgets('success onOk callback pops navigation (lines 226-227)', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Eve');
        vm.updateLastName('Adams');

        await tester.pumpWidget(buildGoRouterTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to the save page
        await tester.tap(find.text('Go to Save'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Save'), findsOneWidget);

        // Trigger a successful save
        await tester.tap(find.text('Save'));
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isSuccess, isTrue);

        // Acknowledging fires onOk → context.mounted check → context.pop()
        // → navigates back to the home route.
        loadingController.acknowledgeAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Save'), findsNothing);
      });

      testWidgets(
        'pre-compressed file is passed to uploadImage and deleted after save',
        (WidgetTester tester) async {
          final compressedFile = File(
            '${Directory.systemTemp.path}/add_wisher_precompressed.webp',
          );
          compressedFile.createSync();
          addTearDown(() {
            if (compressedFile.existsSync()) compressedFile.deleteSync();
          });

          final authRepository = MockAuthRepository(userId: 'user-1');
          await authRepository.login(email: 'test@example.com', password: 'pw');
          final repository = _RecordingWisherRepository(initialWishers: []);
          final imageRepo = _PrecompressedFileRepository(compressedFile);
          final vm = AddWisherDetailsViewModel(
            wisherRepository: repository,
            authRepository: authRepository,
            imageRepository: imageRepo,
          );
          addTearDown(vm.dispose);
          addTearDown(authRepository.dispose);
          addTearDown(repository.dispose);

          vm.updateFirstName('Eva');
          vm.updateLastName('Green');
          vm.updateImage(File('${Directory.systemTemp.path}/original_pre.jpg'));

          await tester.pumpWidget(buildTestWidget(vm));
          await TestHelpers.pumpAndSettle(tester);

          await tester.tap(find.text('Save'));
          await TestHelpers.pumpAndSettle(tester);

          expect(
            imageRepo.capturedPrecompressedFile?.path,
            compressedFile.path,
          );
          expect(compressedFile.existsSync(), isFalse);
          expect(loadingController.isSuccess, isTrue);
        },
      );

      testWidgets('pre-compressed file is deleted even when '
          'ImageValidationException is thrown', (WidgetTester tester) async {
        final compressedFile = File(
          '${Directory.systemTemp.path}/add_wisher_precompressed_throw.webp',
        );
        compressedFile.createSync();
        addTearDown(() {
          if (compressedFile.existsSync()) compressedFile.deleteSync();
        });

        final authRepository = MockAuthRepository(userId: 'user-1');
        await authRepository.login(email: 'test@example.com', password: 'pw');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final imageRepo = _ThrowingPrecompressedRepository(compressedFile);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: imageRepo,
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        vm.updateFirstName('Finn');
        vm.updateLastName('Brown');
        vm.updateImage(File('${Directory.systemTemp.path}/original_throw.jpg'));

        await tester.pumpWidget(buildTestWidget(vm));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Save'));
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isError, isTrue);
        expect(vm.error.type, AddWisherDetailsErrorType.invalidImage);
        expect(compressedFile.existsSync(), isFalse);
      });
    });

    group('tapBackButton', () {
      testWidgets('pops the navigation stack (lines 117-119)', (
        WidgetTester tester,
      ) async {
        final authRepository = MockAuthRepository(userId: 'user-1');
        final repository = _RecordingWisherRepository(initialWishers: []);
        final vm = AddWisherDetailsViewModel(
          wisherRepository: repository,
          authRepository: authRepository,
          imageRepository: MockImageRepository(),
        );
        addTearDown(vm.dispose);
        addTearDown(authRepository.dispose);
        addTearDown(repository.dispose);

        final goRouter = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => Scaffold(
                body: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Home'),
                    ElevatedButton(
                      onPressed: () => context.push('/details'),
                      child: const Text('Open Details'),
                    ),
                  ],
                ),
              ),
            ),
            GoRoute(
              path: '/details',
              builder: (context, state) => Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => vm.tapBackButton(context),
                    child: const Text('Back'),
                  ),
                ),
              ),
            ),
          ],
        );

        await tester.pumpWidget(
          MaterialApp.router(
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
        await TestHelpers.pumpAndSettle(tester);

        // Navigate to the details route
        await tester.tap(find.text('Open Details'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Back'), findsOneWidget);

        // Tap the back button – should pop back to Home
        await tester.tap(find.text('Back'));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Home'), findsOneWidget);
        expect(find.text('Back'), findsNothing);
      });
    });

    group('ViewModel Contract Implementation', () {
      test(
        'contract update methods allow empty names without inline error',
        () {
          final contract = viewModel as AddWisherDetailsViewModelContract;

          contract.updateFirstName('');
          contract.updateLastName('');

          expect(contract.isFormValid, isTrue);
          expect(contract.hasAlert, isFalse);
        },
      );

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

      test('image update does not affect form validity', () {
        viewModel.updateFirstName('');
        viewModel.updateLastName('');
        viewModel.updateImage(null);

        expect(viewModel.isFormValid, isTrue);
        expect(viewModel.hasAlert, isFalse);
      });

      test(
        'compressImage is called when updateImage receives a non-null file',
        () {
          final repo = _RecordingCompressRepository();
          final vm = AddWisherDetailsViewModel(
            wisherRepository: MockWisherRepository(),
            authRepository: MockAuthRepository(),
            imageRepository: repo,
          );
          addTearDown(vm.dispose);

          vm.updateImage(File('/tmp/test.jpg'));

          expect(repo.compressCallCount, 1);
        },
      );

      test('compressImage is not called when updateImage receives null', () {
        final repo = _RecordingCompressRepository();
        final vm = AddWisherDetailsViewModel(
          wisherRepository: MockWisherRepository(),
          authRepository: MockAuthRepository(),
          imageRepository: repo,
        );
        addTearDown(vm.dispose);

        vm.updateImage(null);

        expect(repo.compressCallCount, 0);
      });
    });

    group('Deferred Compression Cleanup', () {
      test(
        'updating with a new image cleans up the previous compression result',
        () async {
          final firstCompressedFile = File(
            '${Directory.systemTemp.path}/add_wisher_cleanup_first.webp',
          );
          await firstCompressedFile.writeAsBytes([]);
          addTearDown(() {
            if (firstCompressedFile.existsSync()) {
              firstCompressedFile.deleteSync();
            }
          });

          final vm = AddWisherDetailsViewModel(
            wisherRepository: MockWisherRepository(),
            authRepository: MockAuthRepository(),
            imageRepository: _PrecompressedFileRepository(firstCompressedFile),
          );
          addTearDown(vm.dispose);

          vm.updateImage(File('/tmp/image_1.jpg'));
          vm.updateImage(File('/tmp/image_2.jpg'));

          await Future.delayed(Duration.zero);

          expect(firstCompressedFile.existsSync(), isFalse);
        },
      );

      test('dispose cleans up an outstanding compression result', () async {
        final compressedFile = File(
          '${Directory.systemTemp.path}/add_wisher_cleanup_dispose.webp',
        );
        await compressedFile.writeAsBytes([]);
        addTearDown(() {
          if (compressedFile.existsSync()) compressedFile.deleteSync();
        });

        final vm = AddWisherDetailsViewModel(
          wisherRepository: MockWisherRepository(),
          authRepository: MockAuthRepository(),
          imageRepository: _PrecompressedFileRepository(compressedFile),
        );

        vm.updateImage(File('/tmp/image_dispose.jpg'));
        vm.dispose();

        await Future.delayed(Duration.zero);

        expect(compressedFile.existsSync(), isFalse);
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

/// Returns null from uploadImage to simulate a failed upload without throwing.
class _NullUploadImageRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async => null;
}

/// Throws [ImageValidationException] from uploadImage to cover the catch block.
class _ThrowingImageRepository extends MockImageRepository {
  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    throw ImageValidationException('Test image error');
  }
}

/// Tracks calls to compressImage without returning a real file.
class _RecordingCompressRepository extends MockImageRepository {
  int compressCallCount = 0;

  @override
  Future<File?> compressImage(String filePath) async {
    compressCallCount++;
    return null;
  }
}

/// Returns a pre-built [File] from compressImage to exercise the deferred
/// compression path end-to-end, including the finally-block cleanup.
class _PrecompressedFileRepository extends MockImageRepository {
  _PrecompressedFileRepository(this._compressResult);

  final File _compressResult;
  File? capturedPrecompressedFile;

  @override
  Future<File?> compressImage(String filePath) async => _compressResult;

  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    capturedPrecompressedFile = precompressedFile;
    return 'https://example.com/mock-upload.jpg';
  }
}

/// Returns a pre-built [File] from compressImage but throws
/// [ImageValidationException] on upload, to verify the finally block still
/// cleans up the temp file on error.
class _ThrowingPrecompressedRepository extends MockImageRepository {
  _ThrowingPrecompressedRepository(this._compressResult);

  final File _compressResult;

  @override
  Future<File?> compressImage(String filePath) async => _compressResult;

  @override
  Future<String?> uploadImage({
    required String filePath,
    required String bucketName,
    String? folder,
    File? precompressedFile,
  }) async {
    throw ImageValidationException('Test validation error');
  }
}
