import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:smart_bidonville/core/api/fan_api_service.dart';
import 'package:smart_bidonville/core/api/api_exception.dart';
import 'package:smart_bidonville/core/config/esp32_config.dart';
import 'package:smart_bidonville/core/models/fan_status.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';
import 'package:smart_bidonville/core/models/fan_speed.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_provider.dart';
import 'package:smart_bidonville/features/dashboard/viewmodel/dashboard_state.dart';

class MockFanApiService extends Mock implements FanApiService {}
class MockEsp32Config extends Mock implements Esp32Config {}

void main() {
  late DashboardProvider provider;
  late MockFanApiService mockApiService;
  late MockEsp32Config mockConfig;
  const testIp = '192.168.1.100';

  setUpAll(() {
    // Enregistrer les fallback values pour mocktail
    registerFallbackValue(FanSpeed.off);
    registerFallbackValue(FanMode.manual);
  });

  setUp(() {
    mockApiService = MockFanApiService();
    mockConfig = MockEsp32Config();
    provider = DashboardProvider(apiService: mockApiService, config: mockConfig);
  });

  // Important : On arrête les timers après chaque test pour libérer les ressources
  tearDown(() {
    provider.stopPolling();
    provider.dispose();
  });

  group('Dashboard Logic', () {
    test('etat_initial_correct', () {
      expect(provider.state.status, DashboardStatus.initial);
    });

    test('chargement_donnees_succes', () async {
      final mockData = FanStatus(
        temperature: 22.0,
        humidity: 45.0,
        fanSpeed: FanSpeed.off,
        mode: FanMode.manual,
        isAuto: false,
      );

      when(() => mockConfig.setIpAddress(any<String>())).thenAnswer((_) async {});
      when(() => mockApiService.getFanStatus(any<String>())).thenAnswer((_) async => mockData);

      await provider.setIpAddress(testIp);
      
      // Arrêter le polling immédiatement pour éviter que le test se bloque
      provider.stopPolling();

      expect(provider.state.status, DashboardStatus.loaded);
      expect(provider.state.fanStatus?.temperature, 22.0);
    });

    test('gestion_erreur_reseau', () async {
      when(() => mockConfig.setIpAddress(any<String>())).thenAnswer((_) async {});
      when(() => mockApiService.getFanStatus(any<String>())).thenThrow(
        ApiException('Erreur de connexion', type: ApiExceptionType.networkError),
      );

      await provider.setIpAddress(testIp);
      
      // Le polling devrait être arrêté automatiquement sur erreur réseau
      expect(provider.state.status, DashboardStatus.error);
    });
  });
}
