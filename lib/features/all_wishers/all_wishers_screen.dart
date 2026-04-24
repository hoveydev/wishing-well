import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar.dart';
import 'package:wishing_well/components/app_bar/app_menu_bar_type.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/touch_feedback/touch_feedback_opacity.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/features/all_wishers/all_wishers_view_model.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_border_radius.dart';
import 'package:wishing_well/theme/app_colors.dart';
import 'package:wishing_well/theme/app_spacing.dart';
import 'package:wishing_well/theme/app_theme.dart';

// Height of the search bar input within the blurred header.
const double _kSearchBarHeight = 48.0;

class AllWishersScreen extends StatefulWidget {
  const AllWishersScreen({required this.viewModel, super.key});

  final AllWishersViewModelContract viewModel;

  @override
  State<AllWishersScreen> createState() => _AllWishersScreenState();
}

class _AllWishersScreenState extends State<AllWishersScreen> {
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
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
        body: _buildBody(context, l10n),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AppLocalizations l10n) {
    final textTheme = Theme.of(context).textTheme;
    final bottomPadding = MediaQuery.of(context).padding.bottom;

    if (widget.viewModel.isLoading) {
      return const SafeArea(child: Center(child: CircularProgressIndicator()));
    }

    if (widget.viewModel.wishers.isEmpty) {
      return SafeArea(child: Center(child: Text(l10n.allWishersEmpty)));
    }

    final filtered = widget.viewModel.filteredWishers;

    return Stack(
      children: [
        filtered.isEmpty
            ? Center(child: Text(l10n.allWishersNoResults))
            : ListView.builder(
                padding: EdgeInsets.only(
                  top: _headerExtent(context),
                  bottom: bottomPadding,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final wisher = filtered[index];
                  return _WisherListTile(
                    wisher: wisher,
                    onTap: () =>
                        widget.viewModel.tapWisherItem(context, wisher),
                  );
                },
              ),
        Positioned(
          top: 0,
          left: 0,
          right: 0,
          child: _BlurredHeader(
            title: l10n.allWishersTitle,
            searchPlaceholder: l10n.allWishersSearchPlaceholder,
            textTheme: textTheme,
            searchController: _searchController,
            searchFocusNode: _searchFocusNode,
            onSearchChanged: widget.viewModel.updateSearchQuery,
          ),
        ),
      ],
    );
  }

  /// Returns the height reserved at the top of the list for the blurred header.
  double _headerExtent(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final textScaler = MediaQuery.textScalerOf(context);
    final style = textTheme.headlineMedium ?? const TextStyle(fontSize: 28);
    final scaledFontSize = textScaler.scale(style.fontSize ?? 28);
    final lineHeight = scaledFontSize * (style.height ?? 1.2);
    // wisherSpacing * 2 = top + bottom padding around the title;
    // wisherSpacing * 0.5 = gap between title and search bar.
    return lineHeight +
        (AppSpacing.wisherSpacing * 2.5) +
        _kSearchBarHeight +
        AppSpacing.wisherSpacing;
  }
}

class _BlurredHeader extends StatelessWidget {
  const _BlurredHeader({
    required this.title,
    required this.searchPlaceholder,
    required this.textTheme,
    required this.searchController,
    required this.searchFocusNode,
    required this.onSearchChanged,
  });

  final String title;
  final String searchPlaceholder;
  final TextTheme textTheme;
  final TextEditingController searchController;
  final FocusNode searchFocusNode;
  final ValueChanged<String> onSearchChanged;

  @override
  Widget build(BuildContext context) {
    final colorScheme = context.colorScheme;

    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 16, sigmaY: 16),
        child: Container(
          color: Theme.of(
            context,
          ).scaffoldBackgroundColor.withValues(alpha: 0.75),
          padding: const EdgeInsets.fromLTRB(
            AppSpacing.screenPaddingStandard,
            AppSpacing.wisherSpacing,
            AppSpacing.screenPaddingStandard,
            AppSpacing.wisherSpacing,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(title, style: textTheme.headlineMedium),
              const SizedBox(height: AppSpacing.wisherSpacing / 2),
              SizedBox(
                height: _kSearchBarHeight,
                child: TextField(
                  controller: searchController,
                  focusNode: searchFocusNode,
                  onChanged: onSearchChanged,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.search,
                      color: colorScheme.primary,
                    ),
                    hintText: searchPlaceholder,
                    hintStyle: textTheme.bodyMedium,
                    contentPadding: EdgeInsets.zero,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.medium,
                      ),
                      borderSide: BorderSide(
                        color: colorScheme.borderGray ?? AppColors.borderGray,
                        width: 1.5,
                      ),
                    ),
                    enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.medium,
                      ),
                      borderSide: BorderSide(
                        color: colorScheme.borderGray ?? AppColors.borderGray,
                        width: 1.5,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        AppBorderRadius.medium,
                      ),
                      borderSide: BorderSide(
                        color: colorScheme.primary ?? AppColors.primary,
                        width: 1.5,
                      ),
                    ),
                  ),
                  cursorColor: colorScheme.primary ?? AppColors.primary,
                ),
              ),
            ],
          ),
        ),
      ),
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
