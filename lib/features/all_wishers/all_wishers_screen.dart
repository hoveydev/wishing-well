import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_spacing.dart';

class AllWishersScreen extends StatefulWidget {
  const AllWishersScreen({required this.viewModel, super.key});

  final AllWishersViewModelContract viewModel;

  @override
  State<AllWishersScreen> createState() => _AllWishersScreenState();
}

class _AllWishersScreenState extends State<AllWishersScreen> {
  @override
  void dispose() {
    widget.viewModel.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return ListenableBuilder(
      listenable: widget.viewModel,
      builder: (context, _) => Scaffold(
        appBar: AppMenuBar(
          action: () => widget.viewModel.tapCloseButton(context),
          type: AppMenuBarType.close,
        ),
        body: SafeArea(child: _buildBody(context, l10n)),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingStandard,
            AppSpacing.wisherSpacing,
            AppSpacing.screenPaddingStandard,
            AppSpacing.wisherSpacing,
          ),
          child: Text(l10n.allWishersTitle, style: textTheme.headlineMedium),
        ),
        if (widget.viewModel.wishers.isEmpty)
          Expanded(
            child: Center(child: Text(l10n.allWishersEmpty)),
          )
        else
          Expanded(
            child: ListView.builder(
              itemCount: widget.viewModel.wishers.length,
              itemBuilder: (context, index) {
                final wisher = widget.viewModel.wishers[index];
                return _WisherListTile(
                  wisher: wisher,
                  onTap: () =>
                      widget.viewModel.tapWisherItem(context, wisher),
                );
              },
            ),
          ),
      ],
    );
  }
}

class _WisherListTile extends StatelessWidget {
  const _WisherListTile({required this.wisher, required this.onTap});

  final Wisher wisher;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return TouchFeedbackOpacity(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPaddingStandard,
          vertical: AppSpacing.wisherSpacing / 2,
        ),
        child: Row(
          children: [
            ProfileAvatar(
              imageUrl: wisher.profilePicture,
              firstName: wisher.firstName,
              lastName: wisher.lastName,
            ),
            const SizedBox(width: AppSpacing.wisherSpacing),
            Expanded(
              child: Text(
                wisher.name,
                style: textTheme.bodyMedium,
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
