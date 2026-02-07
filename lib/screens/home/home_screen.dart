import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/components/wishers/wishers_list.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/screens/home/components/home_header.dart';
import 'package:wishing_well/screens/home/home_view_model.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({required this.viewModel, super.key});
  final HomeViewModel viewModel;

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
      action: () => context.push(Routes.profile.path),
      type: AppMenuBarType.main,
    ),
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      HomeHeader(firstName: widget.viewModel.firstName),
      const AppSpacer.large(),
      WishersList(
        onAddWisherTap: () => context.pushNamed(Routes.addWisher.name),
      ),
    ],
  );
}
