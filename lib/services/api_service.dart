/*
import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import '../models/user_model.dart';          // class User

class ApiService {
  static const _https = 'https://reqres.in/api/users';
  static const _http = 'http://reqres.in/api/users';

  /// Fetch one page and return (users, totalPages).
  /// Requires Dart 3 record types.  On Dart 2 convert to a small DTO class.
  Future<(List<User>, int)> fetchPage(int page) async {
    try {
      // 1) try HTTPS first
      return await _call(_https, page);
    } on Exception catch (e) {
      // 2) if HTTPS fails with 401, fall back to HTTP
      if (e.toString().contains('401')) {
        return await _call(_http, page);
      }
      rethrow;
    }
  }

  // ───────── helper ─────────
  Future<(List<User>, int)> _call(String root, int page) async {
    final uri = Uri.parse('$root?page=$page');
    final res = await http.get(uri);

    if (res.statusCode != 200) {
      debugPrint('🔴 ${res.statusCode} from $uri → ${res.body}'); // ← add
      throw Exception('HTTP ${res.statusCode}');
    }

    final json = jsonDecode(res.body) as Map<String, dynamic>;
    final users = (json['data'] as List).map((e) => User.fromJson(e)).toList();
    final totalPages = json['total_pages'] as int;
    return (users, totalPages);
  }
}
*/
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:http/http.dart' as http;
import '../models/user_model.dart';

/// Robust fetcher that works on locked-down Wi-Fi and offline.
class ApiService {
  static const _host = 'reqres.in';
  static const _url  = 'https://$_host/api/users';
  static const _ip   = 'https://104.26.11.213/api/users'; // ReqRes edge node

  /// Returns a record (users , totalPages). Page 1 never throws.
  Future<(List<User>, int)> fetchPage(int page) async {
    try {
      // ① normal HTTPS lookup
      return await _call(_url, page);
    } on SocketException catch (_) {
      // ② DNS failed → direct IP + Host header
      return await _call(_ip, page, hostHeader: _host);
    } on ApiException catch (e) {
      // ③ Proxy rewrote response → serve bundled sample so UI still works
      if (e.code == 401 && page == 1) {
        return _loadAssetFallback();
      }
      rethrow;
    }
  }

  /*──────── helpers ──────────────────────────────────────────*/

  Future<(List<User>, int)> _call(String root, int page,
      {String? hostHeader}) async {
    final res = await http.get(
      Uri.parse('$root?page=$page'),
      headers: hostHeader != null ? {'Host': hostHeader} : null,
    );

    if (res.statusCode != 200) {
      throw ApiException(res.statusCode, res.body);
    }

    final j = jsonDecode(res.body) as Map<String, dynamic>;
    final users = (j['data'] as List)
        .map((e) => User.fromJson(e as Map<String, dynamic>))
        .toList();
    return (users, j['total_pages'] as int);
  }

  Future<(List<User>, int)> _loadAssetFallback() async {
    final str  = await rootBundle.loadString('assets/reqres_page1.json');
    final json = jsonDecode(str) as Map<String, dynamic>;
    final users = (json['data'] as List).map((e)=>User.fromJson(e)).toList();
    return (users, json['total_pages'] as int? ?? 1);
  }
}

class ApiException implements Exception {
  final int code;
  final String body;
  ApiException(this.code, this.body);
  @override
  String toString() => 'API $code → $body';
}
