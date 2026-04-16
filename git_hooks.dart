// ignore_for_file: type=lint
import 'dart:io';

// ===================================
// PRE-COMMIT CONFIGURATION
// ===================================

// Coverage exclusion patterns - must be kept in sync with scripts/test_coverage.sh
// Note: These use substring matching (not glob patterns like lcov requires)
const _excludePatterns = [
  'l10n/app_localizations',
  '.g.dart',
  'main.dart',
  'app_config.dart',
  'app_logger.dart',
  'components/demo/demos',
  'components/demo/demo_home.dart',
  'components/demo/demo_app.dart',
  'data/data_sources/',
  '/demo/',
  // Note: Integration tests are NOT excluded - they count toward coverage
];

// Enable test quality analysis during refactoring phase
// - Set to 'true' to enforce test standards during refactoring
// - Set to 'false' to skip for normal development
const enableTestQualityAnalysis = true;

// Overall code coverage threshold (used for full repo coverage checks)
const coverageThreshold = 90.0;

// New code coverage threshold - stricter threshold for code being committed
// This ensures new/changed code meets higher quality standards
const newCodeCoverageThreshold = 95.0;

void main(List<String> arguments) async {
  // Check if this is being run as a pre-commit hook
  if (arguments.isNotEmpty && arguments[0] == 'pre-commit') {
    final success = await _preCommit();
    exit(success ? 0 : 1);
  }

  // If no arguments, install the hooks
  print('Installing git hooks...');
  await _installHooks();
  print('✅ Git hooks installed successfully!');
}

Future<void> _installHooks() async {
  Directory? hooksDir = Directory('.git/hooks');

  // Check if we're in a worktree (.git is a file, not a directory)
  final gitDir = File('.git');
  if (gitDir.existsSync()) {
    final content = await gitDir.readAsString();
    if (content.startsWith('gitdir:')) {
      final gitdirPath = content.substring('gitdir:'.length).trim();
      final commondirFile = File('$gitdirPath/commondir');

      if (commondirFile.existsSync()) {
        final commondir = (await commondirFile.readAsString()).trim();
        final worktreesDir = Directory(gitdirPath).parent;
        hooksDir = Directory('${worktreesDir.path}/$commondir/hooks');
      } else {
        hooksDir = Directory('$gitdirPath/hooks');
        if (!hooksDir.existsSync()) {
          await hooksDir.create(recursive: true);
        }
      }
    }
  }

  if (!hooksDir.existsSync()) {
    print('❌ .git/hooks directory not found. Are you in a git repository?');
    exit(1);
  }

  final preCommitHook = File('${hooksDir.path}/pre-commit');

  // Create the pre-commit hook that calls this Dart script
  final hookContent = '''#!/bin/sh
# Get the repository root dynamically (works for both normal repos and worktrees)
GIT_ROOT=\$(git rev-parse --show-toplevel)
exec env -i HOME="\$HOME" USER="\$USER" /bin/sh -c 'cd "\$GIT_ROOT" && dart run git_hooks.dart pre-commit'
''';

  await preCommitHook.writeAsString(hookContent);

  // Make it executable (Unix/Mac/Linux)
  if (!Platform.isWindows) {
    await Process.run('chmod', ['+x', preCommitHook.path]);
  }
}

Future<bool> _runTestQualityAnalysis() async {
  // Check if test quality analysis is enabled (can be toggled during refactoring)
  // Configuration is at the top of git_hooks.dart
  if (!enableTestQualityAnalysis) {
    print('⏭️  Test quality analysis disabled. Skipping...\n');
    return true;
  }

  print('📊 Running test quality analysis...');
  final analysisResult = await Process.run(
    './scripts/analyze_tests.sh',
    [],
    runInShell: true,
  );

  if (analysisResult.exitCode != 0) {
    print('❌ Test quality analysis failed:');
    print(analysisResult.stdout);
    print(analysisResult.stderr);
    print('\n💡 To fix these issues, see: docs/TESTING_STANDARDS.md');
    print(
      '💡 To disable this check temporarily, set enableTestAnalysis = false in git_hooks.dart:98\n',
    );
    return false;
  }
  print('✅ Test quality analysis passed\n');
  return true;
}

Future<bool> _runScreenViewModelAnalysis() async {
  print('🧭 Running screen/viewmodel consistency analysis...');
  final analysisResult = await Process.run(
    './scripts/analyze_screen_viewmodels.sh',
    [],
    runInShell: true,
  );

  if (analysisResult.exitCode != 0) {
    print('❌ Screen/viewmodel consistency analysis failed:');
    print(analysisResult.stdout);
    print(analysisResult.stderr);
    print('\n💡 To fix these issues, see: docs/AGENTS.md\n');
    return false;
  }

  print('✅ Screen/viewmodel consistency analysis passed\n');
  return true;
}

Future<bool> _preCommit() async {
  print('🔍 Running pre-commit checks...\n');

  // Run dart format check
  print('📝 Checking formatting...');
  final formatResult = await Process.run('dart', [
    'format',
    '--set-exit-if-changed',
    '.',
  ], runInShell: true);

  if (formatResult.exitCode != 0) {
    print('❌ Code is not formatted. Running dart format...');
    await Process.run('dart', ['format', '.'], runInShell: true);
    print('✅ Code formatted. Please stage the changes and commit again.\n');
    return false;
  }
  print('✅ Code is formatted correctly\n');

  // Run dart analyze
  print('🔎 Running static analysis...');
  final analyzeResult = await Process.run('dart', [
    'analyze',
    '--fatal-infos',
  ], runInShell: true);

  if (analyzeResult.exitCode != 0) {
    print('❌ Analysis found issues:');
    print(analyzeResult.stdout);
    print(analyzeResult.stderr);
    return false;
  }
  print('✅ No analysis issues found\n');

  // Run test quality analysis (optional - enabled during refactoring)
  final testAnalysisSuccess = await _runTestQualityAnalysis();
  if (!testAnalysisSuccess) {
    return false;
  }

  final screenViewModelAnalysisSuccess = await _runScreenViewModelAnalysis();
  if (!screenViewModelAnalysisSuccess) {
    return false;
  }

  // Run tests with new code coverage (focus on changed files only)
  print('🧪 Running tests for new code...');
  final coverageSuccess = await _checkCoverage(
    threshold: newCodeCoverageThreshold,
    isNewCodeCoverage: true,
  );
  if (!coverageSuccess) {
    return false;
  }

  print('✨ All checks passed! Proceeding with commit.\n');
  return true;
}

/// Checks test coverage against the specified threshold.
/// If isNewCodeCoverage is true, focuses on changed files only.
Future<bool> _checkCoverage({
  required double threshold,
  bool isNewCodeCoverage = false,
}) async {
  // Run pub get first to ensure dependencies are resolved
  await Process.run('flutter', ['pub', 'get'], runInShell: true);

  List<String> testFiles = [];
  List<String> changedFiles = [];

  if (isNewCodeCoverage) {
    // Get changed source files
    print('📝 Finding changed source files...');
    changedFiles = await _getChangedSourceFiles();
    changedFiles = changedFiles.where(_hasCoverableLines).toList();

    if (changedFiles.isEmpty) {
      print('ℹ️  No source files changed. Skipping new code coverage check.\n');
      return true;
    }

    print('Changed files: ${changedFiles.length}');
    for (final file in changedFiles) {
      print('  - $file');
    }
    print('');

    // Map source files to test files
    print('🔗 Mapping source files to test files...');
    testFiles = _mapSourceToTestFiles(changedFiles);

    if (testFiles.isEmpty) {
      print(
        '⚠️  No test files found for changed source files.\n'
        '   This may indicate missing tests. Please ensure tests exist.\n',
      );
      // Don't fail, but warn - the developer should add tests
      return true;
    }

    print('Test files to run: ${testFiles.length}');
    for (final file in testFiles) {
      print('  - $file');
    }
    print('');
  }

  // Run tests with coverage
  // Note: flutter test automatically runs both test/ (unit/widget) and integration_test/
  // directories, so integration tests will be included in coverage automatically.
  print(
    isNewCodeCoverage
        ? '🧪 Running tests for changed files only (including integration tests)...'
        : '🧪 Running all tests (including integration tests)...',
  );

  ProcessResult testResult;

  if (isNewCodeCoverage && testFiles.isNotEmpty) {
    // Run specific test files for changed source files
    // This runs both unit/widget tests AND any related integration tests
    // (flutter test automatically includes integration_test/ when running test files)
    testResult = await Process.run('flutter', [
      'test',
      '--coverage',
      ...testFiles,
    ], runInShell: true);
  } else {
    // Run all tests - includes both unit/widget tests AND integration tests
    // Integration tests in integration_test/ are automatically included
    testResult = await Process.run('flutter', [
      'test',
      '--coverage',
    ], runInShell: true);
  }

  if (testResult.exitCode != 0) {
    print('❌ Tests failed. Fix tests before checking coverage.\n');
    print(testResult.stdout);
    print(testResult.stderr);
    return false;
  }

  print('✅ All tests passed\n');

  // Check if coverage file exists
  print('📊 Checking test coverage...');
  final coverageFile = File('coverage/lcov.info');
  if (!coverageFile.existsSync()) {
    print('❌ Coverage file not found. Make sure tests ran successfully.\n');
    return false;
  }

  // Parse coverage (optionally filtering for new code coverage)
  final coverage = await _parseLcovCoverage(
    coverageFile,
    filterFiles: isNewCodeCoverage ? changedFiles : null,
  );

  final coverageType = isNewCodeCoverage ? 'New code coverage' : 'Coverage';
  print('$coverageType: ${coverage.toStringAsFixed(2)}%');

  if (coverage < threshold) {
    print(
      '❌ $coverageType ${coverage.toStringAsFixed(2)}% is below threshold ${threshold.toStringAsFixed(2)}%\n',
    );
    print('Please add more tests to increase coverage.\n');

    if (isNewCodeCoverage) {
      print('Changed files needing coverage:');
      for (final file in changedFiles) {
        print('  - $file');
      }
      print('');
    }

    print('Check coverage report by running the following commands:\n');
    print('`genhtml coverage/lcov.info -o coverage/html`');
    print('`open coverage/html/index.html`\n');
    return false;
  }

  print('✅ Coverage meets threshold (${threshold.toStringAsFixed(2)}%)\n');
  return true;
}

/// Parses lcov coverage file and returns the coverage percentage.
/// Optionally filters to only include specific files.
Future<double> _parseLcovCoverage(
  File lcovFile, {
  List<String>? filterFiles,
}) async {
  final lines = await lcovFile.readAsLines();

  // Coverage exclusions - must be kept in sync with scripts/test_coverage.sh
  // Note: These use substring matching (not glob patterns like lcov requires)
  const excludePatterns = _excludePatterns;

  int totalLines = 0;
  int coveredLines = 0;
  String? currentFile;
  bool isInFilteredFile = false;

  for (var line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);

      // Check if this file should be included
      final isExcluded = excludePatterns.any(
        (pattern) => currentFile!.contains(pattern),
      );

      if (filterFiles != null && filterFiles.isNotEmpty) {
        // For new code coverage, check if this file matches any of our changed files
        // Convert to relative path for comparison
        final relativePath = currentFile.contains('/lib/')
            ? currentFile.substring(currentFile.indexOf('/lib/') + 4)
            : currentFile;
        isInFilteredFile = filterFiles.any(
          (f) => relativePath.endsWith(f.replaceFirst('lib/', '')),
        );
        // Exclude if it's not a filtered file
        if (!isInFilteredFile) continue;
      }

      // Skip excluded files
      if (isExcluded) continue;
    }

    // Skip files that aren't in our filter (if filtering is enabled)
    if (filterFiles != null && !isInFilteredFile) continue;

    if (line.startsWith('DA:')) {
      // DA:line_number,execution_count
      final parts = line.substring(3).split(',');
      if (parts.length == 2) {
        totalLines++;
        final executionCount = int.tryParse(parts[1]) ?? 0;
        if (executionCount > 0) {
          coveredLines++;
        }
      }
    }
  }

  if (totalLines == 0) return 0.0;
  return (coveredLines / totalLines) * 100;
}

// ===================================
// NEW CODE COVERAGE FUNCTIONS
// ===================================

/// Gets the list of changed/added source files in the current commit.
/// Only considers staged changes (--cached) to ensure we're checking
/// what will actually be committed.
Future<List<String>> _getChangedSourceFiles() async {
  // Get staged changes (what will be committed)
  final stagedResult = await Process.run('git', [
    'diff',
    '--cached',
    '--name-only',
    '--diff-filter=ACM',
  ], runInShell: true);

  if (stagedResult.exitCode != 0) {
    print('⚠️  Could not get staged changes: ${stagedResult.stderr}');
    return [];
  }

  final stagedFiles = (stagedResult.stdout as String)
      .split('\n')
      .where((f) => f.isNotEmpty && f.startsWith('lib/'))
      .toList();

  // Also check for new untracked files in lib/
  final untrackedResult = await Process.run('git', [
    'ls-files',
    '--others',
    '--exclude-standard',
    'lib/',
  ], runInShell: true);

  if (untrackedResult.exitCode != 0) {
    print('⚠️  Could not get untracked files: ${untrackedResult.stderr}');
  } else {
    final untrackedFiles = (untrackedResult.stdout as String)
        .split('\n')
        .where((f) => f.isNotEmpty)
        .toList();
    stagedFiles.addAll(untrackedFiles);
  }

  // Filter out files that match our exclusion patterns
  return stagedFiles.where((f) => !_isExcludedFromCoverage(f)).toList();
}

/// Checks if a file should be excluded from coverage calculations
bool _isExcludedFromCoverage(String filePath) {
  return _excludePatterns.any((pattern) => filePath.contains(pattern));
}

/// Returns true when a file contains Dart statements that should appear in LCOV.
bool _hasCoverableLines(String filePath) {
  final file = File(filePath);
  if (!file.existsSync()) return true;

  final lines = file.readAsLinesSync();

  for (final rawLine in lines) {
    final line = rawLine.trim();

    if (line.isEmpty ||
        line.startsWith('//') ||
        line.startsWith('///') ||
        line.startsWith('*') ||
        line.startsWith('import ') ||
        line.startsWith('export ') ||
        line.startsWith('part ') ||
        line.startsWith('library ') ||
        line.startsWith('@') ||
        line == '{' ||
        line == '}') {
      continue;
    }

    if (RegExp(r'^(abstract\s+)?class\s+\w+[^{]*\{$').hasMatch(line) ||
        RegExp(r'^(abstract\s+)?mixin\s+\w+[^{]*\{$').hasMatch(line) ||
        RegExp(r'^enum\s+\w+[^{]*\{$').hasMatch(line) ||
        RegExp(
          r'^(final|const|static)\s+[\w<>,?]+\s+\w+\s*;$',
        ).hasMatch(line) ||
        RegExp(r'^[\w<>,?]+\s+\w+\s*;$').hasMatch(line) ||
        RegExp(r'^[\w<>,?]+\s+\w+\([^)]*\);$').hasMatch(line) ||
        RegExp(r'^(get|set)\s+\w+[^;]*;$').hasMatch(line)) {
      continue;
    }

    return true;
  }

  return false;
}

/// Maps source files to their corresponding test files.
/// Follows the project's convention: lib/foo/bar.dart -> test/.../bar_test.dart
List<String> _mapSourceToTestFiles(List<String> sourceFiles) {
  final testFiles = <String>{};

  for (final sourceFile in sourceFiles) {
    final testFile = _sourceToTestPath(sourceFile);
    if (testFile != null) {
      if (File(testFile).existsSync()) {
        testFiles.add(testFile);
        continue;
      }

      final fallbackTestFile = _componentToScreenTestPath(sourceFile);
      if (fallbackTestFile != null && File(fallbackTestFile).existsSync()) {
        testFiles.add(fallbackTestFile);
        continue;
      }

      testFiles.add(testFile);
    }
  }

  return testFiles.toList();
}

String? _componentToScreenTestPath(String sourcePath) {
  final match = RegExp(
    r'^lib/features/([^/]+)/([^/]+)/components/[^/]+\.dart$',
  ).firstMatch(sourcePath);

  if (match == null) return null;

  final featureGroup = match.group(1)!;
  final screenFolder = match.group(2)!;

  return 'test/ui_tests/screens/$featureGroup/$screenFolder/${screenFolder}_screen_test.dart';
}

/// Converts a source file path to its corresponding test file path.
///
/// Handles the project's path mapping:
/// - lib/unit_tests/foo/bar.dart -> test/unit_tests/foo/bar_test.dart
/// - lib/ui_tests/foo/bar.dart -> test/ui_tests/foo/bar_test.dart
/// - lib/features/foo/bar_screen.dart -> test/ui_tests/screens/foo/bar_screen_test.dart
/// - lib/features/foo/bar_view_model.dart -> test/unit_tests/screens/foo/bar_view_model_test.dart
String? _sourceToTestPath(String sourcePath) {
  if (!sourcePath.startsWith('lib/')) return null;

  final relativePath = sourcePath.substring(4);

  // Map lib paths to test paths
  String testPath;

  if (relativePath.startsWith('features/')) {
    // Check for feature sub-components (features/*/*/components/*.dart)
    // These are UI components within a feature and should be UI tested
    // Example: features/add_wisher/add_wisher_landing/components/buttons.dart
    //   -> test/ui_tests/screens/add_wisher/add_wisher_landing/buttons_test.dart
    // Pattern: features/{category}/{screen_folder}/components/{file}.dart
    final componentsMatch = RegExp(
      r'^features/([^/]+)/([^/]+)/components/([^/]+\.dart)$',
    ).firstMatch(relativePath);
    if (componentsMatch != null) {
      // Use both category (group 1) and screen folder (group 2) for nested path
      final category = componentsMatch.group(1)!;
      final screenFolder = componentsMatch.group(2)!;
      final fileName = componentsMatch.group(3)!;
      testPath =
          'test/ui_tests/screens/$category/$screenFolder/${_toTestFileName(fileName)}';
    } else {
      // Feature files map to tests following source structure:
      // - features/auth/login/login_screen.dart -> test/ui_tests/screens/login/login_screen_test.dart
      // - features/auth/login/login_view_model.dart -> test/unit_tests/screens/login/login_view_model_test.dart
      // - features/add_wisher/add_wisher_details/screen.dart -> test/ui_tests/screens/add_wisher/add_wisher_details/screen_test.dart
      final parts = relativePath.split('/');
      if (parts.length >= 3) {
        final fileName = parts.last;

        // Determine the test path based on test type
        if (fileName.endsWith('_screen.dart') ||
            fileName.endsWith('_view.dart')) {
          // UI test - preserve subdirectory structure
          // For features/auth/login/login_screen.dart:
          // subDir = parts[1..2] = 'auth/login'
          // Result: test/ui_tests/screens/auth/login/login_screen_test.dart
          final subDir = parts.sublist(1, parts.length - 1).join('/');
          testPath =
              'test/ui_tests/screens/$subDir/${_toTestFileName(fileName)}';
        } else if (fileName.endsWith('_view_model.dart')) {
          // Unit test for view model - preserve subdirectory structure
          // For features/auth/login/login_view_model.dart:
          // subDir = parts[1..2] = 'auth/login'
          // Result: test/unit_tests/screens/auth/login/login_view_model_test.dart
          final subDir = parts.sublist(1, parts.length - 1).join('/');
          testPath =
              'test/unit_tests/screens/$subDir/${_toTestFileName(fileName)}';
        } else {
          // Default to mirrored unit tests for shared feature infrastructure
          final subDir = parts.sublist(0, parts.length - 1).join('/');
          testPath = 'test/unit_tests/lib/$subDir/${_toTestFileName(fileName)}';
        }
      } else {
        return null;
      }
    }
  } else if (relativePath.startsWith('components/')) {
    // Components have two test locations:
    // 1. Type files (*_type.dart) -> unit tests: test/unit_tests/components/{name}_test.dart
    // 2. Widget files -> UI tests: test/ui_tests/components/{folder}/{name}_test.dart
    final parts = relativePath.split('/');
    if (parts.length >= 2) {
      final folderName = parts[1]; // e.g., 'button', 'app_alert'
      final fileName =
          parts.last; // e.g., 'app_button.dart' or 'app_button_type.dart'

      if (fileName.endsWith('_type.dart')) {
        // Type files go to unit tests
        testPath = 'test/unit_tests/components/${_toTestFileName(fileName)}';
      } else if (fileName.endsWith('.dart')) {
        // Widget files go to UI tests
        testPath =
            'test/ui_tests/components/$folderName/${_toTestFileName(fileName)}';
      } else {
        return null;
      }
    } else {
      return null;
    }
  } else if (relativePath.startsWith('data/')) {
    // data/models/foo/bar.dart -> test/unit_tests/data/models/bar_test.dart
    // data/repositories/foo/bar_impl.dart -> test/unit_tests/data/repositories/bar_impl_test.dart
    final parts = relativePath.split('/');
    if (parts.length >= 3) {
      final subDir = parts.sublist(1, parts.length - 1).join('/');
      final fileName = parts.last;
      testPath = 'test/unit_tests/data/$subDir/${_toTestFileName(fileName)}';
    } else {
      return null;
    }
  } else if (relativePath.startsWith('utils/')) {
    // utils/foo/bar.dart -> test/unit_tests/utils/bar_test.dart
    final parts = relativePath.split('/');
    if (parts.length >= 2) {
      final fileName = parts.last;
      testPath = 'test/unit_tests/utils/${_toTestFileName(fileName)}';
    } else {
      return null;
    }
  } else if (relativePath.startsWith('theme/') ||
      relativePath.startsWith('routing/') ||
      relativePath.startsWith('l10n/') ||
      relativePath.startsWith('config/')) {
    // Top-level lib directories map to app tests
    final fileName = relativePath.split('/').last;
    testPath = 'test/unit_tests/app/${_toTestFileName(fileName)}';
  } else {
    // Default: mirror structure under unit_tests/
    final fileName = relativePath.split('/').last;
    final dir = relativePath.contains('/')
        ? relativePath.substring(0, relativePath.lastIndexOf('/'))
        : '';
    testPath = 'test/unit_tests/$dir/${_toTestFileName(fileName)}';
  }

  return testPath;
}

/// Converts a source file name to a test file name
/// bar.dart -> bar_test.dart
String _toTestFileName(String fileName) {
  if (!fileName.contains('.')) return '${fileName}_test.dart';
  final lastDot = fileName.lastIndexOf('.');
  return '${fileName.substring(0, lastDot)}_test.dart';
}
