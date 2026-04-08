import 'package:flutter_riverpod/flutter_riverpod.dart';

final activePlanIdProvider = StateProvider<String?>((ref) => null);

final hasActivePlanProvider =
Provider<bool>((ref) => ref.watch(activePlanIdProvider) != null);