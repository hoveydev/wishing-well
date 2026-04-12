import 'package:flutter/material.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';

abstract class WisherDetailsViewModelContract {
  Wisher? get wisher;
  bool get isLoading;
}

class WisherDetailsViewModel extends ChangeNotifier
    implements WisherDetailsViewModelContract {
  WisherDetailsViewModel({
    required WisherRepository wisherRepository,
    required String wisherId,
  }) : _wisherRepository = wisherRepository,
       _wisherId = wisherId {
    _loadWisher();
  }

  final WisherRepository _wisherRepository;
  final String _wisherId;

  Wisher? _wisher;
  bool _isLoading = true;

  @override
  Wisher? get wisher => _wisher;

  @override
  bool get isLoading => _isLoading;

  Future<void> _loadWisher() async {
    _isLoading = true;
    notifyListeners();

    // Find the wisher in the cached list
    final wishers = _wisherRepository.wishers;
    _wisher = wishers.where((w) => w.id == _wisherId).firstOrNull;

    _isLoading = false;
    notifyListeners();
  }
}
