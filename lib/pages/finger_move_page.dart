import 'dart:async';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/linear_percent_indicator.dart';

import 'package:forklift/components/home_forklift_animation.dart';
import 'package:forklift/models/result.dart';
import 'package:forklift/utils/basic_logger.dart';
import 'package:forklift/utils/camera_utils.dart';
import 'package:forklift/utils/move_direction.dart';
import 'package:forklift/utils/tflite_utils.dart';

class FingerMovePage extends StatefulWidget {
  static const FingerMovePageRoute = '/fingermove';

  @override
  _FingerMovePageState createState() => _FingerMovePageState();
}

class _FingerMovePageState extends State<FingerMovePage>
    with TickerProviderStateMixin {
  AnimationController _colorAnimController;
  Animation _colorTween;

  List<Result> outputs;

  double currentLeft = 100; //starting position
  double currentTop = 100; // starting position
  Size imageSize; // Size of the forklift image
  bool isMoving = false;
  double maxBottom; // the calculated maximum of the pathway vertically
  double maxLeft; // the calculated maximum of the pathway horizontally
  Size pathwaySize; // Size of the container the forklift runs
  Direction _selectedDirection;
  final step = 1; // how many steps per movement
  Timer timer;

  final GlobalKey _forkliftKey = GlobalKey(); // key to the forklift image
  final GlobalKey _pathwayKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    // callback one the build method was executed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _getSizeAndPosition();
      _getPathwaySize();
      _setPayWayNumbers();
      currentLeft = maxLeft / 2;
      currentTop = maxBottom / 2;
    });

    TfliteUtils.loadModel().then((value) {
      setState(() {
        TfliteUtils.modelLoaded = true;
      });
    });

    CameraUtils.initializeCamera();

    //Setup Animation
    _setupAnimation();

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
                        flex: 10,
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
                        flex: 4,
                        child: Column(
                          children: [
                            Container(
                              color: Colors.grey,
                              width: double.infinity,
                              child: outputs != null && outputs.isNotEmpty
                                  ? ListView.builder(
                                      itemCount: outputs.length,
                                      shrinkWrap: true,
                                      itemBuilder:
                                          (BuildContext context, int index) {
                                        return Column(
                                          children: [
                                            Text(outputs[index].label,
                                                style: TextStyle(
                                                    color: _colorTween.value,
                                                    fontSize: 20)),
                                            AnimatedBuilder(
                                                animation: _colorAnimController,
                                                builder: (context, child) {
                                                  return LinearPercentIndicator(
                                                    width:
                                                        MediaQuery.of(context)
                                                                .size
                                                                .width *
                                                            0.88,
                                                    lineHeight: 14.0,
                                                    percent: outputs[index]
                                                        .confidence,
                                                    progressColor:
                                                        _colorTween.value,
                                                  );
                                                }),
                                            Text(
                                              '${(outputs[index].confidence * 100.0).toStringAsFixed(2)} %',
                                              style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 16.0),
                                            ),
                                          ],
                                        );
                                      })
                                  : Center(
                                      child: Text(
                                        'Waiting for model to detect ...',
                                        style: TextStyle(
                                            color: Colors.black,
                                            fontSize: 20.0),
                                      ),
                                    ),
                            ),
                          ],
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

  _evaluateOutputs(List outputs) {
    if (outputs.isNotEmpty) {
      var newDirection = Direction.none;

      BasicLogger.log(
          '_evaluateOutputs', 'EVALUATING outputs: ${outputs.length}');
      if ((outputs[0].confidence * 100) > 80.0) {
        switch (outputs[0].label) {
          case 'Up':
            setState(() {});
            newDirection = Direction.up;
            break;
          case 'Down':
            newDirection = Direction.down;
            break;
          case 'Left':
            newDirection = Direction.left;
            break;
          case 'Right':
            newDirection = Direction.right;
            break;
        }

        setState(() {
          _selectedDirection = newDirection;
        });

        _startMove();
      }
    }
  }

  void _getSizeAndPosition() {
    RenderBox _imageBox = _forkliftKey.currentContext.findRenderObject();
    imageSize = _imageBox.size;

    setState(() {});
  }

  void _getPathwaySize() {
    RenderBox _paywayBox = _pathwayKey.currentContext.findRenderObject();
    pathwaySize = _paywayBox.size;
    setState(() {});
  }

  void _setPayWayNumbers() {
    maxLeft = pathwaySize.width - 2 - imageSize.width;
    maxBottom =
        ((pathwaySize.height / 16) * 15).round() - 12 - imageSize.height - 179;
    setState(() {});
  }

  void _updatePosition(Timer timer) {
    BasicLogger.log("updatePosition", "Updating the forklift position ...");
    if (isMoving) {
      _move(_selectedDirection);
    }
  }

  void _setupAnimation() {
    _colorAnimController =
        AnimationController(vsync: this, duration: Duration(milliseconds: 500));
    _colorTween = ColorTween(begin: Colors.black, end: Colors.red)
        .animate(_colorAnimController);
  }

  void _startMove() {
    BasicLogger.log("startMove", "Start moving ...");
    setState(() {
      isMoving = true;
      timer = Timer.periodic(Duration(milliseconds: 50), _updatePosition);
    });
  }

  void _stopMove() {
    BasicLogger.log("stopMove", "Stop moving ...");
    setState(() {
      isMoving = false;
      _selectedDirection = Direction.none;
      timer.cancel();
    });
  }

  void _move(Direction direction) {
    switch (direction) {
      case Direction.up:
        if (currentTop >= step) {
          currentTop -= step;
        } else {
          BasicLogger.log("move", "You have reached the top");
          _stopMove();
        }
        break;
      case Direction.down:
        if (currentTop < (maxBottom - step)) {
          currentTop += step;
        } else {
          BasicLogger.log("move", "You have reached the bottom end");
          _stopMove();
        }
        break;
      case Direction.left:
        if (currentLeft >= step) {
          currentLeft -= step;
        } else {
          BasicLogger.log("move", "You have reached the left start");
          _stopMove();
        }
        break;
      case Direction.right:
        if (currentLeft <= (maxLeft - step)) {
          currentLeft += step;
        } else {
          BasicLogger.log("move", "You have reached the right end");
          _stopMove();
        }
        break;
      case Direction.none:
        break;
    }

    setState(() {});
  }

  @override
  void dispose() {
    TfliteUtils.disposeModel();
    CameraUtils.camera.dispose();
    BasicLogger.log('dispose', 'Clear resources ...');
    super.dispose();
  }
}
