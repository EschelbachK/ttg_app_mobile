import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../sync/sync_provider.dart';
import 'settings_state.dart';
import 'settings_keys.dart';

final settingsProvider = StateNotifierProvider<SettingsController, SettingsState>(
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
      fontScale: p.getDouble(SettingsKeys.font) ?? 1.0,
      weightStep: p.getDouble(SettingsKeys.weightStep) ?? 1.0,
      countdownSound: p.getBool(SettingsKeys.countdown) ?? true,
      startSound: p.getBool(SettingsKeys.start) ?? true,
      voiceFeedback: p.getBool(SettingsKeys.voice) ?? false,
      language: p.getString(SettingsKeys.language) ?? 'de',
      weightUnit: p.getString(SettingsKeys.weight) ?? 'kg',
      heightUnit: p.getString(SettingsKeys.height) ?? 'cm',
    );
  }

  void _set(String key, dynamic value) {
    final p = _prefs;
    if (p == null) return;
    if (value is bool) p.setBool(key, value);
    if (value is int) p.setInt(key, value);
    if (value is double) p.setDouble(key, value);
    if (value is String) p.setString(key, value);
  }

  void _toggle(bool current, String key, SettingsState Function(bool) updateFn) {
    final value = !current;
    state = updateFn(value);
    _set(key, value);
  }

  void _expand(bool current, SettingsState Function(bool) updateFn) {
    state = updateFn(!current);
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

  void setRestTimer(int value) {
    state = state.copyWith(restTimerSeconds: value);
    _set(SettingsKeys.rest, value);
  }

  void setFontScale(double value) {
    state = state.copyWith(fontScale: value);
    _set(SettingsKeys.font, value);
  }

  void setWeightStep(double value) {
    state = state.copyWith(weightStep: value);
    _set(SettingsKeys.weightStep, value);
  }

  void setLanguage(String value) {
    state = state.copyWith(language: value);
    _set(SettingsKeys.language, value);
  }

  void setWeightUnit(String value) {
    state = state.copyWith(weightUnit: value);
    _set(SettingsKeys.weight, value);
  }

  void setHeightUnit(String value) {
    state = state.copyWith(heightUnit: value);
    _set(SettingsKeys.height, value);
  }

  void toggleKeyboardExpanded() => _expand(state.keyboardExpanded, (v) => state.copyWith(keyboardExpanded: v));
  void toggleSoundExpanded() => _expand(state.soundExpanded, (v) => state.copyWith(soundExpanded: v));
  void toggleLanguageExpanded() => _expand(state.languageExpanded, (v) => state.copyWith(languageExpanded: v));
  void toggleLightExpanded() => _expand(state.lightExpanded, (v) => state.copyWith(lightExpanded: v));
  void toggleOfflineExpanded() => _expand(state.offlineExpanded, (v) => state.copyWith(offlineExpanded: v));
  void toggleSyncExpanded() => _expand(state.syncExpanded, (v) => state.copyWith(syncExpanded: v));
}