import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/routing/routes.dart';
import 'package:wishing_well/utils/result.dart';

abstract class HomeViewModelContract {
  String? get firstName;
  List<Wisher> get wishers;
  bool get isLoadingWishers;
  Object? get wisherError;
  bool get hasWisherError;
  void tapWisherItem(BuildContext context, Wisher wisher);
  void tapAddWisher(BuildContext context);
}

class HomeViewModel extends ChangeNotifier implements HomeViewModelContract {
  HomeViewModel({
    required AuthRepository authRepository,
    required WisherRepository wisherRepository,
    required ImageRepository imageRepository,
  }) : _authRepository = authRepository,
       _wisherRepository = wisherRepository,
       _imageRepository = imageRepository {
    // Listen to repository changes and forward them to our listeners
    _wisherRepository.addListener(_onRepositoryChanged);
  }

  final AuthRepository _authRepository;
  final WisherRepository _wisherRepository;
  final ImageRepository _imageRepository;
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
      return result;
    }

    // Preload all profile pictures after fetching wishers
    // We await this so images are ready before UI shows
    final imageUrls = wishers
        .where((w) => w.profilePicture != null)
        .map((w) => w.profilePicture!)
        .toList();

    if (imageUrls.isNotEmpty) {
      await _imageRepository.preloadImages(imageUrls);
    }

    return result;
  }

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    context.push(Routes.wisherDetails.buildPath(id: wisher.id));
  }

  @override
  void tapAddWisher(BuildContext context) {
    context.pushNamed(Routes.addWisher.name);
  }

  @override
  void dispose() {
    _wisherRepository.removeListener(_onRepositoryChanged);
    super.dispose();
  }
}
