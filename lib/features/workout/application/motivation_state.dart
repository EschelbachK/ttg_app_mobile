import '../domain/motivation/motivation_result.dart';

class MotivationState {
  final MotivationResult? last;

  const MotivationState({this.last});

  MotivationState copyWith({MotivationResult? last}) {
    return MotivationState(last: last ?? this.last);
  }
}