## What Changed
<!-- Brief description of what this PR does and why -->


## Type of Change
- [ ] Bug fix
- [ ] New feature
- [ ] Refactor (no functional change)
- [ ] Chore / dependency update
- [ ] Documentation

---

## Testing
- [ ] Unit tests added/updated for all ViewModel and Repository changes
- [ ] UI tests added/updated for all new/changed screens and components
- [ ] Integration tests updated if user-facing flows changed
- [ ] `dart analyze --fatal-infos` passes with zero warnings
- [ ] `flutter test` — all tests pass
- [ ] 95% coverage on changed files (pre-commit hook passes)

---

## Quality Checklist

**Architecture & MVVM**
- [ ] No business logic in components — actions passed as callbacks from ViewModel
- [ ] Navigation delegated to ViewModel; not called directly from UI
- [ ] ViewModel lifecycle managed (`dispose()` called; controllers/nodes disposed)
- [ ] Repository pattern correct (`Result<T>` returned; no direct API calls in ViewModel)

**Memory & Resource Leaks**
- [ ] All `TextEditingController`s and `FocusNode`s disposed
- [ ] `context.mounted` checked before navigation/setState after every `await`
- [ ] Stream subscriptions cancelled in `dispose()`

**Error & Edge Case Handling**
- [ ] All `Result.error` branches handled with user-visible feedback
- [ ] Empty, loading, and error states all handled
- [ ] No unguarded `!` null assertions

**Code Style**
- [ ] No hardcoded colors, text styles, spacing, or icon sizes
- [ ] All imports use `package:` (no relative imports)
- [ ] No debug code, commented-out code, or stray TODO comments

**Accessibility**
- [ ] `TextOverflow.ellipsis` on potentially long text in constrained layouts
- [ ] Fixed-height containers accommodate large text scaling

**Localization**
- [ ] All user-visible strings use l10n keys
- [ ] `app_en.arb` updated and `flutter gen-l10n` run (if applicable)

**Logging**
- [ ] Sensitive data logged only via `AppLogger.safe()`
- [ ] All log calls include `context: 'ClassName.method'`

---

## Notes for Reviewer
<!-- Any context, known limitations, or areas you'd like focused review on -->
