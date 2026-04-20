import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>(
        (ref) => SettingsNotifier());

class SettingsState {
  final bool soundEnabled, lightMode, offlineMode, keyboardMode, syncEnabled;
  final bool keyboardExpanded;
  final int restTimerSeconds;
  final double fontScale;

  const SettingsState({
    required this.soundEnabled,
    required this.lightMode,
    required this.offlineMode,
    required this.restTimerSeconds,
    required this.keyboardMode,
    required this.syncEnabled,
    required this.fontScale,
    this.keyboardExpanded = false,
  });

  factory SettingsState.initial() => const SettingsState(
    soundEnabled: true,
    lightMode: false,
    offlineMode: false,
    restTimerSeconds: 60,
    keyboardMode: false,
    syncEnabled: true,
    fontScale: 1,
  );

  SettingsState copyWith({
    bool? soundEnabled,
    bool? lightMode,
    bool? offlineMode,
    int? restTimerSeconds,
    bool? keyboardMode,
    bool? syncEnabled,
    double? fontScale,
    bool? keyboardExpanded,
  }) {
    return SettingsState(
      soundEnabled: soundEnabled ?? this.soundEnabled,
      lightMode: lightMode ?? this.lightMode,
      offlineMode: offlineMode ?? this.offlineMode,
      restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
      keyboardMode: keyboardMode ?? this.keyboardMode,
      syncEnabled: syncEnabled ?? this.syncEnabled,
      fontScale: fontScale ?? this.fontScale,
      keyboardExpanded: keyboardExpanded ?? this.keyboardExpanded,
    );
  }
}

class SettingsKeys {
  static const sound = 'sound_enabled';
  static const light = 'light_mode';
  static const offline = 'offline_mode';
  static const rest = 'rest_timer';
  static const keyboard = 'keyboard_mode';
  static const sync = 'sync_enabled';
  static const font = 'font_scale';
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  SharedPreferences? _prefs;

  SettingsNotifier() : super(SettingsState.initial()) {
    _init();
  }

  Future<void> _init() async {
    _prefs = await SharedPreferences.getInstance();
    _load();
  }

  void _load() {
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
    );
  }

  void _set<T>(String key, T value) {
    final p = _prefs;
    if (p == null) return;
    if (value is bool) p.setBool(key, value);
    if (value is int) p.setInt(key, value);
    if (value is double) p.setDouble(key, value);
  }

  void toggleSound() {
    final v = !state.soundEnabled;
    state = state.copyWith(soundEnabled: v);
    _set(SettingsKeys.sound, v);
  }

  void toggleLightMode() {
    final v = !state.lightMode;
    state = state.copyWith(lightMode: v);
    _set(SettingsKeys.light, v);
  }

  void toggleOffline() {
    final v = !state.offlineMode;
    state = state.copyWith(offlineMode: v);
    _set(SettingsKeys.offline, v);
  }

  void setRestTimer(int v) {
    state = state.copyWith(restTimerSeconds: v);
    _set(SettingsKeys.rest, v);
  }

  void toggleKeyboard() {
    final v = !state.keyboardMode;
    state = state.copyWith(keyboardMode: v);
    _set(SettingsKeys.keyboard, v);
  }

  void toggleKeyboardExpanded() {
    state = state.copyWith(keyboardExpanded: !state.keyboardExpanded);
  }

  void toggleSync() {
    final v = !state.syncEnabled;
    state = state.copyWith(syncEnabled: v);
    _set(SettingsKeys.sync, v);
  }

  void setFontScale(double v) {
    state = state.copyWith(fontScale: v);
    _set(SettingsKeys.font, v);
  }
}