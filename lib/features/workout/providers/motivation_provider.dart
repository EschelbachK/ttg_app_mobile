import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../application/motivation_engine.dart';

final motivationProvider = Provider((ref) => MotivationEngine());