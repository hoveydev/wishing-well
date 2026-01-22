import 'package:flutter/foundation.dart';
import 'package:wishing_well/utils/input_validators.dart';

/// Manages password requirement validation tracking
/// Tracks which password requirements have been met and notifies listeners
class PasswordValidator<T> extends ChangeNotifier {
  PasswordValidator();

  final Set<T> _metRequirements = {};
  Set<T> get metRequirements => _metRequirements;

  /// Updates password requirements based on the provided password
  void checkRequirements(
    String password,
    Map<T, bool Function(String)> requirements,
  ) {
    for (final entry in requirements.entries) {
      if (entry.value(password)) {
        _addMetRequirement(entry.key);
      } else {
        _removeMetRequirement(entry.key);
      }
    }
  }

  /// Checks if two passwords match
  void checkPasswordsMatch(
    String passwordOne,
    String passwordTwo,
    T requirement,
  ) {
    if (passwordOne.isNotEmpty &&
        passwordTwo.isNotEmpty &&
        InputValidators.passwordsMatch(passwordOne, passwordTwo)) {
      _addMetRequirement(requirement);
    } else {
      _removeMetRequirement(requirement);
    }
  }

  /// Returns true if all password requirements are met
  // This should be overridden by subclasses or
  // provided all possible requirements
  bool get isValid => _metRequirements.isNotEmpty;

  void _addMetRequirement(T requirement) {
    if (_metRequirements.add(requirement)) {
      notifyListeners();
    }
  }

  void _removeMetRequirement(T requirement) {
    if (_metRequirements.remove(requirement)) {
      notifyListeners();
    }
  }

  /// Resets all requirements
  void reset() {
    if (_metRequirements.isNotEmpty) {
      _metRequirements.clear();
      notifyListeners();
    }
  }
}
