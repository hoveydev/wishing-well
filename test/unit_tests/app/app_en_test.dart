import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('AppLocalizations (app_en.arb)', () {
    group(TestGroups.initialState, () {
      test('all expected l10n keys are defined', () async {
        const locale = Locale('en');
        const delegate = AppLocalizations.delegate;
        expect(delegate.isSupported(locale), isTrue);
        final loc = await delegate.load(locale);

        expect(loc.appName, isNotEmpty);
        expect(loc.authEmail, isNotEmpty);
        expect(loc.authPassword, isNotEmpty);
        expect(loc.authSignIn, isNotEmpty);
        expect(loc.errorInvalidEmail, isNotEmpty);
        expect(loc.errorUnknown, isNotEmpty);
        expect(loc.loginScreenHeader, isNotEmpty);
        expect(loc.addWisherScreenHeader, isNotEmpty);
        expect(loc.firstName, isNotEmpty);
        expect(loc.lastName, isNotEmpty);
        expect(loc.save, isNotEmpty);
        expect(loc.cancel, isNotEmpty);
        expect(loc.delete, isNotEmpty);
        expect(loc.wisherDeleteConfirmTitle, isNotEmpty);
        expect(loc.appBarEdit, isNotEmpty);
        expect(loc.editWisherScreenHeader, isNotEmpty);
        expect(loc.editWisherScreenSubtext, isNotEmpty);
        expect(loc.saveChanges, isNotEmpty);
        expect(loc.wisherNotFound, isNotEmpty);
        expect(loc.wisherUpdatedSuccess('Test'), isNotEmpty);
        expect(loc.wisherDeleteConfirmMessage('Test'), isNotEmpty);
      });

      test('supported locales include English', () {
        expect(AppLocalizations.supportedLocales, contains(const Locale('en')));
      });

      test('delegate list includes required delegates', () {
        expect(
          AppLocalizations.localizationsDelegates,
          containsAll([
            AppLocalizations.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ]),
        );
      });
    });

    group(TestGroups.behavior, () {
      test('wisherDeleteConfirmMessage includes name parameter', () async {
        const name = 'Alice';
        const locale = Locale('en');
        final loc = await AppLocalizations.delegate.load(locale);
        expect(loc.wisherDeleteConfirmMessage(name), contains(name));
      });

      test('wisherUpdatedSuccess includes name parameter', () async {
        const name = 'Bob';
        const locale = Locale('en');
        final loc = await AppLocalizations.delegate.load(locale);
        expect(loc.wisherUpdatedSuccess(name), contains(name));
      });

      test('wisherCreatedSuccess includes name parameter', () async {
        const name = 'Charlie';
        const locale = Locale('en');
        final loc = await AppLocalizations.delegate.load(locale);
        expect(loc.wisherCreatedSuccess(name), contains(name));
      });
    });
  });
}
