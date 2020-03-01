import 'package:flutter/material.dart';

class RoundedButton extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;
  final Color textColor;
  final Color backgroundColor;

  RoundedButton(this.text, this.onPressed,
      {this.textColor = Colors.white, this.backgroundColor = Colors.black});

  @override
  Widget build(BuildContext context) {
    return Container(
        alignment: Alignment.bottomCenter,
        child: ButtonTheme(
            height: 24,
            buttonColor: Colors.transparent,
            splashColor: Colors.transparent,
            child: FlatButton(
              child: Text(
                text,
                style: TextStyle(
                  fontSize: 15,
                  color: textColor,
                ),
              ),
              onPressed: onPressed,
              shape: RoundedRectangleBorder(
                  borderRadius: new BorderRadius.circular(20.0)),
              color: backgroundColor,
            )));
  }
}
