import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/models/wisher_field_options.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_profile.dart';
import 'package:wishing_well/test_helpers/helpers/test_helpers.dart';

void main() {
  group('WisherDetailsProfile', () {
    final wisher = Wisher(
      id: '1',
      userId: 'user1',
      firstName: 'Alice',
      lastName: 'Smith',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    group(TestGroups.rendering, () {
      testWidgets('renders ProfileAvatar', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(WisherDetailsProfile(wisher: wisher)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(ProfileAvatar), findsOneWidget);
      });

      testWidgets('renders wisher name', (WidgetTester tester) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(WisherDetailsProfile(wisher: wisher)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Alice Smith'), findsOneWidget);
      });

      testWidgets('renders single-name wisher when only last name is set', (
        WidgetTester tester,
      ) async {
        final wisherWithOnlyLastName = Wisher(
          id: '2',
          userId: 'user1',
          firstName: '',
          lastName: 'Brown',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WisherDetailsProfile(wisher: wisherWithOnlyLastName),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text('Brown'), findsOneWidget);
      });

      testWidgets('does not render gift sections when empty', (
        WidgetTester tester,
      ) async {
        await tester.pumpWidget(
          createScreenComponentTestWidget(WisherDetailsProfile(wisher: wisher)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Chip), findsNothing);
      });

      testWidgets('renders gift occasions section when present', (
        WidgetTester tester,
      ) async {
        final wisherWithOccasions = Wisher(
          id: '3',
          userId: 'user1',
          firstName: 'Bob',
          lastName: 'Jones',
          giftOccasions: [WisherGiftOccasions.christmas],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WisherDetailsProfile(wisher: wisherWithOccasions),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Chip), findsOneWidget);
      });

      testWidgets('renders gift interests section when present', (
        WidgetTester tester,
      ) async {
        final wisherWithInterests = Wisher(
          id: '4',
          userId: 'user1',
          firstName: 'Carol',
          lastName: 'Davis',
          giftInterests: [WisherGiftInterests.books],
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          createScreenComponentTestWidget(
            WisherDetailsProfile(wisher: wisherWithInterests),
          ),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.byType(Chip), findsOneWidget);
      });
    });
  });
}
