
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_testing_app/data/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';

import 'package:weather_testing_app/models/weather.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}


void main() {
  MockWeatherRepository mockWeatherRepository;
  WeatherBloc weatherBloc;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
    weatherBloc = WeatherBloc(mockWeatherRepository);
  });

  group('GetWeather', () {
    testWidgets('Weather success test', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
          value: weatherBloc,
          child: WeatherSearchPage(),

        ),));
        expect(find.byType(CityInputField), findsWidgets);

        final textSearchField = find.byKey(Key("search_field"));
        await tester.enterText(textSearchField, "cairo");
        when(mockWeatherRepository.fetchWeather.call(any))
            .thenAnswer((_) async {
              return right(Weather(main: Main(temp: 22.5)))  ;
        } );
        weatherBloc.add(GetWeather("cairo"));
        print(weatherBloc.state);
        await tester.pump(Duration(seconds: 1));
        //expect(find.byKey(Key("progress_indicator")), findsWidgets);


        expect(find.byType(CityInputField), findsWidgets);
        print(weatherBloc.state);
        await tester.pumpAndSettle();
        print(weatherBloc.state);

        expect(find.byType(CityInputField), findsWidgets);
        expect(find.byKey(Key("temp_text")), findsWidgets);

      });
    });
  });
}