import 'package:flutter/material.dart';
import 'package:wishing_well/components/date_picker/app_date_picker_field.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_spacing.dart';
import 'package:wishing_well/components/inline_alert/app_inline_alert_type.dart';
import 'package:wishing_well/components/input/app_input.dart';
import 'package:wishing_well/components/input/app_input_type.dart';
import 'package:wishing_well/components/multi_select/app_multi_select_field.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/data/models/wisher_field_options.dart';
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

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) => Column(
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
          if (widget.viewModel.hasAlert)
            Padding(
              padding: AppInlineAlertSpacing.inputPadding,
              child: AppInlineAlert(
                message: _validationMessage(l10n),
                type: AppInlineAlertType.error,
              ),
            ),
          AppDatePickerField(
            placeholder: l10n.birthdayPlaceholder,
            value: widget.viewModel.birthday,
            onChanged: (DateTime? date) =>
                widget.viewModel.updateBirthday(date),
          ),
          AppMultiSelectField(
            placeholder: l10n.giftOccasionsPlaceholder,
            title: l10n.giftOccasions,
            items: _buildOccasionItems(l10n),
            selectedValues: widget.viewModel.giftOccasions,
            onChanged: (List<String> values) =>
                widget.viewModel.updateGiftOccasions(values),
          ),
          AppMultiSelectField(
            placeholder: l10n.giftInterestsPlaceholder,
            title: l10n.giftInterests,
            items: _buildInterestItems(l10n),
            selectedValues: widget.viewModel.giftInterests,
            onChanged: (List<String> values) =>
                widget.viewModel.updateGiftInterests(values),
          ),
        ],
      ),
    );
  }

  List<AppMultiSelectItem> _buildOccasionItems(AppLocalizations l10n) =>
      WisherGiftOccasions.all
          .map(
            (occasion) => AppMultiSelectItem(
              value: occasion,
              label: _occasionLabel(l10n, occasion),
            ),
          )
          .toList();

  List<AppMultiSelectItem> _buildInterestItems(AppLocalizations l10n) =>
      WisherGiftInterests.all
          .map(
            (interest) => AppMultiSelectItem(
              value: interest,
              label: _interestLabel(l10n, interest),
            ),
          )
          .toList();

  String _occasionLabel(AppLocalizations l10n, String occasion) =>
      switch (occasion) {
        'christmas' => l10n.occasionChristmas,
        'hanukkah' => l10n.occasionHanukkah,
        'kwanzaa' => l10n.occasionKwanzaa,
        'diwali' => l10n.occasionDiwali,
        'eid' => l10n.occasionEid,
        'valentines_day' => l10n.occasionValentinesDay,
        'mothers_day' => l10n.occasionMothersDay,
        'fathers_day' => l10n.occasionFathersDay,
        'easter' => l10n.occasionEaster,
        'new_years' => l10n.occasionNewYears,
        _ => occasion,
      };

  String _interestLabel(AppLocalizations l10n, String interest) =>
      switch (interest) {
        'books' => l10n.interestBooks,
        'electronics' => l10n.interestElectronics,
        'clothing' => l10n.interestClothing,
        'jewelry' => l10n.interestJewelry,
        'art' => l10n.interestArt,
        'home_and_garden' => l10n.interestHomeAndGarden,
        'sports' => l10n.interestSports,
        'beauty' => l10n.interestBeauty,
        'food_and_drink' => l10n.interestFoodAndDrink,
        'travel' => l10n.interestTravel,
        'games_and_toys' => l10n.interestGamesAndToys,
        _ => interest,
      };

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
