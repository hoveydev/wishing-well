import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_buttons.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/components/add_wisher_landing_header.dart';
import 'package:wishing_well/features/add_wisher/add_wisher_landing/add_wisher_landing_view_model.dart';

class AddWisherLandingScreen extends StatefulWidget {
  const AddWisherLandingScreen({required this.viewModel, super.key});
  final AddWisherLandingViewModelContract viewModel;

  @override
  State<AddWisherLandingScreen> createState() => _AddWisherLandingScreenState();
}

class _AddWisherLandingScreenState extends State<AddWisherLandingScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(
      action: () => widget.viewModel.tapCloseButton(context),
      type: AppMenuBarType.close,
    ),
    crossAxisAlignment: CrossAxisAlignment.start,
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    children: [
      const AddWisherLandingHeader(),
      AddWisherLandingButtons(
        onAddManually: () => widget.viewModel.tapAddManuallyButton(context),
      ),
    ],
  );
}
