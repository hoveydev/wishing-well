import 'package:flutter/material.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/features/wisher_details/edit_wisher/edit_wisher_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class EditWisherInputs extends StatefulWidget {
  const EditWisherInputs({required this.viewModel, super.key});
  final EditWisherViewModelContract viewModel;

  @override
  State<EditWisherInputs> createState() => _EditWisherInputsState();
}

class _EditWisherInputsState extends State<EditWisherInputs> {
  final firstNameFocusNode = FocusNode();
  final lastNameFocusNode = FocusNode();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _syncControllersFromViewModel();
    firstNameFocusNode.addListener(
      () => widget.viewModel.updateFirstName(firstNameController.text),
    );
    lastNameFocusNode.addListener(
      () => widget.viewModel.updateLastName(lastNameController.text),
    );
  }

  void _syncControllersFromViewModel() {
    final wisher = widget.viewModel.wisher;
    if (wisher != null) {
      firstNameController.text = wisher.firstName;
      lastNameController.text = wisher.lastName;
    }
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
          showIcon: false,
          onChanged: (String firstName) =>
              widget.viewModel.updateFirstName(firstName),
        ),
        AppInput(
          placeholder: l10n.lastName,
          type: AppInputType.text,
          controller: lastNameController,
          focusNode: lastNameFocusNode,
          showIcon: false,
          onChanged: (String lastName) =>
              widget.viewModel.updateLastName(lastName),
        ),
        ListenableBuilder(
          listenable: widget.viewModel,
          builder: (context, _) {
            if (!widget.viewModel.hasAlert) return const SizedBox.shrink();
            return Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: _validationMessage(l10n),
                type: AppInlineAlertType.error,
              ),
            );
          },
        ),
      ],
    );
  }

  String _validationMessage(AppLocalizations l10n) =>
      switch (widget.viewModel.error.type) {
        EditWisherErrorType.firstNameRequired => l10n.errorFirstNameRequired,
        EditWisherErrorType.lastNameRequired => l10n.errorLastNameRequired,
        EditWisherErrorType.bothNamesRequired => l10n.errorBothNamesRequired,
        EditWisherErrorType.noChanges => l10n.errorNoChanges,
        EditWisherErrorType.unknown => l10n.errorUnknown,
        _ => '',
      };
}
