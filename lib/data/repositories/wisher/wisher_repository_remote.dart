import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/utils/app_logger.dart';
import 'package:wishing_well/utils/result.dart';

/// Remote implementation of [WisherRepository] using Supabase.
///
/// This implementation uses Supabase's PostgREST client to perform
/// CRUD operations on the wishers table. Row Level Security (RLS)
/// ensures users can only access their own data.
class WisherRepositoryRemote extends WisherRepository {
  WisherRepositoryRemote({required SupabaseClient supabase})
    : _supabase = supabase;

  final SupabaseClient _supabase;

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
      final response = await _supabase
          .from('wishers')
          .select()
          .order('created_at', ascending: false);

      _wishers = (response as List)
          .map((json) => Wisher.fromJson(json as Map<String, dynamic>))
          .toList();

      _isLoading = false;
      notifyListeners();

      AppLogger.info(
        'Fetched ${_wishers.length} wishers',
        context: 'WisherRepository',
      );
      return const Result.ok(null);
    } on PostgrestException catch (e) {
      _isLoading = false;
      _error = Exception(e.message);
      notifyListeners();

      AppLogger.error(
        'Failed to fetch wishers: ${e.message}',
        context: 'WisherRepository',
      );
      return Result.error(_error!);
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
  }) async {
    AppLogger.debug(
      'Creating wisher: $firstName $lastName',
      context: 'WisherRepository',
    );

    try {
      final response = await _supabase
          .from('wishers')
          .insert({
            'user_id': userId,
            'first_name': firstName,
            'last_name': lastName,
            'profile_picture': profilePicture,
          })
          .select()
          .single();

      final newWisher = Wisher.fromJson(response);
      _wishers.insert(0, newWisher);
      notifyListeners();

      AppLogger.info(
        'Created wisher: ${newWisher.name} (id: ${newWisher.id})',
        context: 'WisherRepository',
      );
      return Result.ok(newWisher);
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to create wisher: ${e.message}',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(Exception(e.message));
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
      final response = await _supabase
          .from('wishers')
          .update({
            'first_name': wisher.firstName,
            'last_name': wisher.lastName,
            'profile_picture': wisher.profilePicture,
          })
          .eq('id', wisher.id)
          .select()
          .single();

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
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to update wisher: ${e.message}',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(Exception(e.message));
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
      await _supabase.from('wishers').delete().eq('id', wisherId);

      _wishers.removeWhere((w) => w.id == wisherId);
      notifyListeners();

      AppLogger.info('Deleted wisher: $wisherId', context: 'WisherRepository');
      return const Result.ok(null);
    } on PostgrestException catch (e, stackTrace) {
      AppLogger.error(
        'Failed to delete wisher: ${e.message}',
        context: 'WisherRepository',
        error: e,
        stackTrace: stackTrace,
      );
      return Result.error(Exception(e.message));
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
