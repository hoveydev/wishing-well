import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository_remote.dart';
import '../../../testing_resources/services/mock_supabase_client.dart';

void main() {
  group('providersRemote coverage', () {
    testWidgets('real providersRemote create constructors are called', (
      tester,
    ) async {
      late SupabaseClient supabase;
      late AuthRepository authRepository;

      // Override the SupabaseClient in providersRemote
      final providers = providersRemote.map((provider) {
        if (provider is Provider<SupabaseClient>) {
          return Provider<SupabaseClient>(create: (_) => MockSupabaseClient());
        }
        return provider;
      }).toList();

      await tester.pumpWidget(
        MultiProvider(
          providers: providers,
          child: Builder(
            builder: (context) {
              supabase = context.read<SupabaseClient>();
              authRepository = context.read<AuthRepository>();
              return const SizedBox.shrink();
            },
          ),
        ),
      );

      await tester.pumpAndSettle();

      expect(supabase, isA<SupabaseClient>());
      expect(authRepository, isA<AuthRepositoryRemote>());
    });

    test('providersRemote order is correct', () {
      expect(providersRemote.length, 2);
      expect(providersRemote[0], isA<Provider<SupabaseClient>>());
      expect(providersRemote[1], isA<ChangeNotifierProvider<AuthRepository>>());
    });
  });
}
