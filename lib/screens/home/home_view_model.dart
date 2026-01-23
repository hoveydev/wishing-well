import 'package:flutter/material.dart';
import 'package:wishing_well/data/repositories/auth/auth_repository.dart';

abstract class HomeViewModelContract {
  String? get firstName;
}

class HomeViewModel extends ChangeNotifier implements HomeViewModelContract {
  HomeViewModel({required AuthRepository authRepository})
    : _authRepository = authRepository;

  final AuthRepository _authRepository;

  @override
  String? get firstName => _authRepository.userFirstName;
}
