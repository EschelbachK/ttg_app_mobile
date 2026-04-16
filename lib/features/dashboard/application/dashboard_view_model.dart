import '../../history/application/history_service.dart';
import '../domain/insight_models.dart';
import 'insight_engine.dart';

class DashboardViewModel {
  final HistoryService historyService;
  final InsightEngine engine;

  DashboardViewModel({
    required this.historyService,
    required this.engine,
  });

  InsightDashboardData build() {
    final history = historyService.getAll();
    return engine.build(history);
  }
}