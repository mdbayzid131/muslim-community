import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class MaleVerifyController extends GetxController {
  final ImagePicker _picker = ImagePicker();
  var verificationImage = Rxn<File>();
  var verificationVideo = Rxn<File>();
  var selectedMethod = RxnString();

  Future<void> takePhoto() async {
    final XFile? photo = await _picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      verificationImage.value = File(photo.path);
      Get.snackbar(
        'Success', 
        'your image upload for verification',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }

  Future<void> recordVideo() async {
    final XFile? video = await _picker.pickVideo(source: ImageSource.camera);
    if (video != null) {
      verificationVideo.value = File(video.path);
      Get.snackbar(
        'Success', 
        'your video is upload for verification',
        backgroundColor: Colors.green.withOpacity(0.8),
        colorText: Colors.white,
      );
    }
  }
}
