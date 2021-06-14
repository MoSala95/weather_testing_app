
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
        when(mockWeatherRepository.fetchWeather.call(any))
            .thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return right(Weather(main: Main(temp: 22.5)))  ;
        });
        expect(find.byType(CityInputField), findsWidgets);

        await tester.enterText(find.byKey(new Key('search_field')), 'cairo');
        await tester.testTextInput.receiveAction(TextInputAction.search);

        await tester.pump();
        await tester.pump(Duration.zero);
        print(weatherBloc.state);

        expect(find.byKey(Key("progress_indicator")), findsOneWidget);
        await tester.idle();
        await tester.pump();
        print(weatherBloc.state);

        expect(find.byType(CityInputField), findsWidgets);
        expect(find.byKey(Key("temp_text")), findsWidgets);

      });
    });
    testWidgets('Weather error test', (WidgetTester tester) async {
      await tester.runAsync(() async {
        await tester.pumpWidget(MaterialApp(home:  BlocProvider.value(
          value: weatherBloc,
          child: WeatherSearchPage(),

        ),));
        when(mockWeatherRepository.fetchWeather.call(any))
            .thenAnswer((_) async {
          await Future.delayed(Duration.zero);
          return left(unit)  ;
        });
        expect(find.byType(CityInputField), findsWidgets);

        await tester.enterText(find.byKey(new Key('search_field')), 'cairo');
        await tester.testTextInput.receiveAction(TextInputAction.search);

        await tester.pump();
        await tester.pump(Duration.zero);
        print(weatherBloc.state);

        expect(find.byKey(Key("progress_indicator")), findsOneWidget);
        await tester.idle();
        await tester.pump();
        print(weatherBloc.state);
        expect(find.byKey(Key("error_bar")), findsWidgets);

      });
    });
  });
}