import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/demo/add_wisher_demo_providers.dart';
import 'package:wishing_well/features/add_wisher/demo/add_wisher_demo_router.dart';
import 'package:wishing_well/components/loading_overlay/loading_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

// Available scenarios:
// - success: Imports a selected contact and preserves photo when available
// - error: Includes a demo contact that fails during import
// - loading: Shows loading state during save
// - duplicate: Includes a contact that matches an existing demo wisher
const AddWisherDemoScenario _scenario = AddWisherDemoScenario.duplicate;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: getAddWisherDemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {
          final authRepo = context.read<AuthRepository>();
          final wisherRepo = context.read<WisherRepository>();
          final imageRepo = context.read<ImageRepository>();
          final contactAccess = context.read<AddWisherContactAccess>();
          final navigatorKey = context.read<GlobalKey<NavigatorState>>();
          final router = addWisherDemoRouter(
            authRepo,
            wisherRepo,
            imageRepo,
            contactAccess,
            navigatorKey,
          );
          return _DemoApp(router: router);
        },
      ),
    ),
  );
}

class _DemoApp extends StatelessWidget {
  const _DemoApp({required this.router});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: MaterialApp.router(
      builder: (_, child) => LoadingOverlay(child: child!),
      title: 'Add Wisher - Demo',
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      debugShowCheckedModeBanner: false,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: router,
    ),
  );
}
