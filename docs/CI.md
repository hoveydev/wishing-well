CI for wishing-well

What runs here
- Format check (dart format)
- Static analysis (dart analyze --fatal-infos)
- Tests (flutter test)

Branch protection
- Require these checks on the main branch to block merges until they pass. Exact check names are: "Format check", "Static analysis", "Tests".

Fork PRs and secrets
- Workflows triggered by forks do not have access to repository secrets. Avoid depending on secrets in checks that must pass for fork PRs. For jobs that need secrets, consider running them only on pushes to protected branches or using a merge queue that runs checks in the base branch context.

How to run locally
- flutter pub get
- dart format --set-exit-if-changed .
- dart analyze --fatal-infos
- flutter test

Contact
- For CI issues, open an issue linking to the failing run URL.
