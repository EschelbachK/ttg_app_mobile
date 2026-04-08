class DashboardToggleItem {
  final String label;
  final bool isArchive;

  const DashboardToggleItem(this.label, this.isArchive);
}

class DashboardToggleConfig {
  static const items = [
    DashboardToggleItem("PLÄNE", false),
    DashboardToggleItem("ARCHIV", true),
  ];
}