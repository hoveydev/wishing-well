import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_button.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/components/edit_wisher_header.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';

class EditWisherScreen extends StatefulWidget {
  const EditWisherScreen({required this.viewModel, super.key});
  final EditWisherViewModel viewModel;

  @override
  State<EditWisherScreen> createState() => _EditWisherScreenState();
}

class _EditWisherScreenState extends State<EditWisherScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Screen(
    appBar: AppMenuBar(action: () => context.pop(), type: AppMenuBarType.back),
    mainAxisAlignment: MainAxisAlignment.spaceBetween,
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
      EditWisherHeader(viewModel: widget.viewModel),
      EditWisherButton(viewModel: widget.viewModel),
    ],
  );
}
