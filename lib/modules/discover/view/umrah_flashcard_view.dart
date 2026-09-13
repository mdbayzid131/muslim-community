import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:muslim_community/core/services/auth_service.dart';
import 'package:muslim_community/modules/discover/view/female_umrah_flashcard_view.dart';
import 'package:muslim_community/modules/discover/view/male_umrah_flashcard_view.dart';

class UmrahFlashcardView extends StatelessWidget {
  final String title;
  final bool? isMale;

  const UmrahFlashcardView({super.key, required this.title, this.isMale});

  @override
  Widget build(BuildContext context) {
    final String currentRole = Get.isRegistered<AuthService>()
        ? Get.find<AuthService>().userRole.toLowerCase()
        : 'male';

    final bool isBrother;
    if (isMale != null) {
      isBrother = isMale!;
    } else {
      isBrother = (currentRole != 'female' && currentRole != 'sister');
    }

    if (isBrother) {
      return MaleUmrahFlashcardView(title: title);
    } else {
      return FemaleUmrahFlashcardView(title: title);
    }
  }
}
