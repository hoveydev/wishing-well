import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_batch_importer.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/features/add_wisher/demo/add_wisher_demo_providers.dart';
import 'package:wishing_well/features/add_wisher/demo/demo_add_wisher_contact_access.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_auth_repository.dart';
import 'package:wishing_well/test_helpers/mocks/repositories/mock_image_repository.dart';

void main() {
  group('AddWisherDemoProviders', () {
    for (final scenario in AddWisherDemoScenario.values) {
      group('${scenario.name} scenario', () {
        late List<SingleChildWidget> providers;

        setUp(() {
          providers = getAddWisherDemoProviders(scenario: scenario);
        });

        test('includes demo-specific contact picker wiring', () {
          expect(providers.length, 5);
          expect(providers[3], isA<Provider<GlobalKey<NavigatorState>>>());
          expect(providers[4], isA<Provider<AddWisherContactAccess>>());
        });
      });
    }

    test('ships canned contacts with and without photos', () {
      final contacts = demoAddWisherContacts(
        scenario: AddWisherDemoScenario.success,
      );

      expect(
        contacts.any(
          (contact) => contact.photoUrl != null && contact.photoUrl!.isNotEmpty,
        ),
        isTrue,
      );
      expect(contacts.any((contact) => contact.photoUrl == null), isTrue);
      expect(
        contacts.any(
          (contact) => contact.selection.imageReference?.hasBytes ?? false,
        ),
        isTrue,
      );
    });

    test('ships real PNG bytes for photo contacts', () {
      final contacts = demoAddWisherContacts(
        scenario: AddWisherDemoScenario.success,
      ).where((contact) => contact.selection.imageReference?.hasBytes ?? false);

      for (final contact in contacts) {
        final imageReference = contact.selection.imageReference!;

        expect(imageReference.fileExtension, 'png');
        expect(imageReference.bytes!.take(8).toList(growable: false), [
          0x89,
          0x50,
          0x4E,
          0x47,
          0x0D,
          0x0A,
          0x1A,
          0x0A,
        ]);
      }
    });

    test('adds a failing contact to the error scenario', () {
      final contacts = demoAddWisherContacts(
        scenario: AddWisherDemoScenario.error,
      );

      expect(
        contacts.any((contact) => contact.description == 'Will fail to import'),
        isTrue,
      );
    });

    test('adds an exact-match duplicate contact to the duplicate scenario', () {
      final contacts = demoAddWisherContacts(
        scenario: AddWisherDemoScenario.duplicate,
      );

      expect(
        contacts.any(
          (contact) =>
              contact.selection.firstName == 'Alice' &&
              contact.selection.lastName == 'Johnson' &&
              contact.description == 'Matches an existing demo wisher',
        ),
        isTrue,
      );
    });

    testWidgets('provides demo contact access implementation', (
      WidgetTester tester,
    ) async {
      late AddWisherContactAccess contactAccess;

      await tester.pumpWidget(
        MultiProvider(
          providers: getAddWisherDemoProviders(
            scenario: AddWisherDemoScenario.success,
          ),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                contactAccess = context.read<AddWisherContactAccess>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      expect(contactAccess, isA<DemoAddWisherContactAccess>());
    });

    testWidgets('wires duplicate scenario into real duplicate detection', (
      WidgetTester tester,
    ) async {
      late WisherRepository wisherRepository;

      await tester.pumpWidget(
        MultiProvider(
          providers: getAddWisherDemoProviders(
            scenario: AddWisherDemoScenario.duplicate,
          ),
          child: MaterialApp(
            home: Builder(
              builder: (context) {
                wisherRepository = context.read<WisherRepository>();
                return const SizedBox.shrink();
              },
            ),
          ),
        ),
      );

      final duplicateDrafts = demoAddWisherContacts(
        scenario: AddWisherDemoScenario.duplicate,
      ).map((contact) => contact.selection.toDraft()).toList(growable: false);

      final importer = AddWisherContactBatchImporter(
        authRepository: MockAuthRepository(),
        wisherRepository: wisherRepository,
        imageRepository: MockImageRepository(),
      );
      final duplicateReport = importer.detectDuplicates(duplicateDrafts);

      expect(
        wisherRepository.wishers.any(
          (wisher) => wisher.name == 'Alice Johnson',
        ),
        isTrue,
      );
      expect(duplicateReport.duplicateCount, 1);
      expect(
        duplicateReport.duplicates.single.draft.summaryLabel,
        'Alice Johnson',
      );
      expect(
        duplicateReport.duplicates.single.normalizedFullName,
        AddWisherContactNormalizedFullName.fromParts(
          firstName: 'Alice',
          lastName: 'Johnson',
        ),
      );
    });
  });
}
