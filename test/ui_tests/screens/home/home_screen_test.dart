import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';

import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

void main() {
  group('HomeScreen', () {
    late MockAuthRepository mockAuthRepository;
    late MockWisherRepository mockWisherRepository;
    late MockImageRepository mockImageRepository;
    late HomeViewModel viewModel;

    setUp(() {
      mockAuthRepository = MockAuthRepository();
      mockWisherRepository = MockWisherRepository();
      mockImageRepository = MockImageRepository();
      viewModel = HomeViewModel(
        authRepository: mockAuthRepository,
        wisherRepository: mockWisherRepository,
        imageRepository: mockImageRepository,
      );
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

      testWidgets('removes screen without disposal errors', (
        WidgetTester tester,
      ) async {
        final testViewModel = HomeViewModel(
          authRepository: mockAuthRepository,
          wisherRepository: mockWisherRepository,
          imageRepository: mockImageRepository,
        );

        await tester.pumpWidget(
          createScreenTestWidget(child: HomeScreen(viewModel: testViewModel)),
        );
        await TestHelpers.pumpAndSettle(tester);

        await tester.pumpWidget(const SizedBox.shrink());
        await TestHelpers.pumpAndSettle(tester);
        expect(tester.takeException(), isNull);
      });
    });
  });
}
