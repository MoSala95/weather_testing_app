import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:weather_testing_app/models/weather.dart';

import 'harness.dart';
import 'page_object.dart';

final app = MyAppPageObject();
void main() {
  group('MyApp', () {
    testWidgets('Primary flow should work, with proper rendering of all success and errors.',
        harness((given, when, then) async {
      await given.pumpApp();
      then.findsTitleWithText('Weather App');
      then.findsOneWidget(app.searchTextField);
      then.findsNothing(app.progressIndicator);

      // First attempt to get weather
      await when.userTypes(app.searchTextField, 'cairo');
      await when.userTapsSubmit();

      then.findsOneWidget(app.progressIndicator);
      then.requestToGetWeatherForCity('cairo');
      when.callToGetWeatherFails();
      await when.pump();

      then.findsNothing(app.progressIndicator);
      then.findsOneWidget(app.error);

      // Second attempt to get weather, different type of error
      await when.userTypes(app.searchTextField, 'cairo');
      await when.userTapsSubmit();

      then.findsOneWidget(app.progressIndicator);
      then.requestToGetWeatherForCity('cairo', at: 1);
      when.callToGetWeatherFails(at: 1, expectedError: unit);
      await when.pump();

      then.findsNothing(app.progressIndicator);
      then.findsOneWidget(app.error);

      // Retry a third time with success
      await when.userTypes(app.searchTextField, 'Cairo');
      await when.userTapsSubmit();

      then.findsOneWidget(app.progressIndicator);
      then.requestToGetWeatherForCity('Cairo', at: 2);
      when.callToGetWeatherSucceedsWith(fakeCairoWeather, at: 2);
      await when.pump();

      then.findsNothing(app.progressIndicator);
      then.findsOneWidget(app.weatherDetails);
      then.findsOneWidget(find.text('99.0 °C'));
    }));
  });
}

final fakeCairoWeather = Weather(main: Main(temp: 99));
