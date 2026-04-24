import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';
import 'package:wishing_well/utils/result.dart';

void main() {
  group('WisherDetailsViewModel', () {
    late MockWisherRepository mockWisherRepository;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
    });

    group('Initialization', () {
      test('initializes with loading state false', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('wisher is null when ID is not found', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('initializes with correct wisherId lookup', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Alice');

        viewModel.dispose();
      });
    });

    group('Wisher Loading', () {
      test('finds wisher from cached list by ID', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Alice');

        viewModel.dispose();
      });

      test('wisher is null when ID is not found in cache', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'definitely-not-a-real-id',
        );

        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('wisher is null for empty wisherId', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '',
        );

        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('finds correct wisher when multiple wishers exist', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        expect(viewModel.wisher, isNotNull);
        expect(viewModel.wisher!.firstName, 'Bob');

        viewModel.dispose();
      });
    });

    group('Repository Listener', () {
      test('updates wisher when repository changes', () async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.wisher?.firstName, 'Alice');

        final updatedAlice = Wisher(
          id: '1',
          userId: 'test-user',
          firstName: 'Alicia',
          lastName: 'Test',
          createdAt: DateTime(2024),
          updatedAt: DateTime.now(),
        );

        await mockWisherRepository.updateWisher(updatedAlice);

        expect(viewModel.wisher?.firstName, 'Alicia');

        viewModel.dispose();
      });

      test('notifies listeners when repository changes', () async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        var notifyCount = 0;
        viewModel.addListener(() => notifyCount++);

        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 10));

        expect(notifyCount, greaterThan(0));

        viewModel.dispose();
      });
    });

    group('Loading State', () {
      test('initializes with isLoading false after construction', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('updates listeners when loading completes', () async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notificationCount, greaterThan(0));

        viewModel.dispose();
      });
    });

    group('Listener Management', () {
      test('cleans up listener on dispose', () async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        var notificationCount = 0;
        viewModel.addListener(() {
          notificationCount++;
        });

        viewModel.dispose();

        final tempVm = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        mockWisherRepository.notifyListeners();
        await Future.delayed(const Duration(milliseconds: 50));

        expect(notificationCount, 0);

        tempVm.dispose();
      });
    });

    group('Contract Implementation', () {
      test('implements WisherDetailsViewModelContract', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel, isA<WisherDetailsViewModelContract>());

        viewModel.dispose();
      });

      test('exposes wisher through contract', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        final Wisher? wisher = viewModel.wisher;
        expect(wisher, isNotNull);

        viewModel.dispose();
      });

      test('exposes isLoading through contract', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        final bool isLoading = viewModel.isLoading;
        expect(isLoading, isFalse);

        viewModel.dispose();
      });

      test('contract has tapDeleteWisher method', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        final contract = viewModel as WisherDetailsViewModelContract;
        expect(contract.tapDeleteWisher, isNotNull);

        viewModel.dispose();
      });

      test('contract has tapEditWisher method', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        final contract = viewModel as WisherDetailsViewModelContract;
        expect(contract.tapEditWisher, isNotNull);

        viewModel.dispose();
      });
    });

    group('Edge Cases', () {
      test('wisher is null for empty wisherId', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '',
        );

        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);

        viewModel.dispose();
      });

      test('can construct multiple instances with different IDs', () {
        final vm1 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        final vm2 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        expect(vm1.wisher!.firstName, 'Alice');
        expect(vm2.wisher!.firstName, 'Bob');
        expect(vm1.wisher!.id, isNot(vm2.wisher!.id));

        vm1.dispose();
        vm2.dispose();
      });

      test('works with all mock repository wishers', () {
        final ids = ['1', '2', '3', '4'];
        final expectedNames = ['Alice', 'Bob', 'Charlie', 'Diana'];

        for (int i = 0; i < ids.length; i++) {
          final vm = WisherDetailsViewModel(
            wisherRepository: mockWisherRepository,
            wisherId: ids[i],
          );

          expect(vm.wisher, isNotNull);
          expect(vm.wisher!.firstName, expectedNames[i]);

          vm.dispose();
        }
      });
    });

    group('menuBarType', () {
      test('returns close when not from all wishers (default)', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.menuBarType, AppMenuBarType.close);

        viewModel.dispose();
      });

      test('returns back when isFromAllWishers is true', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
          isFromAllWishers: true,
        );

        expect(viewModel.menuBarType, AppMenuBarType.back);

        viewModel.dispose();
      });

      test('returns close when isFromAllWishers is false', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        expect(viewModel.menuBarType, AppMenuBarType.close);

        viewModel.dispose();
      });
    });

    group('tapDeleteWisher and tapEditWisher', () {
      late StatusOverlayController loadingController;

      Widget buildRouterWidget(
        WisherDetailsViewModel viewModel, {
        List<GoRoute> extraRoutes = const [],
      }) {
        late GoRouter goRouter;
        goRouter = GoRouter(
          initialLocation: '/home',
          routes: [
            GoRoute(
              path: '/home',
              builder: (context, state) => Scaffold(
                body: Builder(
                  builder: (context) => ElevatedButton(
                    onPressed: () => goRouter.push('/test'),
                    child: const Text('Go to test'),
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/test',
              builder: (context, state) => Scaffold(
                body: Builder(
                  builder: (context) => Column(
                    children: [
                      ElevatedButton(
                        key: const Key('delete-btn'),
                        onPressed: () => viewModel.tapDeleteWisher(context),
                        child: const Text('Trigger Delete'),
                      ),
                      ElevatedButton(
                        key: const Key('edit-btn'),
                        onPressed: () => viewModel.tapEditWisher(context),
                        child: const Text('Edit'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            GoRoute(
              path: '/wisher-details/:id/edit',
              builder: (context, state) =>
                  const Scaffold(body: Text('Edit Screen')),
            ),
            ...extraRoutes,
          ],
        );

        return ChangeNotifierProvider<StatusOverlayController>.value(
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

      Future<void> navigateToTestPage(WidgetTester tester) async {
        await tester.tap(find.text('Go to test'));
        await TestHelpers.pumpAndSettle(tester);
      }

      setUp(() {
        loadingController = StatusOverlayController();
      });

      testWidgets('tapDeleteWisher shows Dialog', (WidgetTester tester) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('delete-btn')));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
      });

      testWidgets('tapDeleteWisher cancel does not delete wisher', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        final initialCount = mockWisherRepository.wishers.length;

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('delete-btn')));
        await tester.pumpAndSettle();

        // Tap Cancel
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsNothing);
        expect(mockWisherRepository.wishers.length, initialCount);
      });

      testWidgets('tapDeleteWisher confirm success deletes wisher', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        final initialCount = mockWisherRepository.wishers.length;

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('delete-btn')));
        await tester.pumpAndSettle();

        // Tap Delete to confirm
        await tester.tap(find.text('Delete'));
        await tester.pump();

        expect(mockWisherRepository.wishers.length, initialCount - 1);
        expect(mockWisherRepository.wishers.any((w) => w.id == '1'), isFalse);
      });

      testWidgets('tapDeleteWisher confirm success hides loading before pop', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('delete-btn')));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Delete'));
        await tester.pump();

        // After successful delete, loading.hide() is called so it goes
        // back to idle before popping
        expect(loadingController.isIdle, isTrue);
      });

      testWidgets('tapDeleteWisher confirm error shows error overlay', (
        WidgetTester tester,
      ) async {
        final errorRepo = MockWisherRepository(
          deleteWisherResult: Result.error(Exception('delete failed')),
        );
        final viewModel = WisherDetailsViewModel(
          wisherRepository: errorRepo,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);
        addTearDown(errorRepo.dispose);

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('delete-btn')));
        await tester.pumpAndSettle();

        // Confirm delete
        await tester.tap(find.text('Delete'));
        await tester.pump();

        // Loading controller should be in error state
        expect(loadingController.isError, isTrue);
      });

      testWidgets('tapEditWisher navigates to edit screen', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(buildRouterWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);
        await navigateToTestPage(tester);

        await tester.tap(find.byKey(const Key('edit-btn')));
        await tester.pumpAndSettle();

        expect(find.text('Edit Screen'), findsOneWidget);
      });
    });
  });
}
