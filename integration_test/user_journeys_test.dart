import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/home/home_screen.dart';
import 'package:wishing_well/features/home/home_view_model.dart';
import 'package:wishing_well/features/profile/profile_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/integration_mock_auth_repository.dart';
import 'mocks/integration_mock_wisher_repository.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.userJourneys, () {
    testWidgets('login and navigate to home renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationTestProviders.quickWisherMock();
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<WisherRepository>.value(value: wisherMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(
              viewModel: HomeViewModel(
                authRepository: authMock,
                wisherRepository: wisherMock,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('profile screen renders with logout button', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - verify logout button is present
      final l10n = AppLocalizations.of(
        tester.element(find.byType(ProfileScreen)),
      )!;
      expect(find.text(l10n.logout), findsOneWidget);
    });

    testWidgets('profile logout calls repository', (WidgetTester tester) async {
      // Arrange
      final authMock = IntegrationMockAuthRepository(
        logoutResult: const Result.ok(null),
      );
      authMock.simulateLoginSuccess(userId: 'test-user');
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: const ProfileScreen(),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Tap logout
      final l10n = AppLocalizations.of(
        tester.element(find.byType(ProfileScreen)),
      )!;
      await tester.tap(find.text(l10n.logout));
      await tester.pumpAndSettle();

      // Verify logout was called
      expect(authMock.logoutCallCount, 1);
    });

    testWidgets('home with existing wishers renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationMockWisherRepository(
        initialWishers: [
          Wisher(
            id: '1',
            userId: 'test-user',
            firstName: 'Alice',
            lastName: 'Johnson',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Wisher(
            id: '2',
            userId: 'test-user',
            firstName: 'Bob',
            lastName: 'Smith',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      );
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<WisherRepository>.value(value: wisherMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: HomeScreen(
              viewModel: HomeViewModel(
                authRepository: authMock,
                wisherRepository: wisherMock,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify fetch was called
      expect(wisherMock.fetchWishersCallCount, 1);

      // Verify wishers are in repository
      expect(wisherMock.wishers.length, 2);
    });

    testWidgets('add wisher flow renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationTestProviders.quickWisherMock();
      final loadingController = LoadingController();

      // Act - Test landing screen
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<WisherRepository>.value(value: wisherMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: AddWisherLandingScreen(
              viewModel: AddWisherLandingViewModel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert landing
      expect(find.byType(AddWisherLandingScreen), findsOneWidget);

      // Act - Test details screen
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<WisherRepository>.value(value: wisherMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: wisherMock,
                authRepository: authMock,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert details
      expect(find.byType(AddWisherDetailsScreen), findsOneWidget);
    });

    testWidgets('add wisher creates wisher in repository', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationMockWisherRepository(
        initialWishers: [],
        createWisherResult: Result.ok(
          Wisher(
            id: 'wisher-1',
            userId: 'test-user',
            firstName: 'Test',
            lastName: 'Wisher',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ),
      );
      final loadingController = LoadingController();

      // Act
      await tester.pumpWidget(
        MultiProvider(
          providers: [
            ChangeNotifierProvider<AuthRepository>.value(value: authMock),
            ChangeNotifierProvider<WisherRepository>.value(value: wisherMock),
            ChangeNotifierProvider<LoadingController>.value(
              value: loadingController,
            ),
          ],
          child: MaterialApp(
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            localizationsDelegates: const [
              AppLocalizations.delegate,
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            home: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: wisherMock,
                authRepository: authMock,
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fill form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'Test');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.last, 'Wisher');
      await tester.pumpAndSettle();

      // Submit
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify
      expect(wisherMock.createWisherCallCount, 1);
    });
  });
}
