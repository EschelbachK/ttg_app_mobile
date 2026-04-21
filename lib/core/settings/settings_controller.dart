import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../offline/sync_provider.dart';
import 'settings_state.dart';
import 'settings_keys.dart';

final settingsProvider =
StateNotifierProvider<SettingsController, SettingsState>(
      (ref) => SettingsController(ref),
);

class SettingsController extends StateNotifier<SettingsState> {
  final Ref ref;
  SharedPreferences? _prefs;

  SettingsController(this.ref) : super(SettingsState.initial()) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    final p = _prefs;
    if (p == null) return;

    state = state.copyWith(
      soundEnabled: p.getBool(SettingsKeys.sound) ?? true,
      lightMode: p.getBool(SettingsKeys.light) ?? false,
      offlineMode: p.getBool(SettingsKeys.offline) ?? false,
      restTimerSeconds: p.getInt(SettingsKeys.rest) ?? 60,
      keyboardMode: p.getBool(SettingsKeys.keyboard) ?? false,
      syncEnabled: p.getBool(SettingsKeys.sync) ?? true,
      fontScale: p.getDouble(SettingsKeys.font) ?? 1,
      countdownSound: p.getBool(SettingsKeys.countdown) ?? true,
      startSound: p.getBool(SettingsKeys.start) ?? true,
      voiceFeedback: p.getBool(SettingsKeys.voice) ?? false,
      language: p.getString(SettingsKeys.language) ?? 'de',
      weightUnit: p.getString(SettingsKeys.weight) ?? 'kg',
      heightUnit: p.getString(SettingsKeys.height) ?? 'cm',
    );
  }

  void _set(String k, dynamic v) {
    final p = _prefs;
    if (p == null) return;
    if (v is bool) p.setBool(k, v);
    if (v is int) p.setInt(k, v);
    if (v is double) p.setDouble(k, v);
    if (v is String) p.setString(k, v);
  }

  void _toggle(bool current, String key, SettingsState Function(bool) fn) {
    final v = !current;
    state = fn(v);
    _set(key, v);
  }

  void toggleOffline() {
    final v = !state.offlineMode;
    state = state.copyWith(offlineMode: v, syncEnabled: v ? false : state.syncEnabled);
    _set(SettingsKeys.offline, v);
    if (v) _set(SettingsKeys.sync, false);
    if (!v && state.syncEnabled) ref.read(syncEngineProvider).processQueue();
  }

  void toggleSync() {
    final v = !state.syncEnabled;
    state = state.copyWith(syncEnabled: v, offlineMode: v ? false : state.offlineMode);
    _set(SettingsKeys.sync, v);
    if (v) _set(SettingsKeys.offline, false);
    if (v && !state.offlineMode) ref.read(syncEngineProvider).processQueue();
  }

  void toggleSound() => _toggle(state.soundEnabled, SettingsKeys.sound, (v) => state.copyWith(soundEnabled: v));
  void toggleLightMode() => _toggle(state.lightMode, SettingsKeys.light, (v) => state.copyWith(lightMode: v));
  void toggleKeyboard() => _toggle(state.keyboardMode, SettingsKeys.keyboard, (v) => state.copyWith(keyboardMode: v));
  void toggleCountdownSound() => _toggle(state.countdownSound, SettingsKeys.countdown, (v) => state.copyWith(countdownSound: v));
  void toggleStartSound() => _toggle(state.startSound, SettingsKeys.start, (v) => state.copyWith(startSound: v));
  void toggleVoiceFeedback() => _toggle(state.voiceFeedback, SettingsKeys.voice, (v) => state.copyWith(voiceFeedback: v));

  void setRestTimer(int v) { state = state.copyWith(restTimerSeconds: v); _set(SettingsKeys.rest, v); }
  void setFontScale(double v) { state = state.copyWith(fontScale: v); _set(SettingsKeys.font, v); }
  void setLanguage(String v) { state = state.copyWith(language: v); _set(SettingsKeys.language, v); }
  void setWeightUnit(String v) { state = state.copyWith(weightUnit: v); _set(SettingsKeys.weight, v); }
  void setHeightUnit(String v) { state = state.copyWith(heightUnit: v); _set(SettingsKeys.height, v); }

  void _expand(bool current, SettingsState Function(bool) fn) =>
      state = fn(!current);

  void toggleKeyboardExpanded() => _expand(state.keyboardExpanded, (v) => state.copyWith(keyboardExpanded: v));
  void toggleSoundExpanded() => _expand(state.soundExpanded, (v) => state.copyWith(soundExpanded: v));
  void toggleLanguageExpanded() => _expand(state.languageExpanded, (v) => state.copyWith(languageExpanded: v));
  void toggleLightExpanded() => _expand(state.lightExpanded, (v) => state.copyWith(lightExpanded: v));
  void toggleOfflineExpanded() => _expand(state.offlineExpanded, (v) => state.copyWith(offlineExpanded: v));
  void toggleSyncExpanded() => _expand(state.syncExpanded, (v) => state.copyWith(syncExpanded: v));
}