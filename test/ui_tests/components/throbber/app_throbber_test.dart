import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/throbber/app_throbber.dart';
import 'package:wishing_well/components/throbber/app_throbber_size.dart';
import 'package:wishing_well/theme/app_theme.dart';

dynamic startGenericApp(WidgetTester tester, Widget child) async {
  final Widget app = MaterialApp(
    theme: AppTheme.lightTheme,
    darkTheme: AppTheme.darkTheme,
    home: Screen(children: [child]),
  );
  await tester.pumpWidget(app);
  await tester.pump();
}

void main() {
  group('AppThrobber', () {
    testWidgets('xsmall constructor applies correct size', (tester) async {
      await startGenericApp(tester, const AppThrobber.xsmall());
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.xsmall);
      expect(sizedBox.width, AppThrobberSize.xsmall);
    });

    testWidgets('small constructor applies correct size', (tester) async {
      await startGenericApp(tester, const AppThrobber.small());
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.small);
      expect(sizedBox.width, AppThrobberSize.small);
    });

    testWidgets('medium constructor applies correct size', (tester) async {
      await startGenericApp(tester, const AppThrobber.medium());
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.medium);
      expect(sizedBox.width, AppThrobberSize.medium);
    });

    testWidgets('large constructor applies correct size', (tester) async {
      await startGenericApp(tester, const AppThrobber.large());
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.large);
      expect(sizedBox.width, AppThrobberSize.large);
    });

    testWidgets('xlarge constructor applies correct size', (tester) async {
      await startGenericApp(tester, const AppThrobber.xlarge());
      final sizedBox = tester.widget<SizedBox>(find.byType(SizedBox));
      expect(sizedBox.height, AppThrobberSize.xlarge);
      expect(sizedBox.width, AppThrobberSize.xlarge);
    });
  });
}
