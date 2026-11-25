import '../../core/network/api_client.dart';
import '../../core/network/exceptions.dart';
import 'user.dart';
import 'users_cache.dart';

class UserRepository {
  UserRepository(this._api, this._cache);

  final ApiClient _api;
  final UsersCache _cache;

  Future<List<User>> _fetch() async {
    final data = await _api.getJson('/users') as List<dynamic>;
    return [for (final m in data) User.fromJson(m as Map<String, dynamic>)];
  }

  Future<({List<User> items, bool fromCache})> getAll() async {
    try {
      final fresh = await _fetch();
      await _cache.save(fresh);
      return (items: fresh, fromCache: false);
    } on NoConnectionException {
      final saved = await _cache.load();
      if (saved == null) rethrow;
      return (items: saved, fromCache: true);
    }
  }
}
