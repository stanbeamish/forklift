import 'package:flutter/material.dart';
import 'package:forklift/components/home_forklift_animation.dart';
import 'dart:math' as math;

import 'package:google_fonts/google_fonts.dart';

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

    final curvedAnimation = CurvedAnimation(
        parent: animationController,
        curve: Curves.bounceIn,
        reverseCurve: Curves.easeOut);

    animation = Tween<double>(
      begin: 0,
      end: 2 * math.pi,
    ).animate(curvedAnimation)
      ..addListener(() {
        setState(() {});
      })
      ..addStatusListener((status) {
        if (status == AnimationStatus.completed) {
          animationController.reverse();
        } else if (status == AnimationStatus.dismissed) {
          animationController.forward();
        }
      });

    animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Container(
          child: Stack(
            children: [
              Image.asset(
                'robot.jpg',
              ),
              Center(
                child: Container(
                  width: 300,
                  padding:
                      EdgeInsets.only(top: 20, bottom: 20, left: 30, right: 30),
                  child: Image.asset(
                    'assets/logo_text.png',
                    height: 90,
                  ),
                  decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(width: 2, color: Colors.white),
                      borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25),
                          bottomRight: Radius.circular(25))),
                ),
              ),
              Center(
                child: Padding(
                  padding: const EdgeInsets.only(top: 450.0),
                  child: FlatButton(
                    padding: EdgeInsets.symmetric(horizontal: 80, vertical: 12),
                    color: Color.fromRGBO(255, 255, 235, 0.8),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => ForkliftAnimation(),
                        ),
                      );
                    },
                    child: Text(
                      'Start',
                      style: GoogleFonts.heebo(
                          fontStyle: FontStyle.normal, fontSize: 30),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
        Column(
          children: [
            Transform.rotate(
              angle: animation.value,
              child: Container(
                alignment: Alignment.center,
                child: Image.asset(
                  'assets/logo_cube.png',
                ),
              ),
            ),
            SizedBox(
              height: 180,
            ),
          ],
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
