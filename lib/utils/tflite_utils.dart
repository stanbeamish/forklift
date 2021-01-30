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

  static classiFyImage(CameraImage image) async {
    await Tflite.runModelOnFrame(
            bytesList: image.planes.map((plane) {
              return plane.bytes;
            }).toList(),
            numResults: 2)
        .then((value) {
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

  static void disposeModel() {
    Tflite.close();
    tfliteResultsController.close();
  }
}
