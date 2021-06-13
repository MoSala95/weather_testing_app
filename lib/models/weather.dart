
import 'dart:convert';

Weather weatherFromJson(String str) => Weather.fromJson(json.decode(str));

class Weather {
  Weather({
    this.main,
  });

  Main main;

  factory Weather.fromJson(Map<String, dynamic> json) => Weather(
    main: Main.fromJson(json["main"]),
  );
}

class Main {
  Main({
    this.temp,
    this.feelsLike,
    this.tempMin,
    this.tempMax,
    this.pressure,
    this.humidity,
  });

  double temp;
  double feelsLike;
  double tempMin;
  double tempMax;
  int pressure;
  int humidity;

  factory Main.fromJson(Map<String, dynamic> json) => Main(
    temp: json["temp"].toDouble(),
    feelsLike: json["feels_like"].toDouble(),
    tempMin: json["temp_min"].toDouble(),
    tempMax: json["temp_max"].toDouble(),
    pressure: json["pressure"],
    humidity: json["humidity"],
  );
}



