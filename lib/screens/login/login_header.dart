import 'package:flutter/material.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_icon_size.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenHeight < 700;

    final logoSize = isSmallScreen
        ? AppIconSize(sectionHeight: screenHeight).xlarge * 0.8
        : AppIconSize(sectionHeight: screenHeight).xlarge;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLogo(size: logoSize),
        Text(
          l10n.appName,
          style: isSmallScreen
              ? textTheme.headlineMedium
              : textTheme.headlineLarge,
          textAlign: TextAlign.center,
          semanticsLabel: l10n.appName,
        ),
        Text(
          l10n.appTagline,
          style: textTheme.bodyMedium?.copyWith(
            color: textTheme.bodyMedium?.color?.withValues(alpha: 0.7),
          ),
          textAlign: TextAlign.center,
          semanticsLabel: l10n.appTagline,
        ),
      ],
    );
  }
}
