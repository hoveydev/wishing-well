import 'package:flutter/foundation.dart';
import 'package:wishing_well/utils/input_validators.dart';

class PasswordValidator<T> extends ChangeNotifier {
  PasswordValidator();

  final Set<T> _metRequirements = {};
  Set<T> get metRequirements => _metRequirements;

  /// Updates password requirements based on the provided password
  ///
  /// Batches all requirement changes and sends a single notification,
  /// preventing unnecessary UI rebuilds during the validation loop.
  void checkRequirements(
    String password,
    Map<T, bool Function(String)> requirements,
  ) {
    // Track which requirements need to be added/removed
    final toAdd = <T>[];
    final toRemove = <T>[];

    for (final entry in requirements.entries) {
      if (entry.value(password)) {
        toAdd.add(entry.key);
      } else {
        toRemove.add(entry.key);
      }
    }

    // Batch update: add all new requirements, remove all old requirements
    var changed = false;

    for (final requirement in toRemove) {
      if (_metRequirements.remove(requirement)) {
        changed = true;
      }
    }

    for (final requirement in toAdd) {
      if (_metRequirements.add(requirement)) {
        changed = true;
      }
    }

    // Only notify listeners if something actually changed
    if (changed) {
      notifyListeners();
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
  /// This should be overridden by subclasses with specific requirement sets
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

  /// Resets all requirements and notifies listeners
  void reset() {
    if (_metRequirements.isNotEmpty) {
      _metRequirements.clear();
      notifyListeners();
    }
  }
}
