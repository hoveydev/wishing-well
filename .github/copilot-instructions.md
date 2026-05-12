# Copilot Instructions

This file provides guidance to GitHub Copilot when working with code in this repository.

## Project Overview

Wishing Well is a Flutter app using **MVVM architecture**, Provider for state management, Supabase for backend, and go_router for navigation.

## Running the App

By default, `flutter run` launches the production app. To run a demo instead, change `_runConfig` in `lib/main.dart` to one of:
- `AppRunConfig.production` — Full production app
- `AppRunConfig.componentsDemo` — Reusable component showcase
- `AppRunConfig.authDemo` — Auth feature demo
- `AppRunConfig.homeDemo` — Home feature demo
- `AppRunConfig.addWisherDemo` — Add wisher feature demo

Each demo runs in isolation without needing authentication or a full backend.

## Development Commands

### Environment Setup
Copy `.env.development` or `.env.test` and configure:
- `SUPABASE_URL`, `SUPABASE_ANON_KEY` - Supabase backend
- `ACCOUNT_CONFIRM_URL`, `PASSWORD_RESET_URL` - Auth redirect URLs

```bash
# Essential
flutter pub get                    # Install dependencies
flutter test test/path/to/test_file.dart          # Run single test
flutter test --coverage           # Run with coverage
./scripts/test_coverage.sh        # Full coverage workflow (90% full-repo threshold)

# Quality
dart format .                     # Format all files
dart analyze --fatal-infos        # Static analysis (fails on warnings)

# Localization
flutter gen-l10n                  # Generate l10n after editing app_en.arb

# Components
./scripts/add_component.sh        # Scaffold new component, demo, and tests

# Git hooks (install once)
dart run git_hooks.dart           # Installs pre-commit hook
```

## Architecture

**MVVM pattern** with three layers:

1. **Presentation**: Screens and reusable components (purely UI, no business logic)
2. **ViewModel**: Extends `ChangeNotifier`, implements a `Contract` interface
3. **Data**: Abstract repositories with concrete implementations

```
lib/
├── features/        # Feature modules (add_wisher, auth, home, profile)
├── components/      # Reusable UI widgets by type (button, input, spacer, etc.)
├── config/          # Dependency injection (dependencies.dart)
├── data/            # Repository interfaces and implementations
├── l10n/            # Localization (ARB files)
├── routing/         # go_router navigation config (routes.dart)
├── screens/         # Screen widgets and ViewModels
├── theme/           # App theming (colors, spacing, typography)
└── utils/           # Utilities (validators, result, error handling)
```

### Key Patterns

- **Screens** receive ViewModel via constructor injection
- **ViewModels** define contract as abstract class, use `notifyListeners()` on state changes
- **Repositories** use sealed `Result<T>` class: `Result.ok(value)` or `Result.error(Exception)`
- **Error handling**: `AuthError<T>` sealed class (UI validation vs. API errors)
- **Dependency injection**: Provider pattern configured in `lib/config/dependencies.dart`
- **Navigation**: `context.pushNamed(Routes.home.name)` using go_router
- **Routing enum** in `lib/routing/routes.dart`

### Component Action Pattern

Components **must not** embed business logic (navigation, API calls, state mutations). All actions must be passed in as callbacks from the ViewModel:

```dart
// ❌ WRONG — navigation embedded in component
class WisherItem extends StatelessWidget {
  void onTap(BuildContext context) {
    context.push(Routes.wisherDetails.path);  // tightly coupled!
  }
}

// ✅ CORRECT — action passed as callback
class WisherItem extends StatelessWidget {
  final VoidCallback onTap;  // caller decides what happens
}

// In ViewModel:
onTap: () => viewModel.tapWisherItem(context, wisher),
```

Never import `go_router` in component files.

### Navigation Delegation Pattern

All navigation logic must go through ViewModel methods, not be called directly from UI:

```dart
// ✅ CORRECT — navigation in ViewModel
void tapAddWisher(BuildContext context) {
  context.pushNamed(Routes.addWisher.name);
}

// In Screen/Component:
onTap: () => viewModel.tapAddWisher(context),

// ❌ INCORRECT — navigation called directly from UI
onTap: () => context.pushNamed(Routes.addWisher.name),
```

For routes with parameters, use the `buildPath()` helper: `Routes.wisherDetails.buildPath(id: wisher.id)`

## Code Style

- Always use `package:` imports (never relative)
- Single quotes, 80 char max line, `const` constructors where possible
- `prefer_expression_function_bodies`, `sort_constructors_first`
- Use theme system: `Theme.of(context).extension<AppColorScheme>()` for colors, `Theme.of(context).textTheme` for text
- `AppIconSize` class for icon sizes (xsmall, small, medium, large, xlarge, xxlarge)
- Avoid `Container`, use `SizedBox` for whitespace

## Design Constants Reference

**CRITICAL:** All pixel values for spacing, sizing, colors, and borders MUST use global constants. Hardcoding values defeats the design system and requires PR comments. See `docs/DESIGN_CONSTANTS.md` for comprehensive guide.

### Spacing (AppSpacerSize + semantic sizing)

```dart
// ✅ CORRECT - Use AppSpacerSize for common spacing
padding: EdgeInsets.all(AppSpacerSize.large);
SizedBox(width: AppSpacerSize.small);
SizedBox(height: AppSpacerSize.xxlarge);

// ✅ CORRECT - Use semantic sizing constants
padding: EdgeInsets.symmetric(
  horizontal: AppScreenLayout.screenPaddingStandard,
);
SizedBox(height: AppBarSizing.height);
```

**Available sizes:**
- `AppSpacerSize`: xsmall (4), small (8), medium (12), large (16), xlarge (20), xxlarge (24), xxxlarge (32), huge (48)
- Semantic classes: `AppScreenLayout.screenPaddingStandard` (24), `AppBarSizing.height` (48), `WisherSizing.itemSpacing` (16), `WisherSizing.avatarDiameter` (60)

### Border Radius (AppBorderRadius)

```dart
// ✅ CORRECT
borderRadius: BorderRadius.circular(AppBorderRadius.small);     // 8
borderRadius: BorderRadius.circular(AppBorderRadius.medium);    // 14
borderRadius: BorderRadius.circular(AppBorderRadius.large);     // 24
```

### Border Weight (AppBorderWeight)

```dart
// ✅ CORRECT
border: Border.all(width: AppBorderWeight.regular);  // 1.0
border: Border.all(width: AppBorderWeight.bold);     // 2.0
```

### Icon Sizes (AppIconSize)

```dart
// ✅ CORRECT
Icon(Icons.star, size: const AppIconSize().small);      // 14
Icon(Icons.star, size: const AppIconSize().medium);     // 18
Icon(Icons.star, size: const AppIconSize().large);      // 24
Icon(Icons.check_circle, size: const AppIconSize().overlayIcon);  // 120
```

### Colors (AppColorScheme)

```dart
// ✅ CORRECT - Always use extension
final colorScheme = Theme.of(context).extension<AppColorScheme>();
Container(color: colorScheme?.primary);
Container(color: colorScheme?.error);
Container(color: colorScheme?.background);
```

**Available colors:** primary, onPrimary, background, surfaceGray, borderGray, success, warning, error (+ dark variants)

### Text Styles (Theme.textTheme)

```dart
// ✅ CORRECT
final textTheme = Theme.of(context).textTheme;
Text('Title', style: textTheme.titleLarge);
Text('Body', style: textTheme.bodyMedium);
```

### Anti-Patterns to Avoid

```dart
// ❌ WRONG - Hardcoded numbers
padding: EdgeInsets.all(16);                    // Use AppSpacerSize.large
SizedBox(width: 8);                             // Use AppSpacerSize.small
borderRadius: BorderRadius.circular(8);         // Use AppBorderRadius.small
Icon(Icons.star, size: 24);                     // Use const AppIconSize().large

// ❌ WRONG - Hardcoded colors
Container(color: Color(0xFF3A8FB7));           // Use colorScheme.primary
Text('Error', style: TextStyle(color: Colors.red));  // Use colorScheme.error

// ❌ WRONG - Creating new constants
static const double myPadding = 15;             // Use existing AppSpacerSize
```

**See `docs/DESIGN_CONSTANTS.md` for comprehensive reference, examples, and best practices.**

## Testing

- Tests in `test/unit_tests/` and `test/ui_tests/`
- Use `MockAuthRepository` from `lib/test_helpers/mocks/`
- Widget test helper: `createScreenTestWidget()` from `lib/test_helpers/helpers/`
- Tests organized with `group()` blocks and descriptive names
- Coverage thresholds: **95% on changed files** (enforced by pre-commit hook), **90% full repo** (`./scripts/test_coverage.sh`)

## Feature Development Workflow

Every plan **must** include todos that cover all six phases below. Do not skip phases or merge them.
Quality gates in Phase 3 must pass before proceeding to Phase 4.

### Phase 1 – Plan
- Analyze the relevant codebase areas before proposing a solution
- Clarify ambiguous requirements with the user before writing code
- Create a structured plan with all six phases represented as explicit todos

### Phase 2 – Implement
- Write code following all architecture patterns (MVVM, Repository, Component Action)
- Keep changes focused; follow naming conventions and code style
- Use `dart format .` after changes

### Phase 3 – Quality Gates *(must pass before Phase 4)*
- `dart analyze --fatal-infos` — zero warnings or errors
- `flutter test` — all tests pass
- 95% coverage on changed files (enforced by pre-commit hook)

### Phase 4 – Testing Checkpoint
- Unit tests added/updated for all new ViewModel and Repository logic
- UI tests added/updated for all new/changed screens and components
- Integration tests updated if any user-facing flows changed
- Run `./scripts/test_coverage.sh` to verify full-repo 90% threshold

### Phase 5 – Self Code Review
The goal of this phase is **zero comments from the PR reviewer**. Check every item:

**Architecture & MVVM**
- No business logic in components — all actions passed as callbacks from ViewModel
- Navigation delegated to ViewModel methods; never called directly from UI
- Screens do not instantiate ViewModels
- ViewModel lifecycle managed correctly (`dispose()` called; controllers/nodes disposed in ViewModel)
- Repository pattern correct: `Result<T>` returned; no direct Supabase/API calls in ViewModel
- New dependencies injected via Provider in `lib/config/dependencies.dart`

**Memory & Resource Leaks**
- Every `TextEditingController` disposed
- Every `FocusNode` disposed
- Every stream subscription cancelled in `dispose()`
- `context.mounted` checked before navigation or `setState` after every `await`
- `unawaited()` used for intentional fire-and-forget operations

**Error & Edge Case Handling**
- All `Result.error` branches handled with user-visible feedback (no silent failures)
- Empty state displayed when lists or data are empty
- Loading state shown during all async operations
- Network/API errors surfaced gracefully (use `LoadingController`)
- No unguarded `!` null assertions — use proper null-safe handling

**Code Style & Quality**
- **Design Constants**: All spacing uses `AppSpacerSize` or semantic sizing classes (`AppScreenLayout`, `AppBarSizing`, `WisherSizing`); all borders use `AppBorderRadius`/`AppBorderWeight`; all icon sizes use `AppIconSize`; all colors use `AppColorScheme`
- No hardcoded colors — use `AppColorScheme` extension
- No hardcoded text styles — use `Theme.of(context).textTheme`
- No hardcoded spacing or sizes — use `AppSpacerSize`, `AppScreenLayout`, `AppBarSizing`, `WisherSizing`, `AppBorderRadius`, `AppBorderWeight`, `AppIconSize`
- All imports use `package:` (no relative imports)
- Lines ≤ 80 characters
- `const` constructors used wherever possible
- `SizedBox` used for whitespace (not `Container`)
- No debug code, commented-out code, or stray TODO comments left behind
- See `docs/DESIGN_CONSTANTS.md` for comprehensive constants reference

**Accessibility**
- `TextOverflow.ellipsis` on all potentially long text in constrained layouts
- `Flexible` wrapping applied to secondary/optional text in rows
- Fixed-height containers are generous enough for large text scaling
- Buttons use `minimumSize` where applicable

**Security & Logging**
- Sensitive/user data only logged via `AppLogger.safe()`
- All log calls include `context: 'ClassName.method'`
- Appropriate log level used: `debug` / `info` / `warning` / `error`
- No credentials or secrets in source code

**Localization**
- All user-visible strings use l10n keys (no raw string literals in UI)
- New strings added to `lib/l10n/app_en.arb` with `@` descriptions
- `flutter gen-l10n` run after any ARB file changes

**Testing Completeness** *(cross-check with Phase 4)*
- All ViewModel public methods covered by unit tests
- All states (initial, loading, success, error, empty) tested
- Every edge case and error branch has a test
- No coverage gaps on new/changed files (95% threshold met)

### Phase 6 – PR Readiness
- Branch is rebased on main if needed; no merge conflicts
- Commit messages are clear and descriptive
- Open PR using the PR template (`.github/pull_request_template.md`)

---

## Detailed Documentation

- Full architecture and style guide: `docs/AGENTS.md`
- Testing standards: `docs/TESTING_STANDARDS.md`
- Logging patterns: `docs/LOGGING.md`
- Component creation: `docs/ADD_COMPONENT_SCRIPT.md`
