import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class AllWishersViewModelContract implements ScreenViewModelContract {
  List<Wisher> get wishers;
  bool get isLoading;
  void tapCloseButton(BuildContext context);
  void tapWisherItem(BuildContext context, Wisher wisher);
}

class AllWishersViewModel extends ChangeNotifier
    implements AllWishersViewModelContract {
  AllWishersViewModel({required WisherRepository wisherRepository})
    : _wisherRepository = wisherRepository {
    _wisherRepository.addListener(notifyListeners);
  }

  final WisherRepository _wisherRepository;

  @override
  List<Wisher> get wishers => _wisherRepository.wishers;

  @override
  bool get isLoading => _wisherRepository.isLoading;

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    context.pushNamed(
      Routes.wisherDetails.name,
      pathParameters: {'id': wisher.id},
      queryParameters: {'from': 'all-wishers'},
    );
  }

  @override
  void dispose() {
    _wisherRepository.removeListener(notifyListeners);
    super.dispose();
  }
}
