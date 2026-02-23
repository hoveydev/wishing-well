/// Abstract data source for wisher operations.
///
/// This interface abstracts the Supabase PostgREST API for wishers,
/// allowing for easy testing by mocking the data source layer.
abstract class WisherDataSource {
  /// Fetches all wishers for the current authenticated user.
  ///
  /// Returns a list of wisher data maps.
  /// Throws an exception on failure.
  Future<List<Map<String, dynamic>>> fetchWishers();

  /// Creates a new wisher.
  ///
  /// Returns the created wisher data map.
  /// Throws an exception on failure.
  Future<Map<String, dynamic>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  });

  /// Updates an existing wisher.
  ///
  /// Returns the updated wisher data map.
  /// Throws an exception on failure.
  Future<Map<String, dynamic>> updateWisher({
    required String wisherId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  });

  /// Deletes a wisher by ID.
  ///
  /// Throws an exception on failure.
  Future<void> deleteWisher(String wisherId);
}
