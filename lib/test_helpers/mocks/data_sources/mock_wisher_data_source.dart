import 'package:wishing_well/data/data_sources/wisher/wisher_data_source.dart';

/// Mock implementation of [WisherDataSource] for testing.
///
/// This mock allows configuring success/error responses for each method
/// and tracking method calls for verification in tests.
class MockWisherDataSource implements WisherDataSource {
  /// Creates a mock with default success responses.
  MockWisherDataSource({
    this.fetchWishersResult,
    this.fetchWishersError,
    this.createWisherResult,
    this.createWisherError,
    this.updateWisherResult,
    this.updateWisherError,
    this.deleteWisherError,
  });

  /// The result to return from [fetchWishers].
  /// If null, returns an empty list.
  List<Map<String, dynamic>>? fetchWishersResult;

  /// The exception to throw from [fetchWishers].
  /// Takes precedence over [fetchWishersResult].
  Exception? fetchWishersError;

  /// The result to return from [createWisher].
  /// If null, returns a default created wisher.
  Map<String, dynamic>? createWisherResult;

  /// The exception to throw from [createWisher].
  /// Takes precedence over [createWisherResult].
  Exception? createWisherError;

  /// The result to return from [updateWisher].
  /// If null, returns a default updated wisher.
  Map<String, dynamic>? updateWisherResult;

  /// The exception to throw from [updateWisher].
  /// Takes precedence over [updateWisherResult].
  Exception? updateWisherError;

  /// The exception to throw from [deleteWisher].
  Exception? deleteWisherError;

  /// Tracks whether [fetchWishers] was called.
  bool fetchWishersCalled = false;

  /// Tracks whether [createWisher] was called.
  bool createWisherCalled = false;

  /// Tracks whether [updateWisher] was called.
  bool updateWisherCalled = false;

  /// Tracks whether [deleteWisher] was called.
  bool deleteWisherCalled = false;

  @override
  Future<List<Map<String, dynamic>>> fetchWishers() async {
    fetchWishersCalled = true;
    if (fetchWishersError != null) {
      throw fetchWishersError!;
    }
    return fetchWishersResult ?? [];
  }

  @override
  Future<Map<String, dynamic>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String> giftOccasions = const [],
    List<String> giftInterests = const [],
  }) async {
    createWisherCalled = true;
    if (createWisherError != null) {
      throw createWisherError!;
    }
    return createWisherResult ??
        {
          'id': 'new-wisher-id',
          'user_id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'profile_picture': profilePicture,
          'birthday': birthday?.toIso8601String(),
          'gift_occasions': giftOccasions,
          'gift_interests': giftInterests,
          'created_at': DateTime.now().toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
  }

  @override
  Future<Map<String, dynamic>> updateWisher({
    required String wisherId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String> giftOccasions = const [],
    List<String> giftInterests = const [],
  }) async {
    updateWisherCalled = true;
    if (updateWisherError != null) {
      throw updateWisherError!;
    }
    return updateWisherResult ??
        {
          'id': wisherId,
          'user_id': 'test-user-id',
          'first_name': firstName,
          'last_name': lastName,
          'profile_picture': profilePicture,
          'birthday': birthday?.toIso8601String(),
          'gift_occasions': giftOccasions,
          'gift_interests': giftInterests,
          'created_at': DateTime(2024).toIso8601String(),
          'updated_at': DateTime.now().toIso8601String(),
        };
  }

  @override
  Future<void> deleteWisher(String wisherId) async {
    deleteWisherCalled = true;
    if (deleteWisherError != null) {
      throw deleteWisherError!;
    }
  }
}
