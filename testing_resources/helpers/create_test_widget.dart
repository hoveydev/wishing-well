import 'package:flutter/material.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/theme/app_theme.dart';

Widget createTestWidget(Widget child) => MaterialApp(
  theme: AppTheme.lightTheme,
  darkTheme: AppTheme.darkTheme,
  home: Screen(children: [child]),
);
