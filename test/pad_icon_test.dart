import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:image/image.dart' as img;

void main() {
  test('pad icon', () {
    final inputPath = 'assets/image/app_logo.png';
    final outputPath = 'assets/image/app_logo_adaptive_foreground.png';
    
    final imageBytes = File(inputPath).readAsBytesSync();
    final original = img.decodeImage(imageBytes);
    
    if (original == null) {
      print('Failed to decode image');
      return;
    }
    
    int maxDim = original.width > original.height ? original.width : original.height;
    int targetDim = (maxDim / 0.55).round(); // Zoom out by making canvas larger (original is 55%)
    
    final padded = img.Image(width: targetDim, height: targetDim, numChannels: 4);
    
    int dstX = (targetDim - original.width) ~/ 2;
    int dstY = (targetDim - original.height) ~/ 2;
    
    img.compositeImage(padded, original, dstX: dstX, dstY: dstY);
    
    File(outputPath).writeAsBytesSync(img.encodePng(padded));
    print('Successfully created padded image: ' + outputPath);
  });
}
