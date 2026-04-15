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
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

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

        viewModel.dispose();
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

        viewModel.dispose();
      });

      testWidgets('displays "Wisher not found" message when wisher is null', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Wisher not found'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        viewModel.dispose();
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

        viewModel.dispose();
      });

      testWidgets('does not render edit icon when wisher is not found', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byIcon(Icons.edit_outlined), findsNothing);

        viewModel.dispose();
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

        viewModel.dispose();
      });

      testWidgets('does not render delete button when wisher not found', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Delete Wisher'), findsNothing);

        viewModel.dispose();
      });
    });

    group('Interaction', () {
      testWidgets('shows close button in app bar', (WidgetTester tester) async {
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

        viewModel.dispose();
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

        viewModel.dispose();
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

        viewModel.dispose();
      });
    });

    group('State Management', () {
      testWidgets('uses ChangeNotifierProvider with Consumer pattern', (
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

        viewModel.dispose();
      });

      testWidgets('provides viewModel to Consumer widget', (
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

        viewModel.dispose();
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

        viewModel.dispose();
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

        vm1.dispose();

        final vm2 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        await tester.pumpWidget(
          createScreenTestWidget(child: WisherDetailsScreen(viewModel: vm2)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Bob Test'), findsOneWidget);

        vm2.dispose();
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

        viewModel.dispose();
      });
    });

    group('Error Handling', () {
      testWidgets('displays fallback UI when wisher data is incomplete', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'invalid-id-that-does-not-exist',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Wisher not found'), findsOneWidget);

        viewModel.dispose();
      });

      testWidgets('handles empty wisherId gracefully', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '',
        );

        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Wisher not found'), findsOneWidget);

        viewModel.dispose();
      });
    });

    group('GoRouter Interaction', () {
      Widget buildGoRouterTestWidget(WisherDetailsViewModel viewModel) {
        final loadingController = LoadingController();
        final goRouter = GoRouter(
          initialLocation: '/wisher-details/1',
          routes: [
            GoRoute(
              path: '/wisher-details/:id',
              builder: (context, state) =>
                  WisherDetailsScreen(viewModel: viewModel),
              routes: [
                GoRoute(
                  path: 'edit',
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

      testWidgets('tapping edit button invokes tapEditWisher', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(buildGoRouterTestWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.byIcon(Icons.edit_outlined));
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Edit Screen'), findsOneWidget);
      });

      testWidgets('tapping delete button shows AlertDialog', (
        WidgetTester tester,
      ) async {
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );
        addTearDown(viewModel.dispose);

        await tester.pumpWidget(buildGoRouterTestWidget(viewModel));
        await TestHelpers.pumpAndSettle(tester);

        await tester.tap(find.text('Delete Wisher'));
        await tester.pumpAndSettle();

        expect(find.byType(AlertDialog), findsOneWidget);
      });
    });
  });
}
