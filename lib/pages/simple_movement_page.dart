import 'package:flutter/material.dart';
import 'package:forklift/components/home_forklift_animation.dart';

class SimpleMovementPage extends StatelessWidget {
  const SimpleMovementPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          actions: [],
          title: Text('Move the forklift around...'),
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
              child: Text('Camera'),
              color: Colors.lightBlue,
            ),
            SizedBox(
              height: 12,
            ),
            Container(
              child: Text('Runway'),
              color: Colors.lightGreen,
            ),
          ],
        ),
      ),
    );
  }
}
