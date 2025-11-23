// ignore_for_file: type=lint
import 'dart:io';

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
  final hooksDir = Directory('.git/hooks');

  if (!hooksDir.existsSync()) {
    print('❌ .git/hooks directory not found. Are you in a git repository?');
    exit(1);
  }

  final preCommitHook = File('.git/hooks/pre-commit');

  // Create the pre-commit hook that calls this Dart script
  const hookContent = '''#!/bin/sh
  dart run git_hooks.dart pre-commit
  ''';

  await preCommitHook.writeAsString(hookContent);

  // Make it executable (Unix/Mac/Linux)
  if (!Platform.isWindows) {
    await Process.run('chmod', ['+x', preCommitHook.path]);
  }
}

Future<bool> _preCommit() async {
  print('🔍 Running pre-commit checks...\n');

  // Run dart format check
  print('📝 Checking formatting...');
  final formatResult = await Process.run('dart', [
    'format',
    '--set-exit-if-changed',
    '.',
  ]);

  if (formatResult.exitCode != 0) {
    print('❌ Code is not formatted. Running dart format...');
    await Process.run('dart', ['format', '.']);
    print('✅ Code formatted. Please stage the changes and commit again.\n');
    return false;
  }
  print('✅ Code is formatted correctly\n');

  // Run dart analyze
  print('🔎 Running static analysis...');
  final analyzeResult = await Process.run('dart', ['analyze', '--fatal-infos']);

  if (analyzeResult.exitCode != 0) {
    print('❌ Analysis found issues:');
    print(analyzeResult.stdout);
    print(analyzeResult.stderr);
    return false;
  }
  print('✅ No analysis issues found\n');

  // Run tests
  print('🧪 Running tests...');
  final coverageSuccess = await _checkCoverage(
    threshold: 100.0,
  ); // UPDATE COVERAGE THRESHOLD HERE
  if (!coverageSuccess) {
    return false;
  }

  print('✨ All checks passed! Proceeding with commit.\n');
  return true;
}

Future<bool> _checkCoverage({required double threshold}) async {
  // Run tests with coverage
  final testResult = await Process.run('flutter', ['test', '--coverage']);

  if (testResult.exitCode != 0) {
    print('❌ Tests failed. Fix tests before checking coverage.\n');
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

  // Parse coverage
  final coverage = await _parseLcovCoverage(coverageFile);

  print('Coverage: ${coverage.toStringAsFixed(2)}%');

  if (coverage < threshold) {
    print(
      '❌ Coverage ${coverage.toStringAsFixed(2)}% is below threshold ${threshold.toStringAsFixed(2)}%\n',
    );
    print('Please add more tests to increase coverage.\n');
    print('Check coverage report by running the folowing commands:\n');
    print('`genhtml coverage/lcov.info -o coverage/html`');
    print('`open coverage/html/index.html`\n');
    return false;
  }

  print('✅ Coverage meets threshold (${threshold.toStringAsFixed(2)}%)\n');
  return true;
}

Future<double> _parseLcovCoverage(File lcovFile) async {
  final lines = await lcovFile.readAsLines();

  const excludePatterns = ['l10n/app_localizations', 'generated', '.g.dart'];

  int totalLines = 0;
  int coveredLines = 0;
  String? currentFile;

  for (var line in lines) {
    if (line.startsWith('SF:')) {
      currentFile = line.substring(3);
    }

    // Skip excluded files
    if (currentFile != null &&
        excludePatterns.any((pattern) => currentFile!.contains(pattern))) {
      continue;
    }

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
