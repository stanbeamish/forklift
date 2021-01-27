import 'package:flutter/material.dart';
import 'package:animated_text/animated_text.dart';

class ExplainApp extends StatelessWidget {
  const ExplainApp({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      child: AnimatedText(
        alignment: Alignment.center,
        speed: Duration(milliseconds: 1000),
        controller: AnimatedTextController.loop,
        displayTime: Duration(milliseconds: 700),
        wordList: ['move', 'your', 'forklift', 'with', 'fingers'],
        textStyle: TextStyle(
            color: Colors.black, fontSize: 90, fontWeight: FontWeight.w700),
        onAnimate: (index) {
          //print("Animating index:" + index.toString());
        },
        onFinished: () {
          //print("Animtion finished");
        },
      ),
    );
  }
}
