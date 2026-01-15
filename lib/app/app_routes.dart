import 'package:get/get.dart';

import 'features/enterprise/list_enterprise_page.dart';
import 'features/enterprise/create_enterprise_page.dart';
import 'features/login/login_page.dart';

class Routes {
  static const INITIAL = "/login";
  static const ENTERPRISE_LIST = "/enterprise-list";
  static const CREATE_ENTERPRISE = "/enterprise-create";
}

class AppPages {
  static final pages = [
    GetPage(
      name: Routes.INITIAL,
      page: () => const LoginPage(),
    ),
    GetPage(
      name: Routes.ENTERPRISE_LIST,
      page: () => const EnterpriseListPage(),
    ),
    GetPage(
      name: Routes.CREATE_ENTERPRISE,
      page: () => const CreateEnterprisePage(),
    ),
  ];
}
