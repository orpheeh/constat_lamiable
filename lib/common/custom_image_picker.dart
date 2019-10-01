import 'dart:io';

import 'package:camera/camera.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class CustomImagePicker {
  static Future<File> pickImage(
      CameraController _controller, var _initializeControllerFuture) async {
    // Ensure that the camera is initialized.
    await _initializeControllerFuture;
    // Construct the path where the image should be saved using the
    // pattern package.
    final path = join(
      // Store the picture in the temp directory.
      // Find the temp directory using the `path_provider` plugin.
      (await getTemporaryDirectory()).path,
      '${DateTime.now()}.png',
    );

    // Attempt to take a picture and log where it's been saved.
    await _controller.takePicture(path);

    //Dispose controller befor finish
    _controller.dispose();

    return File(path);
  }
}
