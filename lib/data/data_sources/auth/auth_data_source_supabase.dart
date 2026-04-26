import 'package:google_sign_in/google_sign_in.dart';
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

    final session = response.session;
    final user = response.user;

    return {
      'user_id': user?.id,
      'aud': user?.aud,
      'email': user?.email,
      'access_token': session?.accessToken,
      'refresh_token': session?.refreshToken,
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

    final user = response.user;
    final session = response.session;

    return {
      'user_id': user?.id,
      'email': user?.email,
      'access_token': session?.accessToken,
      'refresh_token': session?.refreshToken,
    };
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
  }) async {
    final response = await _supabase.auth.updateUser(
      UserAttributes(email: email, password: newPassword),
    );

    final user = response.user;

    return {'user_id': user?.id, 'email': user?.email};
  }

  @override
  Future<void> signInWithGoogle() async {
    final googleSignIn = GoogleSignIn(
      // iOS only
      clientId:
          '641200674201-b7hf3802jnot2htpq34ldhreqdlv1kij'
          '.apps.googleusercontent.com',
      // Android
      serverClientId:
          '641200674201-dpfpeb3k9dqhge5q4gfbfkmll3ruv3jm'
          '.apps.googleusercontent.com',
    );
    final googleUser = await googleSignIn.signIn();
    if (googleUser == null) {
      throw Exception('Google sign-in cancelled');
    }
    final googleAuth = await googleUser.authentication;
    final idToken = googleAuth.idToken;
    if (idToken == null) {
      throw Exception('Google sign-in failed: no ID token');
    }
    await _supabase.auth.signInWithIdToken(
      provider: OAuthProvider.google,
      idToken: idToken,
      accessToken: googleAuth.accessToken,
    );
  }
}
