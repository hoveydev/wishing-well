# Feature Demo Scaffold Agent

This agent scaffolds new feature demos for the Wishing Well Flutter app.

## Purpose

Creates the necessary files and updates to add a demo app for any feature. A demo allows testing a feature in isolation without needing authentication or a full backend.

## Input

- **featureName**: The name of the feature to create a demo for (e.g., `home`, `auth`, `profile`)
- **scenarios**: Optional - list of demo scenarios to support (e.g., `success`, `failure`, `loading`)

## Output

Creates the following files under `lib/features/{feature}/demo/`:

1. `{feature}_demo.dart` - Entry point with configurable scenario
2. `{feature}_demo_router.dart` - Router with feature routes and transitions
3. `{feature}_demo_providers.dart` - Demo providers with scenario configuration

Updates `lib/main.dart` to:
- Add import with alias
- Add enum case
- Add switch case

## Implementation

### Step 1: Create Demo Directory

Create `lib/features/{feature}/demo/` directory.

### Step 2: Create Demo Providers File

Create `{feature}_demo_providers.dart`:

```dart
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_wisher_repository.dart';

enum {Feature}DemoScenario { success, failure, loading }

List<SingleChildWidget> get{Feature}DemoProviders({{required {Feature}DemoScenario scenario}}) {{
  // Configure mock repositories based on scenario
  return [
    ChangeNotifierProvider<AuthRepository>(
      create: (_) =>
          MockAuthRepository()..login(email: 'demo@test.com', password: 'demo'),
    ),
    ChangeNotifierProvider<WisherRepository>(
      create: (_) => MockWisherRepository(),
    ),
  ];
}}
```

### Step 3: Create Demo Router File

Create `{feature}_demo_router.dart`:

```dart
import 'package:go_router/go_router.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/routing/transitions.dart';
import 'package:wishing_well/features/{feature}/{feature}_screen.dart';
import 'package:wishing_well/features/{feature}/{feature}_view_model.dart';

GoRouter {feature}DemoRouter() => GoRouter(
  initialLocation: Routes.{feature}.path,
  routes: [
    GoRoute(
      path: Routes.{feature}.path,
      name: Routes.{feature}.name,
      pageBuilder: (context, state) => CustomTransitionPage(
        child: {Feature}Screen(viewModel: {Feature}ViewModel(...)),
        transitionsBuilder: slideUpTransition,
      ),
    ),
  ],
);
```

### Step 4: Create Demo Entry Point

Create `{feature}_demo.dart`:

```dart
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/{feature}/demo/{feature}_demo_providers.dart';
import 'package:wishing_well/features/{feature}/demo/{feature}_demo_router.dart';
import 'package:wishing_well/features/shared/loading/loading_overlay.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';
import 'package:wishing_well/utils/loading_controller.dart';

const {Feature}DemoScenario _scenario = {Feature}DemoScenario.success;

Future<void> main() async {{
  WidgetsFlutterBinding.ensureInitialized();
  runApp(
    MultiProvider(
      providers: get{Feature}DemoProviders(scenario: _scenario),
      child: Builder(
        builder: (context) {{
          final wisherRepo = context.read<WisherRepository>();
          final router = {feature}DemoRouter();
          return _DemoApp(router: router);
        }},
      ),
    ),
  );
}}

class _DemoApp extends StatelessWidget {{
  const _DemoApp({{required this.router}});

  final GoRouter router;

  @override
  Widget build(BuildContext context) => ChangeNotifierProvider(
    create: (_) => LoadingController(),
    child: MaterialApp.router(
      builder: (_, child) => LoadingOverlay(child: child!),
      title: '{Feature} - Demo',
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
}}
```

### Step 5: Update main.dart

Add to `lib/main.dart`:

1. Add import with alias (after existing imports):
```dart
import 'package:wishing_well/features/{feature}/demo/{feature}_demo.dart'
    as {feature}_demo;
```

2. Add to enum:
```dart
enum AppRunConfig {{
  production,
  {feature}Demo,
}}
```

3. Add switch case:
```dart
case AppRunConfig.{feature}Demo:
  await {feature}_demo.main();
```

## Running the Demo

After scaffolding:

1. **Configure the scenario** in `{feature}_demo.dart`:
   - `success` - successful operation
   - `failure` - shows error
   - `loading` - indefinite loading

2. **Run the demo**:
   ```bash
   flutter run
   ```

   Or to run directly:
   ```bash
   flutter run -t lib/features/{feature}/demo/{feature}_demo.dart
   ```

## Notes

- Demo code is automatically excluded from coverage via `/demo/` pattern in `git_hooks.dart`
- Use transitions from `lib/routing/transitions.dart` for consistency
- Each feature demo owns its own providers and scenarios
- Demo uses mock repositories from `lib/test_helpers/mocks/`
