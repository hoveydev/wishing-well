import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_buttons.dart';
import 'package:wishing_well/screens/add_wisher/components/add_wisher_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_view_model.dart';

class AddWisherInfoScreen extends StatefulWidget {
  const AddWisherInfoScreen({required this.viewModel, super.key});
  final AddWisherViewModel viewModel;

  @override
  State<AddWisherInfoScreen> createState() => _AddWisherInfoScreenState();
}

class _AddWisherInfoScreenState extends State<AddWisherInfoScreen> {
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
      const AddWisherHeader(),
      AddWisherButtons(
        onAddFromContacts: _handleAddFromContacts,
        onAddManually: _handleAddManually,
      ),
    ],
  );
}
