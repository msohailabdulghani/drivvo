import 'package:drivvo/modules/common/map/map_controller.dart';
import 'package:drivvo/services/places_service.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapView extends GetView<MapController> {
  const MapView({super.key});

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          Get.back(result: "");
        }
      },
      child: Scaffold(
        body: SafeArea(
          child: Column(
            children: [
              // Google Map - Takes upper half of screen
              Expanded(
                flex: 5,
                child: Stack(
                  children: [
                    // Google Map
                    Obx(
                      () => GoogleMap(
                        initialCameraPosition: CameraPosition(
                          target: controller.currentPosition.value,
                          zoom: 15.0,
                        ),
                        onMapCreated: controller.onMapCreated,
                        onTap: controller.onMapTap,
                        // ignore: invalid_use_of_protected_member
                        markers: controller.markers.value,
                        myLocationEnabled: true,
                        myLocationButtonEnabled: false,
                        zoomControlsEnabled: false,
                        mapToolbarEnabled: false,
                        compassEnabled: true,
                      ),
                    ),

                    // Loading indicator
                    Obx(
                      () => controller.isLoadingLocation.value
                          ? Container(
                              color: Colors.black26,
                              child: const Center(
                                child: CircularProgressIndicator(
                                  color: Utils.appColor,
                                ),
                              ),
                            )
                          : const SizedBox.shrink(),
                    ),

                    // My Location Button (bottom right of map)
                    Positioned(
                      right: 16,
                      bottom: 16,
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(30),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withValues(alpha: 0.2),
                              blurRadius: 6,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(30),
                            onTap: controller.moveToCurrentLocation,
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Icon(
                                Icons.my_location,
                                color: Utils.appColor,
                                size: 24,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              // Bottom Section - Location selection and nearby places
              Expanded(
                flex: 4,
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.1),
                        blurRadius: 10,
                        offset: const Offset(0, -2),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      // Handle bar
                      Container(
                        margin: const EdgeInsets.only(top: 12),
                        width: 40,
                        height: 4,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: BorderRadius.circular(2),
                        ),
                      ),

                      // Select this location button
                      _buildSelectLocationTile(),

                      // Divider
                      Divider(color: Colors.grey[200], thickness: 1, height: 1),

                      // Nearby places list
                      Expanded(
                        child: Obx(() {
                          // Show loading indicator while fetching places
                          if (controller.isLoadingPlaces.value) {
                            return const Center(
                              child: CircularProgressIndicator(
                                color: Utils.appColor,
                              ),
                            );
                          }

                          // Show empty state if no places found
                          if (controller.nearbyPlaces.isEmpty) {
                            return Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(
                                    Icons.local_gas_station_outlined,
                                    size: 48,
                                    color: Colors.grey[400],
                                  ),
                                  const SizedBox(height: 12),
                                  Text(
                                    'no_gas_stations_found'.tr,
                                    style: Utils.getTextStyle(
                                      baseSize: 14,
                                      isBold: false,
                                      color: Colors.grey[600]!,
                                      isUrdu: controller.isUrdu,
                                    ),
                                  ),
                                ],
                              ),
                            );
                          }

                          // Show nearby places list
                          return ListView.separated(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            itemCount: controller.nearbyPlaces.length,
                            separatorBuilder: (context, index) => Divider(
                              color: Colors.grey[200],
                              thickness: 1,
                              height: 1,
                              indent: 72,
                            ),
                            itemBuilder: (context, index) {
                              final place = controller.nearbyPlaces[index];
                              return _buildNearbyPlaceTile(place);
                            },
                          );
                        }),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Select this location tile
  Widget _buildSelectLocationTile() {
    return InkWell(
      onTap: controller.selectLocation,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Row(
          children: [
            // Location icon
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: Utils.appColor.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: const Icon(
                Icons.location_on,
                color: Utils.appColor,
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Text
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'select_this_location'.tr,
                    style: Utils.getTextStyle(
                      baseSize: 16,
                      isBold: true,
                      color: Utils.appColor,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Obx(
                    () => Text(
                      controller.currentAddress.value.isNotEmpty
                          ? controller.currentAddress.value
                          : 'loading'.tr,
                      style: Utils.getTextStyle(
                        baseSize: 12,
                        isBold: false,
                        color: Colors.grey[600]!,
                        isUrdu: controller.isUrdu,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                ],
              ),
            ),

            // Loading or arrow icon
            Obx(
              () => controller.isLoadingAddress.value
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Utils.appColor,
                      ),
                    )
                  : Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.grey[400],
                      size: 16,
                    ),
            ),
          ],
        ),
      ),
    );
  }

  /// Nearby place tile
  Widget _buildNearbyPlaceTile(NearbyPlace place) {
    return InkWell(
      onTap: () => controller.selectNearbyPlace(place),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Icon based on place type
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: _getPlaceColor(place.type).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                _getPlaceIcon(place.type),
                color: _getPlaceColor(place.type),
                size: 24,
              ),
            ),

            const SizedBox(width: 16),

            // Place details
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    place.name,
                    style: Utils.getTextStyle(
                      baseSize: 14,
                      isBold: true,
                      color: Colors.black87,
                      isUrdu: controller.isUrdu,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    place.address,
                    style: Utils.getTextStyle(
                      baseSize: 12,
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

            // Distance
            if (place.distance > 0)
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  '${place.distance.toStringAsFixed(1)} km',
                  style: Utils.getTextStyle(
                    baseSize: 10,
                    isBold: false,
                    color: Colors.grey[600]!,
                    isUrdu: controller.isUrdu,
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  /// Get icon for place type
  IconData _getPlaceIcon(PlaceType type) {
    switch (type) {
      case PlaceType.gasStation:
        return Icons.local_gas_station;
      case PlaceType.restaurant:
        return Icons.restaurant;
      case PlaceType.parking:
        return Icons.local_parking;
      case PlaceType.service:
        return Icons.build;
      case PlaceType.other:
        return Icons.place;
    }
  }

  /// Get color for place type
  Color _getPlaceColor(PlaceType type) {
    switch (type) {
      case PlaceType.gasStation:
        return Colors.orange;
      case PlaceType.restaurant:
        return Colors.red;
      case PlaceType.parking:
        return Colors.blue;
      case PlaceType.service:
        return Colors.green;
      case PlaceType.other:
        return Utils.appColor;
    }
  }
}
