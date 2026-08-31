import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/config/routes/app_routes.dart';
import 'package:muslim_community/config/themes/app_colors.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/core/utils/helpers.dart';
import 'package:muslim_community/data/models/ask_question_model.dart';
import 'package:muslim_community/data/repositories/ask_imam_repository.dart';

class AskImamController extends GetxController {
  final AskImamRepository askImamRepository;

  AskImamController({required this.askImamRepository});

  final subjectCtrl = TextEditingController();
  final questionCtrl = TextEditingController();
  final selectedCategory = "General".obs;

  final categories = [
    "General",
    "Salah & Purification",
    "Quran & Hadith",
    "Family & Marriage",
    "Finance & Halal",
    "New Revert Support",
  ];

  final myQuestions = <AskQuestionModel>[].obs;
  final isLoading = false.obs;
  final isSubmitting = false.obs;

  String get userRole => Get.find<AuthService>().userRole;
  Color get roleColor => AppColors.getRoleColor(userRole);

  @override
  void onInit() {
    super.onInit();
    fetchMyQuestions();
  }

  Future<void> fetchMyQuestions() async {
    isLoading.value = true;
    try {
      final response = await askImamRepository.getMyQuestions();
      if (response.statusCode == 200) {
        final List list = response.data['data'] ?? response.data ?? [];
        myQuestions.value =
            list.map((e) => AskQuestionModel.fromJson(e)).toList();
      }
    } catch (e) {
      Helpers.error("Fetch questions error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> submitQuestion() async {
    final title = subjectCtrl.text.trim();
    final question = questionCtrl.text.trim();

    if (title.isEmpty || question.isEmpty) {
      Helpers.showError("Please enter subject and your question");
      return;
    }

    isSubmitting.value = true;
    try {
      final response = await askImamRepository.submitQuestion(
        title: title,
        question: question,
        category: selectedCategory.value,
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        subjectCtrl.clear();
        questionCtrl.clear();
        fetchMyQuestions();
        Get.toNamed(AppRoutes.submissionSuccess);
      } else {
        Helpers.showError("Failed to submit question");
      }
    } catch (e) {
      Helpers.error("Submit question error: $e");
    } finally {
      isSubmitting.value = false;
    }
  }

  @override
  void onClose() {
    subjectCtrl.dispose();
    questionCtrl.dispose();
    super.onClose();
  }
}
