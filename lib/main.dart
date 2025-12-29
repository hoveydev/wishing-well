import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/utils/app_config.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/utils/deep_links/deep_link_source.dart';
import 'package:wishing_well/utils/loading_controller.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/screens/loading/loading_overlay.dart';
import 'package:wishing_well/theme/app_theme.dart';

Future<void> main() async {
  final goRouter = router();
  final deepLinkSource = DeepLinkSource.platform();
  final deepLinkHandler = DeepLinkHandler(
    (name, queryParameters) => goRouter.goNamed(
      name,
      queryParameters: queryParameters ?? const <String, dynamic>{},
    ),
    source: deepLinkSource,
  );
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseSecret,
  );
  runApp(
    MultiProvider(
      providers: providersRemote,
      builder: (context, child) =>
          MainApp(router: goRouter, deepLinkHandler: deepLinkHandler),
    ),
  );
}

class MainApp extends StatefulWidget {
  const MainApp({
    required this.router,
    required this.deepLinkHandler,
    super.key,
  });
  final GoRouter router;
  final DeepLinkHandler deepLinkHandler;

  @override
  State<MainApp> createState() => _MainAppState();
}

class _MainAppState extends State<MainApp> {
  @override
  void initState() {
    super.initState();
    widget.deepLinkHandler.init();
  }

  @override
  void dispose() {
    widget.deepLinkHandler.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: MaterialApp.router(
      builder: (_, child) => LoadingOverlay(child: child!),
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      localizationsDelegates: const [
        AppLocalizations.delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: AppLocalizations.supportedLocales,
      routerConfig: widget.router,
    ),
  );
}
