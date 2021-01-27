import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnimationPage extends StatefulWidget {
  AnimationPage({Key key}) : super(key: key);

  @override
  _AnimationPageState createState() => _AnimationPageState();
}

class _AnimationPageState extends State<AnimationPage>
    with SingleTickerProviderStateMixin {
  Animation<double> animation;
  AnimationController animationController;

  @override
  void initState() {
    super.initState();
    animationController = AnimationController(
      duration: Duration(seconds: 5),
      vsync: this,
    );

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(animationController)
      ..addListener(() {
        setState(() {});
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        SizedBox(
          height: 80,
        ),
        Container(
          child: Stack(
            children: [
              Transform.rotate(
                angle: animation.value,
                child: Column(
                  children: [
                    Container(
                      alignment: Alignment.center,
                      child: Image.asset(
                        'assets/logo_cube.png',
                      ),
                    ),
                  ],
                ),
              ),
              Image.asset('robot.jpg')
            ],
          ),
        ),
        Container(
          padding: EdgeInsets.only(bottom: 50),
          child: Image.asset('assets/logo_text.png'),
        ),
      ],
    );
  }

  @override
  void dispose() {
    animationController.dispose();
    super.dispose();
  }
}
