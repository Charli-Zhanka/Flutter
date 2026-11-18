import 'package:http/http.dart' as http;

import '../../core/api/api_client.dart';
import '../../core/api/api_exception.dart';
import 'user.dart';

class UserRepository {
  const UserRepository(this._api);

  final ApiClient _api;

  Future<List<User>> getAll() async {
    final http.Response r = await _api.get(Uri.https(_api.host, '/users'));
    final body = _api.decode(r);
    return _parse(
      'users',
      () => (body as List<dynamic>)
          .map((e) => User.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<User> getById(int id) async {
    final http.Response r = await _api.get(Uri.https(_api.host, '/users/$id'));
    final body = _api.decode(r);
    return _parse(
      'users/$id',
      () => User.fromJson(body as Map<String, dynamic>),
    );
  }

  Future<User> create(User draft) async {
    final payload = draft.toJson()..remove('id');
    final http.Response r =
        await _api.post(Uri.https(_api.host, '/users'), payload);
    if (r.statusCode != 201) {
      throw BadResponseException('users: expected 201, got ${r.statusCode}');
    }
    final body = _api.decode(r);
    return _parse('users', () => User.fromJson(body as Map<String, dynamic>));
  }

  T _parse<T>(String where, T Function() build) {
    try {
      return build();
    } on TypeError catch (e) {
      throw BadResponseException('$where: $e');
    } on FormatException catch (e) {
      throw BadResponseException('$where: $e');
    }
  }
}
