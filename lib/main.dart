import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/app_config.dart';
import 'package:wishing_well/config/dependencies.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/loading_controller.dart';
import 'package:wishing_well/routing/router.dart';
import 'package:wishing_well/screens/loading/loading_overlay.dart';
import 'package:wishing_well/theme/app_theme.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await AppConfig.initialize();
  await Supabase.initialize(
    url: AppConfig.supabaseUrl,
    anonKey: AppConfig.supabaseSecret,
  );
  runApp(
    MultiProvider(
      providers: providersRemote,
      builder: (context, child) => const MainApp(),
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

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
      routerConfig: router(),
    ),
  );
}
