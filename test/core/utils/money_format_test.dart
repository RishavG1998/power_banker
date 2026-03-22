import 'package:flutter_test/flutter_test.dart';
import 'package:powerbanker/core/utils/money_format.dart';

void main() {
  test('formatMinorUnits formats USD', () {
    expect(formatMinorUnits(12345, 'USD'), '\$123.45');
    expect(formatMinorUnits(-500, 'USD'), '-\$5.00');
  });
}
