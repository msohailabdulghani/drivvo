import 'package:drivvo/modules/home/home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: Obx(
        () => Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            if (controller.isFabExpanded.value) ...[
              _buildFabMenuItem(
                icon: Icons.local_gas_station_outlined,
                label: 'refueling'.tr,
                onTap: () {
                  Get.toNamed(AppRoutes.CREATE_REFUELING_VIEW);
                  controller.toggleFab();
                  // Handle Refueling action
                },
              ),
              const SizedBox(height: 12),
              _buildFabMenuItem(
                icon: Icons.receipt_long_outlined,
                label: 'expense'.tr,
                onTap: () {
                  controller.toggleFab();
                  // Handle Expense action
                },
              ),
              const SizedBox(height: 12),
              _buildFabMenuItem(
                icon: Icons.build_outlined,
                label: 'service'.tr,
                onTap: () {
                  controller.toggleFab();
                  // Handle Service action
                },
              ),
              const SizedBox(height: 12),
              _buildFabMenuItem(
                icon: Icons.attach_money,
                label: 'income'.tr,
                onTap: () {
                  controller.toggleFab();
                  // Handle Income action
                },
              ),
              const SizedBox(height: 12),
            ],
            FloatingActionButton(
              onPressed: controller.toggleFab,
              shape: const CircleBorder(),
              foregroundColor: Colors.white,
              backgroundColor: Utils.appColor,
              child: Icon(
                controller.isFabExpanded.value ? Icons.close : Icons.add,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFFF5F5F5),
      body: CustomScrollView(
        slivers: [
          // Sliver Header
          _buildSliverHeader(context),

          // Content Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 20),

                  // Ready to Start Section
                  _buildReadyToStartSection(),

                  const SizedBox(height: 24),

                  // Recent Activity Section
                  _buildRecentActivitySection(),

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    const double expandedHeight = 200.0;
    const double collapsedHeight = 60.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      pinned: true,
      floating: false,
      backgroundColor: Utils.appColor,
      surfaceTintColor: Colors.transparent,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(24),
          bottomRight: Radius.circular(24),
        ),
      ),
      title: Text(
        'history'.tr,
        style: Utils.getTextStyle(
          baseSize: 18,
          isBold: true,
          color: Colors.white,
          isUrdu: controller.isUrdu,
        ),
      ),
      actions: [
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () {},
            icon: Icon(
              Icons.cloud_download_outlined,
              color: Colors.white,
              size: 22,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.15),
            borderRadius: BorderRadius.circular(12),
          ),
          child: IconButton(
            onPressed: () => Get.toNamed(AppRoutes.HOME_FILTER_VIEW),
            icon: const Icon(Icons.tune, color: Colors.white, size: 22),
          ),
        ),
        const SizedBox(width: 12),
      ],
      flexibleSpace: FlexibleSpaceBar(
        background: Container(
          decoration: const BoxDecoration(
            color: Utils.appColor,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(24),
              bottomRight: Radius.circular(24),
            ),
          ),
          child: SafeArea(
            bottom: false,
            child: Padding(
              padding: const EdgeInsets.fromLTRB(20, 60, 20, 24),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ready_to_start_add_first_entry'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 13,
                      isBold: false,
                      color: Colors.white70,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  const Spacer(),
                  _buildVehicleSelector(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVehicleSelector() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.08),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          // Vehicle Icon
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Utils.appColor,
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(
              Icons.directions_car,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 14),

          // Vehicle Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'current_vehicle'.tr,
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Text(
                      'Tesla Model S',
                      style: Utils.getTextStyle(
                        baseSize: 16,
                        isBold: true,
                        color: Colors.black87,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.keyboard_arrow_down,
                      color: Colors.grey[600],
                      size: 20,
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Free Badge
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
            decoration: BoxDecoration(
              color: Utils.appColor.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'free'.tr,
              style: Utils.getTextStyle(
                baseSize: 13,
                isBold: true,
                color: Utils.appColor,
                isUrdu: controller.isUrdu,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildReadyToStartSection() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header Row
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: Utils.appColor,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(
                  Icons.rocket_launch_outlined,
                  color: Colors.white,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'ready_to_start'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 17,
                      isBold: true,
                      color: Colors.black87,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  Text(
                    'add_your_first_entry'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 13,
                      isBold: false,
                      color: Colors.grey[600]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 20),

          // Action Buttons Row
          Row(
            children: [
              _buildActionButton(
                icon: Icons.local_gas_station_outlined,
                label: 'fuel'.tr,
                isSelected: true,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.build_outlined,
                label: 'service'.tr,
                isSelected: false,
              ),
              const SizedBox(width: 12),
              _buildActionButton(
                icon: Icons.receipt_long_outlined,
                label: 'expense'.tr,
                isSelected: false,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 16),
        decoration: BoxDecoration(
          color: isSelected
              ? Utils.appColor.withValues(alpha: 0.08)
              : Colors.grey[50],
          border: Border.all(
            color: isSelected ? Utils.appColor : Colors.grey[300]!,
            width: isSelected ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              color: isSelected ? Utils.appColor : Colors.grey[600],
              size: 26,
            ),
            const SizedBox(height: 8),
            Text(
              label,
              style: Utils.getTextStyle(
                baseSize: 13,
                isBold: isSelected,
                color: isSelected ? Utils.appColor : Colors.grey[700]!,
                isUrdu: controller.isUrdu,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentActivitySection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'recent_activity'.tr,
          style: Utils.getTextStyle(
            baseSize: 18,
            isBold: true,
            color: Colors.black87,
            isUrdu: controller.isUrdu,
          ),
        ),
        const SizedBox(height: 14),

        // Activity Items
        _buildActivityItem(
          icon: Icons.trending_up,
          title: 'started_monitoring_expenses'.tr,
          subtitle: 'your_vehicle_expenses_tracking_journey_begins_here'.tr,
          date: '25 Nov',
          iconBgColor: Utils.appColor,
        ),
        const SizedBox(height: 12),
        _buildActivityItem(
          icon: Icons.check_circle_outline,
          title: 'welcome_to_drivvo'.tr,
          subtitle: 'setup_is_completed_successfully'.tr,
          date: '25 Nov',
          iconBgColor: Utils.appColor,
        ),
      ],
    );
  }

  Widget _buildActivityItem({
    required IconData icon,
    required String title,
    required String subtitle,
    required String date,
    required Color iconBgColor,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border(
          left: BorderSide(color: const Color(0xFF00796B), width: 4),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconBgColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: iconBgColor, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        title,
                        style: Utils.getTextStyle(
                          baseSize: 15,
                          isBold: true,
                          color: Colors.black87,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ),
                    Text(
                      date,
                      style: Utils.getTextStyle(
                        baseSize: 12,
                        isBold: false,
                        color: Colors.grey[500]!,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  subtitle,
                  style: Utils.getTextStyle(
                    baseSize: 13,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFabMenuItem({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(8),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.1),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Text(
            label,
            style: Utils.getTextStyle(
              baseSize: 14,
              isBold: true,
              color: Colors.black87,
              isUrdu: controller.isUrdu,
            ),
          ),
        ),
        const SizedBox(width: 12),
        FloatingActionButton.small(
          onPressed: onTap,
          shape: const CircleBorder(),
          foregroundColor: Colors.white,
          backgroundColor: Utils.appColor,
          heroTag: null,
          child: Icon(icon, color: Colors.white, size: 20),
        ),
      ],
    );
  }
}
