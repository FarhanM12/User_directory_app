import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../services/api_service.dart';

class UserProvider with ChangeNotifier {
  final _api = ApiService();

  // ───────── state ─────────
  final List<User> _users = [];
  int _currentPage = 1;
  int _totalPages  = 1;
  bool _loading    = false;
  String? _error;

  // ───────── getters ─────────
  List<User> get users => _users;
  bool get loading     => _loading;
  String? get error    => _error;
  bool get hasMore     => _currentPage <= _totalPages;

  // ───────── public actions ─────────
  Future<void> loadFirst() async {
    _currentPage = 1;
    _totalPages  = 1;
    _users.clear();
    await _fetch();
  }

  Future<void> loadNext() async {
    if (_loading || !hasMore) return;
    await _fetch();
  }

  // ───────── internal helper ─────────
  Future<void> _fetch() async {
    _loading = true;
    _error   = null;
    notifyListeners();

    try {
      final (list, total) = await _api.fetchPage(_currentPage);
      _users.addAll(list);
      _totalPages = total;
      _currentPage++;
    } catch (e, st) {
      _error = e.toString();
      debugPrint('🔴 UserProvider fetch error → $e\n$st');
    } finally {
      _loading = false;
      notifyListeners();
    }
  }
}
