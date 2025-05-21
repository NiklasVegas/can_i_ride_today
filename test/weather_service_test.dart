import 'package:flutter_test/flutter_test.dart';
import 'package:can_i_ride_today/logic/weather_service.dart';
import 'package:country_state_city/country_state_city.dart' as csc;

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  group('WeatherService', () {
    test('fetchWeatherData returns valid data', () async {
      final service = WeatherService();
      final cities = await csc.getCountryCities('DE');
      final data = await service.fetchWeatherData(cities.first);

      expect(data, isNotNull);
      expect(data['data_day'], isNotNull);
      expect(data['data_day']['temperature_max'], isNotEmpty);
    });
  });
}
