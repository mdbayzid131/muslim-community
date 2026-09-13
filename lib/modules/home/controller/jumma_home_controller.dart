import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/khutbah_model.dart';
import 'package:muslim_community/data/repositories/khutba_repository.dart';

class JummaHomeController extends GetxController {
  final KhutbaRepository khutbaRepository;

  JummaHomeController({required this.khutbaRepository});

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
      final response = await khutbaRepository.getKhutbahs(page: 1, limit: 20);
      if (response.statusCode == 200 || response.statusCode == 201) {
        final dynamic resData = response.data;
        dynamic listData = resData;

        if (resData is Map) {
          if (resData['data'] is List) {
            listData = resData['data'];
          } else if (resData['data'] is Map && resData['data']['data'] is List) {
            listData = resData['data']['data'];
          } else if (resData['data'] is Map && resData['data']['result'] is List) {
            listData = resData['data']['result'];
          } else if (resData['data'] is Map && resData['data']['khutbas'] is List) {
            listData = resData['data']['khutbas'];
          } else if (resData['data'] is Map && resData['data']['khutbahs'] is List) {
            listData = resData['data']['khutbahs'];
          } else if (resData['result'] is List) {
            listData = resData['result'];
          }
        }

        if (listData is List) {
          khutbahs.value = listData
              .map((e) => KhutbahModel.fromJson(Map<String, dynamic>.from(e)))
              .toList();
        }
      }
    } catch (e) {
      Helpers.error("Fetch khutbahs error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
