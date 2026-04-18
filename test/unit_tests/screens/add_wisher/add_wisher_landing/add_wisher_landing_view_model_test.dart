import 'dart:async';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

void main() {
  group('AddWisherLandingViewModel', () {
    late LoadingController loadingController;

    setUp(() {
      loadingController = LoadingController();
    });

    AddWisherLandingViewModel createViewModel({
      required AddWisherContactAccess contactAccess,
      required AddWisherContactBatchImporter contactBatchImporter,
      AddWisherContactPhotoFileBridge? photoFileBridge,
    }) => AddWisherLandingViewModel(
      contactAccess: contactAccess,
      contactBatchImporter: contactBatchImporter,
      photoFileBridge: photoFileBridge,
    );

    Widget buildTestWidget(AddWisherLandingViewModel viewModel) {
      late GoRouter router;
      router = GoRouter(
        initialLocation: '/home',
        routes: [
          GoRoute(
            path: '/home',
            builder: (context, state) => Scaffold(
              body: Builder(
                builder: (context) => ElevatedButton(
                  onPressed: () => context.push('/landing'),
                  child: const Text('Open Landing'),
                ),
              ),
            ),
          ),
          GoRoute(
            path: '/landing',
            builder: (context, state) => Scaffold(
              body: Column(
                children: [
                  ElevatedButton(
                    key: const Key('contacts-btn'),
                    onPressed: () =>
                        viewModel.tapAddFromContactsButton(context),
                    child: const Text('Contacts'),
                  ),
                  ElevatedButton(
                    key: const Key('manual-btn'),
                    onPressed: () => viewModel.tapAddManuallyButton(context),
                    child: const Text('Manual'),
                  ),
                ],
              ),
            ),
            routes: [
              GoRoute(
                path: 'details',
                name: Routes.addWisherDetails.name,
                builder: (context, state) =>
                    const Scaffold(body: Text('Details Screen')),
              ),
            ],
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
          routerConfig: router,
        ),
      );
    }

    Future<void> openLanding(
      WidgetTester tester,
      AddWisherLandingViewModel viewModel,
    ) async {
      await tester.pumpWidget(buildTestWidget(viewModel));
      await TestHelpers.pumpAndSettle(tester);
      await TestHelpers.tapAndSettle(tester, find.text('Open Landing'));
    }

    group(TestGroups.initialState, () {
      test('implements AddWisherLandingViewModelContract', () {
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: const AddWisherContactAccessCancelled(),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
          ),
        );

        expect(viewModel, isA<AddWisherLandingViewModelContract>());
      });

      test('extends ChangeNotifier', () {
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: const AddWisherContactAccessCancelled(),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
          ),
        );

        expect(viewModel, isA<ChangeNotifier>());
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('tapAddManuallyButton keeps manual routing intact', (
        WidgetTester tester,
      ) async {
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: const AddWisherContactAccessCancelled(),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
          ),
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('manual-btn')),
        );

        expect(find.text('Details Screen'), findsOneWidget);
      });

      testWidgets('shows an error when contacts permission is denied', (
        WidgetTester tester,
      ) async {
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(entries: const []),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: const AddWisherContactAccessPermissionDenied(),
          ),
          contactBatchImporter: importer,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isError, isTrue);
        expect(
          loadingController.message,
          'Contacts permission was denied. Please allow access to continue.',
        );
        expect(importer.callCount, 0);
      });

      testWidgets('does nothing when the contact picker is cancelled', (
        WidgetTester tester,
      ) async {
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(entries: const []),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: const AddWisherContactAccessCancelled(),
          ),
          contactBatchImporter: importer,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isIdle, isTrue);
        expect(importer.callCount, 0);
      });

      testWidgets(
        'aborts overlay updates if screen is unmounted after picker returns',
        (WidgetTester tester) async {
          final selectionCompleter = Completer<AddWisherContactAccessResult>();
          final importer = _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
          );
          final viewModel = createViewModel(
            contactAccess: _FakeContactAccess(
              pendingResult: selectionCompleter.future,
            ),
            contactBatchImporter: importer,
          );
          addTearDown(viewModel.dispose);

          await openLanding(tester, viewModel);

          await tester.tap(find.byKey(const Key('contacts-btn')));
          await tester.pump();
          expect(loadingController.isLoading, isTrue);

          final landingContext = tester.element(
            find.byKey(const Key('manual-btn')),
          );
          GoRouter.of(landingContext).pop();
          await TestHelpers.pumpAndSettle(tester);

          selectionCompleter.complete(const AddWisherContactAccessCancelled());
          await TestHelpers.pumpAndSettle(tester);

          expect(find.text('Open Landing'), findsOneWidget);
          expect(loadingController.isIdle, isTrue);
          expect(importer.callCount, 0);
        },
      );

      testWidgets('cancels duplicate import when warning is dismissed', (
        WidgetTester tester,
      ) async {
        const duplicateDraft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
        );
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(
            entries: const [
              AddWisherContactImportResultEntry(
                draft: duplicateDraft,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: 'wisher-1',
              ),
            ],
          ),
          duplicateReport: AddWisherContactDuplicateReport(
            duplicates: [
              AddWisherContactDuplicateMatch(
                draft: duplicateDraft,
                existingWishers: const [],
                normalizedFullName:
                    AddWisherContactNormalizedFullName.fromParts(
                      firstName: 'Alex',
                      lastName: 'Morgan',
                    ),
              ),
            ],
            nonDuplicates: const [],
          ),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
              ],
            ),
          ),
          contactBatchImporter: importer,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await tester.tap(find.byKey(const Key('contacts-btn')));
        await tester.pump();

        expect(loadingController.isWarning, isTrue);
        expect(
          loadingController.message,
          'Alex Morgan is already a registered wisher. Add them anyway?',
        );
        expect(importer.detectDuplicatesCallCount, 1);
        expect(importer.callCount, 0);

        loadingController.secondaryActionAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(loadingController.isIdle, isTrue);
        expect(importer.callCount, 0);
        expect(find.byKey(const Key('contacts-btn')), findsOneWidget);
      });

      testWidgets('continues duplicate import after confirmation', (
        WidgetTester tester,
      ) async {
        const duplicateDraft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
        );
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(
            entries: const [
              AddWisherContactImportResultEntry(
                draft: duplicateDraft,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: 'wisher-1',
              ),
            ],
          ),
          duplicateReport: AddWisherContactDuplicateReport(
            duplicates: [
              AddWisherContactDuplicateMatch(
                draft: duplicateDraft,
                existingWishers: const [],
                normalizedFullName:
                    AddWisherContactNormalizedFullName.fromParts(
                      firstName: 'Alex',
                      lastName: 'Morgan',
                    ),
              ),
            ],
            nonDuplicates: const [],
          ),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
              ],
            ),
          ),
          contactBatchImporter: importer,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await tester.tap(find.byKey(const Key('contacts-btn')));
        await tester.pump();

        expect(loadingController.isWarning, isTrue);
        expect(importer.callCount, 0);

        loadingController.primaryActionAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(importer.detectDuplicatesCallCount, 1);
        expect(importer.callCount, 1);
        expect(importer.receivedDrafts, [duplicateDraft]);
        expect(loadingController.isSuccess, isTrue);
        expect(loadingController.message, 'Alex Morgan added from contacts.');
      });

      testWidgets('uses plural duplicate warning copy for multiple matches', (
        WidgetTester tester,
      ) async {
        const duplicateDraftOne = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
        );
        const duplicateDraftTwo = AddWisherContactImportDraft(
          sourceId: 'contact-2',
          firstName: 'Taylor',
          lastName: 'Swift',
          sourceDisplayName: 'Taylor Swift',
        );
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(
            entries: const [
              AddWisherContactImportResultEntry(
                draft: duplicateDraftOne,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: 'wisher-1',
              ),
              AddWisherContactImportResultEntry(
                draft: duplicateDraftTwo,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: 'wisher-2',
              ),
            ],
          ),
          duplicateReport: AddWisherContactDuplicateReport(
            duplicates: [
              AddWisherContactDuplicateMatch(
                draft: duplicateDraftOne,
                existingWishers: const [],
                normalizedFullName:
                    AddWisherContactNormalizedFullName.fromParts(
                      firstName: 'Alex',
                      lastName: 'Morgan',
                    ),
              ),
              AddWisherContactDuplicateMatch(
                draft: duplicateDraftTwo,
                existingWishers: const [],
                normalizedFullName:
                    AddWisherContactNormalizedFullName.fromParts(
                      firstName: 'Taylor',
                      lastName: 'Swift',
                    ),
              ),
            ],
            nonDuplicates: const [],
          ),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
                AddWisherContactSelection(
                  sourceId: 'contact-2',
                  firstName: 'Taylor',
                  lastName: 'Swift',
                  originalDisplayName: 'Taylor Swift',
                ),
              ],
            ),
          ),
          contactBatchImporter: importer,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await tester.tap(find.byKey(const Key('contacts-btn')));
        await tester.pump();

        expect(loadingController.isWarning, isTrue);
        expect(
          loadingController.message,
          '2 selected contacts already match existing wishers. '
          'Add them anyway?',
        );

        loadingController.secondaryActionAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(importer.callCount, 0);
      });

      testWidgets('shows success and pops after a full import success', (
        WidgetTester tester,
      ) async {
        final photoFileBridge = _FakePhotoFileBridge(
          fileToReturn: File('/mock/contact-photo.jpg'),
        );
        final imageReference = AddWisherContactImageReference(
          identifier: 'flutter_contacts:contact-1',
          bytes: Uint8List.fromList([1, 2, 3]),
        );
        final draft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
          imageReference: imageReference,
        );
        final importer = _FakeBatchImporter(
          result: AddWisherContactImportResult(
            entries: [
              AddWisherContactImportResultEntry(
                draft: draft,
                status: AddWisherContactImportResultStatus.imported,
                createdWisherId: 'wisher-1',
              ),
            ],
          ),
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                  imageReference: imageReference,
                ),
              ],
            ),
          ),
          contactBatchImporter: importer,
          photoFileBridge: photoFileBridge,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isSuccess, isTrue);
        expect(loadingController.message, 'Alex Morgan added from contacts.');
        expect(loadingController.name, 'Alex Morgan');
        expect(
          loadingController.localImageFile?.path,
          '/mock/contact-photo.jpg',
        );
        expect(importer.callCount, 1);
        expect(importer.receivedDrafts, [draft]);
        expect(photoFileBridge.lastCreatedReference, equals(imageReference));

        loadingController.acknowledgeAndClear();
        await TestHelpers.pumpAndSettle(tester);

        expect(
          photoFileBridge.lastDeletedFile?.path,
          '/mock/contact-photo.jpg',
        );
        expect(find.text('Open Landing'), findsOneWidget);
        expect(find.byKey(const Key('contacts-btn')), findsNothing);
      });

      testWidgets('shows personalized success without photo', (
        WidgetTester tester,
      ) async {
        const draft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
        );
        final photoFileBridge = _FakePhotoFileBridge();
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
              ],
            ),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(
              entries: const [
                AddWisherContactImportResultEntry(
                  draft: draft,
                  status: AddWisherContactImportResultStatus.imported,
                  createdWisherId: 'wisher-1',
                ),
              ],
            ),
          ),
          photoFileBridge: photoFileBridge,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isSuccess, isTrue);
        expect(loadingController.name, 'Alex Morgan');
        expect(loadingController.localImageFile, isNull);
        expect(photoFileBridge.lastCreatedReference, isNull);
      });

      testWidgets('cleans up success overlay photo when overlay is hidden', (
        WidgetTester tester,
      ) async {
        final photoFileBridge = _FakePhotoFileBridge(
          fileToReturn: File('/mock/contact-photo.jpg'),
        );
        final imageReference = AddWisherContactImageReference(
          identifier: 'flutter_contacts:contact-1',
          bytes: Uint8List.fromList([1, 2, 3]),
        );
        final draft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
          imageReference: imageReference,
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                  imageReference: imageReference,
                ),
              ],
            ),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(
              entries: [
                AddWisherContactImportResultEntry(
                  draft: draft,
                  status: AddWisherContactImportResultStatus.imported,
                  createdWisherId: 'wisher-1',
                ),
              ],
            ),
          ),
          photoFileBridge: photoFileBridge,
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isSuccess, isTrue);
        expect(
          loadingController.localImageFile?.path,
          '/mock/contact-photo.jpg',
        );

        loadingController.hide();
        await TestHelpers.pumpAndSettle(tester);
        await tester.pump(const Duration(milliseconds: 150));

        expect(
          photoFileBridge.lastDeletedFile?.path,
          '/mock/contact-photo.jpg',
        );
        expect(loadingController.isIdle, isTrue);
      });

      testWidgets('shows success with partial failure details', (
        WidgetTester tester,
      ) async {
        const importedDraft = AddWisherContactImportDraft(
          sourceId: 'contact-1',
          firstName: 'Alex',
          lastName: 'Morgan',
          sourceDisplayName: 'Alex Morgan',
        );
        const failedDraft = AddWisherContactImportDraft(
          sourceId: 'contact-2',
          firstName: 'Taylor',
          lastName: 'Swift',
          sourceDisplayName: 'Taylor Swift',
        );
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
                AddWisherContactSelection(
                  sourceId: 'contact-2',
                  firstName: 'Taylor',
                  lastName: 'Swift',
                  originalDisplayName: 'Taylor Swift',
                ),
              ],
            ),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(
              entries: const [
                AddWisherContactImportResultEntry(
                  draft: importedDraft,
                  status: AddWisherContactImportResultStatus.imported,
                  createdWisherId: 'wisher-1',
                ),
                AddWisherContactImportResultEntry(
                  draft: failedDraft,
                  status: AddWisherContactImportResultStatus.failed,
                  message: 'network error',
                ),
              ],
            ),
          ),
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isSuccess, isTrue);
        expect(
          loadingController.message,
          'Added 1 contacts. 1 couldn\'t be added.',
        );
      });

      testWidgets(
        'shows an error when every selected contact fails to import',
        (WidgetTester tester) async {
          const failedDraft = AddWisherContactImportDraft(
            sourceId: 'contact-1',
            firstName: 'Alex',
            lastName: 'Morgan',
            sourceDisplayName: 'Alex Morgan',
          );
          final viewModel = createViewModel(
            contactAccess: _FakeContactAccess(
              result: AddWisherContactAccessSelection(
                selections: const [
                  AddWisherContactSelection(
                    sourceId: 'contact-1',
                    firstName: 'Alex',
                    lastName: 'Morgan',
                    originalDisplayName: 'Alex Morgan',
                  ),
                ],
              ),
            ),
            contactBatchImporter: _FakeBatchImporter(
              result: AddWisherContactImportResult(
                entries: const [
                  AddWisherContactImportResultEntry(
                    draft: failedDraft,
                    status: AddWisherContactImportResultStatus.failed,
                    message: 'repository error',
                  ),
                ],
              ),
            ),
          );
          addTearDown(viewModel.dispose);

          await openLanding(tester, viewModel);

          await TestHelpers.tapAndSettle(
            tester,
            find.byKey(const Key('contacts-btn')),
          );

          expect(loadingController.isError, isTrue);
          expect(
            loadingController.message,
            'We couldn\'t add the selected contact. Please try again.',
          );
        },
      );

      testWidgets('shows an error when contact access fails unexpectedly', (
        WidgetTester tester,
      ) async {
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            exception: AddWisherContactAccessException('boom'),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
          ),
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isError, isTrue);
        expect(
          loadingController.message,
          'We couldn\'t access your contacts right now. Please try again.',
        );
      });

      testWidgets('shows an error when import orchestration throws', (
        WidgetTester tester,
      ) async {
        final viewModel = createViewModel(
          contactAccess: _FakeContactAccess(
            result: AddWisherContactAccessSelection(
              selections: const [
                AddWisherContactSelection(
                  sourceId: 'contact-1',
                  firstName: 'Alex',
                  lastName: 'Morgan',
                  originalDisplayName: 'Alex Morgan',
                ),
              ],
            ),
          ),
          contactBatchImporter: _FakeBatchImporter(
            result: AddWisherContactImportResult(entries: const []),
            exception: Exception('repository crash'),
          ),
        );
        addTearDown(viewModel.dispose);

        await openLanding(tester, viewModel);

        await TestHelpers.tapAndSettle(
          tester,
          find.byKey(const Key('contacts-btn')),
        );

        expect(loadingController.isError, isTrue);
        expect(
          loadingController.message,
          'We couldn\'t access your contacts right now. Please try again.',
        );
      });
    });
  });
}

class _FakeContactAccess extends AddWisherContactAccess {
  _FakeContactAccess({this.result, this.exception, this.pendingResult})
    : super(
        requestPermission: () async => true,
        pickContactId: () async => null,
        loadContact: (_) async => null,
      );

  final AddWisherContactAccessResult? result;
  final AddWisherContactAccessException? exception;
  final Future<AddWisherContactAccessResult>? pendingResult;
  int callCount = 0;

  @override
  Future<AddWisherContactAccessResult> selectContacts() async {
    callCount += 1;

    if (exception != null) {
      throw exception!;
    }

    if (pendingResult != null) {
      return pendingResult!;
    }

    return result!;
  }
}

class _FakeBatchImporter extends AddWisherContactBatchImporter {
  _FakeBatchImporter({
    required this.result,
    this.exception,
    AddWisherContactDuplicateReport? duplicateReport,
  }) : duplicateReport =
           duplicateReport ??
           AddWisherContactDuplicateReport(
             duplicates: const [],
             nonDuplicates: const [],
           ),
       super(
         authRepository: MockAuthRepository(),
         imageRepository: MockImageRepository(),
         wisherRepository: MockWisherRepository(),
       );

  final AddWisherContactImportResult result;
  final Exception? exception;
  final AddWisherContactDuplicateReport duplicateReport;
  int callCount = 0;
  int detectDuplicatesCallCount = 0;
  List<AddWisherContactImportDraft>? duplicateDetectionDrafts;
  List<AddWisherContactImportDraft>? receivedDrafts;

  @override
  AddWisherContactDuplicateReport detectDuplicates(
    List<AddWisherContactImportDraft> drafts,
  ) {
    detectDuplicatesCallCount += 1;
    duplicateDetectionDrafts = drafts;
    return duplicateReport;
  }

  @override
  Future<AddWisherContactImportResult> importDrafts(
    List<AddWisherContactImportDraft> drafts,
  ) async {
    callCount += 1;
    receivedDrafts = drafts;
    if (exception != null) {
      throw exception!;
    }
    return result;
  }
}

class _FakePhotoFileBridge extends AddWisherContactPhotoFileBridge {
  _FakePhotoFileBridge({this.fileToReturn});

  final File? fileToReturn;
  AddWisherContactImageReference? lastCreatedReference;
  File? lastDeletedFile;

  @override
  Future<File?> createTemporaryFile(
    AddWisherContactImageReference imageReference,
  ) async {
    lastCreatedReference = imageReference;
    return fileToReturn;
  }

  @override
  Future<void> deleteTemporaryFile(File? tempImageFile) async {
    lastDeletedFile = tempImageFile;
  }
}
