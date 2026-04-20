import 'package:shared_preferences/shared_preferences.dart';
import 'offline_action.dart';

class OfflineQueue {
  static const _key = 'offline_queue';

  static Future<SharedPreferences> get _p =>
      SharedPreferences.getInstance();

  static Future<List<OfflineAction>> _load() async {
    final raw = (await _p).getString(_key);
    return raw == null ? [] : OfflineAction.decode(raw);
  }

  static Future<void> _save(List<OfflineAction> list) async =>
      (await _p).setString(_key, OfflineAction.encode(list));

  static Future<void> add(OfflineAction action) async {
    final list = await _load()..add(action);
    await _save(list);
  }

  static Future<List<OfflineAction>> getAll() => _load();

  static Future<void> clear() async =>
      (await _p).remove(_key);
}