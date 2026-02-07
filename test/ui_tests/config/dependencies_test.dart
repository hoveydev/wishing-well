import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_remote.dart';
import '../../../testing_resources/helpers/test_helpers.dart';
import '../../../testing_resources/services/mock_supabase_client.dart';

void main() {
  group('Dependencies', () {
    group(TestGroups.initialState, () {
      test('providersRemote contains exactly 2 providers', () {
        expect(providersRemote.length, 2);
      });

      test('providersRemote has correct provider types', () {
        expect(providersRemote[0], isA<Provider<SupabaseClient>>());
        expect(
          providersRemote[1],
          isA<ChangeNotifierProvider<AuthRepository>>(),
        );
      });

      test('providersRemote maintains correct order', () {
        expect(providersRemote[0], isA<Provider<SupabaseClient>>());
        expect(
          providersRemote[1],
          isA<ChangeNotifierProvider<AuthRepository>>(),
        );
      });
    });

    group(TestGroups.behavior, () {
      testWidgets(
        'providersRemote creates dependencies correctly when initialized',
        (WidgetTester tester) async {
          late SupabaseClient supabase;
          late AuthRepository authRepository;

          // Override the SupabaseClient in providersRemote to use mock
          final providers = providersRemote.map((provider) {
            if (provider is Provider<SupabaseClient>) {
              return Provider<SupabaseClient>(
                create: (_) => MockSupabaseClient(),
              );
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
        },
      );
    });
  });
}
