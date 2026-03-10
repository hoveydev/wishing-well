import 'package:flutter/material.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/result.dart';

abstract class HomeViewModelContract {
  String? get firstName;
  List<Wisher> get wishers;
  bool get isLoadingWishers;
  Object? get wisherError;
  bool get hasWisherError;
}

class HomeViewModel extends ChangeNotifier implements HomeViewModelContract {
  HomeViewModel({
    required AuthRepository authRepository,
    required WisherRepository wisherRepository,
  }) : _authRepository = authRepository,
       _wisherRepository = wisherRepository {
    // Listen to repository changes and forward them to our listeners
    _wisherRepository.addListener(_onRepositoryChanged);
  }

  final AuthRepository _authRepository;
  final WisherRepository _wisherRepository;
  Object? _wisherError;

  @override
  String? get firstName => _authRepository.userFirstName;

  @override
  List<Wisher> get wishers => _wisherRepository.wishers;

  @override
  bool get isLoadingWishers => _wisherRepository.isLoading;

  @override
  Object? get wisherError => _wisherError;

  @override
  bool get hasWisherError => _wisherError != null;

  /// Forward repository notifications to our listeners
  void _onRepositoryChanged() {
    notifyListeners();
  }

  /// Fetches wishers from the repository.
  /// Should be called when the home screen initializes.
  Future<Result<void>> fetchWishers() async {
    // Clear any previous error
    _wisherError = null;
    notifyListeners();

    final result = await _wisherRepository.fetchWishers();
    if (result case Error(:final error)) {
      _wisherError = error;
      notifyListeners();
    }
    return result;
  }

  @override
  void dispose() {
    _wisherRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
