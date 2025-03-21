import 'dart:convert';

import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';

import '../models/weather_model.dart';
import 'package:http/http.dart' as http;

class WeatherService {
  static const BASE_URL = 'http://api.openweathermap.org/data/2.5/weather';
  final String apiKey;

  WeatherService(this.apiKey);

  Future<Weather> getWeather(String cityName) async {
    final response = await http
        .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

    if (response.statusCode == 200) {
      return Weather.fromJson(jsonDecode(response.body));
    } else {
      // 에러 메세지
      throw Exception('Failed to load weather data');
    }
  }

  Future<String> getCurrentCity() async {
    // 유저 위치 권한 수집 동의
    LocationPermission permission = await Geolocator.checkPermission();
    // 거부시 다시 묻기
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // 위치 정보 불러오기
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // 위치 정보 도시명으로 변환
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // 도시 이름 표시
    String? city = placemarks[0].locality;

    return city ?? "";
  }

  // Add new method to get country name
  Future<String> getCurrentCountry() async {
    // Check if we already have permission (reusing logic from getCurrentCity)
    LocationPermission permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
    }

    // Get current position
    Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high);

    // Convert position to placemark
    List<Placemark> placemarks =
        await placemarkFromCoordinates(position.latitude, position.longitude);

    // Get country name
    String? country = placemarks[0].country;

    return country ?? "";
  }

  // 도시 코드 Get country code from city name (for searched cities)
  Future<String> getCountryCode(String cityName) async {
    try {
      final response = await http
          .get(Uri.parse('$BASE_URL?q=$cityName&appid=$apiKey&units=metric'));

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String countryCode = data['sys']['country'] ?? "";
        return countryCode;
      } else {
        return "";
      }
    } catch (e) {
      print('Error getting country code: $e');
      return "";
    }
  }
}
