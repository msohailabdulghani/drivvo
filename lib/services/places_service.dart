import 'dart:convert';
import 'dart:math' as math;

import 'package:drivvo/utils/constants.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:http/http.dart' as http;

/// Service to fetch nearby places using Google Places API
class PlacesService {
  static const String _baseUrl =
      'https://maps.googleapis.com/maps/api/place/nearbysearch/json';

  /// Fetches nearby gas stations from the Google Places API
  ///
  /// [location] - The center point to search around
  /// [radius] - Search radius in meters (default: 5000m = 5km)
  ///
  /// Returns a list of [NearbyPlace] objects

  static final types = ['gas_station', 'car_wash', 'car_repair', 'parking'];

  static Future<List<NearbyPlace>> getNearbyGasStations({
    required LatLng location,
    int radius = 5000,
  }) async {
    try {
      final url = Uri.parse(
        '$_baseUrl?location=${location.latitude},${location.longitude}'
        '&radius=$radius'
        '&type=gas_station'
        '&key=${Constants.GOOGLE_MAPS_API_KEY}',
      );

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['status'] == 'OK') {
          final results = data['results'] as List;
          return results.map((place) {
            return NearbyPlace.fromGooglePlacesApi(
              place,
              userLocation: location,
            );
          }).toList();
        } else if (data['status'] == 'ZERO_RESULTS') {
          return [];
        } else {
          debugPrint('Places API error: ${data['status']}');
          return [];
        }
      } else {
        debugPrint('HTTP error: ${response.statusCode}');
        return [];
      }
    } catch (e) {
      debugPrint('Error fetching nearby places: $e');
      return [];
    }
  }
}

/// Model class for nearby places
class NearbyPlace {
  final String id;
  final String name;
  final String address;
  final String iconPath;
  final PlaceType type;
  final double distance; // in kilometers
  final double latitude;
  final double longitude;
  final double? rating;
  final bool? isOpen;

  NearbyPlace({
    required this.id,
    required this.name,
    required this.address,
    required this.iconPath,
    required this.type,
    required this.distance,
    required this.latitude,
    required this.longitude,
    this.rating,
    this.isOpen,
  });

  /// Factory constructor to create NearbyPlace from Google Places API response
  factory NearbyPlace.fromGooglePlacesApi(
    Map<String, dynamic> json, {
    required LatLng userLocation,
  }) {
    final geometry = json['geometry'] as Map<String, dynamic>?;
    final location = geometry?['location'] as Map<String, dynamic>?;
    final lat = (location?['lat'] as num?)?.toDouble() ?? 0.0;
    final lng = (location?['lng'] as num?)?.toDouble() ?? 0.0;

    // Calculate distance from user location
    final distance = _calculateDistance(
      userLocation.latitude,
      userLocation.longitude,
      lat,
      lng,
    );

    // Determine place type from Google's types array
    final types = json['types'] as List<dynamic>?;
    PlaceType placeType = PlaceType.gasStation;
    if (types != null) {
      if (types.contains('gas_station')) {
        placeType = PlaceType.gasStation;
      } else if (types.contains('restaurant') || types.contains('food')) {
        placeType = PlaceType.restaurant;
      } else if (types.contains('parking')) {
        placeType = PlaceType.parking;
      } else if (types.contains('car_repair') || types.contains('car_wash')) {
        placeType = PlaceType.service;
      }
    }

    return NearbyPlace(
      id: json['place_id'] ?? '',
      name: json['name'] ?? 'Unknown Place',
      address: json['vicinity'] ?? '',
      iconPath: json['icon'] ?? '',
      type: placeType,
      distance: distance,
      latitude: lat,
      longitude: lng,
      rating: json['rating']?.toDouble(),
      isOpen: json['opening_hours']?['open_now'],
    );
  }

  /// Calculate distance between two coordinates using Haversine formula
  static double _calculateDistance(
    double lat1,
    double lon1,
    double lat2,
    double lon2,
  ) {
    const double earthRadius = 6371; // Earth's radius in kilometers

    final dLat = _toRadians(lat2 - lat1);
    final dLon = _toRadians(lon2 - lon1);

    final a =
        math.sin(dLat / 2) * math.sin(dLat / 2) +
        math.cos(_toRadians(lat1)) *
            math.cos(_toRadians(lat2)) *
            math.sin(dLon / 2) *
            math.sin(dLon / 2);

    final c = 2 * math.atan2(math.sqrt(a), math.sqrt(1 - a));

    return earthRadius * c;
  }

  static double _toRadians(double degrees) => degrees * math.pi / 180;
}

/// Enum for place types
enum PlaceType { gasStation, restaurant, parking, service, other }
