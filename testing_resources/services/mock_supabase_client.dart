import 'package:supabase_flutter/supabase_flutter.dart';

class MockGoTrueClient implements GoTrueClient {
  @override
  Future<AuthResponse> signInWithPassword({
    required String password,
    String? email,
    String? captchaToken,
    String? phone,
  }) async {
    final Session mockSession = Session(
      accessToken: 'fake-token',
      tokenType: 'bearer',
      user: User(
        id: '123',
        aud: 'authenticated',
        appMetadata: {},
        userMetadata: {},
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );

    final Session mockSessionWrongAuth = Session(
      accessToken: 'fake-token',
      tokenType: 'bearer',
      user: User(
        id: '123',
        aud: 'wrong',
        appMetadata: {},
        userMetadata: {},
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
    );

    /// simulate a correct email and password
    if (email == 'EMAIL' && password == 'PASSWORD') {
      _currentSession = mockSession;
    } else if (email == 'EMAIL_WRONG_AUTH' &&
        password == 'PASSWORD_WRONG_AUTH') {
      _currentSession = mockSessionWrongAuth;
      return AuthResponse(
        user: User(
          id: '123',
          aud: 'wrong',
          appMetadata: {},
          userMetadata: {},
          createdAt: DateTime.now().toIso8601String(),
          updatedAt: DateTime.now().toIso8601String(),
        ),
        session: mockSessionWrongAuth,
      );
    } else {
      throw Exception('Incorrect email and password');
    }
    return AuthResponse(
      user: User(
        id: '123',
        aud: 'authenticated',
        appMetadata: {},
        userMetadata: {},
        createdAt: DateTime.now().toIso8601String(),
        updatedAt: DateTime.now().toIso8601String(),
      ),
      session: mockSession,
    );
  }

  Session? _currentSession;

  @override
  Session? get currentSession => _currentSession;

  @override
  Future<void> signOut({SignOutScope scope = SignOutScope.local}) async => {
    if (_currentSession == null) {throw Exception('no user to log out')},
    _currentSession = null,
  };

  @override
  Future<AuthResponse> signUp({
    required String password,
    String? email,
    String? phone,
    String? emailRedirectTo,
    Map<String, dynamic>? data,
    String? captchaToken,
    OtpChannel channel = OtpChannel.sms,
  }) async {
    if (email == 'EMAIL' && password == 'PASSWORD') {
      return AuthResponse();
    } else {
      throw Exception('create account error');
    }
  }

  @override
  Future<AuthResponse> resetPasswordForEmail(
    String email, {
    String? redirectTo,
    String? captchaToken,
  }) async {
    if (email == 'EMAIL') {
      return AuthResponse();
    } else {
      throw Exception('forgot password error');
    }
  }

  @override
  Future<UserResponse> updateUser(
    UserAttributes attributes, {
    String? emailRedirectTo,
  }) async {
    if (attributes.nonce == 'FAKE-TOKEN') {
      return UserResponse.fromJson({});
    } else {
      throw Exception('update user error');
    }
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class MockSupabaseClient implements SupabaseClient {
  final MockGoTrueClient _auth = MockGoTrueClient();

  @override
  GoTrueClient get auth => _auth;

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
