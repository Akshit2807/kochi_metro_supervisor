import 'package:get/get.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/maintenance_controller.dart';

class MaintenanceBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<MaintenanceController>(() => MaintenanceController());
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
