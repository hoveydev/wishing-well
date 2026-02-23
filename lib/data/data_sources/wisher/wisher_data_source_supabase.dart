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
  }) async {
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

    return response;
  }

  @override
  Future<Map<String, dynamic>> updateWisher({
    required String wisherId,
    required String firstName,
    required String lastName,
    String? profilePicture,
  }) async {
    final response = await _supabase
        .from('wishers')
        .update({
          'first_name': firstName,
          'last_name': lastName,
          'profile_picture': profilePicture,
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
}
