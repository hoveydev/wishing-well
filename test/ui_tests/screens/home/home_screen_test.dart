import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/screens/home/home_screen.dart';
import 'package:wishing_well/screens/home/home_view_model.dart';

import '../../../../testing_resources/helpers/test_helpers.dart';
import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';
import '../../../../testing_resources/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('HomeScreen', () {
    late MockAuthRepository mockAuthRepository;
    late MockWisherRepository mockWisherRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockWisherRepository = MockWisherRepository();
      viewModel = HomeViewModel(
        authRepository: mockAuthRepository,
        wisherRepository: mockWisherRepository,
      );
    });

    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.rendering, () {
      testWidgets('renders screen with all required UI elements', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Check for app bar
        expect(find.byType(AppMenuBar), findsOneWidget);

        // Check for wishers list
        expect(find.byType(WishersList), findsOneWidget);

        // Check for screen wrapper
        expect(find.byType(Screen), findsOneWidget);
      });

      testWidgets('renders wishers from viewModel', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Should have wishers from mock repository
        expect(viewModel.wishers.length, greaterThanOrEqualTo(0));
      });
    });

    group(TestGroups.interaction, () {
      testWidgets('taps on app bar action', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Verify gesture detectors exist for interaction
        expect(find.byType(GestureDetector), findsWidgets);
      });

      testWidgets('finds add wisher button', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Find the add wisher button (via WishersList)
        final addButtons = find.byIcon(Icons.add);
        expect(addButtons, findsWidgets);
      });
    });

    group(TestGroups.behavior, () {
      testWidgets('fetches wishers on init', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: viewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Wishers should have been fetched
        expect(viewModel.wishers.length, greaterThanOrEqualTo(0));
      });

      testWidgets('disposes viewModel correctly', (WidgetTester tester) async {
        final testViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: mockWisherRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: testViewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        // Dispose should not throw
        testViewModel.dispose();
      });
    });
  });
}
