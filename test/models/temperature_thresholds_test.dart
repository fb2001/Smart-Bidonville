import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bidonville/core/models/temperature_thresholds.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';

void main() {
  group('TemperatureThresholds Tests', () {
    const thresholds = TemperatureThresholds(slow: 20.0, medium: 25.0, fast: 30.0);

    test('Should return correct FanSpeed for different temperatures', () {
      // Sous le seuil slow -> Eteint (null)
      expect(thresholds.speedForTemperature(18.0), isNull);
      
      // Entre slow et medium -> Slow
      expect(thresholds.speedForTemperature(22.0), FanSpeed.slow);
      
      // Entre medium et fast -> Medium
      expect(thresholds.speedForTemperature(27.0), FanSpeed.medium);
      
      // Au dessus de fast -> Fast
      expect(thresholds.speedForTemperature(32.0), FanSpeed.fast);
    });

    test('Validation should fail if thresholds are not in ascending order', () {
      const invalidThresholds = TemperatureThresholds(slow: 30.0, medium: 25.0, fast: 20.0);
      expect(invalidThresholds.isValid, isFalse);
      expect(invalidThresholds.validationError, isNotEmpty);
    });

    test('Validation should pass for correct thresholds', () {
      expect(thresholds.isValid, isTrue);
    });

    test('fromJson should parse correctly', () {
      final json = {'slow': 21.0, 'medium': 26.0, 'fast': 31.0};
      final parsed = TemperatureThresholds.fromJson(json);
      expect(parsed.slow, 21.0);
      expect(parsed.medium, 26.0);
      expect(parsed.fast, 31.0);
    });
  });
}
