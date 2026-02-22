import 'package:flutter/foundation.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/utils/result.dart';

/// Abstract repository for managing wishers.
///
/// This repository handles all CRUD operations for wishers,
/// with Row Level Security ensuring users can only access their own data.
abstract class WisherRepository extends ChangeNotifier {
  /// Returns the list of wishers for the current authenticated user.
  ///
  /// Returns an empty list if no wishers exist or user is not authenticated.
  List<Wisher> get wishers;

  /// Returns true if wishers are currently being loaded.
  bool get isLoading;

  /// Returns the last error that occurred, if any.
  Exception? get error;

  /// Fetches all wishers for the current authenticated user.
  ///
  /// The RLS policy ensures only the user's own wishers are returned.
  /// After calling this, [wishers] will be updated and listeners notified.
  Future<Result<void>> fetchWishers();

  /// Creates a new wisher for the current authenticated user.
  ///
  /// The [userId] must match the authenticated user's ID (enforced by RLS).
  /// Returns the created wisher with its assigned ID.
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  });

  /// Updates an existing wisher.
  ///
  /// Only the authenticated user can update their own wishers
  /// (enforced by RLS).
  Future<Result<Wisher>> updateWisher(Wisher wisher);

  /// Deletes a wisher by its ID.
  ///
  /// Only the authenticated user can delete their own wishers
  /// (enforced by RLS).
  Future<Result<void>> deleteWisher(String wisherId);
}
