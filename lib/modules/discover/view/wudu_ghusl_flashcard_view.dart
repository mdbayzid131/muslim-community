import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/modules/discover/view/female_wudu_ghusl_flashcard_view.dart';
import 'package:muslim_community/modules/discover/view/male_wudu_ghusl_flashcard_view.dart';

class WuduGhuslFlashcardView extends StatelessWidget {
  final String title;

  const WuduGhuslFlashcardView({super.key, required this.title});

  @override
  Widget build(BuildContext context) {
    final role = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>().userRole
        : 'male';
    if (role == 'female') {
      return FemaleWuduGhuslFlashcardView(title: title);
    }
    return MaleWuduGhuslFlashcardView(title: title);
  }
}
