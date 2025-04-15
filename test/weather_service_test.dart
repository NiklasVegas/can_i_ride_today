import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_ride_today/logic/weather_service.dart';

void main() {
  group('WeatherService', () {
    test('fetchWeatherData returns valid data', () async {
      final service = WeatherService();
      final data = await service.fetchWeatherData('Berlin');

      expect(data, isNotNull);
      expect(data['data_day'], isNotNull);
      expect(data['data_day']['temperature_max'], isNotEmpty);
    });
  });
}
