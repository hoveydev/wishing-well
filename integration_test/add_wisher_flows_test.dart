import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/utils/result.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/mocks.dart';
import 'mocks/integration_mock_wisher_repository.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.userInteraction, () {
    testWidgets('add wisher landing screen renders correctly', (
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
            home: AddWisherLandingScreen(
              viewModel: AddWisherLandingViewModel(),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert
      expect(find.byType(AddWisherLandingScreen), findsOneWidget);
    });

    testWidgets('add wisher details screen renders with form fields', (
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
            home: AddWisherDetailsScreen(
              viewModel: AddWisherDetailsViewModel(
                wisherRepository: wisherMock,
                authRepository: authMock,
                imageRepository: IntegrationMockImageRepository(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Assert - verify form fields are present (first name, last name)
      expect(find.byType(TextFormField), findsNWidgets(2));
    });

    testWidgets('add wisher details creates new wisher when submitted', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationMockWisherRepository(
        createWisherResult: Result.ok(
          Wisher(
            id: 'new-wisher-1',
            userId: 'test-user',
            firstName: 'New',
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
                imageRepository: IntegrationMockImageRepository(),
              ),
            ),
          ),
        ),
      );
      await tester.pumpAndSettle();

      // Fill form
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'New');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.last, 'Wisher');
      await tester.pumpAndSettle();

      // Tap submit (ElevatedButton)
      await tester.tap(find.byType(ElevatedButton));
      await tester.pumpAndSettle();

      // Verify create wisher was called
      expect(wisherMock.createWisherCallCount, 1);
    });
  });
}
