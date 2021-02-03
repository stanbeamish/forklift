import 'package:camera/camera.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:forklift/utils/tflite_utils.dart';

class CameraUtils {
  static CameraController camera;

  static bool isDetecting = false;
  static CameraLensDirection _direction = CameraLensDirection.front;
  static Future<void> initializeControllerFuture;

  static Future<CameraDescription> _getCamera(CameraLensDirection dir) async {
    return await availableCameras().then(
      (List<CameraDescription> cameras) => cameras.firstWhere(
        (CameraDescription camera) => camera.lensDirection == dir,
      ),
    );
  }

  static void initializeCamera() async {
    BasicLogger.log('initializeCamera', 'Initializing camera ...');

    camera = CameraController(
      await _getCamera(_direction),
      defaultTargetPlatform == TargetPlatform.android
          ? ResolutionPreset.high
          : ResolutionPreset.low,
      enableAudio: false,
    );

    initializeControllerFuture = camera.initialize().then((value) async {
      BasicLogger.log('_initializeCamera',
          'Camera initialized, starting camera stream ...');

      await camera.startImageStream((CameraImage image) {
        if (!TfliteUtils.modelLoaded) return;
        if (isDetecting) return;
        isDetecting = true;
        try {
          TfliteUtils.classifyImage(image);
        } catch (error) {
          BasicLogger.log('_initializeCamera', error);
        }
      });
    });
  }

  static Future<void> disposeCamera() async {
    await TfliteUtils.tfliteResultsController.close();
  }
}
