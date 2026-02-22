import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository_remote.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository_remote.dart';

List<SingleChildWidget> get providersRemote => [
  Provider(create: (_) => Supabase.instance.client),
  ChangeNotifierProvider(
    create: (context) =>
        AuthRepositoryRemote(supabase: context.read()) as AuthRepository,
  ),
  ChangeNotifierProvider(
    create: (context) =>
        WisherRepositoryRemote(supabase: context.read()) as WisherRepository,
  ),
];
