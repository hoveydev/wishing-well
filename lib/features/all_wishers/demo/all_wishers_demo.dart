import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/status_overlay/status_overlay.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/all_wishers/demo/all_wishers_demo_providers.dart';
import 'package:wishing_well/features/all_wishers/demo/all_wishers_demo_router.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

// Available scenarios:
// - defaultWishers: 5 wishers (mix of with/without images)
// - noWishers: Empty wishers list (shows empty state)
// - manyWishers: 30 wishers for scroll testing
// - longNames: 3 wishers with long names (tests truncation)
const AllWishersDemoScenario _scenario = AllWishersDemoScenario.defaultWishers;

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(
    MultiProvider(
      providers: getAllWishersDemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {
          final wisherRepo = context.read<WisherRepository>();
          final router = allWishersDemoRouter(wisherRepo);
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
      title: 'All Wishers - Demo',
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
