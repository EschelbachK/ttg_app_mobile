import 'package:shared_preferences/shared_preferences.dart';
import 'offline_action.dart';

class OfflineQueue {
  static const _key = 'offline_queue';

  static Future<List<OfflineAction>> _load() async {
    final p = await SharedPreferences.getInstance();
    final raw = p.getString(_key);
    if (raw == null) return [];
    return OfflineAction.decode(raw);
  }

  static Future<void> _save(List<OfflineAction> list) async {
    final p = await SharedPreferences.getInstance();
    await p.setString(_key, OfflineAction.encode(list));
  }

  static Future<void> add(OfflineAction action) async {
    final list = await _load();
    list.add(action);
    await _save(list);
  }

  static Future<List<OfflineAction>> getAll() => _load();

  static Future<void> clear() async {
    final p = await SharedPreferences.getInstance();
    await p.remove(_key);
  }
}