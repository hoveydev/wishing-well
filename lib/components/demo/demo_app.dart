import 'package:flutter/material.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/components/demo/demo_home.dart';

///
/// DEVELOPER DEMO APP - FOR TESTING COMPONENTS ONLY
/// ================================================
///
/// This demo app is for development and testing purposes only.
/// It will never be included in production builds.
///
/// Run with: flutter run --target lib/demo/main.dart
///
class ComponentDemoApp extends StatelessWidget {
  const ComponentDemoApp({super.key});

  @override
  Widget build(BuildContext context) => MaterialApp(
    title: 'Component Demo App',
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: const DemoHome(),
    localizationsDelegates: AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
  );
}
