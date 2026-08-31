import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/constants/api_constants.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/api_client.dart';
import 'package:muslim_community/core/services/auth_service.dart';

class PrivacyAndTermsController extends GetxController {
  final ApiClient apiClient;

  PrivacyAndTermsController({required this.apiClient});

  var isLoading = false.obs;
  var privacyPolicyContent = "".obs;
  var termsContent = "".obs;
  var legalPages = <Map<String, dynamic>>[].obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    // Default fallback text
    privacyPolicyContent.value =
        "Your privacy is critically important to us. At SYA, we are dedicated to protecting your personal information and maintaining strict privacy in adherence to Islamic ethical standards.\n\n"
        "1. Information We Collect:\n"
        "We collect profile details (name, email, age, location), communication data, and verification records to ensure community safety.\n\n"
        "2. Gender Separation:\n"
        "Male and female sections are strictly segregated. Your private information is never accessible to the opposite gender.\n\n"
        "3. Data Security:\n"
        "We employ modern encryption and best security practices to safeguard all user data against unauthorized access.\n\n"
        "4. Your Rights:\n"
        "You may view, edit, or request permanent deletion of your profile data at any time through the app settings.";

    termsContent.value =
        "Welcome to SYA. By using our platform, you agree to comply with and be bound by the following terms and conditions:\n\n"
        "1. Community Guidelines:\n"
        "All members must interact respectfully, constructively, and uphold Islamic values. Harassment, hate speech, or abuse will lead to immediate account termination.\n\n"
        "2. Verified Membership:\n"
        "Identity verification is required to maintain a safe and trusted environment for all reverts.\n\n"
        "3. Privacy & Segregation:\n"
        "Members must respect gender boundaries established within the application.\n\n"
        "4. Modifications:\n"
        "We reserve the right to update these terms at any time. Continued use of the platform constitutes acceptance of updated terms.";

    fetchAllLegalPages();
  }

  Future<void> fetchAllLegalPages() async {
    isLoading.value = true;
    try {
      final response = await apiClient.getData(
        ApiConstants.legal,
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          final pages = data['data'];
          if (pages is List) {
            legalPages.assignAll(
              List<Map<String, dynamic>>.from(pages.whereType<Map>()),
            );

            for (var page in pages) {
              String slug = page['slug']?.toString() ?? "";
              String pageTitle =
                  (page['title']?.toString() ?? "").toLowerCase();

              if (pageTitle.contains('privacy') || slug.contains('privacy')) {
                fetchLegalContent(slug, isPrivacy: true);
              } else if (pageTitle.contains('terms') ||
                  slug.contains('terms') ||
                  pageTitle.contains('condition')) {
                fetchLegalContent(slug, isTerms: true);
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching legal pages: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchLegalContent(
    String slug, {
    bool isPrivacy = false,
    bool isTerms = false,
  }) async {
    try {
      final response = await apiClient.getData(
        "${ApiConstants.legal}/$slug",
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data != null && data['data'] != null) {
          var pageData = data['data'];
          if (pageData is List && pageData.isNotEmpty) {
            pageData = pageData[0];
          }

          if (pageData is Map) {
            final content = pageData['description'] ??
                pageData['content'] ??
                pageData['text'] ??
                "";

            final stripped = _stripHtmlIfNeeded(content.toString());
            if (stripped.isNotEmpty) {
              if (isPrivacy) {
                privacyPolicyContent.value = stripped;
              } else if (isTerms) {
                termsContent.value = stripped;
              }
            }
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching legal content for $slug: $e");
    }
  }

  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim();
  }
}
