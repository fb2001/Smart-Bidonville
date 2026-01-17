import 'package:flutter_test/flutter_test.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';
import 'package:smart_bidonville/core/models/rgb_color.dart';

void main() {
  group('FanStatus', () {
    test('parsing_statut_complet', () {
      final json = {
        'temperature': 25.5,
        'speed': 'medium',  // updated to match Arduino API
        'mode': 'auto',
        'color': '0,0,255'  // Blue for medium speed
      };
      final status = FanStatus.fromJson(json);
      expect(status.temperature, 25.5);
      expect(status.speed, FanSpeed.medium);
      expect(status.mode, FanMode.auto);
      expect(status.color.blue, 255);
    });

    test('parsing_fan_off', () {
      final json = {
        'temperature': 22.0,
        'speed': '',  // Empty string = fan off
        'mode': 'manual',
        'color': '0,0,0'
      };
      final status = FanStatus.fromJson(json);
      expect(status.temperature, 22.0);
      expect(status.speed, null);  // null quand off
      expect(status.isFanRunning, false);
    });
  });
}
