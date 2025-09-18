import 'package:get/get.dart';

class ScheduleController extends GetxController {
  final isLoading = false.obs;

  final schedules = <Map<String, dynamic>>[].obs;

  @override
  void onInit() {
    super.onInit();

    _loadSchedules();
  }

  void _loadSchedules() {
    // Generate dummy schedule data

    final currentTime = DateTime.now();

    for (int i = 0; i < 20; i++) {
      final departureTime = currentTime.add(Duration(minutes: i * 15));

      schedules.add({
        'id': 'schedule_$i',
        'trainNumber': 'KM${(i + 1).toString().padLeft(3, '0')}',
        'route': '${_getRandomStation()} → ${_getRandomStation()}',
        'departureTime': departureTime,
        'platform': 'Platform ${(i % 4) + 1}',
        'status': _getRandomStatus(),
      });
    }
  }

  String _getRandomStation() {
    final stations = ['Aluva', 'Kalamassery', 'Edapally', 'MG Road', 'Vyttila'];

    return stations[DateTime.now().millisecond % stations.length];
  }

  String _getRandomStatus() {
    final statuses = ['On Time', 'Delayed', 'Boarding', 'Departed'];

    return statuses[DateTime.now().millisecond % statuses.length];
  }
}
