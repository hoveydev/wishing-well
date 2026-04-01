import 'package:supabase_flutter/supabase_flutter.dart';

/// Centralized service for authentication-related operations.
///
/// Provides consistent auth header generation across the app for accessing
/// private Supabase Storage buckets.
class AuthService {
  AuthService._();

  /// Returns the authorization headers needed to access private storage files.
  ///
  /// Use these headers with NetworkImage or CachedNetworkImage to load
  /// authenticated images:
  /// ```dart
  /// NetworkImage(
  ///   url,
  ///   headers: AuthService.storageHeaders,
  /// )
  /// ```
  static Map<String, String> get storageHeaders {
    try {
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        return {'Authorization': 'Bearer ${session.accessToken}'};
      }
    } catch (e) {
      // Supabase not initialized - return empty headers
    }
    return {};
  }

  /// Checks if a user is currently authenticated.
  static bool get isAuthenticated {
    try {
      return Supabase.instance.client.auth.currentSession != null;
    } catch (e) {
      return false;
    }
  }

  /// Gets the current user's ID, if authenticated.
  static String? get currentUserId {
    try {
      return Supabase.instance.client.auth.currentUser?.id;
    } catch (e) {
      return null;
    }
  }
}
