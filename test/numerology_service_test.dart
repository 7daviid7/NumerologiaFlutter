import 'package:flutter_test/flutter_test.dart';
import 'package:numerologia/services/numerology_calculation_service.dart';

void main() {
  group('Numerology Calculation Service Date Parsing', () {
    test('calculateDataValues handles YYYY-MM-DD format correctly', () {
      // 2003-04-03 (3rd April 2003)
      final result = calculateDataValues('2003-04-03');

      // Check if basic parts are parsed correctly
      expect(result['Any'], 2003);
      expect(result['Mes'], 4);
      expect(result['Dia'], 3);
    });

    test('calculateDataValues handles DD/MM/YYYY format correctly', () {
      // 03/04/2003 (3rd April 2003)
      final result = calculateDataValues('03/04/2003');

      // Check if basic parts are parsed correctly
      expect(result['Any'], 2003);
      expect(result['Mes'], 4);
      expect(result['Dia'], 3);
    });

    test('calculateDataValues handles invalid format gracefully (zeros)', () {
      final result = calculateDataValues('invalid-date');

      expect(result['Any'], 0);
      expect(result['Mes'], 0);
      expect(result['Dia'], 0);
    });
  });
}
