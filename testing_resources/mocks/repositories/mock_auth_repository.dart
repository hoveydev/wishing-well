import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/result.dart';

class MockAuthRepository extends AuthRepository {
  @override
  bool get isAuthenticated => true;

  @override
  Future<Result<void>> login({
    required String email,
    required String password,
  }) async {
    notifyListeners();
    return const Result.ok(null);
  }

  @override
  Future<Result<void>> logout() async {
    notifyListeners();
    return const Result.ok(null);
  }
}
