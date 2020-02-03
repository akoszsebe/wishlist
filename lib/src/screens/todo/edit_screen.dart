import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/database/database_helper.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/util/alert_dialog.dart';
import 'package:wishlist/util/app_keys.dart';
import 'package:intl/intl.dart';
import 'package:wishlist/util/widgets.dart';

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

class _EditScreenState extends State<EditScreen>
    with SingleTickerProviderStateMixin {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TodoResponse _todo;
  final TodoController _con = TodoController.con;
  String _title;
  String _content;
  int _category;

  Color color;
  Color lastColor;
  AnimationController _animationController;
  Animation<Color> background;

  _EditScreenState(this._todo, {this.color});

  @protected
  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );
    super.initState();
    _category = _todo.category;
    _con.initAlarm(_todo.id);
    lastColor = color;
    setBackgroundColor(lastColor, color);
  }

  @override
  Widget build(BuildContext context) {
    lastColor = color;
    return AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return Scaffold(
              backgroundColor: background.value,
              appBar: AppBar(
                backgroundColor: Colors.transparent,
                elevation: 0,
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
                          Padding(padding: EdgeInsets.only(top: 8)),
                          buildColorSelector(context, color, (index, color) {
                            this.color = color;
                            setBackgroundColor(lastColor, color);
                            _category = index;
                            _animationController.reset();
                            _animationController.forward();
                          }),
                          Padding(padding: EdgeInsets.only(top: 8)),
                          buildContentFormField(),
                          Padding(padding: EdgeInsets.only(top: 8)),
                          buildAlarmField(),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              floatingActionButton: Padding(
                padding: EdgeInsets.only(left: 32),
                child: buildButton(
                    AppLocalizations.of(context).tr('updatetodo'), () {
                  final form = formKey.currentState;
                  if (form.validate()) {
                    form.save();
                    _con.update(_todo.id, _title, _content, _category);
                    Navigator.pop(context);
                  }
                }, color, Theme.of(context).primaryColorDark),
              ));
        });
  }

  void pickTile(BuildContext context,
      {DatabaseActions action = DatabaseActions.insert}) {
    showTimePickerDialog(
        context,
        AppLocalizations.of(context).tr('dialog_timepicker_title'),
        _con.currentAlarm != null, (dateTime) async {
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
    }, () {
      _con.deleteAlarm(_todo.id, () {
        Navigator.pop(context);
      });
    });
  }

  buildContentFormField() {
    return TextFormField(
      initialValue: _todo.content,
      key: AppKeys.noteField,
      maxLines: null,
      minLines: null,
      expands: false,
      style: Theme.of(context)
          .textTheme
          .subhead
          .copyWith(fontWeight: FontWeight.w700),
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

  buildTitleFormField() {
    return TextFormField(
      initialValue: _todo.title,
      key: AppKeys.taskField,
      style: Theme.of(context)
          .textTheme
          .headline
          .copyWith(fontWeight: FontWeight.w800),
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
                      .withOpacity(0.5)),
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
                                      "MMMM d EEEE ",
                                      AppLocalizations.of(context)
                                          .locale
                                          .toString())
                                  .format(DateTime.fromMillisecondsSinceEpoch(
                                      _con.currentAlarm.when)),
                              style: TextStyle(
                                color: Theme.of(context).primaryColorDark,
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
                                fontWeight: FontWeight.w500,
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
                      AppLocalizations.of(context).tr('alarm.select_date'),
                      style: TextStyle(fontWeight: FontWeight.w800),
                    ),
                    onPressed: () {
                      pickTile(context);
                    },
                  ),
          ],
        ));
  }

  void setBackgroundColor(Color color1, Color color2) {
    background = ColorTween(
      begin: color1,
      end: color2,
    ).animate(_animationController)
      ..addListener(() {
        setState(() {});
      });
  }
}
