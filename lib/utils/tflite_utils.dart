import 'dart:async';

import 'package:camera/camera.dart';
import 'package:forklift/models/result.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:tflite/tflite.dart';

class TfliteUtils {
  static StreamController<List<Result>> tfliteResultsController =
      new StreamController.broadcast();

  static List<Result> _outputs = List();
  static var modelLoaded = false;

  static Future<String> loadModel() async {
    BasicLogger.log('loadModel', 'Loading Tflite model ...');

    return Tflite.loadModel(
      model: 'assets/models/model_unquant.tflite',
      labels: 'assets/models/labels.txt',
    );
  }

  static classifyImage(CameraImage image) async {
    await Tflite.runModelOnFrame(
      bytesList: image.planes.map((plane) {
        return plane.bytes;
      }).toList(),
      imageHeight: image.height,
      imageWidth: image.width,
      rotation: 90,
      imageMean: 127.5,
      imageStd: 127.5,
      numResults: 2, // two results
      threshold: 0.2,
    ).then((value) {
      if (value.isNotEmpty) {
        BasicLogger.log('classifyImage', 'Results loaded. ${value.length}');

        // clear previous results
        _outputs.clear();

        value.forEach((element) {
          _outputs.add(Result(
              element['confidence'], element['index'], element['label']));

          BasicLogger.log('classifyImage',
              '${element['confidence']}, ${element['index']}, ${element['label']}');
        });
      }
      _outputs.sort((a, b) => a.confidence.compareTo(b.confidence));
      tfliteResultsController.add(_outputs);
    });
  }

  /*static Future<void> disposeModel() async {
    await Tflite.close();
    BasicLogger.log('disposeModel', 'Tflite closed...');
    await tfliteResultsController.close();
    BasicLogger.log('disposeModel', 'TfliteResultsController closed...');
  }*/
}
