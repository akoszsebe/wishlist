import 'dart:math';

import 'package:flutter/material.dart';
import 'package:simple_animations/simple_animations.dart';

class SwitchlikeCheckbox extends StatelessWidget {
  final bool checked;

  SwitchlikeCheckbox({this.checked});

  @override
  Widget build(BuildContext context) {
    var tween = MultiTrackTween([
      Track("paddingLeft")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 26.0)),
      Track("paddingLeft2")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 19.0)),
      Track("color").add(Duration(milliseconds: 500),
          ColorTween(begin: Colors.lightBlue[600], end: Color(0xff261830))),
      Track("width")
          .add(Duration(milliseconds: 500), Tween(begin: 0.0, end: 20.0)),
    ]);

    return ControlledAnimation(
      playback: checked ? Playback.PLAY_FORWARD : Playback.PLAY_REVERSE,
      startPosition: checked ? 1.0 : 0.0,
      duration: tween.duration * 1.2,
      tween: tween,
      curve: Curves.easeInOut,
      builder: _buildCheckbox,
    );
  }

  Widget _buildCheckbox(context, animation) {
    return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          decoration: _outerBoxDecoration(animation["color"]),
          width: 54,
          height: 28,
          padding: const EdgeInsets.all(4.0),
          child: Stack(
            children: [
              Positioned(
                child: Padding(
                  padding: EdgeInsets.only(left: animation["paddingLeft"]),
                  child: Container(
                    decoration: _innerBoxDecoration(Colors.yellow[700]),
                    width: 20,
                  ),
                ),
              ),
              Positioned(
                child: Padding(
                  padding: EdgeInsets.only(left: animation["paddingLeft2"]),
                  child: Container(
                    decoration: _innerBoxDecoration(animation["color"]),
                    width: animation["width"],
                  ),
                ),
              )
            ],
          ),
        ));
  }

  BoxDecoration _innerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(24)), color: color);

  BoxDecoration _outerBoxDecoration(color) => BoxDecoration(
      borderRadius: BorderRadius.all(Radius.circular(30)), color: color);
}
