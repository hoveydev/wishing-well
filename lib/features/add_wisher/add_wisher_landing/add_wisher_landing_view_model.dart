import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class AddWisherLandingViewModelContract
    implements ScreenViewModelContract {
  void tapCloseButton(BuildContext context);
  void tapAddManuallyButton(BuildContext context);
}

class AddWisherLandingViewModel extends ChangeNotifier
    implements AddWisherLandingViewModelContract {
  @override
  void tapAddManuallyButton(BuildContext context) {
    context.pushNamed(Routes.addWisherDetails.name);
  }

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }
}
