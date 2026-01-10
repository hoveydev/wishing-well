import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/screens/home/home_coming_up.dart';
import 'package:wishing_well/screens/home/home_header.dart';
import 'package:wishing_well/screens/home/home_viewmodel.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewmodel, super.key});
  final HomeViewmodel viewmodel;

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(
      // TODO: Update action to go to profile screen (when built)
      action: () => log('profile screen'),
      type: AppMenuBarType.main,
    ),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeHeader(firstName: widget.viewmodel.firstName),
      const AppSpacer.large(),
      const HomeComingUp(),
    ],
  );
}
