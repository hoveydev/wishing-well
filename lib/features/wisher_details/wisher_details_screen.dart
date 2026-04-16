import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_delete_button.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_profile.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class WisherDetailsScreen extends StatefulWidget {
  const WisherDetailsScreen({required this.viewModel, super.key});
  final WisherDetailsViewModelContract viewModel;

  @override
  State<WisherDetailsScreen> createState() => _WisherDetailsScreenState();
}

class _WisherDetailsScreenState extends State<WisherDetailsScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => ListenableBuilder(
    listenable: widget.viewModel,
    builder: (context, _) {
      final l10n = AppLocalizations.of(context)!;
      return Screen(
        appBar: AppMenuBar(
          action: () => widget.viewModel.tapCloseButton(context),
          type: AppMenuBarType.close,
          additionalActions: !widget.viewModel.isLoading
              ? [
                  Builder(
                    builder: (context) => Semantics(
                      label: l10n.appBarEdit,
                      button: true,
                      child: Padding(
                        padding: const EdgeInsets.all(AppSpacerSize.xsmall),
                        child: AppButton.icon(
                          icon: Icons.edit_outlined,
                          onPressed: () =>
                              widget.viewModel.tapEditWisher(context),
                          type: AppButtonType.tertiary,
                        ),
                      ),
                    ),
                  ),
                ]
              : null,
        ),
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          if (widget.viewModel.isLoading)
            const CircularProgressIndicator()
          else
            WisherDetailsProfile(wisher: widget.viewModel.wisher!),
          if (!widget.viewModel.isLoading)
            WisherDetailsDeleteButton(
              onPressed: () => widget.viewModel.tapDeleteWisher(context),
            ),
        ],
      );
    },
  );
}
