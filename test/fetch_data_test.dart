// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/data/weather_repository.dart';

import 'package:weather_testing_app/main.dart';
import 'package:weather_testing_app/models/weather.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';

void main() {
  WeatherRepositoryImpl weatherRepository;

  setUpAll(() {
    weatherRepository =  WeatherRepositoryImpl();
  });

  test("Fetched weather not null and not empty", () async {
    Either<Unit,Weather> weatherResponse =
    await weatherRepository.fetchWeather("cairo");
    expect(weatherResponse != null, true);
    expect(weatherResponse.fold((l) => unit, (weather) => weather.main!=null), true);
  });
}
