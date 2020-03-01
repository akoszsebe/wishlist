import 'package:flutter/material.dart';
import 'package:wishlist/src/util/style/app_theme.dart';
import 'package:wishlist/src/util/theme_provider.dart';
import 'package:wishlist/src/widgets/buttons/color_button.dart';
import 'package:provider/provider.dart';
import 'package:easy_localization/easy_localization.dart';

class ColorSelector extends StatelessWidget {
  final Color selectedColor;
  final Function(int, Color) onTap;

  ColorSelector(this.selectedColor,this.onTap);

  @override
  Widget build(BuildContext context) {
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
                ColoredButton(
                    cardColors.color0, selectedColor != cardColors.color0,
                    onTap: changeColor(
                        selectedColor, cardColors.color0, 0, onTap)),
                ColoredButton(
                    cardColors.color1, selectedColor != cardColors.color1,
                    onTap: changeColor(
                        selectedColor, cardColors.color1, 1, onTap)),
                ColoredButton(
                    cardColors.color2, selectedColor != cardColors.color2,
                    onTap: changeColor(
                        selectedColor, cardColors.color2, 2, onTap)),
                ColoredButton(
                    cardColors.color3, selectedColor != cardColors.color3,
                    onTap: changeColor(
                        selectedColor, cardColors.color3, 3, onTap)),
                ColoredButton(
                    cardColors.color4, selectedColor != cardColors.color4,
                    onTap: changeColor(
                        selectedColor, cardColors.color4, 4, onTap)),
                ColoredButton(
                    cardColors.color5, selectedColor != cardColors.color5,
                    onTap: changeColor(
                        selectedColor, cardColors.color5, 5, onTap)),
                ColoredButton(
                    cardColors.color6, selectedColor != cardColors.color6,
                    onTap: changeColor(
                        selectedColor, cardColors.color6, 6, onTap)),
              ],
            )
          ],
        ));
  }

  Function changeColor(
      Color selectedColor, Color color, int index, Function(int, Color) onTap) {
    var a = () {
      selectedColor = color;
      onTap(index, color);
    };
    return a;
  }
}
