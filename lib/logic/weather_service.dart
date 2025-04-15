import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeatherData(String city) async {
    final url = Uri.parse(
      'https://my.meteoblue.com/packages/basic-day?apikey=r5YN9EtfGCuwnkUb&lat=52.2659&lon=10.5267&asl=72&format=json',
    );
    final response = await http.get(url);
    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      throw Exception('Failed to load weather data');
    }
  }
}
