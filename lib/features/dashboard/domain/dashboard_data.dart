class DashboardData {
  final List<VolumePoint> volumeSeries;
  final TrendDirection trend;
  final KPIs kpis;
  final List<SessionPreview> sessions;

  DashboardData({
    required this.volumeSeries,
    required this.trend,
    required this.kpis,
    required this.sessions,
  });
}

class VolumePoint {
  final DateTime date;
  final double volume;

  VolumePoint(this.date, this.volume);
}

enum TrendDirection {
  up,
  down,
  neutral,
}

class KPIs {
  final double totalVolume;
  final double avgVolume;
  final double bestSession;
  final int totalSessions;
  final double? changePercent;

  const KPIs({
    required this.totalVolume,
    required this.avgVolume,
    required this.bestSession,
    required this.totalSessions,
    this.changePercent,
  });
}

class SessionPreview {
  final DateTime date;
  final double volume;
  final Duration duration;

  const SessionPreview({
    required this.date,
    required this.volume,
    required this.duration,
  });
}