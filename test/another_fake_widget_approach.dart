
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:weather_testing_app/data/weather_repository.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';

import 'package:weather_testing_app/models/weather.dart';

class MockWeatherRepository extends Mock implements WeatherRepository {}


void main() {
  MockWeatherRepository mockWeatherRepository;

  setUp(() {
    mockWeatherRepository = MockWeatherRepository();
  });
  blocTest(
    'emits [WeatherLoading, WeatherLoaded] when successful',
    build: () {
      when(mockWeatherRepository.fetchWeather.call(any))
          .thenAnswer((_) async => right(Weather(main: Main(temp: 22.5))));
      return WeatherBloc(mockWeatherRepository);
    },
    act: (bloc) => bloc.add(GetWeather('cairo')),
    expect:()=> [isA<WeatherLoading>(),isA<WeatherLoaded>()],
  );
}