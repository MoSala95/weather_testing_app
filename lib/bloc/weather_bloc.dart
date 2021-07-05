import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:meta/meta.dart';
import 'package:weather_testing_app/data/weather_repository.dart';
import 'package:weather_testing_app/models/weather.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository _weatherRepository;

  WeatherBloc(this._weatherRepository) : super(WeatherInitial());

  @override
  Stream<WeatherState> mapEventToState(WeatherEvent event) async* {
    if (event is GetWeather) {
      try {
        print("map events");
        yield WeatherLoading();
        final weather = await _weatherRepository.fetchWeather(event.cityName);
        print(weather.isRight());
        yield weather.fold((l) => WeatherError("Couldn't fetch weather"), (r) => WeatherLoaded(r));
      } catch (error, _) {
        yield WeatherError("Couldn't fetch weather");
      }
    }
  }
}
