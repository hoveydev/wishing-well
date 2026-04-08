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
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/mocks.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.navigation, () {
    testWidgets('home screen renders with wishers', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final wisherMock = IntegrationMockWisherRepository(
        initialWishers: [
          Wisher(
            id: '1',
            userId: 'user-1',
            firstName: 'John',
            lastName: 'Doe',
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ],
      );
      final loadingController = LoadingController();

      // Act - Render the home screen directly
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
                imageRepository: IntegrationMockImageRepository(),
              ),
            ),
          ),
        ),
      );

      // Wait for async fetch
      await tester.pumpAndSettle();

      // Assert - verify screen renders without error
      expect(find.byType(HomeScreen), findsOneWidget);
    });

    testWidgets('home screen loading state renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final wisherMock = IntegrationMockWisherRepository(
        fetchDelay: const Duration(milliseconds: 500),
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
                imageRepository: IntegrationMockImageRepository(),
              ),
            ),
          ),
        ),
      );

      // Initial pump - should show loading
      await tester.pump();

      // Verify loading state
      expect(wisherMock.isLoading, true);

      // Wait for loading to complete
      await tester.pumpAndSettle();

      // Verify loading is complete
      expect(wisherMock.isLoading, false);
    });

    testWidgets('home screen error state renders correctly', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock();
      final wisherMock = IntegrationMockWisherRepository(
        fetchWishersResult: Result.error(Exception('Network error')),
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
                imageRepository: IntegrationMockImageRepository(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Verify error state
      expect(wisherMock.error, isNotNull);
    });
  });
}
