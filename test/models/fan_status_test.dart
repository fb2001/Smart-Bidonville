import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';

void main() {
  group('FanStatus', () {
    test('parsing_statut_complet', () {
      final json = {
        'temperature': 25.5,
        'humidity': 60.0,
        'fan_speed': 'medium',
        'mode': 'auto',
        'is_auto': true
      };
      final status = FanStatus.fromJson(json);
      expect(status.temperature, 25.5);
      expect(status.humidity, 60.0);
      expect(status.fanSpeed, FanSpeed.medium);
      expect(status.mode, FanMode.auto);
      expect(status.isAuto, isTrue);
    });
  });
}
