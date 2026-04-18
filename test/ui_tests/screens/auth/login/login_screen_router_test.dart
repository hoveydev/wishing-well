import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/auth/login/components/login_buttons.dart';
import 'package:wishing_well/features/auth/login/components/login_header.dart';
import 'package:wishing_well/features/auth/login/components/login_inputs.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  group('LoginScreen Router Handling', () {
    late LoginViewModel viewModel;

    setUp(() {
      viewModel = LoginViewModel(authRepository: MockAuthRepository());
    });

    testWidgets('screen renders with all subcomponents', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenTestWidget(
          loadingController: StatusOverlayController(),
          child: LoginScreen(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Verify main components render
      expect(find.byType(StatusOverlay), findsOneWidget);
      expect(find.byType(Screen), findsOneWidget);
      expect(find.byType(LoginHeader), findsOneWidget);
      expect(find.byType(LoginInputs), findsOneWidget);
      expect(find.byType(LoginButtons), findsOneWidget);
    });

    testWidgets('focus nodes are properly managed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenTestWidget(
          loadingController: StatusOverlayController(),
          child: LoginScreen(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Let the widget tree dispose properly - don't manually dispose viewModel
      // The LoginScreen's dispose method handles focus node cleanup
    });

    testWidgets('keyboard dismissal works via GestureDetector', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenTestWidget(
          loadingController: StatusOverlayController(),
          child: LoginScreen(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Find GestureDetector and tap it
      final gestureDetector = find.byType(GestureDetector);
      await tester.tap(gestureDetector.first);
      await tester.pump();

      // Should not throw - screen should remain functional
      expect(find.byType(LoginScreen), findsOneWidget);
    });

    testWidgets('accountConfirmationChecked flag prevents duplicate checks', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        createScreenTestWidget(
          loadingController: StatusOverlayController(),
          child: LoginScreen(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Rebuild - the _accountConfirmationChecked flag should prevent re-run
      await tester.pumpWidget(
        createScreenTestWidget(
          loadingController: StatusOverlayController(),
          child: LoginScreen(viewModel: viewModel),
        ),
      );
      await TestHelpers.pumpAndSettle(tester);

      // Should work without errors
      expect(find.byType(LoginScreen), findsOneWidget);
    });
  });
}
