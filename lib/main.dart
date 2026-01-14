import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'app/bloc_injector.dart';
import 'app/core/rest/http/http_rest_client.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load();

  final baseUrl = dotenv.env['BASE_URL'];
  if (baseUrl == null || baseUrl.isEmpty) {
    throw Exception('BASE_URL não definido no .env');
  }

  final httpClient = HttpRestClient(baseUrl: baseUrl);

  runApp(BlocInjection());
}
