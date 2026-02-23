import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/data_sources/auth/auth_data_source.dart';

/// Supabase implementation of [AuthDataSource].
///
/// This implementation uses Supabase's GoTrue client for authentication.
/// This class is excluded from coverage as it's a thin wrapper around
/// the Supabase SDK which is tested by Supabase itself.
class AuthDataSourceSupabase implements AuthDataSource {
  AuthDataSourceSupabase({required SupabaseClient supabase})
    : _supabase = supabase;

  final SupabaseClient _supabase;

  @override
  String? get currentUserId => _supabase.auth.currentUser?.id;

  @override
  String? get currentAccessToken => _supabase.auth.currentSession?.accessToken;

  @override
  String? get userFirstName =>
      _supabase.auth.currentUser?.userMetadata?['first_name'] as String?;

  @override
  Future<Map<String, dynamic>> signInWithPassword({
    required String email,
    required String password,
  }) async {
    final response = await _supabase.auth.signInWithPassword(
      email: email,
      password: password,
    );

    return {
      'user_id': response.user?.id,
      'aud': response.user?.aud,
      'email': response.user?.email,
    };
  }

  @override
  Future<Map<String, dynamic>> signUp({
    required String email,
    required String password,
    String? emailRedirectTo,
  }) async {
    final response = await _supabase.auth.signUp(
      email: email,
      password: password,
      emailRedirectTo: emailRedirectTo,
    );

    return {'user_id': response.user?.id, 'email': response.user?.email};
  }

  @override
  Future<void> signOut() async {
    await _supabase.auth.signOut();
  }

  @override
  Future<void> resetPasswordForEmail(String email, {String? redirectTo}) async {
    await _supabase.auth.resetPasswordForEmail(email, redirectTo: redirectTo);
  }

  @override
  Future<Map<String, dynamic>> updateUserPassword({
    required String email,
    required String newPassword,
    required String token,
  }) async {
    final attributes = UserAttributes(
      email: email,
      password: newPassword,
      nonce: token,
    );

    final response = await _supabase.auth.updateUser(attributes);

    return {'user_id': response.user?.id, 'email': response.user?.email};
  }
}
