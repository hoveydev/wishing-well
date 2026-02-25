import 'package:flutter/material.dart';
import 'package:wishing_well/components/throbber/skeleton_loader.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/theme/app_spacing.dart';

class WishersListSkeleton extends StatelessWidget {
  const WishersListSkeleton({super.key});

  @override
  Widget build(BuildContext context) => ListView.builder(
    scrollDirection: Axis.horizontal,
    padding: const EdgeInsets.symmetric(
      horizontal: AppSpacing.screenPaddingStandard,
    ),
    itemCount: 5,
    itemBuilder: (context, index) => _WisherSkeletonItem(
      padding: index == 4
          ? EdgeInsets.zero
          : const EdgeInsets.only(right: AppSpacing.wisherSpacing),
    ),
  );
}

class _WisherSkeletonItem extends StatelessWidget {
  const _WisherSkeletonItem({required this.padding});

  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) => Padding(
    padding: padding,
    child: const Column(
      children: [
        SkeletonLoader(shape: SkeletonShape.circle, width: 60, height: 60),
        AppSpacer.xsmall(),
        SkeletonLoader(
          shape: SkeletonShape.roundedRectangle,
          width: 40,
          height: 14,
          borderRadius: 4,
        ),
      ],
    ),
  );
}
