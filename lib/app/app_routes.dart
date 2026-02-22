// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:yachid/app/features/auth/module/companies/auth_companies_page.dart';
import 'package:yachid/app/features/home/module/dashboard/dashboard_page.dart';
import 'package:yachid/app/features/home/module/employee/employee.dart';
import 'package:yachid/app/features/home/module/partners/module/partner_detail.dart';
import 'package:yachid/app/features/home/module/partners/partners_list.dart';

import 'features/auth/auth_page.dart';
import 'features/home/home_page.dart';

class Routes {
  static const INITIAL = '/auth';
  static const COMPANIES = '/companies/:id';
  static const HOME = '/home';
  static const DASHBOARD = '/dashboard';
  static const EMPLOYEE = '/employee';
  static const PARTNERS = '/partners';
  static const PARTNER_DETAILS = '/partner-details/:id';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const AuthPage()),
    GetPage(name: Routes.COMPANIES, page: () => AuthCompaniesPage()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.DASHBOARD, page: () => DashboardPage()),
    GetPage(name: Routes.EMPLOYEE, page: () => const EmployeePage()),
    GetPage(name: Routes.PARTNERS, page: () => const PartnersList()),
    GetPage(
      name: Routes.PARTNER_DETAILS,
      page: () => const PartnerDetailsPage(),
    ),
  ];
}
