import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'summary_view_mapper.dart';
import '../providers/workout_provider.dart';

final summaryProvider = Provider((ref) {
  final state = ref.watch(workoutProvider);
  final session = state.session;

  if (session == null) return null;

  return SummaryViewMapper.map(session);
});