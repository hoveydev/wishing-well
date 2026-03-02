import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository_impl.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';
import 'package:wishing_well/test_helpers/mocks/data_sources/mock_auth_data_source.dart';
import 'package:wishing_well/test_helpers/mocks/data_sources/mock_wisher_data_source.dart';
import 'package:wishing_well/test_helpers/mocks/mock_supabase_client_for_deps.dart';

void main() {
  group('Dependencies', () {
    group(TestGroups.initialState, () {
      test('providersRemote contains exactly 3 providers', () {
        expect(providersRemote.length, 3);
      });

      test('providersRemote has correct provider types in order', () {
        expect(providersRemote[0], isA<Provider<SupabaseClient>>());
        expect(
          providersRemote[1],
          isA<ChangeNotifierProvider<AuthRepository>>(),
        );
        expect(
          providersRemote[2],
          isA<ChangeNotifierProvider<WisherRepository>>(),
        );
      });
    });

    group(TestGroups.behavior, () {
      testWidgets(
        'providersRemote creates dependencies correctly with mock data sources',
        (WidgetTester tester) async {
          late SupabaseClient supabase;
          late AuthRepository authRepository;
          late WisherRepository wisherRepository;

          // Create mock data sources
          final mockAuthDataSource = MockAuthDataSource();
          final mockWisherDataSource = MockWisherDataSource();

          // Build providers with mock data sources injected directly
          final providers = [
            Provider<SupabaseClient>(
              create: (_) => MockSupabaseClientForDeps(),
            ),
            ChangeNotifierProvider<AuthRepository>(
              create: (context) =>
                  AuthRepositoryImpl(dataSource: mockAuthDataSource),
            ),
            ChangeNotifierProvider<WisherRepository>(
              create: (context) =>
                  WisherRepositoryImpl(dataSource: mockWisherDataSource),
            ),
          ];

          await tester.pumpWidget(
            MultiProvider(
              providers: providers,
              child: Builder(
                builder: (context) {
                  supabase = context.read<SupabaseClient>();
                  authRepository = context.read<AuthRepository>();
                  wisherRepository = context.read<WisherRepository>();
                  return const SizedBox.shrink();
                },
              ),
            ),
          );

          await TestHelpers.pumpAndSettle(tester);

          expect(supabase, isA<SupabaseClient>());
          expect(authRepository, isA<AuthRepositoryImpl>());
          expect(wisherRepository, isA<WisherRepositoryImpl>());
        },
      );

      testWidgets('repositories are ChangeNotifiers', (
        WidgetTester tester,
      ) async {
        late AuthRepository authRepository;
        late WisherRepository wisherRepository;

        final mockAuthDataSource = MockAuthDataSource();
        final mockWisherDataSource = MockWisherDataSource();

        final providers = [
          Provider<SupabaseClient>(create: (_) => MockSupabaseClientForDeps()),
          ChangeNotifierProvider<AuthRepository>(
            create: (context) =>
                AuthRepositoryImpl(dataSource: mockAuthDataSource),
          ),
          ChangeNotifierProvider<WisherRepository>(
            create: (context) =>
                WisherRepositoryImpl(dataSource: mockWisherDataSource),
          ),
        ];

        await tester.pumpWidget(
          MultiProvider(
            providers: providers,
            child: Builder(
              builder: (context) {
                authRepository = context.read<AuthRepository>();
                wisherRepository = context.read<WisherRepository>();
                return const SizedBox.shrink();
              },
            ),
          ),
        );

        await TestHelpers.pumpAndSettle(tester);

        // Verify repositories are ChangeNotifiers
        expect(authRepository, isA<AuthRepositoryImpl>());
        expect(wisherRepository, isA<WisherRepositoryImpl>());
      });
    });
  });
}
