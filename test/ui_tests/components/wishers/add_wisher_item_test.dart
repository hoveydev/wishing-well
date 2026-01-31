import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/wishers/add_wisher_item.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_theme.dart';

void main() {
  testWidgets('AddWisherItem renders basic structure', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        localizationsDelegates: AppLocalizations.localizationsDelegates,
        supportedLocales: AppLocalizations.supportedLocales,
        theme: AppTheme.lightTheme,
        home: Scaffold(body: AddWisherItem(EdgeInsets.zero, () => {})),
      ),
    );

    // Basic structural test
    expect(find.byType(AddWisherItem), findsOneWidget);
    expect(find.byType(Column), findsOneWidget);
    expect(find.byType(GestureDetector), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);

    final column = tester.widget<Column>(find.byType(Column));
    expect(column.children.length, 3); // Just GestureDetector + Text + Spacer
  });
}
