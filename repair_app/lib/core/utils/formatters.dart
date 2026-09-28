String formatPrice(double value) => '\$${value.toStringAsFixed(2)}';

String formatDistance(double km) => '${km.toStringAsFixed(1)}km';

String formatDuration(int minutes) {
  if (minutes < 60) return '$minutes min';
  final hours = minutes / 60;
  return '${hours == hours.roundToDouble() ? hours.toInt() : hours.toStringAsFixed(1)} hrs';
}
