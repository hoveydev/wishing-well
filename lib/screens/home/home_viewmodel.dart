import 'package:flutter/material.dart';
import 'package:wishing_well/data/respositories/auth/auth_repository.dart';

abstract class HomeViewmodelContract {
  String? get firstName;
}

class HomeViewmodel extends ChangeNotifier implements HomeViewmodelContract {
  HomeViewmodel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  String? get firstName => _authRepository.userFirstName;
}
