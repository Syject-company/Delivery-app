import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/widgets.dart';
import 'package:twsl_flutter/src/model/base_constants.dart';

class CameraModel extends ChangeNotifier {
  Directory? _applicationDirectory;
  File? photo;

  CameraModel(this._applicationDirectory);

  Future<String?> savePhoto(CameraController controller) async {
    if (!controller.value.isInitialized) return null;
    if (controller.value.isTakingPicture) return null;
    final String dirPath =
        '${_applicationDirectory!.path}${LocalPaths.DIR_PICTURES}';
    await Directory(dirPath).create(recursive: true);
    final String filePath =
        "$dirPath/${PROFILE_PHOTO_NAME}_${DateTime.now().millisecondsSinceEpoch}";
    try {
      var file = File(filePath);
      if (await file.exists()) {
        file.deleteSync(recursive: true);
      }
      await controller.takePicture();
      photo = file;
      return "Captured";
    } on CameraException catch (e) {
      return e.toString();
    }
  }
}
