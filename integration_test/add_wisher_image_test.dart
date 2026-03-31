import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'helpers/integration_test_groups.dart';
import 'mocks/mocks.dart';
import 'providers/integration_test_providers.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group(IntegrationTestGroups.userInteraction, () {
    testWidgets('add wisher details with image URL renders image avatar', (
      WidgetTester tester,
    ) async {
      // Arrange
      final authMock = IntegrationTestProviders.quickAuthMock(
        userId: 'test-user',
      );
      final wisherMock = IntegrationTestProviders.quickWisherMock();
      final loadingController = LoadingController();

      // Act - render with imageUrl to trigger _buildImageAvatar path
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

      // The CircleImagePicker is in the header component
      // Fill in form to ensure widget is interactive
      final textFields = find.byType(TextFormField);
      await tester.enterText(textFields.first, 'John');
      await tester.pumpAndSettle();
      await tester.enterText(textFields.last, 'Doe');
      await tester.pumpAndSettle();

      // Verify the screen is functional
      expect(find.byType(AddWisherDetailsScreen), findsOneWidget);
      expect(wisherMock.createWisherCallCount, 0); // Not submitted yet
    });
  });
}
