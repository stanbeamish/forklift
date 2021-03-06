import 'package:flutter/material.dart';
import 'package:forklift/pages/start_page.dart';
import 'package:splashscreen/splashscreen.dart';

class MySplashScreen extends StatefulWidget {
  static const SplashScreenRoute = '/';

  final cameras;
  MySplashScreen(this.cameras, {Key key}) : super(key: key);

  @override
  _MySplashScreenState createState() => _MySplashScreenState();
}

class _MySplashScreenState extends State<MySplashScreen> {
  @override
  Widget build(BuildContext context) {
    return SplashScreen(
      seconds: 3,
      navigateAfterSeconds: StartPage(widget.cameras),
      title: Text(
        'forklifter',
        style: TextStyle(
          fontSize: 30,
        ),
      ),
      image: Image.asset(
        'assets/images/logo_cube.png',
      ),
      photoSize: 100,
    );
  }
}
