import 'package:get/get.dart';

import '../../data/services/storage_service.dart';

class InitialBindings extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut<StorageService>(() => StorageService(), fenix: true);
  }
}
