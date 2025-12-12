import 'dart:async';
import 'package:drivvo/services/app_service.dart';
import 'package:drivvo/utils/constants.dart';
import 'package:drivvo/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';

class MapController extends GetxController {
  late AppService appService;

  bool get isUrdu => Get.locale?.languageCode == Constants.URDU_LANGUAGE_CODE;

  // Google Map Controller
  Completer<GoogleMapController> mapControllerCompleter = Completer();
  GoogleMapController? googleMapController;

  // Location variables
  var currentPosition = const LatLng(30.1575, 71.5249).obs; // Default: Multan
  var selectedPosition = const LatLng(30.1575, 71.5249).obs;
  var currentAddress = "".obs;
  var isLoadingLocation = true.obs;
  var isLoadingAddress = false.obs;

  // Markers
  var markers = <Marker>{}.obs;

  // Nearby places (mock data for gas stations)
  var nearbyPlaces = <NearbyPlace>[].obs;

  @override
  void onInit() {
    appService = Get.find<AppService>();
    _getCurrentLocation();
    super.onInit();
  }

  @override
  void onClose() {
    googleMapController?.dispose();
    super.onClose();
  }

  /// Check location permissions and get current location
  Future<void> _getCurrentLocation() async {
    isLoadingLocation.value = true;

    try {
      // Check if location services are enabled
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Utils.showSnackBar(
          message: 'location_services_disabled'.tr,
          success: false,
        );
        isLoadingLocation.value = false;
        return;
      }

      // Check location permissions
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          Utils.showSnackBar(
            message: 'location_permission_denied'.tr,
            success: false,
          );
          isLoadingLocation.value = false;
          return;
        }
      }

      if (permission == LocationPermission.deniedForever) {
        Utils.showSnackBar(
          message: 'location_permission_permanently_denied'.tr,
          success: false,
        );
        isLoadingLocation.value = false;
        return;
      }

      // Get current position
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      selectedPosition.value = currentPosition.value;

      // Update marker
      _updateMarker(selectedPosition.value);

      // Move camera to current location
      _moveCamera(currentPosition.value);

      // Get address for current location
      await _getAddressFromLatLng(selectedPosition.value);

      // Load nearby places
      _loadNearbyPlaces();
    } catch (e) {
      debugPrint('Error getting location: $e');
      Utils.showSnackBar(
        message: 'error_getting_location'.tr,
        success: false,
      );
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Update marker on map
  void _updateMarker(LatLng position) {
    markers.value = {
      Marker(
        markerId: const MarkerId('selected_location'),
        position: position,
        icon: BitmapDescriptor.defaultMarkerWithHue(BitmapDescriptor.hueOrange),
        infoWindow: InfoWindow(
          title: 'selected_location'.tr,
        ),
      ),
    };
  }

  /// Move camera to position
  Future<void> _moveCamera(LatLng position) async {
    if (googleMapController != null) {
      await googleMapController!.animateCamera(
        CameraUpdate.newCameraPosition(
          CameraPosition(
            target: position,
            zoom: 16.0,
          ),
        ),
      );
    }
  }

  /// Get address from coordinates
  Future<void> _getAddressFromLatLng(LatLng position) async {
    isLoadingAddress.value = true;
    try {
      List<Placemark> placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );

      if (placemarks.isNotEmpty) {
        Placemark place = placemarks[0];
        currentAddress.value = _formatAddress(place);
      }
    } catch (e) {
      debugPrint('Error getting address: $e');
      currentAddress.value = '${position.latitude}, ${position.longitude}';
    } finally {
      isLoadingAddress.value = false;
    }
  }

  /// Format address from placemark
  String _formatAddress(Placemark place) {
    List<String> addressParts = [];

    if (place.street != null && place.street!.isNotEmpty) {
      addressParts.add(place.street!);
    }
    if (place.subLocality != null && place.subLocality!.isNotEmpty) {
      addressParts.add(place.subLocality!);
    }
    if (place.locality != null && place.locality!.isNotEmpty) {
      addressParts.add(place.locality!);
    }
    if (place.postalCode != null && place.postalCode!.isNotEmpty) {
      addressParts.add(place.postalCode!);
    }
    if (place.country != null && place.country!.isNotEmpty) {
      addressParts.add(place.country!);
    }

    return addressParts.join(', ');
  }

  /// Load nearby places (mock data for gas stations)
  void _loadNearbyPlaces() {
    // This is mock data - in production, you would integrate with Google Places API
    nearbyPlaces.value = [
      NearbyPlace(
        id: '1',
        name: 'Shell Shujabad Filling Station',
        address: 'Multan, Pakistan',
        iconPath: 'assets/images/placeholder.png',
        type: PlaceType.gasStation,
        distance: 0.5,
      ),
      NearbyPlace(
        id: '2',
        name: 'Crystal Filling Station',
        address: '10 B, Officers Colony, Bosan Road Chungi # 09\nMultan., Multan 60000, Pakistan',
        iconPath: 'assets/images/placeholder.png',
        type: PlaceType.gasStation,
        distance: 1.2,
      ),
      NearbyPlace(
        id: '3',
        name: 'PSO Filling Station',
        address: 'Khursheed Colony Rd, Multan, Pakistan',
        iconPath: 'assets/images/placeholder.png',
        type: PlaceType.gasStation,
        distance: 1.8,
      ),
    ];
  }

  /// Called when map is created
  void onMapCreated(GoogleMapController controller) {
    if (!mapControllerCompleter.isCompleted) {
      mapControllerCompleter.complete(controller);
    }
    googleMapController = controller;
  }

  /// Called when user taps on map
  Future<void> onMapTap(LatLng position) async {
    selectedPosition.value = position;
    _updateMarker(position);
    await _getAddressFromLatLng(position);
  }

  /// Called when camera stops moving
  Future<void> onCameraIdle() async {
    // Optional: Update address when camera stops
  }

  /// Move to current location
  Future<void> moveToCurrentLocation() async {
    isLoadingLocation.value = true;
    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
        ),
      );

      currentPosition.value = LatLng(position.latitude, position.longitude);
      selectedPosition.value = currentPosition.value;

      _updateMarker(selectedPosition.value);
      await _moveCamera(currentPosition.value);
      await _getAddressFromLatLng(selectedPosition.value);
    } catch (e) {
      debugPrint('Error moving to current location: $e');
    } finally {
      isLoadingLocation.value = false;
    }
  }

  /// Select the current location and return
  void selectLocation() {
    Get.back(result: {
      'latitude': selectedPosition.value.latitude,
      'longitude': selectedPosition.value.longitude,
      'address': currentAddress.value,
    });
  }

  /// Select a nearby place
  void selectNearbyPlace(NearbyPlace place) {
    Get.back(result: {
      'name': place.name,
      'address': place.address,
    });
  }
}

/// Model class for nearby places
class NearbyPlace {
  final String id;
  final String name;
  final String address;
  final String iconPath;
  final PlaceType type;
  final double distance;

  NearbyPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.iconPath,
    required this.type,
    required this.distance,
  });
}

/// Enum for place types
enum PlaceType {
  gasStation,
  restaurant,
  parking,
  service,
  other,
}
