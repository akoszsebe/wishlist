import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:wishlist/src/database/database_helper.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/util/alert_dialog.dart';
import 'package:wishlist/util/app_keys.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/util/app_theme.dart';
import 'package:wishlist/util/theme_provider.dart';

class EditScreen extends StatefulWidget {
  final TodoResponse todo;
  final Color color;

  EditScreen(
    this.todo, {
    Key key,
    this.color,
  }) : super(key: key ?? AppKeys.addTodoScreen);

  @override
  _EditScreenState createState() => _EditScreenState(todo, color: color);
}

class _EditScreenState extends State<EditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TodoResponse _todo;
  final Color color;
  final TodoController _con = TodoController.con;
  String _title;
  String _content;

  _EditScreenState(this._todo, {this.color});

  @protected
  @override
  void initState() {
    super.initState();
    _con.initAlarm(_todo.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: color,
      appBar: AppBar(
        backgroundColor: color,
        title: Text(AppLocalizations.of(context).tr('edittitle')),
        elevation: 0,
        actions: <Widget>[
          Container(
              alignment: Alignment.centerLeft,
              padding: EdgeInsets.only(right: 16),
              child: ButtonTheme(
                  height: 32,
                  buttonColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: FlatButton(
                    child: Text(
                      AppLocalizations.of(context).tr('updatetodo'),
                      style: TextStyle(
                        fontSize: 18,
                        color: color,
                      ),
                    ),
                    onPressed: () {
                      final form = formKey.currentState;
                      if (form.validate()) {
                        form.save();
                        _con.update(_todo.id, _title, _content);
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
                  buildTitleFormField(),
                  buildColorsField(),
                  buildContentFormField(),
                  buildAlarmField(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void pickTile(BuildContext context,
      {DatabaseActions action = DatabaseActions.insert}) {
    showTimePickerDialog(
        context, AppLocalizations.of(context).tr('dialog_timepicker_title'),
        (dateTime) async {
      showLoaderDialog(context);
      await _con.insertOrUpdateAlarm(
          dateTime, _todo.id, _title == null ? _todo.title : _title, () {
        _con.initAlarm(_todo.id);
        setState(() {
          if (_con.currentAlarm != null) {
            _con.currentAlarm.alarmEnabled = true;
          }
        });
        Navigator.pop(context);
      }, action: action);
    });
  }

  buildContentFormField() {
    return TextFormField(
      initialValue: _todo.content,
      key: AppKeys.noteField,
      maxLines: 15,
      style: Theme.of(context).textTheme.subhead.copyWith(fontWeight: FontWeight.w700),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('contenttext'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('content'),
          labelStyle: TextStyle(
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.3))),
      cursorColor: Theme.of(context).accentColor,
      onSaved: (value) => _content = value,
      validator: (String arg) {
        if (arg.length < 3)
          return AppLocalizations.of(context).tr('contenttextmin');
        else
          return null;
      },
    );
  }

  buildTitleFormField() {
    return TextFormField(
      initialValue: _todo.title,
      key: AppKeys.taskField,
      style: Theme.of(context).textTheme.headline.copyWith(fontWeight: FontWeight.w800),
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('newTodotite'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('todotite'),
          labelStyle: TextStyle(
              color:
                  Theme.of(context).textTheme.headline.color.withOpacity(0.3))),
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

  buildAlarmField() {
    return Padding(
        padding: EdgeInsets.only(left: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Text(
              AppLocalizations.of(context).tr('alarm.title'),
              style: TextStyle(
                  fontSize: 16,
                  color: Theme.of(context)
                      .textTheme
                      .headline
                      .color
                      .withOpacity(0.3)),
            ),
            _con.currentAlarm != null
                ? Material(
                    color: Colors.transparent,
                    child: InkWell(
                        onTap: () {
                          pickTile(context, action: DatabaseActions.update);
                        },
                        child: RichText(
                          text: TextSpan(children: [
                            TextSpan(
                              text: DateFormat(
                                      "MMM d EEE ",
                                      AppLocalizations.of(context)
                                          .locale
                                          .toString())
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      _con.currentAlarm.when)),
                              style: TextStyle(
                                color:
                                    Theme.of(context).textTheme.display1.color,
                                fontSize: 17,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat(
                                      "HH:mm",
                                      AppLocalizations.of(context)
                                          .locale
                                          .toString())
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      _con.currentAlarm.when)),
                              style: TextStyle(
                                fontSize: 20,
                                color: Theme.of(context).primaryColorDark,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            TextSpan(
                              text: DateFormat(
                                      " a",
                                      AppLocalizations.of(context)
                                          .locale
                                          .toString())
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      _con.currentAlarm.when)),
                              style: TextStyle(
                                fontSize: 15,
                                fontWeight: FontWeight.w200,
                                color:
                                    Theme.of(context).textTheme.display1.color,
                              ),
                            ),
                          ]),
                        )))
                : FlatButton.icon(
                    padding: EdgeInsets.all(0),
                    icon: Icon(Icons.alarm_off),
                    label: Text(
                        AppLocalizations.of(context).tr('alarm.select_date'), style: TextStyle(fontWeight: FontWeight.w800),),
                    onPressed: () {
                      pickTile(context);
                    },
                  ),
            // Switch(
            //   value: _con.currentAlarm != null
            //       ? _con.currentAlarm.alarmEnabled
            //       : false,
            //   activeColor: Theme.of(context).accentColor,
            //   onChanged: (val) {
            //     setState(() async {
            //       if (_con.currentAlarm != null) {
            //         if (val == false) {
            //           _con.disableAlarm(
            //               DateTime.fromMillisecondsSinceEpoch(
            //                   _con.currentAlarm.when),
            //               _con.currentAlarm.id,
            //               _con.currentAlarm.title, () {
            //             _con.currentAlarm.alarmEnabled = val;
            //           });
            //         } else {
            //           await _con.insertOrUpdateAlarm(
            //               DateTime.fromMillisecondsSinceEpoch(
            //                   _con.currentAlarm.when),
            //               _con.currentAlarm.id,
            //               _title == null ? _todo.title : _title, () {
            //             _con.initAlarm(_todo.id);
            //             setState(() {
            //               if (_con.currentAlarm != null) {
            //                 _con.currentAlarm.alarmEnabled = true;
            //               }
            //             });
            //           }, action: DatabaseActions.update);
            //         }
            //       } else {
            //         pickTile(context);
            //       }
            //     });
            //   },
            // ),
          ],
        ));
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
                      .withOpacity(0.3)),
            ),
            Padding(padding: EdgeInsets.only(top: 5),),
            Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.start,
              alignment: WrapAlignment.center,
              children: <Widget>[
                colorButton(cardColors.color0),
                colorButton(cardColors.color1),
                colorButton(cardColors.color2),
                colorButton(cardColors.color3),
              ],
            )
          ],
        ));
  }

  colorButton(color) {
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
          onTap: () {},
        ),
      ),
    );
  }
}
