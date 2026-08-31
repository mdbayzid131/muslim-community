import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/constants/storage_constants.dart';
import 'package:muslim_community/core/services/storage_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';

class LocationService extends GetxService {
  Future<Position?> getCurrentLocationInstance() => getCurrentLocation();

  Future<Map<String, String>> getAddressFromLatLng(
    double latitude,
    double longitude,
  ) =>
      getAddressFromCoordinates(latitude, longitude);

  static Future<Position?> getCurrentLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        Helpers.warning("Location permission denied.");
        return null;
      }

      final bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        Helpers.warning("Location services are disabled.");
        return null;
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.medium,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (_) {
        position = await Geolocator.getLastKnownPosition();
      }

      if (position != null) {
        await StorageService.setDouble(
          StorageConstants.latitude,
          position.latitude,
        );
        await StorageService.setDouble(
          StorageConstants.longitude,
          position.longitude,
        );
      }

      return position;
    } catch (e) {
      Helpers.error("Error getting current location: $e");
      return null;
    }
  }

  static Future<Map<String, String>> getAddressFromCoordinates(
    double latitude,
    double longitude,
  ) async {
    String country = "Unknown";
    String city = "Unknown";

    try {
      final List<Placemark> placemarks = await placemarkFromCoordinates(
        latitude,
        longitude,
      ).timeout(const Duration(seconds: 5));

      if (placemarks.isNotEmpty) {
        final Placemark place = placemarks[0];
        country = place.country ?? "Unknown";
        city = place.locality ??
            place.subAdministrativeArea ??
            place.name ??
            "Unknown";
      }
    } catch (e) {
      Helpers.error("Reverse geocoding error: $e");
    }

    return {'country': country, 'city': city};
  }
}
