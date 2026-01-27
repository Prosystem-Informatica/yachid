import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:yachid/app/features/auth/module/companies/auth_companies_page.dart';

import 'features/auth/auth_page.dart';
import 'features/home/home_page.dart';

class Routes {
  static const INITIAL = '/auth';
  static const COMPANIES = '/companies';
  static const HOME = '/home';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const AuthPage()),
    GetPage(name: Routes.COMPANIES, page: () => AuthCompaniesPage()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
  ];
}
