import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_button.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/components/add_wisher_details_header.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

class AddWisherDetailsScreen extends StatefulWidget {
  const AddWisherDetailsScreen({required this.viewModel, super.key});
  final AddWisherDetailsViewModel viewModel;

  @override
  State<AddWisherDetailsScreen> createState() => _AddWisherDetailsScreenState();
}

class _AddWisherDetailsScreenState extends State<AddWisherDetailsScreen> {
  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(action: () => context.pop(), type: AppMenuBarType.back),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      AddWisherDetailsHeader(viewModel: widget.viewModel),
      AddWisherDetailsButton(viewModel: widget.viewModel),
    ],
  );
}
