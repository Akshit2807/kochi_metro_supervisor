import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kochi_metro_supervisor/presentation/pages/schedule/train_detail_page.dart';
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
      body: Column(
        children: [
          // Compact Filter Section
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            color: Colors.grey.shade50,
            child: Column(
              children: [
                // First row - Station and Train ID
                Row(
                  children: [
                    Expanded(
                      child: Obx(() => CompactFilterDropdown(
                            hint: 'Station',
                            value: controller.staion.value.isEmpty
                                ? null
                                : controller.staion.value,
                            isEnabled: controller.trainid.value.isEmpty,
                            onChanged: (value) {
                              controller.selectStation(value);
                            },
                            items: controller.getStationOptions(),
                          )),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Obx(() => CompactFilterDropdown(
                            hint: 'Train ID',
                            value: controller.trainid.value.isEmpty
                                ? null
                                : controller.trainid.value,
                            isEnabled: controller.staion.value.isEmpty,
                            onChanged: (value) {
                              controller.selectTrainId(value);
                            },
                            items: controller.getTrainIdOptions(),
                          )),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                // Second row - Time filter (full width)
                Obx(() => CompactFilterDropdown(
                      hint: 'Time *',
                      value: controller.getSelectedTimeLabel(),
                      isEnabled: true,
                      isRequired: true,
                      onChanged: (value) {
                        if (value != null) {
                          controller.setTimeFilter(value);
                        }
                      },
                      items: controller.getTimeOptions(),
                    )),
              ],
            ),
          ),
          // List Section
          Expanded(
            child: Obx(
              () => controller.isLoading.value
                  ? const Center(
                      child: CircularProgressIndicator(
                          color: AppTheme.primaryColor),
                    )
                  : RefreshIndicator(
                      onRefresh: () => controller.refreshData(),
                      color: AppTheme.primaryColor,
                      child: ListView.builder(
                        padding: const EdgeInsets.all(12),
                        itemCount: controller.schedules.length,
                        itemBuilder: (context, index) {
                          final schedule = controller.schedules[index];
                          return GestureDetector(
                            onTap: () {
                              int last = schedule.tripDetails.stops.length;
                              Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => TrainDetailsScreen(
                                      trainId: schedule.trainId.substring(6),
                                      route:
                                          "${schedule.tripDetails.stops.elementAt(0).stopId} → ${schedule.currentTrip.endStation}",
                                      departureTime:
                                          "${schedule.currentTrip.startStation} : ${schedule.tripDetails.stops.elementAt(0).departureTime}",
                                      arrivalTime:
                                          "${schedule.currentTrip.endStation} : ${schedule.tripDetails.stops.elementAt(last - 1).departureTime}",
                                      stop: schedule.tripDetails.stops
                                          .elementAt(0)
                                          .stopName,
                                      isMaintenanceCompleted: true,
                                      isClearanceApproved: true,
                                      nextMaintenanceDate: '2025-09-30',
                                      isFitnessCertificateValid: true,
                                      stops: schedule.tripDetails.stops,
                                    ),
                                  ));
                            },
                            child: CompactTrainCard(
                              trainName:
                                  "Train ${schedule.trainId.substring(6)}",
                              time:
                                  '${schedule.currentTrip.startTime} - ${schedule.currentTrip.endTime}',
                            ),
                          );
                        },
                      ),
                    ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavigationBar(),
    );
  }
}

class CompactFilterDropdown extends StatelessWidget {
  final String hint;
  final String? value;
  final Function(String?) onChanged;
  final List<String> items;
  final bool isEnabled;
  final bool isRequired;

  const CompactFilterDropdown({
    super.key,
    required this.hint,
    required this.value,
    required this.onChanged,
    required this.items,
    this.isEnabled = true,
    this.isRequired = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40, // Fixed height for consistency
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 2),
      decoration: BoxDecoration(
        color: isEnabled ? Colors.white : Colors.grey.shade100,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isEnabled
              ? (isRequired ? const Color(0xFFFF6B6B) : const Color(0xFF4ECDC4))
              : Colors.grey.shade300,
          width: 1.5,
        ),
        boxShadow: isEnabled
            ? [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 4,
                  offset: const Offset(0, 1),
                ),
              ]
            : [],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          hint: Text(
            hint,
            style: TextStyle(
              color: isEnabled ? Colors.grey.shade700 : Colors.grey.shade400,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          value: value,
          onChanged: isEnabled ? onChanged : null,
          isExpanded: true,
          icon: Icon(
            Icons.keyboard_arrow_down,
            color: isEnabled
                ? (isRequired
                    ? const Color(0xFFFF6B6B)
                    : const Color(0xFF4ECDC4))
                : Colors.grey.shade400,
            size: 18,
          ),
          style: TextStyle(
            color: isEnabled ? Colors.grey.shade800 : Colors.grey.shade400,
            fontSize: 12,
            fontWeight: FontWeight.w500,
          ),
          dropdownColor: Colors.white,
          items: items.map((String item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Row(
                children: [
                  if (item == 'Clear Selection')
                    const Icon(
                      Icons.clear,
                      size: 14,
                      color: Colors.red,
                    ),
                  if (item == 'Clear Selection') const SizedBox(width: 6),
                  Expanded(
                    child: Text(
                      item,
                      style: TextStyle(
                        color: item == 'Clear Selection'
                            ? Colors.red
                            : Colors.grey.shade800,
                        fontSize: 12,
                        fontWeight: item == 'Clear Selection'
                            ? FontWeight.w600
                            : FontWeight.w500,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ),
      ),
    );
  }
}

class CompactTrainCard extends StatelessWidget {
  final String trainName;
  final String time;

  const CompactTrainCard({
    super.key,
    required this.trainName,
    required this.time,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8.0),
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16.0),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          // Train Icon
          const ImageIcon(
            AssetImage("assets/icons/train.png"),
            size: 28,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          // Train Details
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  trainName,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  time,
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
