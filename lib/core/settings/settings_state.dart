class SettingsState {
  final bool soundEnabled, lightMode, offlineMode, keyboardMode, syncEnabled;
  final bool countdownSound, startSound, voiceFeedback;
  final bool keyboardExpanded, soundExpanded, languageExpanded, lightExpanded, offlineExpanded, syncExpanded;
  final int restTimerSeconds;
  final double fontScale, weightStep;
  final String language, weightUnit, heightUnit;

  const SettingsState({
    required this.soundEnabled,
    required this.lightMode,
    required this.offlineMode,
    required this.restTimerSeconds,
    required this.keyboardMode,
    required this.syncEnabled,
    required this.fontScale,
    required this.weightStep,
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
    weightStep: 1.0,
    countdownSound: true,
    startSound: true,
    voiceFeedback: false,
    language: 'de',
    weightUnit: 'kg',
    heightUnit: 'cm',
  );

  SettingsState copyWith({
    bool? soundEnabled, bool? lightMode, bool? offlineMode,
    int? restTimerSeconds, bool? keyboardMode, bool? syncEnabled,
    double? fontScale, double? weightStep,
    bool? countdownSound, bool? startSound, bool? voiceFeedback,
    bool? keyboardExpanded, bool? soundExpanded, bool? languageExpanded,
    bool? lightExpanded, bool? offlineExpanded, bool? syncExpanded,
    String? language, String? weightUnit, String? heightUnit,
  }) => SettingsState(
    soundEnabled: soundEnabled ?? this.soundEnabled,
    lightMode: lightMode ?? this.lightMode,
    offlineMode: offlineMode ?? this.offlineMode,
    restTimerSeconds: restTimerSeconds ?? this.restTimerSeconds,
    keyboardMode: keyboardMode ?? this.keyboardMode,
    syncEnabled: syncEnabled ?? this.syncEnabled,
    fontScale: fontScale ?? this.fontScale,
    weightStep: weightStep ?? this.weightStep,
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