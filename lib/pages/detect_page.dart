import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:forklift/models/result.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:forklift/utils/camera_utils.dart';
import 'package:forklift/utils/tflite_utils.dart';

class DetectPage extends StatefulWidget {
  DetectPage({Key key}) : super(key: key);

  static const DetectPageRoute = '/detect';

  @override
  _DetectPageState createState() => _DetectPageState();
}

class _DetectPageState extends State<DetectPage> {
  List<Result> outputs;

  @override
  void initState() {
    super.initState();

    // load Tflite Model
    TfliteUtils.loadModel().then((value) {
      setState(() {
        TfliteUtils.modelLoaded = true;
      });
    });

    // initialize camera
    CameraUtils.initializeCamera();

    // subscribe to Tflite classify events
    TfliteUtils.tfliteResultsController.stream.listen(
        (value) {
          // set results
          outputs = value;

          // do something with the results on the screen
          setState(() {
            // set to false to allow detection again
            CameraUtils.isDetecting = false;
          });
        },
        onDone: () {},
        onError: (error) {
          BasicLogger.log('listen', error);
        });
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;

    return Scaffold(
      appBar: AppBar(
        title: Text('forklifter at your fingertips'),
      ),
      body: FutureBuilder<void>(
        future: CameraUtils.initializeControllerFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.done) {
            //if the future is complete, display the preview
            return Stack(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('Hello'),
                    Container(
                      width: 500,
                      height: 320,
                      child: RotatedBox(
                        quarterTurns: 1,
                        child: AspectRatio(
                          aspectRatio: CameraUtils.camera.value.aspectRatio,
                          child: CameraPreview(CameraUtils.camera),
                        ),
                      ),
                    ),
                    _buildForklifterRunwayWidget(width, outputs),
                  ],
                ),
              ],
            );
          } else {
            // otherwise display a loading indicator
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
      ),
    );
  }

  Widget _buildForklifterRunwayWidget(double width, List<Result> outputs) {
    return Positioned.fill(
        child: Align(
      alignment: Alignment.bottomCenter,
      child: Container(
        child: Text(
            "Outputs: ${outputs[0].confidence}, ${outputs[0].id}, ${outputs[0].label}"),
      ),
    ));
  }

  @override
  void dispose() {
    TfliteUtils.disposeModel();
    CameraUtils.camera.dispose();
    BasicLogger.log('dispose', 'Clear resources ...');
    super.dispose();
  }
}
