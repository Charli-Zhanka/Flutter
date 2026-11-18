import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;

import 'api_exception.dart';

class ApiClient {
  ApiClient(this._client, {this.host = 'jsonplaceholder.typicode.com'});

  factory ApiClient.real() => ApiClient(http.Client());

  final http.Client _client;
  final String host;

  static const _timeout = Duration(seconds: 10);

  Map<String, String> get _headers => const {'Accept': 'application/json'};

  Future<http.Response> get(Uri uri) =>
      _request(() => _client.get(uri, headers: _headers));

  Future<http.Response> post(Uri uri, Object? body) => _request(
        () => _client.post(
          uri,
          headers: {..._headers, 'Content-Type': 'application/json'},
          body: jsonEncode(body),
        ),
      );

  dynamic decode(http.Response r) => _decode(r);

  Future<http.Response> _request(Future<http.Response> Function() call) async {
    final r = await _send(call);
    if (kDebugMode) {
      log('${r.request?.method} ${r.request?.url} -> ${r.statusCode}',
          name: 'api');
    }
    _check(r);
    return r;
  }

  Future<http.Response> _send(Future<http.Response> Function() call) async {
    try {
      return await call().timeout(_timeout);
    } on SocketException {
      throw const NoConnectionException();
    } on http.ClientException {
      throw const NoConnectionException();
    } on TimeoutException {
      throw const NoConnectionException();
    }
  }

  void _check(http.Response r) {
    final s = r.statusCode;
    if (s == 401) throw const UnauthorizedException();
    if (s == 404) throw const NotFoundException();
    if (s >= 500) throw ServerException(s);
    if (s < 200 || s >= 300) {
      throw BadResponseException('unexpected status $s');
    }
  }

  dynamic _decode(http.Response r) {
    try {
      return jsonDecode(r.body);
    } on FormatException catch (e) {
      throw BadResponseException('invalid JSON: ${e.message}');
    }
  }
}
