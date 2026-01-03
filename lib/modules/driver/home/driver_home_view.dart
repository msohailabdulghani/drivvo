import 'package:circular_menu/circular_menu.dart';
import 'package:drivvo/model/timeline_entry.dart';
import 'package:drivvo/modules/driver/home/driver_home_controller.dart';
import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DriverHomeView extends GetView<DriverHomeController> {
  const DriverHomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: CircularMenu(
        key: controller.circularMenuKey,
        alignment: Alignment.bottomRight,
        curve: Curves.bounceOut,
        reverseCurve: Curves.bounceIn,
        animationDuration: Duration.zero,
        toggleButtonColor: Utils.appColor,
        toggleButtonIconColor: Colors.white,
        toggleButtonSize: 30.0,
        toggleButtonPadding: 10.0,
        toggleButtonMargin: 0.0,
        radius: 130,
        toggleButtonBoxShadow: [],
        items: [
          CircularMenuItem(
            iconSize: 20,
            icon: Icons.local_gas_station_outlined,
            color: const Color(0xFFFB9601),
            boxShadow: [],
            onTap: () {
              controller.circularMenuKey.currentState?.reverseAnimation();
              controller.checkVehicleAndNavigate(
                routeName: AppRoutes.CREATE_REFUELING_VIEW,
              );
            },
          ),
          CircularMenuItem(
            iconSize: 20,
            icon: Icons.receipt_long_outlined,
            color: Colors.red,
            boxShadow: [],
            onTap: () {
              controller.circularMenuKey.currentState?.reverseAnimation();
              controller.checkVehicleAndNavigate(
                routeName: AppRoutes.CREATE_EXPENSE_VIEW,
              );
            },
          ),
          CircularMenuItem(
            iconSize: 20,
            icon: Icons.build_outlined,
            color: Colors.brown,
            boxShadow: [],
            onTap: () {
              controller.circularMenuKey.currentState?.reverseAnimation();
              controller.checkVehicleAndNavigate(
                routeName: AppRoutes.CRAETE_SERVICE_VIEW,
              );
            },
          ),
          CircularMenuItem(
            iconSize: 20,
            icon: Icons.attach_money,
            color: Colors.green,
            boxShadow: [],
            onTap: () {
              controller.circularMenuKey.currentState?.reverseAnimation();
              controller.checkVehicleAndNavigate(
                routeName: AppRoutes.CRAETE_INCOME_VIEW,
              );
            },
          ),
          CircularMenuItem(
            iconSize: 20,
            icon: Icons.route,
            color: const Color(0xFF5E7E8D),
            boxShadow: [],
            onTap: () {
              controller.circularMenuKey.currentState?.reverseAnimation();
              controller.checkVehicleAndNavigate(
                routeName: AppRoutes.CRAETE_ROUTE_VIEW,
              );
            },
          ),
        ],
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
              child: Obx(
                () => Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    controller.allEntries.isEmpty
                        ? _buildReadyToStartSection() // Ready to Start Section
                        : _buildTimelineContent(),

                    // Welcome items at the end
                    _buildTimelineWelcomeItem(
                      hasEntriesAbove: controller.allEntries.isNotEmpty,
                    ),
                    _buildTimelineLogoItem(),

                    const SizedBox(height: 100),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSliverHeader(BuildContext context) {
    const double expandedHeight = 160.0;
    const double collapsedHeight = 60.0;

    return SliverAppBar(
      expandedHeight: expandedHeight,
      collapsedHeight: collapsedHeight,
      pinned: true,
      automaticallyImplyLeading: false,
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
        Obx(
          () => Stack(
            children: [
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
              // Show badge when filters are applied
              if (controller.hasActiveFilter)
                Positioned(
                  right: 0,
                  top: 0,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                      border: Border.all(color: Utils.appColor, width: 1.5),
                    ),
                    constraints: const BoxConstraints(
                      minWidth: 18,
                      minHeight: 18,
                    ),
                    child: Text(
                      '${controller.disabledFilterCount}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ),
            ],
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
              padding: const EdgeInsets.fromLTRB(20, 70, 20, 0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Text(
                  //   'ready_to_start_add_first_entry'.tr,
                  //   style: Utils.getTextStyle(
                  //     baseSize: 13,
                  //     isBold: false,
                  //     color: Colors.white70,
                  //     isUrdu: controller.isUrdu,
                  //   ),
                  // ),
                  // const Spacer(),
                  _buildVehicleSelector(),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  //! Current Vehicle
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
            child: GestureDetector(
              onTap: () {
                Get.toNamed(
                  AppRoutes.VEHICLES_VIEW,
                  arguments: {"is_from_home": true, "is_from_user": false},
                );
              },
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
                      Obx(
                        () => Text(
                          controller.appService.currentVehicleId.value.isEmpty
                              ? 'select_your_vehicle'.tr
                              : controller.appService.currentVehicle.value,
                          style: Utils.getTextStyle(
                            baseSize: 16,
                            isBold: true,
                            color: Colors.black87,
                            isUrdu: controller.isUrdu,
                          ),
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
          ),
          Column(
            children: [
              Text(
                "last_odometer".tr,
                style: Utils.getTextStyle(
                  baseSize: 12,
                  isBold: false,
                  color: Colors.grey,
                  isUrdu: controller.isUrdu,
                ),
              ),
              Obx(
                () => Text(
                  "${controller.appService.appUser.value.lastOdometer} km",
                  style: Utils.getTextStyle(
                    baseSize: 12,
                    isBold: true,
                    color: Utils.appColor,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  //! Read to start
  Widget _buildReadyToStartSection() {
    return Container(
      margin: EdgeInsets.only(top: 20),
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
              Obx(
                () => _buildActionButton(
                  // icon: Icons.local_gas_station_outlined,
                  image: "assets/images/more/fuel.png",
                  label: 'fuel'.tr,
                  isSelected: controller.initialSelection.value == "Fuel"
                      ? true
                      : false,
                ),
              ),
              const SizedBox(width: 12),
              Obx(
                () => _buildActionButton(
                  // icon: Icons.build_outlined,
                  image: "assets/images/more/services.png",
                  label: 'service'.tr,
                  isSelected: controller.initialSelection.value == "Service"
                      ? true
                      : false,
                ),
              ),
              const SizedBox(width: 12),
              Obx(
                () => _buildActionButton(
                  // icon: Icons.receipt_long_outlined,
                  image: "assets/images/more/expenses.png",
                  label: 'expense'.tr,
                  isSelected: controller.initialSelection.value == "Expense"
                      ? true
                      : false,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildActionButton({
    required String image,
    required String label,
    required bool isSelected,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: () {
          if (controller.appService.currentVehicleId.value.isEmpty) {
            Utils.showSnackBar(
              message: "vehicle_must_be_selected_first".tr,
              success: false,
            );
            return;
          }

          controller.initialSelection.value = label;
          if (label == "Fuel") {
            Get.toNamed(AppRoutes.CREATE_REFUELING_VIEW);
          } else if (label == "Service") {
            Get.toNamed(AppRoutes.CRAETE_SERVICE_VIEW);
          } else if (label == "Expense") {
            Get.toNamed(AppRoutes.CREATE_EXPENSE_VIEW);
          }
        },
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
              Image.asset(image, height: 36),
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
      ),
    );
  }

  Widget _buildTimelineContent() {
    if (controller.isLoading.value) {
      return const Center(
        child: CircularProgressIndicator(color: Utils.appColor),
      );
    }

    return RefreshIndicator(
      onRefresh: controller.refreshData,
      color: Utils.appColor,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Build timeline entries grouped by month
          if (controller.allEntries.isNotEmpty)
            ...controller.groupedEntries.entries.map((monthGroup) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildMonthHeader(monthGroup.key),
                  ...monthGroup.value.asMap().entries.map((entry) {
                    final index = entry.key;
                    final timelineEntry = entry.value;
                    final isLastInGroup = index == monthGroup.value.length - 1;
                    final isLastMonth =
                        monthGroup.key == controller.groupedEntries.keys.last;
                    final isLastOverall = isLastMonth && isLastInGroup;

                    // Create a unique key for this entry
                    final entryKey = '${monthGroup.key}_$index';

                    return Column(
                      children: [
                        _buildTimelineItem(
                          entry: timelineEntry,
                          isLast: isLastOverall,
                          entryKey: entryKey,
                        ),
                        _buildTimelineConnector(),
                      ],
                    );
                  }),
                ],
              );
            }),

          // // Welcome items at the end
          // _buildTimelineWelcomeItem(
          //   hasEntriesAbove: controller.allEntries.isNotEmpty,
          // ),
          // _buildTimelineLogoItem(),

          // const SizedBox(height: 100),
        ],
      ),
    );
  }

  Widget _buildMonthHeader(String month) {
    return Container(
      padding: const EdgeInsets.only(left: 56, top: 20, bottom: 8),
      child: Text(
        month,
        style: Utils.getTextStyle(
          baseSize: 12,
          isBold: true,
          color: Colors.grey[500]!,
          isUrdu: controller.isUrdu,
        ),
      ),
    );
  }

  Widget _buildTimelineItem({
    required TimelineEntry entry,
    required bool isLast,
    required String entryKey,
  }) {
    return Obx(() {
      final isExpanded = controller.isEntryExpanded(entryKey);

      return Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Timeline Line and Dot - using Stack to handle variable height
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Line above dot
                Container(width: 3, height: 20, color: const Color(0xFF424242)),
                // Dot
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: entry.iconBgColor,
                    borderRadius: BorderRadius.circular(120),
                  ),
                  child: Icon(entry.icon, color: Colors.white, size: 22),
                ),
              ],
            ),
          ),
          // Content Card
          Expanded(
            child: GestureDetector(
              onTap: () => controller.toggleEntryExpansion(entryKey),
              child: Container(
                padding: const EdgeInsets.all(10),
                margin: const EdgeInsets.only(right: 10, left: 10, bottom: 0),
                decoration: BoxDecoration(
                  color: Colors.white,
                  border: Border.all(
                    color: isExpanded
                        ? entry.iconBgColor
                        : Colors.grey.shade400,
                    width: isExpanded ? 1.5 : 1,
                  ),
                  borderRadius: const BorderRadius.all(Radius.circular(16)),
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Main content row (always visible)
                    Row(
                      children: [
                        // Title and Odometer
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                entry.title,
                                style: Utils.getTextStyle(
                                  baseSize: 15,
                                  isBold: true,
                                  color: Colors.black87,
                                  isUrdu: controller.isUrdu,
                                ),
                              ),
                              const SizedBox(height: 2),
                              entry.origin != null
                                  ? Text(
                                      "From: ${entry.origin!}",
                                      style: Utils.getTextStyle(
                                        baseSize: 12,
                                        isBold: false,
                                        color: Colors.grey[500]!,
                                        isUrdu: controller.isUrdu,
                                      ),
                                    )
                                  : Row(
                                      children: [
                                        Icon(
                                          Icons.speed,
                                          color: Colors.grey[500],
                                          size: 14,
                                        ),
                                        const SizedBox(width: 4),
                                        Text(
                                          '${entry.odometer} km',
                                          style: Utils.getTextStyle(
                                            baseSize: 12,
                                            isBold: false,
                                            color: Colors.grey[500]!,
                                            isUrdu: controller.isUrdu,
                                          ),
                                        ),
                                      ],
                                    ),
                            ],
                          ),
                        ),
                        // Date and Amount
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              children: [
                                entry.origin != null
                                    ? Text(
                                        "${entry.routeStartFormattedDate} - ${entry.routeEndFormattedDate}",
                                        style: Utils.getTextStyle(
                                          baseSize: 12,
                                          isBold: false,
                                          color: Colors.grey[500]!,
                                          isUrdu: controller.isUrdu,
                                        ),
                                      )
                                    : Text(
                                        entry.formattedDate,
                                        style: Utils.getTextStyle(
                                          baseSize: 12,
                                          isBold: false,
                                          color: Colors.grey[500]!,
                                          isUrdu: controller.isUrdu,
                                        ),
                                      ),
                                const SizedBox(width: 6),
                                AnimatedRotation(
                                  turns: isExpanded ? 0.5 : 0,
                                  duration: const Duration(milliseconds: 300),
                                  child: Icon(
                                    Icons.keyboard_arrow_down,
                                    size: 22,
                                    color: isExpanded
                                        ? entry.iconBgColor
                                        : Colors.grey.shade400,
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 2),
                            entry.origin != null
                                ? SizedBox(height: 14)
                                : Text(
                                    "${controller.appService.selectedCurrencySymbol.value} ${entry.amount}",
                                    style: Utils.getTextStyle(
                                      baseSize: 14,
                                      isBold: true,
                                      color: entry.isIncome
                                          ? Utils.appColor
                                          : Colors.black87,
                                      isUrdu: controller.isUrdu,
                                    ),
                                  ),
                          ],
                        ),
                      ],
                    ),
                    // Expanded content section - only show when expanded
                    if (isExpanded) _buildExpandedContent(entry),
                  ],
                ),
              ),
            ),
          ),
        ],
      );
    });
  }

  /// Build the timeline connector line below the card
  Widget _buildTimelineConnector() {
    return Row(
      children: [
        SizedBox(
          width: 44,
          child: Center(
            child: Container(
              width: 3,
              height: 16,
              color: const Color(0xFF424242),
            ),
          ),
        ),
        const Expanded(child: SizedBox.shrink()),
      ],
    );
  }

  /// Build the expanded content section for a timeline entry
  Widget _buildExpandedContent(TimelineEntry entry) {
    return Container(
      margin: const EdgeInsets.only(top: 12),
      padding: const EdgeInsets.only(right: 12, left: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Entry type
          _buildExpandedRow(
            icon: entry.icon,
            iconColor: entry.iconBgColor,
            label: 'type'.tr.isNotEmpty ? 'type'.tr : 'Type',
            value: entry.type.name,
          ),
          const SizedBox(height: 8),
          // Full date
          // _buildExpandedRow(
          //   icon: Icons.calendar_today,
          //   iconColor: Colors.blue,
          //   label: 'date'.tr.isNotEmpty ? 'date'.tr : 'Date',
          //   value: Utils.formatDate(date: entry.date),
          // ),
          // const SizedBox(height: 8),
          // Odometer
          _buildExpandedRow(
            icon: Icons.speed,
            iconColor: Colors.orange,
            label: 'odometer'.tr.isNotEmpty ? 'odometer'.tr : 'Odometer',
            value: entry.origin != null
                ? '${entry.routeOdometer} km'
                : '${entry.odometer} km',
          ),
          const SizedBox(height: 8),
          // Amount
          _buildExpandedRow(
            icon: entry.isIncome ? Icons.arrow_downward : Icons.arrow_upward,
            iconColor: entry.isIncome ? Colors.green : Colors.red,
            label: entry.isIncome
                ? ('income'.tr.isNotEmpty ? 'income'.tr : 'Income')
                : ('amount'.tr.isNotEmpty ? 'amount'.tr : 'Amount'),
            value:
                "${controller.appService.selectedCurrencySymbol.value} ${entry.amount}",
            valueColor: entry.isIncome ? Colors.green : Colors.red,
          ),
          const SizedBox(height: 8),
          Divider(height: 1, color: Colors.grey.shade300),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Material(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: InkWell(
                  onTap: () => controller.deleteEntry(entry),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                    child: Icon(Icons.delete, color: Colors.red, size: 18),
                  ),
                ),
              ),
              Material(
                borderRadius: BorderRadius.all(Radius.circular(20)),
                child: InkWell(
                  onTap: () => controller.editEntry(entry),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8, top: 8),
                    child: Icon(
                      Icons.edit_note_outlined,
                      color: Utils.appColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  /// Build a row for the expanded content section
  Widget _buildExpandedRow({
    required IconData icon,
    required Color iconColor,
    required String label,
    required String value,
    Color? valueColor,
  }) {
    return Row(
      children: [
        Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            color: iconColor.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(6),
          ),
          child: Icon(icon, size: 16, color: iconColor),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Text(
            label,
            style: Utils.getTextStyle(
              baseSize: 13,
              isBold: false,
              color: Colors.grey[600]!,
              isUrdu: controller.isUrdu,
            ),
          ),
        ),
        Text(
          value,
          style: Utils.getTextStyle(
            baseSize: 13,
            isBold: false,
            color: valueColor ?? Colors.black,
            isUrdu: controller.isUrdu,
          ),
        ),
      ],
    );
  }

  Widget _buildTimelineWelcomeItem({required bool hasEntriesAbove}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line and Star
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Top line
                Container(width: 3, height: 20, color: const Color(0xFF424242)),
                // Star Icon
                Container(
                  width: 24,
                  height: 24,
                  decoration: const BoxDecoration(
                    color: Color(0xFFFFB74D),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(Icons.star, color: Colors.white, size: 14),
                ),
                // Bottom line
                Expanded(
                  child: Container(width: 3, color: const Color(0xFF424242)),
                ),
              ],
            ),
          ),
          // Content
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 12, bottom: 8),
              child: Row(
                children: [
                  // Check Icon
                  Container(
                    width: 28,
                    height: 28,
                    decoration: const BoxDecoration(
                      color: Utils.appColor,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 12),
                  // Text
                  Expanded(
                    child: Text(
                      'started_monitoring_your_vehicle'.tr.isNotEmpty
                          ? 'started_monitoring_your_vehicle'.tr
                          : 'Started monitoring your vehicle\nexpenses with Drivvo.',
                      style: Utils.getTextStyle(
                        baseSize: 13,
                        isBold: false,
                        color: Colors.grey[600]!,
                        isUrdu: controller.isUrdu,
                      ),
                    ),
                  ),
                  // Date
                  Text(
                    Utils.formatAccountDate(controller.accountCreatedDate),
                    textDirection: TextDirection.ltr,
                    style: Utils.getTextStyle(
                      baseSize: 12,
                      isBold: false,
                      color: Colors.grey[500]!,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineLogoItem() {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          // Timeline Line and End
          SizedBox(
            width: 44,
            child: Column(
              children: [
                // Top line
                Container(width: 3, height: 20, color: const Color(0xFF424242)),
                // End circle
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: Utils.appColor.withValues(alpha: 0.1),
                    shape: BoxShape.circle,
                    border: Border.all(color: Utils.appColor, width: 2),
                  ),
                  child: const Icon(
                    Icons.local_gas_station,
                    color: Utils.appColor,
                    size: 22,
                  ),
                ),
              ],
            ),
          ),
          // Content - Welcome to Drivvo
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(right: 16, top: 8, bottom: 16),
              child: Row(
                children: [
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'welcome_to'.tr.isNotEmpty
                            ? 'welcome_to'.tr
                            : 'Welcome to',
                        style: Utils.getTextStyle(
                          baseSize: 14,
                          isBold: false,
                          color: Colors.grey[600]!,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                      Text(
                        'Drivvo',
                        style: Utils.getTextStyle(
                          baseSize: 22,
                          isBold: true,
                          color: Colors.black87,
                          isUrdu: controller.isUrdu,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
