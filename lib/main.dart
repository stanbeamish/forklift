import 'package:flutter/material.dart';
import 'package:forklift/pages/basic_animation_page.dart';
import 'package:forklift/pages/simple_movement_page.dart';
import 'package:forklift/pages/splashscreen.dart';
import 'package:forklift/pages/start_page.dart';
import 'package:forklift/utils/special_color.dart';
import 'package:google_fonts/google_fonts.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      initialRoute: '/',
      routes: {
        '/': (context) => MySplashScreen(),
        '/start': (context) => StartPage(),
        '/simplemove': (context) => SimpleMovementPage(),
      },
      title: 'forklift',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: createMaterialColor(Color(0xFFBF1537)),
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  const MyHomePage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          title: Text(
            'Forklift - CNN animated',
            style: GoogleFonts.heebo(fontStyle: FontStyle.normal),
          ),
        ),
        body: AnimationPage(),
      ),
    );
  }
}
