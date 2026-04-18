import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/home/demo/home_demo_providers.dart';
import 'package:wishing_well/features/home/demo/home_demo_router.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

// Available scenarios:
// - noWishers: Empty wishers list
// - fewWishers: 2 wishers (some with images)
// - defaultWishers: 5 wishers (mix of with/without images)
// - manyWishers: 50 wishers (some with images)
// - brokenImages: Wishers with broken/invalid image URLs
// - longNames: 3 wishers with notably long names (tests truncation)
// - failure: Empty with error handling
const HomeDemoScenario _scenario = HomeDemoScenario.defaultWishers;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: getHomeDemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {
          final authRepo = context.read<AuthRepository>();
          final wisherRepo = context.read<WisherRepository>();
          final imageRepo = context.read<ImageRepository>();
          final router = homeDemoRouter(authRepo, wisherRepo, imageRepo);
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
    create: (_) => StatusOverlayController(),
    child: MaterialApp.router(
      builder: (_, child) => StatusOverlay(child: child!),
      title: 'Home - Demo',
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
