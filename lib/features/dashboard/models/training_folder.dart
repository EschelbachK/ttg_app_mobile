import 'training_plan.dart';

class TrainingFolder {
  final String id;
  final String name;
  final List<TrainingPlan> plans;

  TrainingFolder({
    required this.id,
    required this.name,
    required this.plans,
  });

  TrainingFolder copyWith({
    String? id,
    String? name,
    List<TrainingPlan>? plans,
  }) {
    return TrainingFolder(
      id: id ?? this.id,
      name: name ?? this.name,
      plans: plans ?? this.plans,
    );
  }
}