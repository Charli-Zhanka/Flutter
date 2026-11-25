import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../storage/secure_store.dart';
import 'exceptions.dart';

class ApiClient {
  ApiClient(this._client, this._store);

  static const _base = 'https://jsonplaceholder.typicode.com';

  final http.Client _client;
  final SecureStore _store;

  Future<Map<String, String>> _headers() async => {
    'Accept': 'application/json',
    if (await _store.readToken() case final t?) 'Authorization': 'Bearer $t',
  };

  Future<dynamic> getJson(String path) async {
    try {
      final res = await _client
          .get(Uri.parse('$_base$path'), headers: await _headers())
          .timeout(const Duration(seconds: 10));
      if (res.statusCode != 200) throw ApiException(res.statusCode);
      return jsonDecode(res.body);
    } on SocketException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }
}
