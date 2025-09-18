import 'package:get/get.dart';

import '../../data/models/train_model.dart';

import '../../data/models/user_model.dart';

import '../../data/services/storage_service.dart';

import '../../core/constants/app_constants.dart';

class DashboardController extends GetxController {
  final isLoading = false.obs;

  final availableTrains = <TrainModel>[].obs;

  final maintenanceTrains = <TrainModel>[].obs;

  final currentUser = Rx<UserModel?>(null);

  @override
  void onInit() {
    super.onInit();

    _loadUserData();

    _loadDummyData();
  }

  void _loadUserData() {
    final storageService = Get.find<StorageService>();

    final userData = storageService.readObject(AppConstants.userDataKey);

    if (userData != null) {
      currentUser.value = UserModel.fromJson(userData);
    }
  }

  void _loadDummyData() {
    // Generate dummy train data

    for (int i = 1; i <= 25; i++) {
      availableTrains.add(TrainModel(
        id: 'train_$i',
        number: 'KM${i.toString().padLeft(3, '0')}',
        status: 'Operational',
        currentLocation: _getRandomLocation(),
        isOperational: true,
        lastMaintenance: DateTime.now().subtract(Duration(days: i * 2)),
      ));
    }

    for (int i = 1; i <= 6; i++) {
      maintenanceTrains.add(TrainModel(
        id: 'maintenance_$i',
        number: 'KM${(25 + i).toString().padLeft(3, '0')}',
        status: 'Under Maintenance',
        currentLocation: 'Maintenance Depot',
        isOperational: false,
        lastMaintenance: DateTime.now().subtract(Duration(days: i)),
      ));
    }
  }

  String _getRandomLocation() {
    final locations = [
      'Aluva',
      'Kalamassery',
      'Cochin University',
      'Pathadipalam',
      'Edapally',
      'Changampuzha Park',
      'Palarivattom',
      'JLN Stadium',
      'Kaloor',
      'Lissie',
      'MG Road',
      'Maharajas',
      'Ernakulam South',
      'Kadavanthra',
      'Elamkulam',
      'Vyttila',
      'Thaikoodam',
      'Petta',
      'Mattancherry',
    ];

    return locations[DateTime.now().millisecond % locations.length];
  }

  void refreshData() {
    isLoading.value = true;

    Future.delayed(const Duration(seconds: 2), () {
      isLoading.value = false;

      Get.snackbar(
        'Success',
        'Data refreshed successfully',
        snackPosition: SnackPosition.TOP,
      );
    });
  }
}
