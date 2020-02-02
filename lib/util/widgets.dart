import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/util/app_theme.dart';
import 'package:wishlist/util/theme_provider.dart';

Widget buildLoader(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(
              Theme.of(context).accentColor)));
}

Widget buildButton(
    String text, VoidCallback onPressed, Color textColor, Color bacgoundColor) {
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
            color: bacgoundColor,
          )));
}

Widget buildColorSelector(
    BuildContext context, Color selectedColor, Function(int, Color) onTap) {
  final themeProvider = Provider.of<ThemeProvider>(context);
  CardColors cardColors =
      themeProvider.isLightTheme ? CardLightColors() : CardDarkColors();
  return Padding(
      padding: EdgeInsets.only(left: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text(
            AppLocalizations.of(context).tr('colors'),
            style: TextStyle(
                fontSize: 16,
                color: Theme.of(context)
                    .textTheme
                    .headline
                    .color
                    .withOpacity(0.5)),
          ),
          Padding(
            padding: EdgeInsets.only(top: 5),
          ),
          Wrap(
            spacing: 10,
            crossAxisAlignment: WrapCrossAlignment.start,
            alignment: WrapAlignment.center,
            children: <Widget>[
              _colorButton(context, selectedColor, cardColors.color0, 0, onTap),
              _colorButton(context, selectedColor, cardColors.color1, 1, onTap),
              _colorButton(context, selectedColor, cardColors.color2, 2, onTap),
              _colorButton(context, selectedColor, cardColors.color3, 3, onTap),
              _colorButton(context, selectedColor, cardColors.color4, 4, onTap),
              _colorButton(context, selectedColor, cardColors.color5, 5, onTap),
              _colorButton(context, selectedColor, cardColors.color6, 6, onTap),
            ],
          )
        ],
      ));
}

Widget _colorButton(BuildContext context, Color selectedColor, Color color,
    int index, Function(int, Color) onTap) {
  return ClipOval(
    child: Material(
      color: color != selectedColor
          ? Colors.transparent
          : Theme.of(context).primaryColorDark,
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
          onTap: () {
            selectedColor = color;
            onTap(index, color);
          }),
    ),
  );
}
