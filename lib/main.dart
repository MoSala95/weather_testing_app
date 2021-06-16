import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';

import 'bloc/weather_bloc.dart';
import 'data/weather_repository.dart';

void main() => runApp(
      MyApp(
        createWeatherBloc: (context) => WeatherBloc(WeatherRepositoryImpl()),
      ),
    );

class MyApp extends StatelessWidget {
  final WeatherBloc Function(BuildContext) createWeatherBloc;

  const MyApp({Key key, this.createWeatherBloc}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Weather App',
      home: BlocProvider(
        create: createWeatherBloc,
        child: WeatherSearchPage(),
      ),
    );
  }
}
