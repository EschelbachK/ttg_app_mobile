import '../models/exercise.dart';

class DashboardMapper {
  static List<Exercise> mapExercises(List<dynamic> list) =>
      list.map((e) => e is Exercise ? e : Exercise.fromJson(e)).toList();
}