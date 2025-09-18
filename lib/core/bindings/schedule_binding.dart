import 'package:get/get.dart';

import '../../presentation/controllers/bottom_nav_controller.dart';
import '../../presentation/controllers/schedule_controller.dart';

class ScheduleBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<ScheduleController>(() => ScheduleController());
    Get.lazyPut<BottomNavController>(() => BottomNavController());
  }
}
