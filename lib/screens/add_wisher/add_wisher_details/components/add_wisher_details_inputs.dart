import 'package:flutter/material.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/screens/add_wisher/add_wisher_details/add_wisher_details_view_model.dart';

class AddWisherDetailsInputs extends StatefulWidget {
  const AddWisherDetailsInputs({required this.viewModel, super.key});
  final AddWisherDetailsViewModel viewModel;

  @override
  State<AddWisherDetailsInputs> createState() => _AddWisherDetailsInputsState();
}

class _AddWisherDetailsInputsState extends State<AddWisherDetailsInputs> {
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    firstNameFocusNode.addListener(
      () => widget.viewModel.updateFirstName(firstNameController.text),
    );
    lastNameFocusNode.addListener(
      () => widget.viewModel.updateLastName(lastNameController.text),
    );
  }

  @override
  void dispose() {
    firstNameFocusNode.dispose();
    lastNameFocusNode.dispose();
    firstNameController.dispose();
    lastNameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppInput(
          placeholder: l10n.firstName,
          type: AppInputType.text,
          controller: firstNameController,
          focusNode: firstNameFocusNode,
          onChanged: (String firstName) =>
              widget.viewModel.updateFirstName(firstName),
        ),
        AppInput(
          placeholder: l10n.lastName,
          type: AppInputType.text,
          controller: lastNameController,
          focusNode: lastNameFocusNode,
          onChanged: (String lastName) =>
              widget.viewModel.updateLastName(lastName),
        ),
      ],
    );
  }
}
