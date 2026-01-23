import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/screens/profile_screen/profile_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';

import '../../../../testing_resources/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late ProfileViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository(logoutResult: const Result.ok(null));
    viewModel = ProfileViewModel(authRepository: authRepository);
  });

  group('ProfileViewModel', () {
    test('hasAlert returns false when no error', () {
      expect(viewModel.hasAlert, false);
    });

    test('authError is ProfileErrorType.none initially', () {
      final error = viewModel.authError;
      expect(error, isA<UIAuthError>());
      expect((error as UIAuthError).type, ProfileErrorType.none);
    });

    test('clearError can be called without error', () {
      expect(() => viewModel.clearError(), returnsNormally);
      expect(viewModel.hasAlert, false);
    });
  });
}
