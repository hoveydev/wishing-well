import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/data_sources/auth/auth_data_source_supabase.dart';
import 'package:wishing_well/data/data_sources/wisher/wisher_data_source_supabase.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/data/repositories/image/image_repository.dart';
import 'package:wishing_well/data/repositories/image/image_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository_impl.dart';
import 'package:wishing_well/features/add_wisher/contact_import/add_wisher_contact_access.dart';

List<SingleChildWidget> get providersRemote => [
  // Supabase client
  Provider(create: (_) => Supabase.instance.client),

  // Auth repository with inline DataSource (tested)
  ChangeNotifierProvider<AuthRepository>(
    create: (context) => AuthRepositoryImpl(
      dataSource: AuthDataSourceSupabase(supabase: context.read()),
    ),
  ),

  // Wisher repository with inline DataSource (tested)
  ChangeNotifierProvider<WisherRepository>(
    create: (context) => WisherRepositoryImpl(
      dataSource: WisherDataSourceSupabase(supabase: context.read()),
    ),
  ),

  // Storage repository for file uploads
  ChangeNotifierProvider<ImageRepository>(
    create: (context) => ImageRepositoryImpl(supabase: context.read()),
  ),

  // Contacts access for add-from-contacts flows
  Provider<AddWisherContactAccess>(
    create: (_) => AddWisherContactAccess.platform(),
  ),
];

/// Providers that accept an existing [AuthRepository] instance.
///
/// Use this when you need to share the same [AuthRepository] with the
/// router (e.g. for redirect guards) and the provider tree.
List<SingleChildWidget> providersRemoteWith({
  required AuthRepository authRepository,
}) => [
  Provider(create: (_) => Supabase.instance.client),
  ChangeNotifierProvider<AuthRepository>.value(value: authRepository),
  ChangeNotifierProvider<WisherRepository>(
    create: (context) => WisherRepositoryImpl(
      dataSource: WisherDataSourceSupabase(supabase: context.read()),
    ),
  ),
  ChangeNotifierProvider<ImageRepository>(
    create: (context) => ImageRepositoryImpl(supabase: context.read()),
  ),
  Provider<AddWisherContactAccess>(
    create: (_) => AddWisherContactAccess.platform(),
  ),
];
