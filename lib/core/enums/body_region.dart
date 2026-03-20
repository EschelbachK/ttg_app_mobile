enum BodyRegion {
  BRUST,
  RUECKEN,
  BEINE,
  SCHULTERN,
  ARME,
  CORE,
}

extension BodyRegionExtension on BodyRegion {
  String toApi() {
    return name;
  }

  String get label {
    switch (this) {
      case BodyRegion.BRUST:
        return 'Brust';
      case BodyRegion.RUECKEN:
        return 'Rücken';
      case BodyRegion.BEINE:
        return 'Beine';
      case BodyRegion.SCHULTERN:
        return 'Schultern';
      case BodyRegion.ARME:
        return 'Arme';
      case BodyRegion.CORE:
        return 'Core';
    }
  }
}