import 'dart:io';

import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_cropper/image_cropper.dart';

Future<XFile?> onImageCropBtnClick({ImageSource? source}) async {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  try {
    final pickedFile = await _picker.pickImage(
        source: source!, imageQuality: 50, maxHeight: 1000, maxWidth: 1000);
    return pickedFile;
  } catch (e) {
    print(e);
  }
}

Future<File?> cropImage({file}) async {
  ImageCropper imageFile = ImageCropper();
  File? croppedFile = await imageFile.cropImage(
      aspectRatio: CropAspectRatio(ratioX: 100, ratioY: 100),
      sourcePath: file,
      aspectRatioPresets: Platform.isAndroid
          ? [
              CropAspectRatioPreset.square,
            ]
          : [
              CropAspectRatioPreset.square,
            ],
      androidUiSettings: AndroidUiSettings(
          toolbarTitle: 'Cropper',
          toolbarColor: Colors.deepOrange,
          toolbarWidgetColor: Colors.white,
          initAspectRatio: CropAspectRatioPreset.square,
          lockAspectRatio: true),
      iosUiSettings: IOSUiSettings(
        title: 'Cropper',
      ));
  if (croppedFile != null) {
    return croppedFile;
  }
}
