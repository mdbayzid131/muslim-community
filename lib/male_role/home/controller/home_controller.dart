import 'package:muslim_community/male_role/home/controller/qibla_controller.dart';
import 'package:muslim_community/male_role/home/controller/payertimecontroller.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';

class MaleHomeController extends GetxController {
  final MaleQiblaController qiblaController = Get.put(MaleQiblaController());
  final PrayerTimeController prayerTimeController = Get.put(PrayerTimeController());

  var isLoading = true.obs;
  var currentLocation = "Unknown".obs;

  @override
  void onInit() {
    super.onInit();
    fetchData();
  }

  Future<void> fetchData() async {
    try {
      isLoading(true);

      double lat = 51.5074; // Default London/UK latitude fallback
      double lng = -0.1278; // Default London/UK longitude fallback
      bool hasLocation = false;

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever &&
            await Geolocator.isLocationServiceEnabled()) {
          Position? position;
          try {
            position = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 5),
            );
          } catch (e) {
            position = await Geolocator.getLastKnownPosition();
          }

          if (position != null) {
            lat = position.latitude;
            lng = position.longitude;
            hasLocation = true;
          }
        }
      } catch (e) {
        print("Location retrieval warning: $e");
      }

      // Always fetch prayer times using resolved or default coordinates
      await prayerTimeController.fetchPrayerTimes(lat, lng);

      if (hasLocation) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isNotEmpty) {
            Placemark place = placemarks[0];
            String city = place.locality ?? place.subAdministrativeArea ?? place.name ?? "";
            String country = place.country ?? "";
            if (city.isNotEmpty && country.isNotEmpty) {
              currentLocation.value = "$city, $country";
            } else if (city.isNotEmpty) {
              currentLocation.value = city;
            } else if (country.isNotEmpty) {
              currentLocation.value = country;
            }
          }
        } catch (geocodingError) {
          currentLocation.value = "GPS Location";
        }
      } else {
        currentLocation.value = "Richmond, United Kingdom";
      }

      isLoading(false);
    } catch (e) {
      print("Error in fetchData: $e");
      isLoading(false);
    }
  }
}
