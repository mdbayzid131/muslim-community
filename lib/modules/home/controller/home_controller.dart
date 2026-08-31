import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/home/controller/prayer_time_controller.dart';
import 'package:muslim_community/modules/home/controller/qibla_controller.dart';

class HomeController extends GetxController {
  final UserRepository? userRepository;

  HomeController({this.userRepository});

  QiblaController get qiblaController => Get.isRegistered<QiblaController>()
      ? Get.find<QiblaController>()
      : Get.put(QiblaController());

  PrayerTimeController get prayerTimeController =>
      Get.isRegistered<PrayerTimeController>()
          ? Get.find<PrayerTimeController>()
          : Get.put(PrayerTimeController());

  final isLoading = true.obs;
  final currentLocation = "Richmond, United Kingdom".obs;
  final currentUser = Rxn<UserModel>();

  String get userName {
    final user = currentUser.value;
    if (user != null && user.name.isNotEmpty) return user.name;
    final auth = Get.find<AuthService>();
    if (auth.currentUser.value != null && auth.currentUser.value!.name.isNotEmpty) {
      return auth.currentUser.value!.name;
    }
    return "Brother";
  }

  String get userProfileImage {
    return currentUser.value?.profileImage ??
        Get.find<AuthService>().currentUser.value?.profileImage ??
        '';
  }

  String get userRole => Get.find<AuthService>().userRole;
  dynamic get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchHomeData();
  }

  Future<void> fetchHomeData() async {
    isLoading.value = true;
    try {
      // 1. Fetch user profile
      if (userRepository != null) {
        try {
          final res = await userRepository!.getProfile();
          if (res.statusCode == 200) {
            final data = res.data['data'] ?? res.data;
            currentUser.value = UserModel.fromJson(data);
          }
        } catch (_) {}
      }

      // 2. Fetch location & prayer times
      double lat = 51.5074;
      double lng = -0.1278;
      bool hasLocation = false;

      try {
        LocationPermission permission = await Geolocator.checkPermission();
        if (permission == LocationPermission.denied) {
          permission = await Geolocator.requestPermission();
        }

        if (permission != LocationPermission.denied &&
            permission != LocationPermission.deniedForever &&
            await Geolocator.isLocationServiceEnabled()) {
          Position? pos;
          try {
            pos = await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 5),
            );
          } catch (_) {
            pos = await Geolocator.getLastKnownPosition();
          }

          if (pos != null) {
            lat = pos.latitude;
            lng = pos.longitude;
            hasLocation = true;
          }
        }
      } catch (e) {
        Helpers.error("Location error: $e");
      }

      await prayerTimeController.fetchPrayerTimes(lat, lng);

      if (hasLocation) {
        try {
          List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
          if (placemarks.isNotEmpty) {
            final p = placemarks.first;
            final city = p.locality ?? p.subAdministrativeArea ?? "";
            final country = p.country ?? "";
            if (city.isNotEmpty && country.isNotEmpty) {
              currentLocation.value = "$city, $country";
            } else if (city.isNotEmpty) {
              currentLocation.value = city;
            } else if (country.isNotEmpty) {
              currentLocation.value = country;
            }
          }
        } catch (_) {
          currentLocation.value = "GPS Location";
        }
      }
    } catch (e) {
      Helpers.error("Fetch home data error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
