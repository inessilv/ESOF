import 'dart:ffi';

import 'package:flutter_driver/flutter_driver.dart';
import 'package:flutter_gherkin/flutter_gherkin.dart';
import 'package:gherkin/gherkin.dart';


StepDefinitionGeneric DisableAll() {
  return then<FlutterWorld>(
    'I do not expect all the switches to be enabled',
        (context) async {
      final locator = find.byValueKey('all_Enabled');
      FlutterDriverUtils.isAbsent(context.world.driver, locator);
    },
  );
}