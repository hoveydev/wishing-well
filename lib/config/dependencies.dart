import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/data_sources/auth/auth_data_source_supabase.dart';
import 'package:wishing_well/data/data_sources/wisher/wisher_data_source_supabase.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_impl.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository_impl.dart';

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
];
