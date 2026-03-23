import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/core/utils/money_format.dart';

void main() {
  test('formatMinorUnits formats INR', () {
    expect(formatMinorUnits(12345, 'INR'), '₹123.45');
    expect(formatMinorUnits(-500, 'INR'), '-₹5.00');
  });
}
