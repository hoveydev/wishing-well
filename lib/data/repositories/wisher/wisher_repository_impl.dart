import 'package:wishing_well/data/data_sources/wisher/wisher_data_source.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

/// Implementation of [WisherRepository] using a [WisherDataSource].
///
/// This class contains the business logic for wisher management,
/// including state management, error handling, and `Result<T>` transformations.
/// The actual Supabase calls are delegated to the [WisherDataSource].
class WisherRepositoryImpl extends WisherRepository {
  WisherRepositoryImpl({required WisherDataSource dataSource})
    : _dataSource = dataSource;

  final WisherDataSource _dataSource;

  List<Wisher> _wishers = [];
  bool _isLoading = false;
  Exception? _error;

  @override
  List<Wisher> get wishers => List.unmodifiable(_wishers);

  @override
  bool get isLoading => _isLoading;

  @override
  Exception? get error => _error;

  @override
  Future<Result<void>> fetchWishers() async {
    AppLogger.debug('Fetching wishers...', context: 'WisherRepository');

    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dataSource.fetchWishers();

      _wishers = response.map((json) => Wisher.fromJson(json)).toList();

      _isLoading = false;
      notifyListeners();

      AppLogger.info(
        'Fetched ${_wishers.length} wishers',
        context: 'WisherRepository',
      );
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      _isLoading = false;
      _error = e;
      notifyListeners();

      AppLogger.error(
        'Failed to fetch wishers: $e',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(e);
    }
  }

  @override
  Future<Result<Wisher>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String> giftOccasions = const [],
    List<String> giftInterests = const [],
  }) async {
    AppLogger.debug(
      'Creating wisher: $firstName $lastName',
      context: 'WisherRepository',
    );

    try {
      final response = await _dataSource.createWisher(
        userId: userId,
        firstName: firstName,
        lastName: lastName,
        profilePicture: profilePicture,
        birthday: birthday,
        giftOccasions: giftOccasions,
        giftInterests: giftInterests,
      );

      final newWisher = Wisher.fromJson(response);
      _wishers.insert(0, newWisher);
      notifyListeners();

      AppLogger.info(
        'Created wisher: ${newWisher.name} (id: ${newWisher.id})',
        context: 'WisherRepository',
      );
      return Result.ok(newWisher);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create wisher: $e',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(e);
    }
  }

  @override
  Future<Result<Wisher>> updateWisher(Wisher wisher) async {
    AppLogger.debug(
      'Updating wisher: ${wisher.name} (id: ${wisher.id})',
      context: 'WisherRepository',
    );

    try {
      final response = await _dataSource.updateWisher(
        wisherId: wisher.id,
        firstName: wisher.firstName,
        lastName: wisher.lastName,
        profilePicture: wisher.profilePicture,
        birthday: wisher.birthday,
        giftOccasions: wisher.giftOccasions,
        giftInterests: wisher.giftInterests,
      );

      final updatedWisher = Wisher.fromJson(response);

      final index = _wishers.indexWhere((w) => w.id == wisher.id);
      if (index != -1) {
        _wishers[index] = updatedWisher;
        notifyListeners();
      }

      AppLogger.info(
        'Updated wisher: ${updatedWisher.name} (id: ${updatedWisher.id})',
        context: 'WisherRepository',
      );
      return Result.ok(updatedWisher);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update wisher: $e',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(e);
    }
  }

  @override
  Future<Result<void>> deleteWisher(String wisherId) async {
    AppLogger.debug('Deleting wisher: $wisherId', context: 'WisherRepository');

    try {
      await _dataSource.deleteWisher(wisherId);

      _wishers.removeWhere((w) => w.id == wisherId);
      notifyListeners();

      AppLogger.info('Deleted wisher: $wisherId', context: 'WisherRepository');
      return const Result.ok(null);
    } on Exception catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete wisher: $e',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(e);
    }
  }
}
