import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class Environments {
  Environments._();

  static String? get(String param) {
    return dotenv.get(param);
  }

  /// Carrega .env.production em release (build web --release) e .env em debug/profile.
  static Future<void> load(String ambiente) async {
    final fileName = kReleaseMode ? '.env.production' : '.env';
    await dotenv.load(fileName: fileName);
  }

  static void init() {
    Environments._();
  }
}
