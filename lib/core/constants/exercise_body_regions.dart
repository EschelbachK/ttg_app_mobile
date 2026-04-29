final categories = [
  "Alle Bereiche",
  "Brust",
  "Rücken",
  "Beine",
  "Schultern",
  "Bizeps",
  "Trizeps",
  "Bauch",
  "Nacken",
  "Unterarme",
  "Cardio",
  "Ganzkörper",
]..sort((a, b) => a.toLowerCase().compareTo(b.toLowerCase()));

class BodyRegions {
  static const ALL = "ALL";
  static const CHEST = "CHEST";
  static const BACK = "BACK";
  static const LEGS = "LEGS";
  static const SHOULDERS = "SHOULDERS";
  static const ARMS = "ARMS";
  static const CORE = "CORE";
  static const CONDITIONING = "CONDITIONING";
  static const FULL_BODY = "FULL_BODY";

  static const all = [
    ALL,
    CHEST,
    BACK,
    LEGS,
    SHOULDERS,
    ARMS,
    CORE,
    CONDITIONING,
    FULL_BODY,
  ];
}

String mapCategoryToBodyRegion(String c) {
  switch (c.toLowerCase()) {
    case "alle bereiche":
      return BodyRegions.ALL;
    case "brust":
      return BodyRegions.CHEST;
    case "rücken":
      return BodyRegions.BACK;
    case "beine":
      return BodyRegions.LEGS;
    case "schultern":
      return BodyRegions.SHOULDERS;
    case "bizeps":
    case "trizeps":
    case "unterarme":
      return BodyRegions.ARMS;
    case "bauch":
      return BodyRegions.CORE;
    case "nacken":
      return BodyRegions.SHOULDERS;
    case "cardio":
      return BodyRegions.CONDITIONING;
    case "ganzkörper":
      return BodyRegions.FULL_BODY;
    default:
      return BodyRegions.ALL;
  }
}

String mapBodyRegionToDisplayName(String region) {
  switch (region) {
    case BodyRegions.CHEST:
      return "Brust";
    case BodyRegions.BACK:
      return "Rücken";
    case BodyRegions.LEGS:
      return "Beine";
    case BodyRegions.SHOULDERS:
      return "Schultern";
    case BodyRegions.ARMS:
      return "Arme";
    case BodyRegions.CORE:
      return "Bauch";
    case BodyRegions.CONDITIONING:
      return "Cardio";
    case BodyRegions.FULL_BODY:
      return "Ganzkörper";
    case BodyRegions.ALL:
      return "Alle Bereiche";
    default:
      return "Andere";
  }
}