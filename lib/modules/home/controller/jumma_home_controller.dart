import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/khutbah_model.dart';
import 'package:muslim_community/data/repositories/learning_repository.dart';

class JummaHomeController extends GetxController {
  final LearningRepository learningRepository;

  JummaHomeController({required this.learningRepository});

  final isLoading = true.obs;
  final khutbahs = <KhutbahModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchKhutbahs();
  }

  Future<void> fetchKhutbahs() async {
    isLoading.value = true;
    try {
      final response = await learningRepository.getKhutbahs();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        khutbahs.value = list.map((e) => KhutbahModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch khutbahs error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
