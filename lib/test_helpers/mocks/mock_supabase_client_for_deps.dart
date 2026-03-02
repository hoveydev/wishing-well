import 'package:supabase_flutter/supabase_flutter.dart';

/// Minimal mock Supabase client for dependency injection tests.
///
/// This mock uses `noSuchMethod` to handle any method call, making it
/// suitable for tests that only need a SupabaseClient instance without
/// actually using any of its methods.
///
/// For tests that need to mock specific Supabase behaviors (auth, database),
/// use [MockAuthDataSource] or [MockWisherDataSource] instead.
class MockSupabaseClientForDeps implements SupabaseClient {
  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}
