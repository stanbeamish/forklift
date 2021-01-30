import 'dart:async';

import 'package:flutter/material.dart';
import 'package:forklift/utils/move_direction.dart';

class Pathway extends StatefulWidget {
  const Pathway({Key key}) : super(key: key);

  @override
  _PathwayState createState() => _PathwayState();
}

class _PathwayState extends State<Pathway> {
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
  final GlobalKey _pathwayKey =
      GlobalKey(); // key to the container of the payway

  @override
  void initState() {
    super.initState();
    // callback one the build method was executed
    WidgetsBinding.instance.addPostFrameCallback((_) {
      getSizeAndPosition();
      getPathwaySize();
      setPayWayNumbers();
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
    if (isMoving) {
      move(selectedDirection);
    }
  }

  startMove() {
    setState(() {
      isMoving = true;
      timer = Timer.periodic(Duration(milliseconds: 50), updatePosition);
    });
  }

  stopMove() {
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
          print("You have reached the top");
          stopMove();
        }
        break;
      case Direction.down:
        if (currentTop < (maxBottom - step)) {
          currentTop += step;
        } else {
          print("You have reached the bottom end");
          stopMove();
        }
        break;
      case Direction.left:
        if (currentLeft >= step) {
          currentLeft -= step;
        } else {
          print("You have reached the left start");
          stopMove();
        }
        break;
      case Direction.right:
        if (currentLeft <= (maxLeft - step)) {
          currentLeft += step;
        } else {
          print("You have reached the right end");
          stopMove();
        }
        break;
      case Direction.none:
        break;
    }

    setState(() {});
  }

  OutlineButton buildOutlineButton(String title, Direction direction) {
    return OutlineButton(
      highlightColor: Colors.greenAccent,
      highlightedBorderColor: Colors.green,
      onPressed: () {
        setState(() {
          selectedDirection = direction;
        });

        startMove();
      },
      child: Text(title),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      key: _pathwayKey,
      decoration: BoxDecoration(
        border: Border.all(
          color: Theme.of(context).primaryColor,
          width: 1,
        ),
      ),
      child: Column(
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
                    'assets/forklift_2.png',
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
              child: Stack(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      buildOutlineButton('Hoch', Direction.up),
                      SizedBox(
                        width: 4,
                      ),
                      buildOutlineButton('Runter', Direction.down),
                      SizedBox(
                        width: 4,
                      ),
                      buildOutlineButton('Links', Direction.left),
                      SizedBox(
                        width: 4,
                      ),
                      buildOutlineButton('Rechts', Direction.right),
                      SizedBox(
                        width: 4,
                      ),
                      RaisedButton(
                        onPressed: () {
                          stopMove();
                        },
                        child: Text('Stop'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      //Text(' Image Size - H: ${imageSize.height}, W: ${imageSize.width}'),
                      Text(' Pathway Horizontal Max: $maxLeft'),
                      Text(' Pathway Vertical Max: $maxBottom'),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
