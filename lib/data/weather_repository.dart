import 'dart:math';

import 'package:dartz/dartz.dart';
import 'package:weather_testing_app/models/weather.dart';
import 'api_routes.dart';
import 'package:http/http.dart' as http;

abstract class WeatherRepository {
  /// Throws [NetworkException].
  Future<Either<Unit,Weather>> fetchWeather(String cityName);
}

class WeatherRepositoryImpl implements WeatherRepository {
  @override
  Future<Either<Unit,Weather>> fetchWeather(String cityName) async{
    // Simulate network delay
    var url = Uri.parse(ApiRoutes.BaseUrl+cityName+ApiRoutes.apiKey);

    print("start fectching");
    try {
      final http.Response response=  await http
          .get(url,
        headers: {
          "Content-Type": "application/json",
        }
      );
      print(url.path);
      print(response.body);
      if (response.statusCode == 200) {
        Weather weatherModel= weatherFromJson(response.body);
        print("weather success");
        return right(weatherModel);
      } else {
        print("weather failed");

        return left(unit);
      }

    } catch (e) {
      print(e.toString());

      return left(unit);
    }

  }
}

class NetworkException implements Exception {}