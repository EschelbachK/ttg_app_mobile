final categories = [
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

String mapCategoryToBodyRegion(String c) {
  switch (c.toLowerCase()) {
    case "brust":
      return "BRUST";
    case "rücken":
      return "RUECKEN";
    case "beine":
      return "BEINE";
    case "schultern":
      return "SCHULTERN";
    case "bizeps":
      return "BIZEPS";
    case "trizeps":
      return "TRIZEPS";
    case "bauch":
      return "BAUCH";
    case "nacken":
      return "NACKEN";
    case "unterarme":
      return "UNTERARME";
    case "cardio":
      return "CARDIO";
    case "ganzkörper":
      return "GANZKOERPER";
    default:
      return c.toUpperCase();
  }
}