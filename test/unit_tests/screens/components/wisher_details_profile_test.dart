import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/data/models/wisher.dart';
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
          buildMaterialAppHome(WisherDetailsProfile(wisher: wisher)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.byType(ProfileAvatar), findsOneWidget);
      });

      testWidgets('renders wisher name', (WidgetTester tester) async {
        await tester.pumpWidget(
          buildMaterialAppHome(WisherDetailsProfile(wisher: wisher)),
        );
        await TestHelpers.pumpAndSettle(tester);
        expect(find.text('Alice Smith'), findsOneWidget);
      });

      testWidgets('renders fallback name when both names are blank', (
        WidgetTester tester,
      ) async {
        final unnamedWisher = Wisher(
          id: '2',
          userId: 'user1',
          firstName: '',
          lastName: '',
          createdAt: DateTime.now(),
          updatedAt: DateTime.now(),
        );

        await tester.pumpWidget(
          buildMaterialAppHome(WisherDetailsProfile(wisher: unnamedWisher)),
        );
        await TestHelpers.pumpAndSettle(tester);

        expect(find.text(Wisher.unnamedDisplayName), findsOneWidget);
      });
    });
  });
}
