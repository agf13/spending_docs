import 'dart:io';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:spending_docs/features/scan/presentation/screens/scanCameraScreen.dart';

class ImagePickerUtil {
  final ImagePicker _picker = ImagePicker();

  Future<String?> startScanProcess(BuildContext context) async {
    if (await isMobile() == false) {
      return await _handleOtherPlatforms();
    }

    return await _handleMobilePlatforms(context);
  }

  Future<bool> isMobile() async {
    if (Platform.isAndroid || Platform.isIOS) {
      return true;
    }

    return false;
  }

  Future<String?> _handleOtherPlatforms() async {
    return await _openGaleryPicker();
  }

  Future<String?> _handleMobilePlatforms(BuildContext context) async {
    try {
      final cameras = await availableCameras();
      if (cameras.isEmpty) {
        return await _openGaleryPicker();
      }

      if (!context.mounted) {
        return null;
      }

      // Open the camera screen
      final String? imagePath = await Navigator.push<String>(
        context,
        MaterialPageRoute(
          builder: (newPageContext) => ScanCameraScreen(cameras: cameras),
        ),
      );

      return imagePath;
    } catch (e) {
      print(
        'Error at ScanService::_handleMobilePlatform when trying to initialize camera',
      );
      return null;
    }
  }

  Future<String?> _openGaleryPicker() async {
    try {
      final XFile? file = await _picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 100,
      );

      return file?.path;
    } catch (e) {
      print('Error on ScanService::_openGaleryPicker');
      return null;
    }
  }
}
