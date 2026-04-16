class InsightDashboardData {
  final List<SessionInsight> sessions;
  final InsightSummary summary;
  final TrendInsight trend;

  InsightDashboardData({
    required this.sessions,
    required this.summary,
    required this.trend,
  });
}

class SessionInsight {
  final DateTime date;
  final double volume;
  final double changeToPrevious;
  final SessionState state;

  SessionInsight({
    required this.date,
    required this.volume,
    required this.changeToPrevious,
    required this.state,
  });
}

class InsightSummary {
  final double totalVolume;
  final double avgPerSession;
  final int totalSessions;
  final double relativeStrength;
  final double consistency;
  final String interpretation;

  InsightSummary({
    required this.totalVolume,
    required this.avgPerSession,
    required this.totalSessions,
    required this.relativeStrength,
    required this.consistency,
    required this.interpretation,
  });
}

enum SessionState { strong, stable, weak }

enum TrendState { improving, stable, declining }

class TrendInsight {
  final TrendState state;
  final double changePercent;
  final String message;

  const TrendInsight({
    required this.state,
    required this.changePercent,
    required this.message,
  });
}