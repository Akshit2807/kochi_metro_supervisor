import 'package:flutter/material.dart';

import 'package:get/get.dart';

import '../../controllers/dashboard_controller.dart';

import '../../../core/theme/app_theme.dart';

class OverviewCards extends GetView<DashboardController> {
  const OverviewCards({super.key});

  @override
  Widget build(BuildContext context) {
    return Obx(
      () => Column(
        children: [
          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Available Trains',

                  value: controller.availableTrains.length.toString(),

                  subtitle: 'Fitness Valid',

                  icon: Icons.train,

                  color: AppTheme.successColor,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _OverviewCard(
                  title: 'Trains for Maintenance',

                  value: controller.maintenanceTrains.length.toString(),

                  subtitle: 'Pending Cleaning\nMaintenance',

                  icon: Icons.build,

                  color: AppTheme.warningColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Available Trains',

                  value: controller.availableTrains.length.toString(),

                  subtitle: 'Fitness Valid',

                  icon: Icons.check_circle,

                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _OverviewCard(
                  title: 'Trains for Maintenance',

                  value: controller.maintenanceTrains.length.toString(),

                  subtitle: 'Pending Cleaning\nMaintenance',

                  icon: Icons.schedule,

                  color: AppTheme.secondaryColor,
                ),
              ),
            ],
          ),

          const SizedBox(height: 16),

          Row(
            children: [
              Expanded(
                child: _OverviewCard(
                  title: 'Available Trains',

                  value: controller.availableTrains.length.toString(),

                  subtitle: 'Fitness Valid',

                  icon: Icons.speed,

                  color: AppTheme.primaryColor,
                ),
              ),

              const SizedBox(width: 16),

              Expanded(
                child: _OverviewCard(
                  title: 'Trains for Maintenance',

                  value: controller.maintenanceTrains.length.toString(),

                  subtitle: 'Pending Cleaning\nMaintenance',

                  icon: Icons.engineering,

                  color: AppTheme.errorColor,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewCard extends StatelessWidget {
  final String title;

  final String value;

  final String subtitle;

  final IconData icon;

  final Color color;

  const _OverviewCard({
    required this.title,

    required this.value,

    required this.subtitle,

    required this.icon,

    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
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
                  title,

                  style: const TextStyle(
                    fontSize: 12,

                    color: AppTheme.textSecondary,

                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),

              Icon(icon, color: color, size: 20),
            ],
          ),

          const SizedBox(height: 12),

          Text(
            value,

            style: const TextStyle(
              fontSize: 32,

              fontWeight: FontWeight.bold,

              color: AppTheme.textPrimary,
            ),
          ),

          const SizedBox(height: 4),

          Text(
            subtitle,

            style: const TextStyle(
              fontSize: 11,

              color: AppTheme.textSecondary,

              height: 1.2,
            ),
          ),
        ],
      ),
    );
  }
}
