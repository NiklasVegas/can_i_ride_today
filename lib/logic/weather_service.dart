// import 'dart:nativewrappers/_internal/vm/lib/math_patch.dart';

import 'dart:developer';

import 'package:country_state_city/country_state_city.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class WeatherService {
  Future<Map<String, dynamic>> fetchWeatherData(City city) async {
    String cityName = city.name;
    String? lat = city.latitude;
    String? lon = city.longitude;
    log("fetching weather Data for city: $cityName");
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
