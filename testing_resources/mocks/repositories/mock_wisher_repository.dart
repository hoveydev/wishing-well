import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

class MockWisherRepository extends WisherRepository {
  MockWisherRepository() {
    _wishers = [
      Wisher(
        id: '1',
        userId: 'test-user',
        firstName: 'Alice',
        lastName: 'Test',
        createdAt: DateTime(2024),
        updatedAt: DateTime(2024),
      ),
      Wisher(
        id: '2',
        userId: 'test-user',
        firstName: 'Bob',
        lastName: 'Test',
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 2),
      ),
      Wisher(
        id: '3',
        userId: 'test-user',
        firstName: 'Charlie',
        lastName: 'Test',
        createdAt: DateTime(2024, 1, 3),
        updatedAt: DateTime(2024, 1, 3),
      ),
      Wisher(
        id: '4',
        userId: 'test-user',
        firstName: 'Diana',
        lastName: 'Test',
        createdAt: DateTime(2024, 1, 4),
        updatedAt: DateTime(2024, 1, 4),
      ),
    ];
  }

  List<Wisher> _wishers = [];
  bool _isLoading = false;
  Exception? _error;

  @override
  List<Wisher> get wishers => List.unmodifiable(_wishers);

  @override
  bool get isLoading => _isLoading;

  @override
  Exception? get error => _error;

  @override
  Future<Result<void>> fetchWishers() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    await Future.delayed(const Duration(milliseconds: 10));

    _isLoading = false;
    notifyListeners();

    return const Result.ok(null);
  }

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    final wisher = Wisher(
      id: '${_wishers.length + 1}',
      userId: userId,
      firstName: firstName,
      lastName: lastName,
      profilePicture: profilePicture,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    _wishers.insert(0, wisher);
    notifyListeners();
    return Result.ok(wisher);
  }

  @override
  Future<Result<Wisher>> updateWisher(Wisher wisher) async {
    final index = _wishers.indexWhere((w) => w.id == wisher.id);
    if (index != -1) {
      _wishers[index] = wisher;
      notifyListeners();
    }
    return Result.ok(wisher);
  }

  @override
  Future<Result<void>> deleteWisher(String wisherId) async {
    _wishers.removeWhere((w) => w.id == wisherId);
    notifyListeners();
    return const Result.ok(null);
  }
}
