import 'package:flutter/material.dart';

import 'app/bloc_injector.dart';
import 'app/core/config/application_config.dart';
import 'app/core/helpers/environments.dart';

void main() async {
  await ApplicationConfig().configure();
  await Environments.load("BASE_URL");
  runApp(BlocInjection());
}
