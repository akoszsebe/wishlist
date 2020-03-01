import 'package:flutter/material.dart';

class ColoredButton extends StatelessWidget {
  final Color color;
  final bool isSelected;
  final Function onTap;

  ColoredButton(this.color, this.isSelected, {this.onTap});

  @override
  Widget build(BuildContext context) {
    return ClipOval(
    child: Material(
      color:
          isSelected ? Colors.transparent : Theme.of(context).primaryColorDark,
      elevation: 0,
      child: InkWell(
          child: Padding(
              padding: EdgeInsets.all(2),
              child: SizedBox(
                width: 24,
                height: 24,
                child: ClipOval(
                    child: Material(
                  color: color,
                )),
              )),
          onTap: onTap),
    ),
  );
  }
}
