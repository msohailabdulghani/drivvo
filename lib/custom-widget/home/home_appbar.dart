import 'package:drivvo/routes/app_routes.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class HomeAppbar extends StatelessWidget {
  final bool isUrdu;
  final bool hasActiveFilter;
  final int disabledFilterCount;
  final String currentVehicleId;
  final String currentVehicle;
  final int lastOdometer;

  const HomeAppbar({
    super.key,
    required this.isUrdu,
    required this.hasActiveFilter,
    required this.disabledFilterCount,
    required this.currentVehicleId,
    required this.currentVehicle,
    required this.lastOdometer,
  });

  @override
  Widget build(BuildContext context) {
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
          isUrdu: isUrdu,
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
        Stack(
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
            if (hasActiveFilter)
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
                    disabledFilterCount.toString(),
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
                  //!Current Vehicle Card
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
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
                                arguments: {
                                  "is_from_home": true,
                                  "is_from_user": false,
                                },
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
                                    isUrdu: isUrdu,
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Row(
                                  children: [
                                    Text(
                                      currentVehicleId.isEmpty
                                          ? 'select_your_vehicle'.tr
                                          : currentVehicle,
                                      style: Utils.getTextStyle(
                                        baseSize: 16,
                                        isBold: true,
                                        color: Colors.black87,
                                        isUrdu: isUrdu,
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
                                isUrdu: isUrdu,
                              ),
                            ),
                            Text(
                              "$lastOdometer km",
                              style: Utils.getTextStyle(
                                baseSize: 12,
                                isBold: true,
                                color: Utils.appColor,
                                isUrdu: isUrdu,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
