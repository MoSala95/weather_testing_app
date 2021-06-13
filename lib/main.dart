import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_testing_app/pages/weather_search_page.dart';

import 'bloc/weather_bloc.dart';
import 'data/weather_repository.dart';
void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Material App',
      home: BlocProvider(
        create: (context) => WeatherBloc(WeatherRepositoryImpl()),
        child: WeatherSearchPage(),
      ),
    );
  }
}