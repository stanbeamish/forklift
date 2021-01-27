import 'package:flutter/material.dart';
import 'package:forklift/components/home_forklift_animation.dart';
import 'package:forklift/components/show_camera.dart';
import 'package:forklift/utils/screen_arguments.dart';

class SimpleMovementPage extends StatelessWidget {
  static const SimpleMovementPageRoute = '/simplemove';

  @override
  Widget build(BuildContext context) {
    final ScreenArguments args = ModalRoute.of(context).settings.arguments;

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
              child: ShowCamera(args.cameras),
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
