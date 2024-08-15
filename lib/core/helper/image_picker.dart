// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_cropper/image_cropper.dart';
// import 'package:image_picker/image_picker.dart';
//
// Future<File?> pickSingleImage(ImageSource source) async {
//   try {
//     final picker = ImagePicker();
//
//     final XFile? image = await picker.pickImage(source: source);
//     if (image != null) {
//       // debugPrint("selected image path = ${image.path}");
//       final file = File(image.path);
//       final croppedFile = await cropCustomImage(file);
//       if (croppedFile != null) {
//         final resultFile = File(croppedFile.path);
//         return resultFile;
//       }
//       return file;
//     }
//   } catch (e) {
//     debugPrint(e.toString());
//   }
//   return null;
// }
//
// Future<CroppedFile?> cropCustomImage(File imageFile) async {
//   final croppedImage = await ImageCropper().cropImage(
//     compressFormat: ImageCompressFormat.jpg,
//     aspectRatio: const CropAspectRatio(ratioX: 8, ratioY: 8),
//     sourcePath: imageFile.path,
//     aspectRatioPresets: [
//       CropAspectRatioPreset.square,
//     ],
//     uiSettings: [
//       AndroidUiSettings(),
//       IOSUiSettings(),
//     ],
//     compressQuality: 50,
//   );
//   // debugPrint()
//   return croppedImage;
// }
