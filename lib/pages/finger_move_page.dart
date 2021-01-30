import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';

import 'package:forklift/components/home_forklift_animation.dart';
import 'package:forklift/main.dart';
import 'package:forklift/models/result.dart';
import 'package:forklift/pages/start_page.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:forklift/utils/camera_utils.dart';
import 'package:forklift/utils/move_direction.dart';

import 'package:forklift/utils/tflite_utils.dart';

class FingerMovePage extends StatefulWidget {
  static const FingerMovePageRoute = '/fingermove';

  @override
  _FingerMovePageState createState() => _FingerMovePageState();
}

class _FingerMovePageState extends State<FingerMovePage> {
  List<Result> outputs;
  double currentLeft = 100; //starting position
  double currentTop = 100; // starting position
  Size imageSize; // Size of the forklift image
  bool isMoving = false;
  double maxBottom; // the calculated maximum of the pathway vertically
  double maxLeft; // the calculated maximum of the pathway horizontally
  Size pathwaySize; // Size of the container the forklift runs
  Direction selectedDirection;
  final step = 1; // how many steps per movement
  Timer timer;

  final GlobalKey _forkliftKey = GlobalKey(); // key to the forklift image
  final GlobalKey _pathwayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // callback one the build method was executed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSizeAndPosition();
      getPathwaySize();
      setPayWayNumbers();
      currentLeft = maxLeft / 2;
      currentTop = maxBottom / 2;
    });

    TfliteUtils.loadModel().then((value) {
      setState(() {
        TfliteUtils.modelLoaded = true;
      });
    });

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

  getSizeAndPosition() {
    RenderBox _imageBox = _forkliftKey.currentContext.findRenderObject();
    imageSize = _imageBox.size;

    setState(() {});
  }

  getPathwaySize() {
    RenderBox _paywayBox = _pathwayKey.currentContext.findRenderObject();
    pathwaySize = _paywayBox.size;
    setState(() {});
  }

  setPayWayNumbers() {
    maxLeft = pathwaySize.width - 2 - imageSize.width;
    maxBottom =
        ((pathwaySize.height / 16) * 15).round() - 12 - imageSize.height - 179;
    setState(() {});
  }

  updatePosition(Timer timer) {
    BasicLogger.log("updatePosition", "Updating the forklift position ...");
    if (isMoving) {
      move(selectedDirection);
    }
  }

  startMove() {
    BasicLogger.log("startMove", "Start moving ...");
    setState(() {
      isMoving = true;
      timer = Timer.periodic(Duration(milliseconds: 50), updatePosition);
    });
  }

  stopMove() {
    BasicLogger.log("stopMove", "Stop moving ...");
    setState(() {
      isMoving = false;
      selectedDirection = Direction.none;
      timer.cancel();
    });
  }

  move(Direction direction) {
    switch (direction) {
      case Direction.up:
        if (currentTop >= step) {
          currentTop -= step;
        } else {
          BasicLogger.log("move", "You have reached the top");
          stopMove();
        }
        break;
      case Direction.down:
        if (currentTop < (maxBottom - step)) {
          currentTop += step;
        } else {
          BasicLogger.log("move", "You have reached the bottom end");
          stopMove();
        }
        break;
      case Direction.left:
        if (currentLeft >= step) {
          currentLeft -= step;
        } else {
          BasicLogger.log("move", "You have reached the left start");
          stopMove();
        }
        break;
      case Direction.right:
        if (currentLeft <= (maxLeft - step)) {
          currentLeft += step;
        } else {
          BasicLogger.log("move", "You have reached the right end");
          stopMove();
        }
        break;
      case Direction.none:
        break;
    }

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Gabelstapler über CNN kontrolliert ...'),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Container(
              child: ForkliftAnimation(),
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: FutureBuilder<void>(
                  future: CameraUtils.initializeControllerFuture,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      return Container(
                        width: 300,
                        height: 220,
                        child: RotatedBox(
                          quarterTurns: 1,
                          child: AspectRatio(
                            aspectRatio: CameraUtils.camera.value.aspectRatio,
                            child: CameraPreview(CameraUtils.camera),
                          ),
                        ),
                      );
                    } else {
                      return Container(
                        width: 300,
                        height: 220,
                        color: Colors.grey[300],
                        child: Text("Camera not available"),
                      );
                    }
                  }),
            ),
            Expanded(
              child: Container(
                width: double.infinity,
                margin: EdgeInsets.symmetric(horizontal: 12, vertical: 12),
                child: Container(
                  decoration: BoxDecoration(
                    border: Border.all(
                      color: Theme.of(context).primaryColor,
                      width: 1,
                    ),
                  ),
                  child: Column(
                    key: _pathwayKey,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        flex: 15,
                        child: Stack(
                          children: [
                            Container(
                              padding: EdgeInsets.only(
                                top: currentTop,
                                left: currentLeft,
                              ),
                              child: Image.asset(
                                'assets/images/forklift_2.png',
                                width: 60,
                                height: 40,
                                key: _forkliftKey,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Expanded(
                        flex: 1,
                        child: Container(
                          color: Colors.grey,
                          width: double.infinity,
                          child: Text(
                              "Outputs: ${outputs[0].confidence}, ${outputs[0].id}, ${outputs[0].label}"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    TfliteUtils.disposeModel();
    CameraUtils.camera.dispose();
    BasicLogger.log('dispose', 'Clear resources ...');
    super.dispose();
  }
}
