import 'package:flutter/foundation.dart';

import '../../core/network/exceptions.dart';
import 'user.dart';
import 'user_repository.dart';

class UsersModel extends ChangeNotifier {
  UsersModel(this._repo);

  final UserRepository _repo;

  List<User> items = const [];
  bool loading = false;
  bool offline = false;
  String? error;
  bool fromCache = false;

  Future<void> load() async {
    loading = true;
    offline = false;
    error = null;
    notifyListeners();
    try {
      final r = await _repo.getAll();
      items = r.items;
      fromCache = r.fromCache;
    } on NoConnectionException {
      offline = true;
    } catch (e) {
      error = e.toString();
    }
    loading = false;
    notifyListeners();
  }
}
