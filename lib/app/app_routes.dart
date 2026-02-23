// ignore_for_file: constant_identifier_names

import 'package:get/get.dart';
import 'package:yachid/app/features/auth/module/companies/auth_companies_page.dart';
import 'package:yachid/app/features/home/module/employee/employee.dart';
import 'package:yachid/app/features/home/module/partners/module/partner_detail.dart';
import 'package:yachid/app/features/home/module/partners/partners_list.dart';
import 'package:yachid/app/features/home/module/products/module/product_detail_page.dart';
import 'package:yachid/app/features/home/module/products/products_list.dart';
import 'package:yachid/app/features/home/module/representatives/representatives_list.dart';
import 'package:yachid/app/features/home/module/banks/banks_list.dart';

import 'features/auth/auth_page.dart';
import 'features/home/home_page.dart';

class Routes {
  static const INITIAL = '/auth';
  static const COMPANIES = '/companies';
  static const HOME = '/home';
  static const EMPLOYEE = '/employee';
  static const PARTNERS = '/partners';
  static const PARTNER_DETAILS = '/partner-details/:id';
  static const PRODUCTS = '/products';
  static const PRODUCT_DETAILS = '/product-details/:id';
  static const REPRESENTATIVES = '/representatives';
  static const BANKS = '/banks';
}

class AppPages {
  static final pages = [
    GetPage(name: Routes.INITIAL, page: () => const AuthPage()),
    GetPage(name: Routes.COMPANIES, page: () => AuthCompaniesPage()),
    GetPage(name: Routes.HOME, page: () => HomePage()),
    GetPage(name: Routes.EMPLOYEE, page: () => const EmployeePage()),
    GetPage(name: Routes.PARTNERS, page: () => const PartnersList()),
    GetPage(
      name: Routes.PARTNER_DETAILS,
      page: () => const PartnerDetailsPage(),
    ),
    GetPage(name: Routes.PRODUCTS, page: () => const ProductsList()),
    GetPage(
      name: Routes.PRODUCT_DETAILS,
      page: () => const ProductDetailPage(),
    ),
    GetPage(name: Routes.REPRESENTATIVES, page: () => const RepresentativesList()),
    GetPage(name: Routes.BANKS, page: () => const BanksList()),
  ];
}
