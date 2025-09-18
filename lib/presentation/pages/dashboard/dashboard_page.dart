import 'package:flutter/material.dart';

import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/core/routes/app_routes.dart';

import '../../controllers/dashboard_controller.dart';

import '../../controllers/bottom_nav_controller.dart';

import '../../widgets/dashboard/overview_cards.dart';

import '../../widgets/dashboard/train_status_section.dart';

import '../../widgets/common/custom_app_bar.dart';

import '../../widgets/common/bottom_navigation_bar.dart';

import '../../../core/theme/app_theme.dart';

class DashboardPage extends GetView<DashboardController> {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Overview',
        actions: [
          GestureDetector(
              onTap: () {
                Get.toNamed(AppRoutes.notification);
              },
              child: const Icon(Icons.notifications,
                  color: AppTheme.textSecondary)),
          const SizedBox(width: 16),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async => controller.refreshData(),
        color: AppTheme.primaryColor,
        child: Obx(
          () => controller.isLoading.value
              ? const Center(
                  child: CircularProgressIndicator(
                    color: AppTheme.primaryColor,
                  ),
                )
              : SingleChildScrollView(
                  physics: const AlwaysScrollableScrollPhysics(),
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Welcome section
                      Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [
                              AppTheme.primaryColor,
                              AppTheme.secondaryColor,
                            ],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => Text(
                                'Welcome back, ${controller.currentUser.value?.name ?? "Supervisor"}!',
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Here\'s your system overview for today',
                              style: TextStyle(
                                fontSize: 14,
                                color: Colors.white.withOpacity(0.9),
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 24),

                      // Overview cards
                      const OverviewCards(),

                      const SizedBox(height: 24),
                      //
                      // // Train status section
                      // const TrainStatusSection(),
                    ],
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}
