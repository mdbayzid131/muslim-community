import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/mosque_model.dart';
import 'package:muslim_community/data/repositories/mosque_repository.dart';

class MosqueController extends GetxController {
  final MosqueRepository mosqueRepository;

  MosqueController({required this.mosqueRepository});

  final mosques = <MosqueModel>[].obs;
  final merchants = <MosqueModel>[].obs;
  final isLoading = false.obs;
  final searchQuery = ''.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyMosques();
  }

  Future<void> fetchNearbyMosques({
    bool isSilent = false,
    String? search,
    double radius = 5000,
  }) async {
    if (!isSilent) isLoading.value = true;
    try {
      double latitude = 23.78088; // Default fallback lat
      double longitude = 90.40759; // Default fallback lng

      try {
        final position = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 4),
            );

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        Helpers.error("Geolocator position error: $e");
      }

      final activeSearch = search ?? (searchQuery.value.isNotEmpty ? searchQuery.value : null);

      final list = await mosqueRepository.getNearbyMosques(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: activeSearch,
      );

      mosques.value = list;
    } catch (e) {
      Helpers.error("Error fetching mosques: $e");
      mosques.value = [];
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  Future<void> fetchNearbyMerchants({
    bool isSilent = false,
    String? search,
    double radius = 5000,
  }) async {
    if (!isSilent) isLoading.value = true;
    try {
      double latitude = 23.78088;
      double longitude = 90.40759;

      try {
        final position = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 4),
            );

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        Helpers.error("Geolocator error for merchants: $e");
      }

      final list = await mosqueRepository.getNearbyMerchants(
        latitude: latitude,
        longitude: longitude,
        radius: radius,
        search: search,
      );

      merchants.value = list;
    } catch (e) {
      Helpers.error("Error fetching merchants: $e");
      merchants.value = [];
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  void searchMosques(String query) {
    searchQuery.value = query;
    fetchNearbyMosques(search: query);
  }

  Future<void> fetchMosques() => fetchNearbyMosques();
}
