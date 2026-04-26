import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/app_logger.dart';

/// The type of deep link error, used to tailor the error message and action.
enum DeepLinkErrorType {
  /// An expired or invalid password reset link.
  passwordReset,

  /// An expired or invalid account confirmation link.
  accountConfirm,

  /// An unrecognized or generic deep link error.
  unknown;

  /// Parses a raw string value from a route query parameter.
  ///
  /// Returns [unknown] for any unrecognized string.
  static DeepLinkErrorType fromString(String? value) => switch (value) {
    'password-reset' => DeepLinkErrorType.passwordReset,
    'account-confirm' => DeepLinkErrorType.accountConfirm,
    _ => DeepLinkErrorType.unknown,
  };
}

abstract class DeepLinkErrorViewModelContract
    implements ScreenViewModelContract {
  DeepLinkErrorType get errorType;
  void tapActionButton(BuildContext context);
  void tapCloseButton(BuildContext context);
}

class DeepLinkErrorViewModel extends ChangeNotifier
    implements DeepLinkErrorViewModelContract {
  DeepLinkErrorViewModel({required this.errorType});

  @override
  final DeepLinkErrorType errorType;

  @override
  void tapActionButton(BuildContext context) {
    AppLogger.debug(
      'Deep link error action tapped: $errorType',
      context: 'DeepLinkErrorViewModel.tapActionButton',
    );
    switch (errorType) {
      case DeepLinkErrorType.passwordReset:
        context.goNamed(Routes.forgotPassword.name);
      case DeepLinkErrorType.accountConfirm:
      case DeepLinkErrorType.unknown:
        context.goNamed(Routes.login.name);
    }
  }

  @override
  void tapCloseButton(BuildContext context) {
    AppLogger.debug(
      'Deep link error screen closed',
      context: 'DeepLinkErrorViewModel.tapCloseButton',
    );
    context.goNamed(Routes.login.name);
  }
}
