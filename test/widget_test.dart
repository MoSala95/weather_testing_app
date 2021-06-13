// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';
import 'package:weather_testing_app/data/weather_repository.dart';

import 'package:weather_testing_app/main.dart';
import 'package:weather_testing_app/models/weather.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';
import 'package:bloc_test/bloc_test.dart';

void main() {
  WeatherBloc weatherBloc;
 
  setUpAll(() {
     weatherBloc = WeatherBloc(FakeWeatherRepository());

  });
  testWidgets('Weather loading test', (WidgetTester tester) async {
      await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
        value: weatherBloc,
        child: WeatherSearchPage(),

      ),));
      expect(find.byType(CityInputField), findsWidgets);
      weatherBloc.emit(WeatherLoading());
      await tester.pump();
      expect(find.byKey(ValueKey("progress_indicator")), findsWidgets);
      print("${weatherBloc.state}");
  });

  testWidgets('Weather success test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
      value: weatherBloc,
      child: WeatherSearchPage(),

    ),));

    weatherBloc.emit(WeatherLoaded(Weather(main: Main(temp: 22.5))));
    await tester.pump();
    expect(find.byKey(ValueKey("temp_text")), findsWidgets);
    print("${weatherBloc.state}");

  });
  testWidgets('Weather error test', (WidgetTester tester) async {
    await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
      value: weatherBloc,
      child: WeatherSearchPage(),

    ),));

    weatherBloc.emit(WeatherError("error"));
    await tester.pump();
    expect(find.byKey(ValueKey("error_bar")), findsWidgets);
    print("${weatherBloc.state}");

  });

}
