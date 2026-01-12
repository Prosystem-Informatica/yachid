import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'features/auth/auth_page.dart';

class Routes {
  static const INITIAL = "/auth";
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const AuthPage()),
  ];
}
