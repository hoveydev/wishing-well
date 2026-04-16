import 'package:flutter/material.dart';
import 'package:wishing_well/components/profile_image/profile_image.dart';
import 'package:wishing_well/components/spacer/app_spacer.dart';
import 'package:wishing_well/data/models/wisher.dart';

class WisherDetailsProfile extends StatelessWidget {
  const WisherDetailsProfile({required this.wisher, super.key});
  final Wisher wisher;

  @override
  Widget build(BuildContext context) => Column(
    mainAxisSize: MainAxisSize.min,
    children: [
      ProfileAvatar(
        imageUrl: wisher.profilePicture,
        firstName: wisher.firstName,
        lastName: wisher.lastName,
        radius: 50,
      ),
      const AppSpacer.medium(),
      Text(
        wisher.name,
        style: Theme.of(context).textTheme.headlineMedium,
        textAlign: TextAlign.center,
      ),
    ],
  );
}
