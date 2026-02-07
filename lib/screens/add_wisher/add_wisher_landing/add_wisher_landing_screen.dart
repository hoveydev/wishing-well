import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_buttons.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';

class AddWisherLandingScreen extends StatefulWidget {
  const AddWisherLandingScreen({required this.viewModel, super.key});
  final AddWisherLandingViewModel viewModel;

  @override
  State<AddWisherLandingScreen> createState() => _AddWisherLandingScreenState();
}

class _AddWisherLandingScreenState extends State<AddWisherLandingScreen> {
  @override
  void initState() {
    super.initState();
  }

  void _handleAddFromContacts() {
    // TODO: Navigate to contacts selection
  }

  void _handleAddManually() {
    // TODO: Navigate to manual wisher creation
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(action: () => context.pop(), type: AppMenuBarType.close),
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const AddWisherLandingHeader(),
      AddWisherLandingButtons(
        onAddFromContacts: _handleAddFromContacts,
        onAddManually: _handleAddManually,
      ),
    ],
  );
}
