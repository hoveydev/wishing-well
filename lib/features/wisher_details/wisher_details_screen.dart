import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/button/app_button.dart';
import 'package:wishing_well/components/button/app_button_type.dart';
import 'package:wishing_well/components/screen/screen.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_delete_button.dart';
import 'package:wishing_well/features/wisher_details/components/wisher_details_profile.dart';
import 'package:wishing_well/features/wisher_details/wisher_details_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';

class WisherDetailsScreen extends StatefulWidget {
  const WisherDetailsScreen({required this.viewModel, super.key});
  final WisherDetailsViewModel viewModel;

  @override
  State<WisherDetailsScreen> createState() => _WisherDetailsScreenState();
}

class _WisherDetailsScreenState extends State<WisherDetailsScreen> {
  @override
  Widget build(BuildContext context) =>
      ChangeNotifierProvider<WisherDetailsViewModel>.value(
        value: widget.viewModel,
        child: Consumer<WisherDetailsViewModel>(
          builder: (context, viewModel, child) {
            final l10n = AppLocalizations.of(context)!;
            return Screen(
              appBar: AppMenuBar(
                action: () => context.pop(),
                type: AppMenuBarType.close,
                additionalActions: viewModel.wisher != null
                    ? [
                        Builder(
                          builder: (context) => Semantics(
                            label: l10n.appBarEdit,
                            button: true,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: AppButton.icon(
                                icon: Icons.edit_outlined,
                                onPressed: () =>
                                    viewModel.tapEditWisher(context),
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
                if (viewModel.isLoading)
                  const CircularProgressIndicator()
                else if (viewModel.wisher != null)
                  WisherDetailsProfile(wisher: viewModel.wisher!)
                else
                  Text(
                    'Wisher not found',
                    style: Theme.of(context).textTheme.titleMedium,
                  ),
                if (viewModel.wisher != null)
                  WisherDetailsDeleteButton(
                    onPressed: () => viewModel.tapDeleteWisher(context),
                  ),
              ],
            );
          },
        ),
      );
}
