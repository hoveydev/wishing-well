import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository_remote.dart';

List<SingleChildWidget> get providersRemote => [
  Provider(
    // coverage:ignore-start
    create: (_) => Supabase.instance.client,
    // coverage:ignore-end
  ),
  ChangeNotifierProvider(
    create: (context) =>
        AuthRepositoryRemote(supabase: context.read()) as AuthRepository,
  ),
];
