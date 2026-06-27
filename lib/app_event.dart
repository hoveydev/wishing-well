import 'package:wishing_well/utils/deep_links/deep_link_handler.dart';

sealed class AppEvent {}

class ShowAccountConfirmation extends AppEvent {}

class NavigateToResetPassword extends AppEvent {}

class ShowDeepLinkError extends AppEvent {
  ShowDeepLinkError(this.type);
  final DeepLinkErrorType type;
}
