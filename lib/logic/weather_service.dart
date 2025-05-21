import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeatherData(
    String? lat,
    String? lon,
  ) async {
    if (lat == null || lon == null) {
      throw Exception('Latitude and Longitude cannot be null');
    }
    final url = Uri.parse(
      'https://my.meteoblue.com/packages/basic-day?apikey=r5YN9EtfGCuwnkUb&lat=$lat&lon=$lon&asl=72&format=json',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
