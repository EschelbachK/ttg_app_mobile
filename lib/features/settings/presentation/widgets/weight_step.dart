class WeightStep {
  static const min = 0.5;
  static const max = 10.0;
  static const step = 0.5;

  static double normalize(double v) {
    final snapped = (v / step).round() * step;
    return snapped.clamp(min, max);
  }

  static String label(double v) => '${v.toStringAsFixed(1)} kg';
}