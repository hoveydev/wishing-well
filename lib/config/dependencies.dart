import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository_remote.dart';

List<SingleChildWidget> get providersRemote => [
  ChangeNotifierProvider(
    create: (context) =>
        AuthRepositoryRemote(supabase: context.read()) as AuthRepository,
  ),
];
