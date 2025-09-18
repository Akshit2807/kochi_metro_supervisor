import 'package:get/get.dart';

import '../../presentation/controllers/dashboard_controller.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';

class DashboardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<DashboardController>(() => DashboardController());

    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
