import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mocktail/mocktail.dart';
import 'package:smart_bidonville/core/api/fan_api_service.dart';
import 'package:smart_bidonville/core/api/api_exception.dart';
import 'package:smart_bidonville/core/models/fan_mode.dart';

class MockClient extends Mock implements http.Client {}
class FakeUri extends Fake implements Uri {}

void main() {
  late FanApiService apiService;
  late MockClient mockClient;
  const baseUrl = '192.168.1.50';

  setUpAll(() {
    registerFallbackValue(FakeUri());
  });

  setUp(() {
    mockClient = MockClient();
    apiService = FanApiService(client: mockClient);
  });

  group('FanApiService', () {
    test('recuperation_statut_succes', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response(
        '{"temperature": 25.0, "humidity": 50.0, "fan_speed": "slow", "mode": "auto", "is_auto": true}',
        200,
      ));

      final status = await apiService.getFanStatus(baseUrl);

      expect(status.temperature, 25.0);
      verify(() => mockClient.get(Uri.parse('http://$baseUrl/status'))).called(1);
    });

    test('changement_mode_requete_post', () async {
      when(() => mockClient.post(any(), body: any(named: 'body')))
          .thenAnswer((_) async => http.Response('{"success": true}', 200));

      final result = await apiService.setMode(baseUrl, FanMode.auto);

      expect(result, isTrue);
      verify(() => mockClient.post(
        Uri.parse('http://$baseUrl/mode'),
        body: any(named: 'body'),
      )).called(1);
    });

    test('gestion_erreur_serveur_500', () async {
      when(() => mockClient.get(any())).thenAnswer((_) async => http.Response('Error', 500));

      expect(
        () => apiService.getFanStatus(baseUrl),
        throwsA(isA<ApiException>()),
      );
    });
  });
}
