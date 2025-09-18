import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/maintenance_controller.dart';

import '../../controllers/bottom_nav_controller.dart';

import '../../widgets/common/custom_app_bar.dart';

import '../../widgets/common/bottom_navigation_bar.dart';

import '../../../core/theme/app_theme.dart';

class MaintenancePage extends GetView<MaintenanceController> {
  const MaintenancePage({super.key});

  @override
  Widget build(BuildContext context) {
    // Update bottom nav index

    final navController = Get.find<BottomNavController>();

    navController.currentIndex.value = 2;

    return Scaffold(
      appBar: const CustomAppBar(title: 'Maintenance Tasks'),

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

                  itemCount: controller.maintenanceTasks.length,

                  itemBuilder: (context, index) {
                    final task = controller.maintenanceTasks[index];

                    return _MaintenanceCard(task: task);
                  },
                ),
              ),
      ),

      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class _MaintenanceCard extends StatelessWidget {
  final Map<String, dynamic> task;

  const _MaintenanceCard({required this.task});

  @override
  Widget build(BuildContext context) {
    final priority = task['priority'] as String;

    final status = task['status'] as String;

    Color priorityColor;

    switch (priority) {
      case 'High':
        priorityColor = AppTheme.errorColor;

        break;

      case 'Medium':
        priorityColor = AppTheme.warningColor;

        break;

      case 'Low':
        priorityColor = AppTheme.successColor;

        break;

      default:
        priorityColor = AppTheme.primaryColor;
    }

    Color statusColor;

    switch (status) {
      case 'Pending':
        statusColor = AppTheme.warningColor;

        break;

      case 'In Progress':
        statusColor = AppTheme.primaryColor;

        break;

      case 'Completed':
        statusColor = AppTheme.successColor;

        break;

      case 'On Hold':
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
              Expanded(
                child: Text(
                  task['task'],

                  style: const TextStyle(
                    fontSize: 16,

                    fontWeight: FontWeight.bold,

                    color: AppTheme.textPrimary,
                  ),
                ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: priorityColor,

                  borderRadius: BorderRadius.circular(12),
                ),

                child: Text(
                  priority,

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
              const Icon(Icons.train, color: AppTheme.textSecondary, size: 16),

              const SizedBox(width: 8),

              Text(
                'Train ${task['trainNumber']}',

                style: const TextStyle(
                  fontSize: 14,

                  color: AppTheme.textSecondary,
                ),
              ),

              const Spacer(),

              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),

                decoration: BoxDecoration(
                  color: statusColor.withOpacity(0.1),

                  borderRadius: BorderRadius.circular(8),
                ),

                child: Text(
                  status,

                  style: TextStyle(
                    fontSize: 12,

                    color: statusColor,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 8),

          Row(
            children: [
              const Icon(Icons.person, color: AppTheme.textSecondary, size: 16),

              const SizedBox(width: 8),

              Text(
                task['assignedTo'],

                style: const TextStyle(
                  fontSize: 14,

                  color: AppTheme.textSecondary,
                ),
              ),

              const SizedBox(width: 16),

              const Icon(Icons.timer, color: AppTheme.textSecondary, size: 16),

              const SizedBox(width: 8),

              Text(
                task['estimatedTime'],

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
