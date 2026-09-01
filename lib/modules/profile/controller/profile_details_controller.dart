import 'package:get/get.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/user_model.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';

class ProfileDetailsController extends GetxController {
  final UserRepository userRepository;

  ProfileDetailsController({required this.userRepository});

  final Rxn<UserModel> user = Rxn<UserModel>();
  final isLoading = false.obs;

  void setUser(UserModel initialUser) {
    user.value = initialUser;
    if (initialUser.id.isNotEmpty) {
      fetchPublicProfile(initialUser.id);
    }
  }

  Future<void> fetchPublicProfile(String userId) async {
    isLoading.value = true;
    try {
      final response = await userRepository.getPublicProfile(userId);
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data is Map) {
          final mapData = Map<String, dynamic>.from(data);
          final fetchedUser = UserModel.fromJson(mapData);

          if (user.value != null) {
            user.value = user.value!.copyWith(
              name: fetchedUser.name.isNotEmpty ? fetchedUser.name : user.value!.name,
              profileImage: fetchedUser.profileImage.isNotEmpty
                  ? fetchedUser.profileImage
                  : user.value!.profileImage,
              bio: fetchedUser.bio,
              revertStory: fetchedUser.revertStory,
              revertDate: fetchedUser.revertDate,
              interests: fetchedUser.interests,
              country: fetchedUser.country.isNotEmpty
                  ? fetchedUser.country
                  : user.value!.country,
              city: fetchedUser.city.isNotEmpty
                  ? fetchedUser.city
                  : user.value!.city,
              isVerified: fetchedUser.isVerified,
            );
          } else {
            user.value = fetchedUser;
          }
        }
      }
    } catch (e) {
      Helpers.error("Fetch public profile error: $e");
    } finally {
      isLoading.value = false;
    }
  }
}
