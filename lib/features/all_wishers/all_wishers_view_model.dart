import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/result.dart';

abstract class AllWishersViewModelContract implements ScreenViewModelContract {
  List<Wisher> get wishers;
  bool get isLoading;
  bool get hasError;
  Future<Result<void>> fetchWishers();
  void tapCloseButton(BuildContext context);
  void tapWisherItem(BuildContext context, Wisher wisher);
}

class AllWishersViewModel extends ChangeNotifier
    implements AllWishersViewModelContract {
  AllWishersViewModel({required WisherRepository wisherRepository})
    : _wisherRepository = wisherRepository {
    _wisherRepository.addListener(_onRepositoryChanged);
  }

  final WisherRepository _wisherRepository;
  Object? _error;

  @override
  List<Wisher> get wishers => _wisherRepository.wishers;

  @override
  bool get isLoading => _wisherRepository.isLoading;

  @override
  bool get hasError => _error != null;

  @override
  Future<Result<void>> fetchWishers() async {
    _error = null;
    notifyListeners();

    final result = await _wisherRepository.fetchWishers();
    if (result case Error(:final error)) {
      _error = error;
      notifyListeners();
      return result;
    }

    return result;
  }

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    context.push(Routes.wisherDetails.buildPath(id: wisher.id));
  }

  void _onRepositoryChanged() {
    notifyListeners();
  }

  @override
  void dispose() {
    _wisherRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
