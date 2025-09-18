import 'package:flutter/material.dart';

import 'package:get/get.dart';

import 'package:intl/intl.dart';

import '../../controllers/schedule_controller.dart';

import '../../controllers/bottom_nav_controller.dart';

import '../../widgets/common/custom_app_bar.dart';

import '../../widgets/common/bottom_navigation_bar.dart';

import '../../../core/theme/app_theme.dart';

class SchedulePage extends GetView<ScheduleController> {
  const SchedulePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Update bottom nav index

    final navController = Get.find<BottomNavController>();

    navController.currentIndex.value = 1;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Train Schedules'),
      body: Obx(
        () => controller.isLoading.value
            ? const Center(
                child: CircularProgressIndicator(color: AppTheme.primaryColor),
              )
            : RefreshIndicator(
                onRefresh: () async {
                  controller.onInit();
                },
                color: AppTheme.primaryColor,
                child: ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: controller.schedules.length,
                  itemBuilder: (context, index) {
                    final schedule = controller.schedules[index];

                    return _ScheduleCard(schedule: schedule);
                  },
                ),
              ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class _ScheduleCard extends StatelessWidget {
  final Map<String, dynamic> schedule;

  const _ScheduleCard({required this.schedule});

  @override
  Widget build(BuildContext context) {
    final departureTime = schedule['departureTime'] as DateTime;

    final status = schedule['status'] as String;

    Color statusColor;

    switch (status) {
      case 'On Time':
        statusColor = AppTheme.successColor;

        break;

      case 'Delayed':
        statusColor = AppTheme.errorColor;

        break;

      case 'Boarding':
        statusColor = AppTheme.warningColor;

        break;

      case 'Departed':
        statusColor = AppTheme.textSecondary;

        break;

      default:
        statusColor = AppTheme.primaryColor;
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Train ${schedule['trainNumber']}',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: AppTheme.textPrimary,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: statusColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  status,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Colors.white,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              const Icon(Icons.route, color: AppTheme.textSecondary, size: 16),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  schedule['route'],
                  style: const TextStyle(
                    fontSize: 14,
                    color: AppTheme.textSecondary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Row(
            children: [
              const Icon(
                Icons.access_time,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                'Departure: ${DateFormat('HH:mm').format(departureTime)}',
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
              const SizedBox(width: 16),
              Icon(
                Icons.stay_primary_landscape_rounded,
                color: AppTheme.textSecondary,
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                schedule['platform'],
                style: const TextStyle(
                  fontSize: 14,
                  color: AppTheme.textSecondary,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
