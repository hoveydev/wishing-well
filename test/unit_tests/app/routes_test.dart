import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('Routes', () {
    group(TestGroups.initialState, () {
      test('all expected routes exist', () {
        expect(Routes.values.length, greaterThanOrEqualTo(10));
        expect(Routes.home, isA<Routes>());
        expect(Routes.profile, isA<Routes>());
        expect(Routes.login, isA<Routes>());
        expect(Routes.forgotPassword, isA<Routes>());
        expect(Routes.resetPassword, isA<Routes>());
        expect(Routes.createAccount, isA<Routes>());
        expect(Routes.addWisher, isA<Routes>());
        expect(Routes.addWisherDetails, isA<Routes>());
        expect(Routes.wisherDetails, isA<Routes>());
        expect(Routes.editWisher, isA<Routes>());
      });

      test('routes have correct paths', () {
        expect(Routes.home.path, '/home');
        expect(Routes.profile.path, '/profile');
        expect(Routes.login.path, '/login');
        expect(Routes.forgotPassword.path, '/forgot-password');
        expect(Routes.resetPassword.path, '/reset-password');
        expect(Routes.createAccount.path, '/create-account');
        expect(Routes.addWisher.path, '/add-wisher');
        expect(Routes.addWisherDetails.path, 'details');
        expect(Routes.wisherDetails.path, '/wisher-details/:id');
        expect(Routes.editWisher.path, '/wisher-details/:id/edit');
      });

      test('routes have correct kebab-case names', () {
        expect(Routes.home.name, 'home');
        expect(Routes.profile.name, 'profile');
        expect(Routes.login.name, 'login');
        expect(Routes.forgotPassword.name, 'forgot-password');
        expect(Routes.resetPassword.name, 'reset-password');
        expect(Routes.createAccount.name, 'create-account');
        expect(Routes.addWisher.name, 'add-wisher');
        expect(Routes.addWisherDetails.name, 'add-wisher-details');
        expect(Routes.wisherDetails.name, 'wisher-details');
        expect(Routes.editWisher.name, 'edit-wisher');
      });
    });

    group(TestGroups.behavior, () {
      test('buildPath replaces :id for wisherDetails', () {
        final result = Routes.wisherDetails.buildPath(id: 'abc123');
        expect(result, '/wisher-details/abc123');
      });

      test('buildPath replaces :id for editWisher', () {
        final result = Routes.editWisher.buildPath(id: 'xyz789');
        expect(result, '/wisher-details/xyz789/edit');
      });

      test('buildPath without id returns path unchanged', () {
        expect(Routes.home.buildPath(), '/home');
        expect(Routes.wisherDetails.buildPath(), '/wisher-details/:id');
      });

      test('buildPath with special characters in id', () {
        final result = Routes.wisherDetails.buildPath(id: 'user-123_abc');
        expect(result, '/wisher-details/user-123_abc');
      });
    });
  });
}
