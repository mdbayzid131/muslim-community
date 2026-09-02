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
  var isDetailLoading = false.obs;
  var privacyPolicyContent = "".obs;
  var termsContent = "".obs;
  var legalPages = <Map<String, dynamic>>[].obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
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
        dynamic pages;
        if (data is Map && data['data'] != null) {
          pages = data['data'];
        } else if (data is List) {
          pages = data;
        }

        if (pages is List) {
          legalPages.assignAll(
            List<Map<String, dynamic>>.from(pages.whereType<Map>()),
          );

          for (var page in pages) {
            String slug = page['slug']?.toString() ?? "";
            String pageTitle = (page['title']?.toString() ?? "").toLowerCase();

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
    isDetailLoading.value = true;
    try {
      final response = await apiClient.getData(
        "${ApiConstants.legal}/$slug",
        requiresAuth: true,
      );

      if (response.statusCode == 200) {
        final data = response.data;
        dynamic pageData;
        if (data is Map && data['data'] != null) {
          pageData = data['data'];
        } else {
          pageData = data;
        }

        if (pageData is List && pageData.isNotEmpty) {
          pageData = pageData[0];
        }

        if (pageData is Map) {
          final content = pageData['description'] ??
              pageData['content'] ??
              pageData['text'] ??
              pageData['body'] ??
              "";

          final stripped = _stripHtmlIfNeeded(content.toString());
          if (isPrivacy) {
            privacyPolicyContent.value = stripped;
          } else if (isTerms) {
            termsContent.value = stripped;
          } else {
            // Default store in privacyPolicyContent if generic
            privacyPolicyContent.value = stripped;
          }
        }
      }
    } catch (e) {
      debugPrint("Error fetching legal content for $slug: $e");
    } finally {
      isDetailLoading.value = false;
    }
  }

  String _stripHtmlIfNeeded(String text) {
    return text.replaceAll(RegExp(r'<[^>]*>|&nbsp;'), ' ').trim();
  }
}
