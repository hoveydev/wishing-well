# WishingWell

A new Flutter project.

## Helpful Commands

### Localized Strings

This project uses the `flutter_localizations` package for app localizations and requires a couple easy steps to add and generate new strings.

1. Add your string variable and value to `lib/l10n/app_en.arb`
2. Add a property object using the `@` keyword followed by the variable defined
3. That object should contain a `description` property where you should define the purpose and use of the string
4. Run `flutter gen-l10n` to generate the necessary localization files*
```console
$ flutter gen-l10n
```

**you will be unable to use the new localization variable without running this script*

### UI/Unit Testing

Along with standard flutter testing, the app also uses the `coverage` package to handle code coverage gates and generate simple coverage reports to help with code coverage.

To accurately test the code coverage of the app, you should do the following:

1. Run `flutter test --coverage` to run the entire testing suite and generate a coverate report in a new `coverage` folder
```console
$ flutter test --coverage
```
2. Run `lcov -r coverage/lcov.info "**/l10n/**" -o coverage/lcov.info` to remove the unecessary files from the coverage report.*
```console
$ lcov -r coverage/lcov.info "**/l10n/**" -o coverage/lcov.info
```
**the above script only ignores the localization files - you will need to add any additional files/patterns in quotations*

3. Run `genhtml coverage/lcov.info -o coverage/html` to generate a simple html file with the new report for coverage visualization
```console
$ genhtml coverage/lcov.info -o coverage/html
```
4. Run `open coverage/html/index.html` to open the file in your local browser.
```console
$ open coverage/html/index.html
```

#### Pre-Commit
**all code found in `git_hooks.dart`*

The pre-commit script included has a dedicated section for code coverage threshold (line 74) and exlcluded files (line 126), which can be updated at any time.
