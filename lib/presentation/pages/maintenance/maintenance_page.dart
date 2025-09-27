import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../core/theme/app_theme.dart';
import '../../../data/models/maintenance_model.dart';
import '../../controllers/bottom_nav_controller.dart';
import '../../controllers/maintenance_controller.dart';
import '../../widgets/common/bottom_navigation_bar.dart';

class MaintenancePage extends StatefulWidget {
  const MaintenancePage({super.key});

  @override
  State<MaintenancePage> createState() => _MaintenancePageState();
}

class _MaintenancePageState extends State<MaintenancePage> {
  @override
  Widget build(BuildContext context) {
    // Update bottom nav index
    final navController = Get.find<BottomNavController>();
    navController.currentIndex.value = 2;
    return GetBuilder<MaintenanceController>(
      builder: (controller) {
        return Scaffold(
          backgroundColor: Colors.white,
          appBar: _buildAppBar(controller),
          body: RefreshIndicator(
            onRefresh: () async => controller.refreshData(),
            color: AppTheme.primaryColor,
            child: Obx(() {
              if (controller.isLoading) {
                return _buildLoadingView();
              }

              if (controller.errorMessage.isNotEmpty) {
                return _buildErrorView(controller);
              }

              if (controller.maintenanceData == null) {
                return _buildEmptyView(controller);
              }

              return Container(
                  color: AppTheme.primaryColor.withValues(alpha: 0.2),
                  child: _buildMainContent(controller));
            }),
          ),
          bottomNavigationBar: const CustomBottomNavigationBar(),
        );
      },
    );
  }

  PreferredSizeWidget _buildAppBar(MaintenanceController controller) {
    return AppBar(
      elevation: 0,
      backgroundColor: AppTheme.primaryColor.withValues(alpha: 0.2),
      foregroundColor: Colors.black,
      title: const Text(
        'Train Maintenance',
        style: TextStyle(
          fontWeight: FontWeight.w600,
          fontSize: 20,
        ),
      ),
      actions: [
        IconButton(
          icon: const Icon(Icons.filter_list),
          onPressed: () => _showFilterDialog(controller),
          tooltip: 'Filter Trains',
        ),
      ],
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(60),
        child: Container(
          padding: const EdgeInsets.all(12),
          child: _buildSearchBar(controller),
        ),
      ),
    );
  }

  Widget _buildSearchBar(MaintenanceController controller) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: TextField(
        onChanged: controller.setSearchQuery,
        decoration: InputDecoration(
          hintText: 'Search trains by ID, priority, or rank...',
          prefixIcon: const Icon(Icons.search, color: Color(0xFF6B7280)),
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 12,
          ),
          suffixIcon: Obx(() {
            return controller.searchQuery.isEmpty
                ? const SizedBox.shrink()
                : IconButton(
                    icon: const Icon(Icons.clear, color: Color(0xFF6B7280)),
                    onPressed: () => controller.setSearchQuery(''),
                  );
          }),
        ),
      ),
    );
  }

  Widget _buildLoadingView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          CircularProgressIndicator(
            valueColor: AlwaysStoppedAnimation<Color>(AppTheme.primaryColor),
          ),
          SizedBox(height: 16),
          Text(
            'Loading maintenance data...',
            style: TextStyle(
              color: Color(0xFF6B7280),
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorView(MaintenanceController controller) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Color(0xFFEF4444),
            ),
            const SizedBox(height: 16),
            const Text(
              'Failed to Load Data',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1F2937),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              controller.errorMessage,
              textAlign: TextAlign.center,
              style: const TextStyle(
                color: Color(0xFF6B7280),
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: controller.refreshData,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF1E40AF),
                foregroundColor: Colors.white,
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyView(MaintenanceController controller) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.train,
            size: 64,
            color: Color(0xFF9CA3AF),
          ),
          const SizedBox(height: 16),
          const Text(
            'No Data Available',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Color(0xFF4B5563),
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'No maintenance data found',
            style: TextStyle(
              color: Color(0xFF6B7280),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton.icon(
            onPressed: controller.refreshData,
            icon: const Icon(Icons.refresh),
            label: const Text('Reload'),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF1E40AF),
              foregroundColor: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainContent(MaintenanceController controller) {
    return Column(
      children: [
        _buildStatsCards(controller),
        _buildFilterChips(controller),
        Expanded(
          child: _buildTrainsList(controller),
        ),
      ],
    );
  }

  Widget _buildStatsCards(MaintenanceController controller) {
    return Container(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              'Total Trains',
              controller.totalTrains.toString(),
              Icons.train,
              const Color(0xFF3B82F6),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'High Priority',
              controller.highPriorityCount.toString(),
              Icons.priority_high,
              const Color(0xFFEF4444),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Medium Priority',
              controller.mediumPriorityCount.toString(),
              Icons.warning,
              const Color(0xFFF59E0B),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              'Low Priority',
              controller.lowPriorityCount.toString(),
              Icons.check_circle,
              const Color(0xFF10B981),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              color: Color(0xFF6B7280),
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildFilterChips(MaintenanceController controller) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          const Text(
            'Filter: ',
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: Color(0xFF374151),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Obx(() {
                return Row(
                  children: controller.priorityLevels.map((level) {
                    final isSelected =
                        controller.selectedPriorityLevel == level;
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(level),
                        selected: isSelected,
                        onSelected: (_) => controller.setPriorityFilter(level),
                        backgroundColor: Colors.white,
                        selectedColor: const Color(0xFF1E40AF).withOpacity(0.1),
                        checkmarkColor: const Color(0xFF1E40AF),
                        labelStyle: TextStyle(
                          color: isSelected
                              ? const Color(0xFF1E40AF)
                              : const Color(0xFF6B7280),
                          fontWeight:
                              isSelected ? FontWeight.w600 : FontWeight.normal,
                        ),
                      ),
                    );
                  }).toList(),
                );
              }),
            ),
          ),
          Obx(() {
            return controller.selectedPriorityLevel != 'All' ||
                    controller.searchQuery.isNotEmpty
                ? TextButton.icon(
                    onPressed: controller.clearFilters,
                    icon: const Icon(Icons.clear, size: 16),
                    label: const Text('Clear'),
                    style: TextButton.styleFrom(
                      foregroundColor: const Color(0xFF6B7280),
                    ),
                  )
                : const SizedBox.shrink();
          }),
        ],
      ),
    );
  }

  Widget _buildTrainsList(MaintenanceController controller) {
    return Obx(() {
      final trains = controller.filteredTrains;

      if (trains.isEmpty) {
        return _buildEmptyTrainsView();
      }

      return ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: trains.length,
        itemBuilder: (context, index) {
          final train = trains[index];
          return _buildTrainCard(train, controller);
        },
      );
    });
  }

  Widget _buildEmptyTrainsView() {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 48,
            color: Color(0xFF9CA3AF),
          ),
          SizedBox(height: 16),
          Text(
            'No trains found',
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
              color: Color(0xFF6B7280),
            ),
          ),
          SizedBox(height: 8),
          Text(
            'Try adjusting your filters or search terms',
            style: TextStyle(
              color: Color(0xFF9CA3AF),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrainCard(
      TrainPriority train, MaintenanceController controller) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: train.priorityColor.withOpacity(0.2),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () => controller.showTrainDetails(train),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(
                          color: train.priorityColor.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Icon(
                          Icons.train,
                          color: train.priorityColor,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Train ${train.trainId}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFF1F2937),
                            ),
                          ),
                          Text(
                            'Rank #${train.priorityRank}',
                            style: const TextStyle(
                              color: Color(0xFF6B7280),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: train.priorityColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: train.priorityColor.withOpacity(0.3),
                      ),
                    ),
                    child: Text(
                      train.priorityLevel,
                      style: TextStyle(
                        color: train.priorityColor,
                        fontWeight: FontWeight.w600,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Score Progress Bar
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Maintenance Score',
                        style: TextStyle(
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF374151),
                        ),
                      ),
                      Text(
                        '${controller.getFormattedScore(train.finalScore)}%',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: train.priorityColor,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: train.finalScore,
                    backgroundColor: train.priorityColor.withOpacity(0.1),
                    valueColor:
                        AlwaysStoppedAnimation<Color>(train.priorityColor),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // // Component Scores Row
              // Row(
              //   children: [
              //     Expanded(
              //       child: _buildComponentScore(
              //         'Branding',
              //         train.scoresBySheet.branding,
              //         controller,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: _buildComponentScore(
              //         'Job Card',
              //         train.scoresBySheet.jobCard,
              //         controller,
              //       ),
              //     ),
              //     const SizedBox(width: 12),
              //     Expanded(
              //       child: _buildComponentScore(
              //         'Cleaning',
              //         train.scoresBySheet.cleaning,
              //         controller,
              //       ),
              //     ),
              //   ],
              // ),
              //
              // const SizedBox(height: 12),

              // Action Row
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Tap for details',
                    style: TextStyle(
                      color: Colors.grey[600],
                      fontSize: 12,
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 14,
                    color: Colors.grey[400],
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildComponentScore(
    String label,
    double score,
    MaintenanceController controller,
  ) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            color: Color(0xFF6B7280),
          ),
        ),
        const SizedBox(height: 4),
        Text(
          '${controller.getFormattedScore(score)}%',
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1F2937),
          ),
        ),
      ],
    );
  }

  void _showFilterDialog(MaintenanceController controller) {
    Get.dialog(
      AlertDialog(
        title: const Text('Filter Trains'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Priority Level',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Obx(() {
              return Wrap(
                spacing: 8,
                children: controller.priorityLevels.map((level) {
                  final isSelected = controller.selectedPriorityLevel == level;
                  return FilterChip(
                    label: Text(level),
                    selected: isSelected,
                    onSelected: (_) => controller.setPriorityFilter(level),
                    backgroundColor: Colors.grey[100],
                    selectedColor: const Color(0xFF1E40AF).withOpacity(0.1),
                    checkmarkColor: const Color(0xFF1E40AF),
                  );
                }).toList(),
              );
            }),
            const SizedBox(height: 16),
            const Text(
              'Analysis Info',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 8),
            Text(
              'Last Updated: ${controller.getFormattedTimestamp()}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
            Text(
              'Total Trains: ${controller.totalTrains}',
              style: TextStyle(
                color: Colors.grey[600],
                fontSize: 14,
              ),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: controller.clearFilters,
            child: const Text('Clear Filters'),
          ),
          TextButton(
            onPressed: () => Get.back(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
