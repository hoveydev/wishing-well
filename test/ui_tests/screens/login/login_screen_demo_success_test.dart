import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/auth/login/login_screen.dart';
import 'package:wishing_well/features/auth/login/login_view_model.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late LoginViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository();
    viewModel = LoginViewModel(authRepository: authRepository);
  });

  tearDown(() {
    viewModel.dispose();
  });

  group('LoginScreen showDemoSuccess parameter', () {
    test('constructor accepts showDemoSuccess true', () {
      // Verifies LoginScreen can be constructed with showDemoSuccess=true
      final screen = LoginScreen(viewModel: viewModel, showDemoSuccess: true);

      expect(screen.showDemoSuccess, true);
    });

    test('constructor defaults showDemoSuccess to false', () {
      final screen = LoginScreen(viewModel: viewModel);

      expect(screen.showDemoSuccess, false);
    });
  });
}
