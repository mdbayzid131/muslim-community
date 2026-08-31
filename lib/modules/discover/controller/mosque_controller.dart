import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/mosque_model.dart';
import 'package:muslim_community/data/repositories/mosque_repository.dart';

class MosqueController extends GetxController {
  final MosqueRepository mosqueRepository;

  MosqueController({required this.mosqueRepository});

  final mosques = <MosqueModel>[].obs;
  final isLoading = false.obs;

  @override
  void onInit() {
    super.onInit();
    fetchNearbyMosques();
  }

  Future<void> fetchNearbyMosques({bool isSilent = false}) async {
    if (!isSilent) isLoading.value = true;
    try {
      double latitude = 51.5074; // London fallback
      double longitude = -0.1278;

      try {
        final position = await Geolocator.getLastKnownPosition() ??
            await Geolocator.getCurrentPosition(
              desiredAccuracy: LocationAccuracy.low,
              timeLimit: const Duration(seconds: 3),
            );

        latitude = position.latitude;
        longitude = position.longitude;
      } catch (e) {
        Helpers.error("Geolocator for mosques error: $e");
      }

      final response = await mosqueRepository.getNearbyMosques(
        latitude: latitude,
        longitude: longitude,
      );

      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        mosques.value = list.map((item) => MosqueModel.fromJson(item)).toList();
      }
    } catch (e) {
      Helpers.error("Error fetching mosques: $e");
    } finally {
      if (!isSilent) isLoading.value = false;
    }
  }

  Future<void> fetchMosques() => fetchNearbyMosques();
}
