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

  print('✨ All checks passed! Proceeding with commit.\n');
  return true;
}
