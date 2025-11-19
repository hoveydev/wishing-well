import 'package:flutter/material.dart';
import 'package:wishing_well/components/logo/app_logo.dart';
import 'package:wishing_well/components/spacer/app_spacer_size.dart';
import 'package:wishing_well/l10n/app_localizations.dart';
import 'package:wishing_well/theme/app_logo_size.dart';

class LoginHeader extends StatelessWidget {
  const LoginHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final TextTheme textTheme = Theme.of(context).textTheme;
    final screenHeight = MediaQuery.of(context).size.height;
    final logoSize = AppLogoSize(sectionHeight: screenHeight).large;

    return Column(
      spacing: AppSpacerSize.small,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        AppLogo(size: logoSize),
        Text(
          l10n.appName,
          style: textTheme.headlineLarge,
          textAlign: TextAlign.center,
        ),
        Text(
          l10n.appTagline,
          style: textTheme.bodyMedium,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
