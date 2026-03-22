String formatMinorUnits(int minorUnits, String currencyCode) {
  final major = minorUnits.abs() / 100;
  final negative = minorUnits < 0;
  final body = major.toStringAsFixed(2);
  if (currencyCode == 'USD') {
    return negative ? '-\$$body' : '\$$body';
  }
  return negative ? '-$currencyCode $body' : '$currencyCode $body';
}
