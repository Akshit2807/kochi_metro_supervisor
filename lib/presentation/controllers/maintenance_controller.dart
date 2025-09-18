import 'package:get/get.dart';

class MaintenanceController extends GetxController {
  final isLoading = false.obs;

  final maintenanceTasks = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    _loadMaintenanceTasks();
  }

  void _loadMaintenanceTasks() {
    // Generate dummy maintenance data

    final tasks = [
      'Brake System Check',
      'Engine Inspection',
      'Door Mechanism Service',
      'Air Conditioning Maintenance',
      'Safety System Verification',
      'Electrical System Check',
      'Wheel Inspection',
      'Communication System Test',
    ];

    for (int i = 0; i < tasks.length; i++) {
      maintenanceTasks.add({
        'id': 'task_$i',
        'trainNumber': 'KM${(26 + i).toString().padLeft(3, '0')}',
        'task': tasks[i],
        'priority': _getRandomPriority(),
        'assignedTo': 'Technician ${i + 1}',
        'estimatedTime': '${(i % 4) + 1} hours',
        'status': _getRandomTaskStatus(),
      });
    }
  }

  String _getRandomPriority() {
    final priorities = ['High', 'Medium', 'Low'];

    return priorities[DateTime.now().millisecond % priorities.length];
  }

  String _getRandomTaskStatus() {
    final statuses = ['Pending', 'In Progress', 'Completed', 'On Hold'];

    return statuses[DateTime.now().millisecond % statuses.length];
  }
}
