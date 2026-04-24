import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:wishing_well/data/models/wisher.dart';
import 'package:wishing_well/data/repositories/wisher/wisher_repository.dart';
import 'package:wishing_well/features/shared/screen_view_model_contract.dart';
import 'package:wishing_well/routing/routes.dart';

abstract class AllWishersViewModelContract implements ScreenViewModelContract {
  List<Wisher> get wishers;
  List<Wisher> get filteredWishers;
  String get searchQuery;
  bool get isLoading;
  void updateSearchQuery(String query);
  void tapCloseButton(BuildContext context);
  void tapWisherItem(BuildContext context, Wisher wisher);
}

class AllWishersViewModel extends ChangeNotifier
    implements AllWishersViewModelContract {
  AllWishersViewModel({required WisherRepository wisherRepository})
    : _wisherRepository = wisherRepository {
    _wisherRepository.addListener(notifyListeners);
  }

  final WisherRepository _wisherRepository;
  String _searchQuery = '';

  @override
  List<Wisher> get wishers => _wisherRepository.wishers;

  @override
  String get searchQuery => _searchQuery;

  @override
  List<Wisher> get filteredWishers {
    if (_searchQuery.trim().isEmpty) return wishers;
    return wishers.where((w) => _matchesQuery(w, _searchQuery)).toList();
  }

  @override
  bool get isLoading => _wisherRepository.isLoading;

  @override
  void updateSearchQuery(String query) {
    if (query == _searchQuery) return;
    _searchQuery = query;
    notifyListeners();
  }

  @override
  void tapCloseButton(BuildContext context) {
    context.pop();
  }

  @override
  void tapWisherItem(BuildContext context, Wisher wisher) {
    context.pushNamed(
      Routes.wisherDetails.name,
      pathParameters: {'id': wisher.id},
      queryParameters: {'from': 'all-wishers'},
    );
  }

  @override
  void dispose() {
    _wisherRepository.removeListener(notifyListeners);
    super.dispose();
  }

  /// Returns true when [wisher] matches [query] using substring and
  /// approximate (fuzzy) matching on first and last name.
  bool _matchesQuery(Wisher wisher, String query) {
    final q = query.trim().toLowerCase();
    if (q.isEmpty) return true;

    final firstName = wisher.firstName.toLowerCase();
    final lastName = wisher.lastName.toLowerCase();
    final fullName = wisher.name.toLowerCase();

    // 1. Substring match — handles prefix, infix, full-name queries.
    if (firstName.contains(q) ||
        lastName.contains(q) ||
        fullName.contains(q)) {
      return true;
    }

    // 2. Fuzzy word-by-word match — allows for minor typos (e.g. "Jon"→"John").
    final queryWords =
        q.split(RegExp(r'\s+')).where((w) => w.isNotEmpty).toList();
    final nameWords =
        [firstName, lastName].where((s) => s.isNotEmpty).toList();

    return queryWords.every(
      (qWord) => nameWords.any((nWord) => _fuzzyWordMatch(qWord, nWord)),
    );
  }

  /// Returns true when [queryWord] matches [nameWord] either as a substring
  /// or within the allowed edit-distance threshold.
  bool _fuzzyWordMatch(String queryWord, String nameWord) {
    if (nameWord.contains(queryWord)) return true;
    final threshold = _editDistanceThreshold(queryWord.length);
    if (threshold == 0) return false;
    return _editDistance(queryWord, nameWord) <= threshold;
  }

  /// Allowed edit-distance for a query word of [length]:
  /// - ≤2 chars: exact only (0)
  /// - 3–5 chars: 1 edit (catches "Jon"→"John")
  /// - 6+ chars: 2 edits (catches longer typos)
  int _editDistanceThreshold(int length) {
    if (length <= 2) return 0;
    if (length <= 5) return 1;
    return 2;
  }

  /// Standard Levenshtein distance between [a] and [b].
  int _editDistance(String a, String b) {
    if (a == b) return 0;
    if (a.isEmpty) return b.length;
    if (b.isEmpty) return a.length;

    final m = a.length;
    final n = b.length;
    var prev = List.generate(n + 1, (j) => j);
    var curr = List.filled(n + 1, 0);

    for (var i = 1; i <= m; i++) {
      curr[0] = i;
      for (var j = 1; j <= n; j++) {
        if (a[i - 1] == b[j - 1]) {
          curr[j] = prev[j - 1];
        } else {
          curr[j] = 1 + math.min(prev[j], math.min(curr[j - 1], prev[j - 1]));
        }
      }
      final temp = prev;
      prev = curr;
      curr = temp;
    }

    return prev[n];
  }
}
