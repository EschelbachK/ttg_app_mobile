import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Global state that holds the currently selected training plan ID.
///
/// This is required so the app knows which plan's folders and exercises
/// should be loaded from the backend.
final activePlanIdProvider = StateProvider<String?>((ref) => null);


/// (Optional – empfohlen für später)
/// Falls du den ganzen Plan statt nur der ID speichern willst,
/// kannst du das hier zusätzlich verwenden.
///
/// Beispiel:
/// ref.read(activePlanProvider.notifier).state = plan;
///
/// Vorteil:
/// - Zugriff auf Name, etc.
/// - weniger erneute API Calls nötig
/*
import '../models/training_plan.dart';

final activePlanProvider = StateProvider<TrainingPlan?>((ref) => null);
*/