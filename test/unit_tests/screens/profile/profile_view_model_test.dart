import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/features/profile/profile_view_model.dart';
import 'package:wishing_well/utils/auth_error.dart';
import 'package:wishing_well/utils/result.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';

void main() {
  late MockAuthRepository authRepository;
  late ProfileViewModel viewModel;

  setUp(() {
    authRepository = MockAuthRepository(logoutResult: const Result.ok(null));
    viewModel = ProfileViewModel(authRepository: authRepository);
  });

  group('ProfileViewModel', () {
    tearDown(() {
      viewModel.dispose();
    });

    group(TestGroups.initialState, () {
      test('implements ProfileViewModelContract', () {
        expect(viewModel, isA<ProfileViewModelContract>());
      });

      test('extends ChangeNotifier', () {
        expect(viewModel, isA<ChangeNotifier>());
      });

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

    group(TestGroups.errorHandling, () {
      test('clearError multiple times does not throw', () {
        viewModel.clearError();
        viewModel.clearError();
        expect(viewModel.hasAlert, false);
      });

      test('clearError after clearError keeps error as none', () {
        viewModel.clearError();
        expect(viewModel.hasAlert, false);
        final error = viewModel.authError as UIAuthError;
        expect(error.type, ProfileErrorType.none);
      });
    });

    group('ProfileErrorType', () {
      test('has none and unknown values', () {
        expect(ProfileErrorType.values, contains(ProfileErrorType.none));
        expect(ProfileErrorType.values, contains(ProfileErrorType.unknown));
        expect(ProfileErrorType.values.length, 2);
      });
    });
  });
}
