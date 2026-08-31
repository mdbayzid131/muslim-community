import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/repositories/user_repository.dart';
import 'package:muslim_community/modules/home/controller/home_controller.dart';

class PersonalInfoController extends GetxController {
  final UserRepository userRepository;

  PersonalInfoController({required this.userRepository});

  final ImagePicker _picker = ImagePicker();

  var isEditingPersonalDetails = false.obs;
  var isEditingAboutMe = false.obs;
  var isEditingStory = false.obs;
  var isEditingInterests = false.obs;

  var isLoading = false.obs;
  var isFetchingProfile = false.obs;
  final selectedProfileImage = Rxn<File>();
  final profileImageUrl = "".obs;
  final joinedAgo = "Joined some time ago".obs;

  bool get isAnyEditing =>
      isEditingPersonalDetails.value ||
      isEditingAboutMe.value ||
      isEditingStory.value ||
      isEditingInterests.value;

  late TextEditingController nameCtrl;
  late TextEditingController ageCtrl;
  late TextEditingController locationCtrl;
  late TextEditingController durationCtrl;
  late TextEditingController emailCtrl;
  late TextEditingController aboutCtrl;
  late TextEditingController storyCtrl;

  var interestsList = <String>[].obs;

  // Stored location data
  String? _currentCity;
  String? _currentCountry;
  String? _currentLat;
  String? _currentLng;
  String? _revertDate;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    nameCtrl = TextEditingController(text: "");
    ageCtrl = TextEditingController(text: "");
    locationCtrl = TextEditingController(text: "");
    durationCtrl = TextEditingController(text: "");
    emailCtrl = TextEditingController(text: "");
    aboutCtrl = TextEditingController(text: "");
    storyCtrl = TextEditingController(text: "");

    loadProfileData();
  }

  Future<void> loadProfileData() async {
    isFetchingProfile.value = true;
    try {
      final response = await userRepository.getProfile();
      if (response.statusCode == 200) {
        final data = response.data['data'] ?? response.data;
        if (data != null && data is Map) {
          nameCtrl.text = data['name'] ?? "";
          aboutCtrl.text = data['aboutMe'] ?? "";
          storyCtrl.text = data['revertStory'] ?? "";
          emailCtrl.text = data['email'] ?? "";
          ageCtrl.text = (data['age'] ?? "").toString();

          final rawImg = data['profileImage'];
          if (rawImg != null && rawImg.toString().isNotEmpty) {
            profileImageUrl.value = ApiConstants.getImageUrl(rawImg.toString());
          }

          final createdAt = data['createdAt'];
          if (createdAt != null) {
            try {
              final date = DateTime.parse(createdAt.toString());
              final difference = DateTime.now().difference(date);
              final days = difference.inDays;

              if (days >= 365) {
                final years = (days / 365).floor();
                joinedAgo.value = "Joined $years years ago";
              } else if (days >= 30) {
                final months = (days / 30).floor();
                joinedAgo.value = "Joined $months months ago";
              } else if (days > 0) {
                joinedAgo.value = "Joined $days days ago";
              } else {
                joinedAgo.value = "Joined today";
              }
            } catch (e) {
              joinedAgo.value = "Joined recently";
            }
          }

          _revertDate = data['revertDate']?.toString();
          if (_revertDate != null && _revertDate!.isNotEmpty) {
            try {
              final date = DateTime.parse(_revertDate!);
              final now = DateTime.now();
              int years = now.year - date.year;
              int months = now.month - date.month;
              int days = now.day - date.day;

              if (days < 0) {
                months -= 1;
                days += 30;
              }
              if (months < 0) {
                years -= 1;
                months += 12;
              }

              if (years > 0) {
                durationCtrl.text =
                    "$years years${months > 0 ? ' $months months' : ''}";
              } else if (months > 0) {
                durationCtrl.text = "$months months";
              } else if (days > 0) {
                durationCtrl.text = "$days days";
              } else {
                durationCtrl.text = "New Revert";
              }
            } catch (e) {
              durationCtrl.text = _revertDate!;
            }
          } else {
            durationCtrl.text = "New Revert";
          }

          final loc = data['location'];
          if (loc != null && loc is Map) {
            _currentCity = loc['city']?.toString() ?? "";
            _currentCountry = loc['country']?.toString() ?? "";

            if (loc['coordinates'] != null && loc['coordinates'] is List) {
              _currentLng = loc['coordinates'][0]?.toString();
              _currentLat = loc['coordinates'][1]?.toString();
            }

            if (_currentCity!.isNotEmpty && _currentCountry!.isNotEmpty) {
              locationCtrl.text = "$_currentCity, $_currentCountry";
            } else {
              locationCtrl.text = "$_currentCity$_currentCountry";
            }
          }

          if (data['interests'] != null && data['interests'] is List) {
            interestsList.assignAll(
              List<String>.from(data['interests'].map((e) => e.toString())),
            );
          }
        }
      }
    } catch (e) {
      Helpers.error("Error fetching profile: $e");
    } finally {
      isFetchingProfile.value = false;
    }
  }

  Future<void> pickProfileImage() async {
    final XFile? image = await _picker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 80,
    );
    if (image != null) {
      selectedProfileImage.value = File(image.path);
    }
  }

  Future<void> saveProfile() async {
    isLoading.value = true;
    try {
      final Map<String, dynamic> body = {
        'name': nameCtrl.text.trim(),
        'aboutMe': aboutCtrl.text.trim(),
        'revertStory': storyCtrl.text.trim(),
      };

      if (_revertDate != null && _revertDate!.isNotEmpty) {
        body['revertDate'] = _revertDate;
      }
      if (interestsList.isNotEmpty) {
        body['interests'] = interestsList.toList();
      }
      if (_currentCity != null) body['city'] = _currentCity;
      if (_currentCountry != null) body['country'] = _currentCountry;
      if (_currentLat != null) body['latitude'] = _currentLat;
      if (_currentLng != null) body['longitude'] = _currentLng;

      final response = await userRepository.updateProfile(
        body: body,
        profileImage: selectedProfileImage.value,
      );

      if (response.statusCode == 200) {
        Helpers.showSuccess("Profile updated successfully");
        isEditingPersonalDetails.value = false;
        isEditingAboutMe.value = false;
        isEditingStory.value = false;
        isEditingInterests.value = false;
        selectedProfileImage.value = null;

        if (Get.isRegistered<HomeController>()) {
          Get.find<HomeController>().fetchHomeData();
        }
        await loadProfileData();
      } else {
        final msg = response.data?['message'] ?? 'Failed to update profile';
        Helpers.showError(msg.toString());
      }
    } catch (e) {
      Helpers.error("Update Profile Error: $e");
      Helpers.showError("An error occurred while updating");
    } finally {
      isLoading.value = false;
    }
  }

  void addInterest(String text) {
    if (text.isNotEmpty &&
        interestsList.length < 10 &&
        !interestsList.contains(text)) {
      interestsList.add(text);
    }
  }

  void removeInterest(String text) {
    interestsList.remove(text);
  }

  @override
  void onClose() {
    nameCtrl.dispose();
    ageCtrl.dispose();
    locationCtrl.dispose();
    durationCtrl.dispose();
    emailCtrl.dispose();
    aboutCtrl.dispose();
    storyCtrl.dispose();
    super.onClose();
  }
}
