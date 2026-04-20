import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/offline/sync_provider.dart';

final settingsProvider =
StateNotifierProvider<SettingsNotifier, SettingsState>(
      (ref) => SettingsNotifier(ref),
);

class SettingsState {
  final bool soundEnabled, lightMode, offlineMode, keyboardMode, syncEnabled;
  final bool countdownSound, startSound, voiceFeedback;

  final bool keyboardExpanded,
      soundExpanded,
      languageExpanded,
      lightExpanded,
      offlineExpanded,
      syncExpanded;

  final int restTimerSeconds;
  final double fontScale;

  final String language, weightUnit, heightUnit;

  const SettingsState({
    required this.soundEnabled,
    required this.lightMode,
    required this.offlineMode,
    required this.restTimerSeconds,
    required this.keyboardMode,
    required this.syncEnabled,
    required this.fontScale,
    required this.countdownSound,
    required this.startSound,
    required this.voiceFeedback,
    required this.language,
    required this.weightUnit,
    required this.heightUnit,
    this.keyboardExpanded = false,
    this.soundExpanded = false,
    this.languageExpanded = false,
    this.lightExpanded = false,
    this.offlineExpanded = false,
    this.syncExpanded = false,
  });

  factory SettingsState.initial() => const SettingsState(
    soundEnabled: true,
    lightMode: false,
    offlineMode: false,
    restTimerSeconds: 60,
    keyboardMode: false,
    syncEnabled: true,
    fontScale: 1,
    countdownSound: true,
    startSound: true,
    voiceFeedback: false,
    language: 'de',
    weightUnit: 'kg',
    heightUnit: 'cm',
  );

  SettingsState copyWith({
    bool? soundEnabled,
    bool? lightMode,
    bool? offlineMode,
    int? restTimerSeconds,
    bool? keyboardMode,
    bool? syncEnabled,
    double? fontScale,
    bool? countdownSound,
    bool? startSound,
    bool? voiceFeedback,
    bool? keyboardExpanded,
    bool? soundExpanded,
    bool? languageExpanded,
    bool? lightExpanded,
    bool? offlineExpanded,
    bool? syncExpanded,
    String? language,
    String? weightUnit,
    String? heightUnit,
  }) =>
      SettingsState(
        soundEnabled: soundEnabled ?? this.soundEnabled,
        lightMode: lightMode ?? this.lightMode,
        offlineMode: offlineMode ?? this.offlineMode,
        restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
        keyboardMode: keyboardMode ?? this.keyboardMode,
        syncEnabled: syncEnabled ?? this.syncEnabled,
        fontScale: fontScale ?? this.fontScale,
        countdownSound: countdownSound ?? this.countdownSound,
        startSound: startSound ?? this.startSound,
        voiceFeedback: voiceFeedback ?? this.voiceFeedback,
        language: language ?? this.language,
        weightUnit: weightUnit ?? this.weightUnit,
        heightUnit: heightUnit ?? this.heightUnit,
        keyboardExpanded: keyboardExpanded ?? this.keyboardExpanded,
        soundExpanded: soundExpanded ?? this.soundExpanded,
        languageExpanded: languageExpanded ?? this.languageExpanded,
        lightExpanded: lightExpanded ?? this.lightExpanded,
        offlineExpanded: offlineExpanded ?? this.offlineExpanded,
        syncExpanded: syncExpanded ?? this.syncExpanded,
      );
}

class SettingsKeys {
  static const sound = 'sound_enabled';
  static const light = 'light_mode';
  static const offline = 'offline_mode';
  static const rest = 'rest_timer';
  static const keyboard = 'keyboard_mode';
  static const sync = 'sync_enabled';
  static const font = 'font_scale';

  static const countdown = 'countdown_sound';
  static const start = 'start_sound';
  static const voice = 'voice_feedback';

  static const language = 'language';
  static const weight = 'weight_unit';
  static const height = 'height_unit';
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  final Ref ref;
  SharedPreferences? _prefs;

  SettingsNotifier(this.ref) : super(SettingsState.initial()) {
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

  void _toggle(bool current, SettingsState Function(bool) fn, String key) {
    final v = !current;
    state = fn(v);
    _set(key, v);
  }

  void toggleOffline() {
    final v = !state.offlineMode;

    state = state.copyWith(
      offlineMode: v,
      syncEnabled: v ? false : state.syncEnabled,
    );

    _set(SettingsKeys.offline, v);
    if (v) _set(SettingsKeys.sync, false);

    if (!v && state.syncEnabled) {
      ref.read(syncEngineProvider).processQueue();
    }
  }

  void toggleSync() {
    final v = !state.syncEnabled;

    state = state.copyWith(
      syncEnabled: v,
      offlineMode: v ? false : state.offlineMode,
    );

    _set(SettingsKeys.sync, v);
    if (v) _set(SettingsKeys.offline, false);

    if (v && !state.offlineMode) {
      ref.read(syncEngineProvider).processQueue();
    }
  }

  void toggleSound() =>
      _toggle(state.soundEnabled, (v) => state.copyWith(soundEnabled: v), SettingsKeys.sound);

  void toggleLightMode() =>
      _toggle(state.lightMode, (v) => state.copyWith(lightMode: v), SettingsKeys.light);

  void toggleKeyboard() =>
      _toggle(state.keyboardMode, (v) => state.copyWith(keyboardMode: v), SettingsKeys.keyboard);

  void toggleCountdownSound() =>
      _toggle(state.countdownSound, (v) => state.copyWith(countdownSound: v), SettingsKeys.countdown);

  void toggleStartSound() =>
      _toggle(state.startSound, (v) => state.copyWith(startSound: v), SettingsKeys.start);

  void toggleVoiceFeedback() =>
      _toggle(state.voiceFeedback, (v) => state.copyWith(voiceFeedback: v), SettingsKeys.voice);

  void setRestTimer(int v) {
    state = state.copyWith(restTimerSeconds: v);
    _set(SettingsKeys.rest, v);
  }

  void setFontScale(double v) {
    state = state.copyWith(fontScale: v);
    _set(SettingsKeys.font, v);
  }

  void setLanguage(String v) {
    state = state.copyWith(language: v);
    _set(SettingsKeys.language, v);
  }

  void setWeightUnit(String v) {
    state = state.copyWith(weightUnit: v);
    _set(SettingsKeys.weight, v);
  }

  void setHeightUnit(String v) {
    state = state.copyWith(heightUnit: v);
    _set(SettingsKeys.height, v);
  }

  void toggleKeyboardExpanded() =>
      state = state.copyWith(keyboardExpanded: !state.keyboardExpanded);

  void toggleSoundExpanded() =>
      state = state.copyWith(soundExpanded: !state.soundExpanded);

  void toggleLanguageExpanded() =>
      state = state.copyWith(languageExpanded: !state.languageExpanded);

  void toggleLightExpanded() =>
      state = state.copyWith(lightExpanded: !state.lightExpanded);

  void toggleOfflineExpanded() =>
      state = state.copyWith(offlineExpanded: !state.offlineExpanded);

  void toggleSyncExpanded() =>
      state = state.copyWith(syncExpanded: !state.syncExpanded);
}