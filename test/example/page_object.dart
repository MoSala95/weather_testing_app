import 'package:flutter/widgets.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:page_object/page_object.dart';
import 'package:weather_testing_app/main.dart';

class MyAppPageObject extends PageObject {
  MyAppPageObject() : super(find.byType(MyApp));

  Finder get searchTextField => find.byKey(Key('search_field'));
  Finder get progressIndicator => find.byKey(Key("progress_indicator"));
  Finder get error => find.byKey(Key("error_bar"));
  Finder get weatherDetails => find.byKey(Key("temp_text"));
}
