import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_import.dart';
import 'package:wishing_well/features/add_wisher/demo/demo_add_wisher_contact_access.dart';
import 'package:wishing_well/utils/status_overlay_controller.dart';

void main() {
  group('DemoAddWisherContactAccess', () {
    late GlobalKey<NavigatorState> navigatorKey;
    late StatusOverlayController loadingController;
    late DemoAddWisherContactAccess contactAccess;
    AddWisherContactAccessResult? result;

    setUp(() {
      navigatorKey = GlobalKey<NavigatorState>();
      loadingController = StatusOverlayController();
      contactAccess = DemoAddWisherContactAccess(
        navigatorKey: navigatorKey,
        contacts: const [
          DemoAddWisherContact(
            selection: AddWisherContactSelection(
              sourceId: 'demo-contact-1',
              firstName: 'Alex',
              lastName: 'Morgan',
              originalDisplayName: 'Alex Morgan',
            ),
          ),
          DemoAddWisherContact(
            selection: AddWisherContactSelection(
              sourceId: 'demo-contact-2',
              firstName: 'Taylor',
              lastName: 'Brooks',
              originalDisplayName: 'Taylor Brooks',
            ),
          ),
        ],
      );
      result = null;
    });

    Future<void> pumpAccessHarness(WidgetTester tester) async {
      await tester.pumpWidget(
        ChangeNotifierProvider<StatusOverlayController>.value(
          value: loadingController,
          child: MaterialApp(
            navigatorKey: navigatorKey,
            home: Scaffold(
              body: Center(
                child: ElevatedButton(
                  onPressed: () async {
                    result = await contactAccess.selectContacts();
                  },
                  child: const Text('Open picker'),
                ),
              ),
            ),
          ),
        ),
      );
    }

    testWidgets('returns the selected canned contact', (
      WidgetTester tester,
    ) async {
      loadingController.show();
      await pumpAccessHarness(tester);

      await tester.tap(find.text('Open picker'));
      await tester.pumpAndSettle();

      expect(find.text('Pick a demo contact'), findsOneWidget);
      expect(find.text('Alex Morgan'), findsOneWidget);
      expect(find.text('Taylor Brooks'), findsOneWidget);
      expect(loadingController.isIdle, isTrue);

      await tester.tap(find.text('Taylor Brooks'));
      await tester.pumpAndSettle();

      expect(
        result,
        isA<AddWisherContactAccessSelection>().having(
          (selection) => selection.drafts.single.sourceId,
          'selected sourceId',
          'demo-contact-2',
        ),
      );
      expect(loadingController.isLoading, isTrue);
    });

    testWidgets('returns cancelled when the picker is dismissed', (
      WidgetTester tester,
    ) async {
      loadingController.show();
      await pumpAccessHarness(tester);

      await tester.tap(find.text('Open picker'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();

      expect(result, isA<AddWisherContactAccessCancelled>());
      expect(loadingController.isIdle, isTrue);
    });
  });
}
