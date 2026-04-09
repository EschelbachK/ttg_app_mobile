import '../domain/motivation/motivation_result.dart';

class MotivationState {
  final MotivationResult? last;
  final bool visible;
  final DateTime? timestamp;

  const MotivationState({
    this.last,
    this.visible = false,
    this.timestamp,
  });

  MotivationState copyWith({
    MotivationResult? last,
    bool? visible,
    DateTime? timestamp,
  }) {
    return MotivationState(
      last: last ?? this.last,
      visible: visible ?? this.visible,
      timestamp: timestamp ?? this.timestamp,
    );
  }
}