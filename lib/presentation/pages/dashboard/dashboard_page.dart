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
                  child: Container(
                    height: MediaQuery.of(context).size.height,
                    decoration: BoxDecoration(
                        gradient: LinearGradient(
                            begin: Alignment.topCenter,
                            end: Alignment.bottomCenter,
                            colors: [
                          Color(0xff2DBBAD).withValues(alpha: 0.1),
                          Color(0xff2DBBAD).withValues(alpha: 0.88),
                        ])),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Image.asset(
                            "assets/dashboard.png",
                            fit: BoxFit.cover,
                          ),
                        ),
                        CustomAppBar(
                          title: 'Overview',
                          actions: [
                            GestureDetector(
                                onTap: () {
                                  Get.toNamed(AppRoutes.notification);
                                },
                                child: const Icon(
                                  Icons.notifications_active_outlined,
                                  color: Colors.black,
                                  size: 32,
                                )),
                            const SizedBox(width: 16),
                          ],
                        ),

                        // Overview cards
                        Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: const OverviewCards(),
                        ),

                        const SizedBox(height: 24),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            _buildTile(
                                "Maintenance",
                                controller.maintenanceTrains.value.toString(),
                                "assets/icons/maintenance.png"),
                            _buildTile(
                                "Cleaning", "3", "assets/icons/cleaning.png"),
                            _buildTile(
                                "Operation", "1", "assets/icons/operation.png"),
                            _buildTile(
                                "Stand By", "4", "assets/icons/stand.png"),
                          ],
                        ),
                        const SizedBox(height: 24),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Image.asset(
                            "assets/ssl.png",
                            fit: BoxFit.fitWidth,
                          ),
                        )
                        //
                        // // Train status section
                        // const TrainStatusSection(),
                      ],
                    ),
                  ),
                ),
        ),
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }

  Widget _buildTile(String title, String count, String img) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 8,
            spreadRadius: 2,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(crossAxisAlignment: CrossAxisAlignment.center, children: [
        ImageIcon(
          AssetImage(img),
          size: 36,
        ),
        Text(
          title,
          style: TextStyle(
              fontWeight: FontWeight.w900, color: Colors.black, fontSize: 12),
        ),
        Text(
          "Ongoing: $count",
          style: TextStyle(
              fontWeight: FontWeight.w400, color: Colors.black, fontSize: 10),
        ),
      ]),
    );
  }
}
