import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/util/app_keys.dart';
import 'package:wishlist/util/app_theme.dart';
import 'package:wishlist/util/theme_provider.dart';

class AddScreen extends StatefulWidget {
  final String todoId;

  AddScreen({
    Key key,
    this.todoId,
  }) : super(key: key ?? AppKeys.addTodoScreen);

  @override
  _AddScreenState createState() => _AddScreenState();
}

class _AddScreenState extends State<AddScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();
  final TodoController _con = TodoController.con;
  String _title;
  String _content;
  int _category = 0;
  Color color;

  @override
  Widget build(BuildContext context) {
    if (color == null) {
      final themeProvider = Provider.of<ThemeProvider>(context);
      CardColors cardColors =
          themeProvider.isLightTheme ? CardLightColors() : CardDarkColors();
      color = cardColors.color0;
    }

    /// Return the 'universally recognized' Map object.
    /// The data will only be known through the use of Map objects.
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        title: Text(AppLocalizations.of(context).tr('addtitle')),
        elevation: 2,
        actions: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 16),
              child: ButtonTheme(
                  height: 24,
                  buttonColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: FlatButton(
                    child: Text(
                      AppLocalizations.of(context).tr('addtodo'),
                      style: TextStyle(
                        fontSize: 15,
                        color: color == null
                            ? Theme.of(context).backgroundColor
                            : color,
                      ),
                    ),
                    onPressed: () {
                      final form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        _con.saveTodo(_title, _content, _category);
                        Navigator.pop(context);
                      }
                    },
                    shape: RoundedRectangleBorder(
                        borderRadius: new BorderRadius.circular(20.0)),
                    color: Theme.of(context).primaryColorDark,
                  ))),
        ],
      ),
      body: Form(
        key: formKey,
        autovalidate: false,
        onWillPop: () {
          return Future(() => true);
        },
        child: ListView(
          children: [
            Container(
                padding: EdgeInsets.only(top: 16, bottom: 16),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      buildTitleFormFieled(),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      buildColorsField(),
                      Padding(padding: EdgeInsets.only(top: 8)),
                      buildContentFormFieled(),
                    ])),
          ],
        ),
      ),
    );
  }

  Widget buildTitleFormFieled() {
    return TextFormField(
      initialValue: "",
      key: AppKeys.taskField,
      style: Theme.of(context).textTheme.headline,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('newTodotite'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('todotite'),
          labelStyle: TextStyle(
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.5))),
      cursorColor: Theme.of(context).accentColor,
      onSaved: (value) => _title = value,
      validator: (String arg) {
        if (arg.length < 3)
          return AppLocalizations.of(context).tr('titletextmin');
        else
          return null;
      },
    );
  }

  Widget buildContentFormFieled() {
    return TextFormField(
      initialValue: '',
      key: AppKeys.noteField,
      maxLines: null,
      minLines: null,
      expands: false,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('contenttext'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('content'),
          labelStyle: TextStyle(
              fontSize: 21,
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.5))),
      cursorColor: Theme.of(context).accentColor,
      onSaved: (value) => _content = value,
    );
  }

  buildColorsField() {
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
                colorButton(cardColors.color0, 0),
                colorButton(cardColors.color1, 1),
                colorButton(cardColors.color2, 2),
                colorButton(cardColors.color3, 3),
                colorButton(cardColors.color4, 4),
                colorButton(cardColors.color5, 5),
                colorButton(cardColors.color6, 6),
              ],
            )
          ],
        ));
  }

  colorButton(color, int category) {
    return ClipOval(
      child: Material(
        color: color != this.color
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
            _category = category;
            setState(() {
              this.color = color;
            });
          },
        ),
      ),
    );
  }
}
