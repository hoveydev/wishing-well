import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

/// Mock implementation of [WisherRepository] for integration tests.
///
/// Provides configurable results and optional delays to simulate various
/// wisher management scenarios in integration tests.
class IntegrationMockWisherRepository extends WisherRepository {
  IntegrationMockWisherRepository({
    /// Initial list of wishers to populate
    List<Wisher>? initialWishers,

    /// Result to return from fetchWishers operations
    Result<void>? fetchWishersResult,

    /// Result to return from createWisher operations
    Result<Wisher>? createWisherResult,

    /// Result to return from updateWisher operations
    Result<Wisher>? updateWisherResult,

    /// Result to return from deleteWisher operations
    Result<void>? deleteWisherResult,

    /// Optional delay for fetchWishers operations
    Duration? fetchDelay,

    /// Optional delay for createWisher operations
    Duration? createDelay,

    /// Optional delay for updateWisher operations
    Duration? updateDelay,

    /// Optional delay for deleteWisher operations
    Duration? deleteDelay,
  }) : _wishers = initialWishers ?? [],
       _fetchWishersResult = fetchWishersResult ?? const Result.ok(null),
       _createWisherResult = createWisherResult ?? _defaultCreateWisherResult(),
       _updateWisherResult =
           updateWisherResult ??
           (() {
             final wisher = Wisher(
               id: 'updated',
               userId: 'test',
               firstName: 'Updated',
               lastName: 'Wisher',
               createdAt: DateTime.now(),
               updatedAt: DateTime.now(),
             );
             return Result<Wisher>.ok(wisher);
           })(),
       _deleteWisherResult = deleteWisherResult ?? const Result.ok(null),
       _fetchDelay = fetchDelay,
       _createDelay = createDelay,
       _updateDelay = updateDelay,
       _deleteDelay = deleteDelay;

  static Result<Wisher> _defaultCreateWisherResult() {
    final wisher = Wisher(
      id: 'mock-wisher-${DateTime.now().millisecondsSinceEpoch}',
      userId: 'test-user',
      firstName: 'Test',
      lastName: 'Wisher',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    return Result.ok(wisher);
  }

  final Result<void> _fetchWishersResult;
  final Result<Wisher> _createWisherResult;
  final Result<Wisher> _updateWisherResult;
  final Result<void> _deleteWisherResult;
  final Duration? _fetchDelay;
  final Duration? _createDelay;
  final Duration? _updateDelay;
  final Duration? _deleteDelay;

  List<Wisher> _wishers;
  bool _isLoading = false;
  Exception? _error;

  @override
  List<Wisher> get wishers => List.unmodifiable(_wishers);

  @override
  bool get isLoading => _isLoading;

  @override
  Exception? get error => _error;

  /// Track fetchWishers call count for verification
  int get fetchWishersCallCount => _fetchWishersCallCount;
  int _fetchWishersCallCount = 0;

  /// Track createWisher call count for verification
  int get createWisherCallCount => _createWisherCallCount;
  int _createWisherCallCount = 0;

  /// Track updateWisher call count for verification
  int get updateWisherCallCount => _updateWisherCallCount;
  int _updateWisherCallCount = 0;

  /// Track deleteWisher call count for verification
  int get deleteWisherCallCount => _deleteWisherCallCount;
  int _deleteWisherCallCount = 0;

  /// Reset all call counters
  void resetCallCounts() {
    _fetchWishersCallCount = 0;
    _createWisherCallCount = 0;
    _updateWisherCallCount = 0;
    _deleteWisherCallCount = 0;
  }

  /// Reset to initial state
  void resetState({List<Wisher>? initialWishers}) {
    _wishers = initialWishers ?? [];
    _error = null;
    _isLoading = false;
    resetCallCounts();
  }

  /// Add a wisher directly to the mock (for test setup)
  void addWisher(Wisher wisher) {
    _wishers = [..._wishers, wisher];
    notifyListeners();
  }

  /// Remove a wisher directly from the mock (for test setup)
  void removeWisher(String wisherId) {
    _wishers = _wishers.where((w) => w.id != wisherId).toList();
    notifyListeners();
  }

  /// Simulate loading state
  void simulateLoading() {
    _isLoading = true;
    notifyListeners();
  }

  /// Simulate error state
  void simulateError(Exception e) {
    _error = e;
    _isLoading = false;
    notifyListeners();
  }

  @override
  Future<Result<void>> fetchWishers() async {
    _fetchWishersCallCount++;
    _isLoading = true;
    _error = null;
    notifyListeners();

    if (_fetchDelay != null) {
      await Future.delayed(_fetchDelay);
    }

    final result = _fetchWishersResult;
    _isLoading = false;

    if (result is Error<void>) {
      _error = result.error;
    }

    notifyListeners();
    return result;
  }

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    _createWisherCallCount++;
    _isLoading = true;
    notifyListeners();

    if (_createDelay != null) {
      await Future.delayed(_createDelay);
    }

    final result = _createWisherResult;
    _isLoading = false;

    if (result is Ok<Wisher>) {
      final newWisher = Wisher(
        id: '${_wishers.length + 1}',
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        profilePicture: profilePicture,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      );
      _wishers = [..._wishers, newWisher];
    } else if (result is Error<Wisher>) {
      _error = result.error;
    }

    notifyListeners();
    return result;
  }

  @override
  Future<Result<Wisher>> updateWisher(Wisher wisher) async {
    _updateWisherCallCount++;
    _isLoading = true;
    notifyListeners();

    if (_updateDelay != null) {
      await Future.delayed(_updateDelay);
    }

    final result = _updateWisherResult;
    _isLoading = false;

    if (result is Ok<Wisher>) {
      final updatedWisher = Wisher(
        id: wisher.id,
        userId: wisher.userId,
        firstName: result.value.firstName,
        lastName: result.value.lastName,
        profilePicture: result.value.profilePicture,
        createdAt: wisher.createdAt,
        updatedAt: DateTime.now(),
      );
      _wishers = _wishers
          .map((w) => w.id == wisher.id ? updatedWisher : w)
          .toList();
    } else if (result is Error<Wisher>) {
      _error = result.error;
    }

    notifyListeners();
    return result;
  }

  @override
  Future<Result<void>> deleteWisher(String wisherId) async {
    _deleteWisherCallCount++;
    _isLoading = true;
    notifyListeners();

    if (_deleteDelay != null) {
      await Future.delayed(_deleteDelay);
    }

    final result = _deleteWisherResult;
    _isLoading = false;

    if (result is Ok<void>) {
      _wishers = _wishers.where((w) => w.id != wisherId).toList();
    } else if (result is Error<void>) {
      _error = result.error;
    }

    notifyListeners();
    return result;
  }
}
