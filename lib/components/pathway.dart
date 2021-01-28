import 'package:flutter/material.dart';
import 'package:forklift/utils/move_direction.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

class Pathway extends StatefulWidget {
  const Pathway({Key key}) : super(key: key);

  @override
  _PathwayState createState() => _PathwayState();
}

class _PathwayState extends State<Pathway> {
  final GlobalKey _forkliftKey = GlobalKey();
  final GlobalKey _pathwayKey = GlobalKey();
  Size pathwaySize;
  Size imageSize;
  Offset imagePosition;

  final step = 5;
  double maxLeft;
  double maxBottom;
  double currentLeft = 100;
  double currentTop = 100;

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
    imagePosition = _imageBox.localToGlobal(Offset.zero);

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

  startAnimation() {}

  stopAnimation() {}

  move(Direction direction) {
    switch (direction) {
      case Direction.up:
        if (currentTop >= step) {
          currentTop -= step;
        } else {
          print("You have reached the top");
        }
        break;
      case Direction.down:
        if (currentTop < (maxBottom - step)) {
          currentTop += step;
        } else {
          print("You have reached the bottom end");
        }
        break;
      case Direction.left:
        if (currentLeft >= step) {
          currentLeft -= step;
        } else {
          print("You have reached the left start");
        }
        break;
      case Direction.right:
        if (currentLeft <= (maxLeft - step)) {
          currentLeft += step;
        } else {
          print("You have reached the right end");
        }
        break;
    }

    setState(() {});
  }

  stopMovement() {}

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
                          stopMovement();
                        },
                        child: Text('Stop'),
                      ),
                      SizedBox(
                        width: 12,
                      )
                    ],
                  ),
                  Column(
                    children: [
                      Text('Size - $imageSize'),
                      Text('Position - $imagePosition'),
                      Text('MaxLeft: $maxLeft, MaxBottom: $maxBottom')
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

  OutlineButton buildOutlineButton(String title, Direction direction) {
    return OutlineButton(
      highlightColor: Colors.greenAccent,
      highlightedBorderColor: Colors.green,
      onPressed: () {
        move(direction);
      },
      child: Text(title),
    );
  }
}
