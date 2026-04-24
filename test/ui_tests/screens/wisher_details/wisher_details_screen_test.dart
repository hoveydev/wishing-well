import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  group('WisherDetailsScreen', () {
    late MockWisherRepository mockWisherRepository;

    setUp(() {
      mockWisherRepository = MockWisherRepository();
    });

    group('Rendering', () {
      testWidgets('renders screen with all required UI elements', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Screen), findsOneWidget);
        expect(find.byType(AppMenuBar), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);
      });

      testWidgets('renders wisher name when wisher is found', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Test'), findsOneWidget);
      });

      testWidgets('renders edit icon button when wisher is loaded', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit_outlined), findsOneWidget);
      });

      testWidgets('renders delete button when wisher is loaded', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Delete Wisher'), findsOneWidget);
      });
    });

    group('Interaction', () {
      testWidgets('shows close button in app bar by default', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.close), findsOneWidget);
        expect(find.byIcon(Icons.arrow_back_ios_new), findsNothing);
      });

      testWidgets('shows back button when navigated from all wishers', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
          isFromAllWishers: true,
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.close), findsNothing);
      });

      testWidgets('responds to ViewModel state changes', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Test'), findsOneWidget);

        viewModel.notifyListeners();
        await tester.pumpAndSettle();

        expect(find.text('Alice Test'), findsOneWidget);
      });

      testWidgets('handles rapid state changes without errors', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        for (int i = 0; i < 10; i++) {
          viewModel.notifyListeners();
          await tester.pumpAndSettle();
        }

        expect(find.text('Alice Test'), findsOneWidget);
      });
    });

    group('State Management', () {
      testWidgets('rebuilds from the injected view model', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(WisherDetailsScreen), findsOneWidget);
        expect(find.text('Alice Test'), findsOneWidget);
      });

      testWidgets('renders the injected view model state', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Alice Test'), findsOneWidget);
      });

      testWidgets('disposes view model when screen is removed', (
        WidgetTester tester,
      ) async {
        final trackedViewModel = _TrackedWisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: trackedViewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.pumpWidget(const SizedBox.shrink());
        await tester.pumpAndSettle();

        expect(trackedViewModel.disposeCallCount, 1);
      });
    });

    group('Different Wisher IDs', () {
      testWidgets('displays different wisher when initialized with other ID', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Bob Test'), findsOneWidget);
      });

      testWidgets('correctly displays multiple wishers in sequence', (
        WidgetTester tester,
      ) async {
        final vm1 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(child: WisherDetailsScreen(viewModel: vm1)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Alice Test'), findsOneWidget);

        final vm2 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        await tester.pumpWidget(
          createScreenTestWidget(child: WisherDetailsScreen(viewModel: vm2)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Bob Test'), findsOneWidget);
      });
    });

    group('Accessibility', () {
      testWidgets('renders text with appropriate semantics', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Text), findsWidgets);
      });
    });

    group('Error Handling', () {
      test('wisher is null when ID does not exist', () {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'invalid-id-that-does-not-exist',
        );
        expect(viewModel.wisher, isNull);
        expect(viewModel.isLoading, isFalse);
        viewModel.dispose();
      });
    });

    group('GoRouter Interaction', () {
      Widget buildGoRouterTestWidget(WisherDetailsViewModel viewModel) {
        final loadingController = StatusOverlayController();
        final goRouter = GoRouter(
          initialLocation: '/wisher-details/1',
          routes: [
            GoRoute(
              path: '/wisher-details/:id',
              builder: (context, state) =>
                  WisherDetailsScreen(viewModel: viewModel),
              routes: [
                GoRoute(
                  path: Routes.editWisher.path,
                  builder: (context, state) =>
                      const Scaffold(body: Center(child: Text('Edit Screen'))),
                ),
              ],
            ),
            GoRoute(
              path: '/home',
              builder: (context, state) =>
                  const Scaffold(body: Center(child: Text('Home Screen'))),
            ),
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

      testWidgets('tapping edit button invokes tapEditWisher', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        await tester.pumpWidget(buildGoRouterTestWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byIcon(Icons.edit_outlined));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Edit Screen'), findsOneWidget);
      });

      testWidgets('tapping delete button shows Dialog', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        await tester.pumpWidget(buildGoRouterTestWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Delete Wisher'));
        await tester.pumpAndSettle();

        expect(find.byType(Dialog), findsOneWidget);
      });
    });
  });
}

class _TrackedWisherDetailsViewModel extends WisherDetailsViewModel {
  _TrackedWisherDetailsViewModel({
    required super.wisherRepository,
    required super.wisherId,
  });

  int disposeCallCount = 0;

  @override
  void dispose() {
    disposeCallCount += 1;
    super.dispose();
  }
}
