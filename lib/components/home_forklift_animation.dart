import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';
import 'package:supercharged/supercharged.dart';

enum AnimationProps { opacity, reverseOpacity, leftPosition }

class ForkliftAnimation extends StatelessWidget {
  final _tween = MultiTween<AnimationProps>()
    ..add(AnimationProps.leftPosition, 840.0.tweenTo(0.0), 2200.milliseconds)
    ..add(AnimationProps.opacity, 0.0.tweenTo(1.0), 7.seconds)
    ..add(AnimationProps.reverseOpacity, 1.0.tweenTo(0.0), 7.seconds);

  @override
  Widget build(BuildContext context) {
    return PlayAnimation<MultiTweenValues<AnimationProps>>(
      tween: _tween,
      duration: _tween.duration,
      builder: (context, child, value) {
        return Container(
          child: Stack(
            children: [
              Opacity(
                opacity: value.get(AnimationProps.opacity),
                child: Center(
                  child: Container(
                    width: 200,
                    padding:
                        EdgeInsets.only(top: 0, bottom: 5, left: 40, right: 40),
                    child: Image.asset(
                      'assets/images/logo_text.png',
                      height: 50,
                    ),
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(width: 2, color: Colors.white),
                        borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(25),
                            bottomRight: Radius.circular(25))),
                  ),
                ),
              ),
              Opacity(
                opacity: value.get(AnimationProps.reverseOpacity),
                child: Container(
                  color: Colors.white,
                  child: Container(
                    color: Colors.white,
                    margin: EdgeInsets.only(
                        left: value.get(AnimationProps.leftPosition)),
                    child: Container(
                      color: Colors.white,
                      child: Image.asset(
                        'assets/images/forklift_side.png',
                        height: 50,
                      ),
                    ),
                  ),
                ),
              )
            ],
          ),
        );
      },
    );
  }
}
