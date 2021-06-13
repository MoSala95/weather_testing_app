
import 'package:weather_testing_app/data/weather_repository.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';

import 'package:weather_testing_app/models/weather.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';

 void main() {
   WeatherBloc weatherBloc;
   FakeWeatherRepository fakeWeatherRepository;

  setUp(() {
    fakeWeatherRepository = FakeWeatherRepository();
    weatherBloc = WeatherBloc(fakeWeatherRepository);
  });

  group('GetWeather', () {
    testWidgets('Weather success test', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
          value: weatherBloc,
          child: WeatherSearchPage(),

        ),));
        expect(find.byType(CityInputField), findsWidgets);
        final expectedStates = [WeatherLoading(),WeatherLoaded(Weather(main: Main(temp: 22.5)))];
        weatherBloc.add(GetWeather("cairo"));
        await tester.pumpAndSettle();
        expectLater(
          weatherBloc.stream,
          emitsInAnyOrder(expectedStates),
        );
       });
    });
  });
}

