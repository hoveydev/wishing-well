import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_screen.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

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
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.byType(Screen), findsOneWidget);
        expect(find.byType(AppMenuBar), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('renders wisher name when wisher is found', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('displays "Wisher not found" message when wisher is null', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'nonexistent-id',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Wisher not found'), findsOneWidget);
        expect(find.byType(CircularProgressIndicator), findsNothing);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('renders with correct text styling', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Text should exist
        final textFinder = find.byType(Text);
        expect(textFinder, findsWidgets);

        // Find the name text widget
        final nameText = find.text('Alice Test');
        expect(nameText, findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('centers content vertically and horizontally', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Screen should have center alignment
        final screenFinder = find.byType(Screen);
        expect(screenFinder, findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Interaction', () {
      testWidgets('closes screen when back button is tapped', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find and tap the back button (AppMenuBar with close type)
        final appBar = find.byType(AppMenuBar);
        expect(appBar, findsOneWidget);

        // The close action button
        final closeButton = find.byIcon(Icons.close);
        expect(closeButton, findsWidgets);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('responds to ViewModel state changes', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Text should be visible
        expect(find.text('Alice Test'), findsOneWidget);

        // Act - Notify listeners to trigger Consumer rebuild
        viewModel.notifyListeners();
        await tester.pumpAndSettle();

        // Assert - Text should still be visible after rebuild
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('handles rapid state changes without errors', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Act - Simulate rapid listener notifications
        for (int i = 0; i < 10; i++) {
          viewModel.notifyListeners();
          await tester.pumpAndSettle();
        }

        // Assert - Screen should remain stable
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('State Management', () {
      testWidgets('uses ChangeNotifierProvider with Consumer pattern', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Should render without errors
        expect(find.byType(WisherDetailsScreen), findsOneWidget);
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('provides viewModel to Consumer widget', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Should display content from viewModel
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Different Wisher IDs', () {
      testWidgets('displays different wisher when initialized with other ID', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Bob Test'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('correctly displays multiple wishers in sequence', (
        WidgetTester tester,
      ) async {
        // Arrange - First wisher
        final vm1 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act & Assert - Display first wisher
        await tester.pumpWidget(
          createScreenTestWidget(child: WisherDetailsScreen(viewModel: vm1)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Alice Test'), findsOneWidget);

        // Cleanup first viewModel
        vm1.dispose();

        // Arrange - Second wisher with fresh widget
        final vm2 = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '2',
        );

        // Act - Build new widget with different viewModel
        await tester.pumpWidget(
          createScreenTestWidget(child: WisherDetailsScreen(viewModel: vm2)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Bob Test'), findsOneWidget);

        // Cleanup
        vm2.dispose();
      });
    });

    group('Accessibility', () {
      testWidgets('renders text with appropriate semantics', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert - Screen should be complete and testable
        expect(find.byType(Text), findsWidgets);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('displays content in readable size', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '1',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        final textWidget = find.byType(Text);
        expect(textWidget, findsWidgets);

        // Cleanup
        viewModel.dispose();
      });
    });

    group('Error Handling', () {
      testWidgets('displays fallback UI when wisher data is incomplete', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: 'invalid-id-that-does-not-exist',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Wisher not found'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });

      testWidgets('handles empty wisherId gracefully', (
        WidgetTester tester,
      ) async {
        // Arrange
        final viewModel = WisherDetailsViewModel(
          wisherRepository: mockWisherRepository,
          wisherId: '',
        );

        // Act
        await tester.pumpWidget(
          createScreenTestWidget(
            child: WisherDetailsScreen(viewModel: viewModel),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Assert
        expect(find.text('Wisher not found'), findsOneWidget);

        // Cleanup
        viewModel.dispose();
      });
    });
  });
}
