import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:given_when_then/given_when_then.dart';
import 'package:weather_testing_app/bloc/weather_bloc.dart';
import 'package:weather_testing_app/data/weather_repository.dart';
import 'package:weather_testing_app/main.dart';
import 'package:weather_testing_app/models/weather.dart';

Future<void> Function(WidgetTester) harness(WidgetTestHarnessCallback<_ExampleWidgetTestHarness> callback) {
  return (tester) => givenWhenThenWidgetTest(_ExampleWidgetTestHarness(tester), callback);
}

class _ExampleWidgetTestHarness extends WidgetTestHarness {
  _ExampleWidgetTestHarness(WidgetTester tester) : super(tester);

  final FakeWeatherRepository fakeWeatherRepository = FakeWeatherRepository();
}

extension ExampleGiven on WidgetTestGiven<_ExampleWidgetTestHarness> {
  Future<void> pumpApp() async {
    await tester.pumpWidget(MyApp(
      createWeatherBloc: (_) => WeatherBloc(this.harness.fakeWeatherRepository),
    ));
  }
}

extension ExampleWhen on WidgetTestWhen<_ExampleWidgetTestHarness> {
  Future<void> pump([Duration duration]) => tester.pump(duration);

  Future<void> userTypes(Finder finder, String text) => tester.enterText(finder, text);

  Future<void> userTapsSubmit() async {
    await tester.testTextInput.receiveAction(TextInputAction.search);
    await pump();
  }

  void callToGetWeatherFails({int at = 0, Unit expectedError}) {
    if (expectedError != null) {
      this.harness.fakeWeatherRepository.weatherCompleters[at].complete(Left(expectedError));
    } else {
      this.harness.fakeWeatherRepository.weatherCompleters[at].completeError('some error');
    }
  }

  void callToGetWeatherSucceedsWith(Weather weather, {int at = 0}) {
    this.harness.fakeWeatherRepository.weatherCompleters[at].complete(Right(weather));
  }
}

extension ExampleThen on WidgetTestThen<_ExampleWidgetTestHarness> {
  void findsOneWidget(Finder finder) => _expect(finder, _findsOneWidget);

  void findsNothing(Finder finder) => _expect(finder, _findsNothing);

  void findsTitleWithText(String text) {
    final widget = tester.widget<Title>(find.byType(Title));
    _expect(widget.title, equals(text));
  }

  void requestToGetWeatherForCity(String cityName, {int at = 0}) {
    _expect(this.harness.fakeWeatherRepository.requestParams[at]['cityName'], equals(cityName));
  }
}

class FakeWeatherRepository implements WeatherRepository {
  final List<Map<String, String>> requestParams = [];
  final List<Completer<Either<Unit, Weather>>> weatherCompleters = [];

  @override
  Future<Either<Unit, Weather>> fetchWeather(String cityName) {
    requestParams.add({'cityName': cityName});
    final completer = Completer<Either<Unit, Weather>>();
    weatherCompleters.add(completer);
    return completer.future;
  }
}

const _expect = expect;
const _findsOneWidget = findsOneWidget;
const _findsNothing = findsNothing;
