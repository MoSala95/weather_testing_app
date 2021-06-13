import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';
 import 'package:weather_testing_app/models/weather.dart';

class WeatherSearchPage extends StatefulWidget {
  @override
  _WeatherSearchPageState createState() => _WeatherSearchPageState();
}

class _WeatherSearchPageState extends State<WeatherSearchPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Weather Search"),
      ),
      body: Container(
        padding: EdgeInsets.symmetric(vertical: 16),
        alignment: Alignment.center,
        child: BlocConsumer<WeatherBloc, WeatherState>(
          listener: (context, state) {
            if (state is WeatherError) {
              ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(state.message),key: Key("error_bar"),),);
            }
          },
          builder: (context, state) {
            if (state is WeatherInitial) {
              return buildInitialInput();
            } else if (state is WeatherLoading) {
              return buildLoading();
            } else if (state is WeatherLoaded) {
              return buildColumnWithData(state.weather);
            } else {
              // (state is WeatherError)
              return buildInitialInput();
            }
          },
        ),
      ),
    );
  }

  Widget buildInitialInput() {
    return Center(
      child: CityInputField(),
    );
  }

  Widget buildLoading() {
    return Center(
       child: CircularProgressIndicator(key:Key("progress_indicator") ,),
    );
  }

  Column buildColumnWithData(Weather weather) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      key: Key("temp_text"),
      children: <Widget>[
        Text(
          "Temperature: ",
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w700,
          ),
        ),
        Text(
          // Display the temperature with 1 decimal place
          "${weather.main.temp} °C",
          style: TextStyle(fontSize: 60),


        ),
        CityInputField(),
      ],
    );
  }
}

class CityInputField extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50),
      child: TextField(
        key: Key("getData"),
        onSubmitted: (value) => submitCityName(context, value),
        textInputAction: TextInputAction.search,
        decoration: InputDecoration(
          hintText: "Enter a city",
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          suffixIcon: Icon(Icons.search),
        ),
      ),
    );
  }

  void submitCityName(BuildContext context, String cityName) {
    final weatherBloc = context.read<WeatherBloc>();
    weatherBloc.add(GetWeather(cityName));
  }
}