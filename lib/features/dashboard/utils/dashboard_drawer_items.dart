import 'package:flutter/material.dart';

class DashboardDrawerItem {
  final IconData icon;
  final String label;

  const DashboardDrawerItem(this.icon, this.label);
}

class DashboardDrawerItems {
  static const items = [
    DashboardDrawerItem(Icons.folder_copy, "Trainingspläne"),
    DashboardDrawerItem(Icons.fitness_center, "Eigene Übungen"),
    DashboardDrawerItem(Icons.emoji_events, "Absolvierte Einheiten"),
    DashboardDrawerItem(Icons.monitor_weight, "Körperdaten"),
    DashboardDrawerItem(Icons.bar_chart, "Statistik"),
    DashboardDrawerItem(Icons.settings, "Einstellungen"),
    DashboardDrawerItem(Icons.favorite, "Unterstütze Gainsfire"),
    DashboardDrawerItem(Icons.help, "Hilfe"),
    DashboardDrawerItem(Icons.school, "Gainsfire für Trainer"),
    DashboardDrawerItem(Icons.info, "Über Gainsfire"),
  ];
}