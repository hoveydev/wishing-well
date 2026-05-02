import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/data_sources/wisher/wisher_data_source.dart';

/// Supabase implementation of [WisherDataSource].
///
/// This implementation uses Supabase's PostgREST client for wisher CRUD
/// operations. This class is excluded from coverage as it's a thin wrapper
/// around the Supabase SDK which is tested by Supabase itself.
class WisherDataSourceSupabase implements WisherDataSource {
  WisherDataSourceSupabase({required SupabaseClient supabase})
    : _supabase = supabase;

  final SupabaseClient _supabase;

  @override
  Future<List<Map<String, dynamic>>> fetchWishers() async {
    final response = await _supabase
        .from('wishers')
        .select()
        .order('created_at', ascending: false);

    return (response as List)
        .map((json) => json as Map<String, dynamic>)
        .toList();
  }

  @override
  Future<Map<String, dynamic>> createWisher({
    required String userId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String> giftOccasions = const [],
    List<String> giftInterests = const [],
  }) async {
    final response = await _supabase
        .from('wishers')
        .insert({
          'user_id': userId,
          'first_name': firstName,
          'last_name': lastName,
          'profile_picture': profilePicture,
          'birthday': _formatDate(birthday),
          'gift_occasions': giftOccasions.isEmpty ? null : giftOccasions,
          'gift_interests': giftInterests.isEmpty ? null : giftInterests,
        })
        .select()
        .single();

    return response;
  }

  @override
  Future<Map<String, dynamic>> updateWisher({
    required String wisherId,
    required String firstName,
    required String lastName,
    String? profilePicture,
    DateTime? birthday,
    List<String> giftOccasions = const [],
    List<String> giftInterests = const [],
  }) async {
    final response = await _supabase
        .from('wishers')
        .update({
          'first_name': firstName,
          'last_name': lastName,
          'profile_picture': profilePicture,
          'birthday': _formatDate(birthday),
          'gift_occasions': giftOccasions.isEmpty ? null : giftOccasions,
          'gift_interests': giftInterests.isEmpty ? null : giftInterests,
        })
        .eq('id', wisherId)
        .select()
        .single();

    return response;
  }

  @override
  Future<void> deleteWisher(String wisherId) async {
    await _supabase.from('wishers').delete().eq('id', wisherId);
  }

  /// Formats a [DateTime] as a yyyy-MM-dd string for Postgres DATE columns.
  /// Returns null when [date] is null.
  String? _formatDate(DateTime? date) {
    if (date == null) return null;
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }
}
