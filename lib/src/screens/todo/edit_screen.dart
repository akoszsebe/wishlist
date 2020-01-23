import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/util/database_helper.dart';
import 'package:wishlist/src/networking/response/todo_response.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/util/alert_dialog.dart';
import 'package:wishlist/util/app_keys.dart';
import 'package:intl/intl.dart';

class EditScreen extends StatefulWidget {
  final TodoResponse todo;

  EditScreen(
    this.todo, {
    Key key,
  }) : super(key: key ?? AppKeys.addTodoScreen);

  @override
  _EditScreenState createState() => _EditScreenState(todo);
}

class _EditScreenState extends State<EditScreen> {
  static final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  final TodoResponse _todo;
  final TodoController _con = TodoController.con;
  String _title;
  String _content;

  _EditScreenState(this._todo);

  @protected
  @override
  void initState() {
    super.initState();
    _con.initAlarm(_todo.id);
  }

  @override
  Widget build(BuildContext context) {
    /// Return the 'universally recognized' Map object.
    /// The data will only be known through the use of Map objects.

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr('edittitle')),
        elevation: 2,
      ),
      body: Form(
        key: formKey,
        autovalidate: false,
        onWillPop: () {
          return Future(() => true);
        },
        child: ListView(
          children: [
            Padding(
                padding: EdgeInsets.all(16),
                child: Container(
                  padding: EdgeInsets.only(top: 16, bottom: 16),
                  decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: new BorderRadius.circular(12.0)),
                  child: TextFormField(
                    initialValue: _todo.title,
                    key: AppKeys.taskField,
                    style: Theme.of(context).textTheme.headline,
                    decoration: InputDecoration(
                        border: InputBorder.none,
                        hintText:
                            AppLocalizations.of(context).tr('newTodotite'),
                        contentPadding: EdgeInsets.all(16),
                        labelText: AppLocalizations.of(context).tr('todotite')),
                    cursorColor: Theme.of(context).accentColor,
                    onSaved: (value) => _title = value,
                    validator: (String arg) {
                      if (arg.length < 3)
                        return AppLocalizations.of(context).tr('titletextmin');
                      else
                        return null;
                    },
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                  padding:
                      EdgeInsets.only(top: 8, bottom: 8, left: 16, right: 0),
                  decoration: new BoxDecoration(
                      color: Theme.of(context).primaryColorLight,
                      borderRadius: new BorderRadius.circular(12.0)),
                  child: Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: <Widget>[
                      Text(
                        "Alarm",
                        style: TextStyle(
                          fontSize: 24,
                        ),
                      ),
                      _con.currentAlarm != null
                          ? Material(
                              color: Colors.transparent,
                              child: InkWell(
                                  onTap: () {
                                    pickTile(context,
                                        action: DatabaseActions.update);
                                  },
                                  child: RichText(
                                    text: TextSpan(children: [
                                      TextSpan(
                                        text: DateFormat(
                                                "MMM, d EEE ",
                                                AppLocalizations.of(context)
                                                    .locale
                                                    .toString())
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    _con.currentAlarm.when)),
                                        style: TextStyle(
                                          color: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .color,
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
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    _con.currentAlarm.when)),
                                        style: TextStyle(
                                          fontSize: 20,
                                          color: Theme.of(context).accentColor,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                      TextSpan(
                                        text: DateFormat(
                                                " a",
                                                AppLocalizations.of(context)
                                                    .locale
                                                    .toString())
                                            .format(DateTime
                                                .fromMillisecondsSinceEpoch(
                                                    _con.currentAlarm.when)),
                                        style: TextStyle(
                                          fontSize: 15,
                                          fontWeight: FontWeight.w200,
                                          color: Theme.of(context)
                                              .textTheme
                                              .display1
                                              .color,
                                        ),
                                      ),
                                    ]),
                                  )))
                          : FlatButton.icon(
                              icon: Icon(Icons.alarm_add),
                              label: Text("Select date"),
                              onPressed: () {
                                pickTile(context);
                              },
                            ),
                      Switch(
                        value: _con.currentAlarm != null
                            ? _con.currentAlarm.alarmEnabled
                            : false,
                        activeColor: Theme.of(context).accentColor,
                        onChanged: (val) {
                          setState(() async {
                            if (_con.currentAlarm != null) {
                              if (val == false) {
                                _con.disableAlarm(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _con.currentAlarm.when),
                                    _con.currentAlarm.id,
                                    _con.currentAlarm.title, () {
                                  _con.currentAlarm.alarmEnabled = val;
                                });
                              } else {
                                await _con.insertOrUpdateAlarm(
                                    DateTime.fromMillisecondsSinceEpoch(
                                        _con.currentAlarm.when),
                                    _con.currentAlarm.id,
                                    _title == null ? _todo.title : _title, () {
                                  _con.initAlarm(_todo.id);
                                  setState(() {
                                    if (_con.currentAlarm != null) {
                                      _con.currentAlarm.alarmEnabled = true;
                                    }
                                  });
                                },action: DatabaseActions.update);
                              }
                            } else {
                              pickTile(context);
                            }
                          });
                        },
                      ),
                    ],
                  ),
                )),
            Padding(
                padding: EdgeInsets.only(left: 16, right: 16, bottom: 16),
                child: Container(
                    padding: EdgeInsets.only(top: 16, bottom: 16),
                    decoration: new BoxDecoration(
                        color: Theme.of(context).primaryColorLight,
                        borderRadius: new BorderRadius.circular(12.0)),
                    child: TextFormField(
                      initialValue: _todo.content,
                      key: AppKeys.noteField,
                      maxLines: 15,
                      style: Theme.of(context).textTheme.subhead,
                      decoration: InputDecoration(
                          border: InputBorder.none,
                          hintText:
                              AppLocalizations.of(context).tr('contenttext'),
                          contentPadding: EdgeInsets.all(16),
                          labelText:
                              AppLocalizations.of(context).tr('content')),
                      cursorColor: Theme.of(context).accentColor,
                      onSaved: (value) => _content = value,
                      validator: (String arg) {
                        if (arg.length < 3)
                          return AppLocalizations.of(context)
                              .tr('contenttextmin');
                        else
                          return null;
                      },
                    ))),
            Container(
                padding: EdgeInsets.only(bottom: 16),
                height: 60,
                child: Center(
                    child: FloatingActionButton.extended(
                  key: AppKeys.saveTodoFab,
                  backgroundColor: Theme.of(context).accentColor,
                  tooltip: AppLocalizations.of(context).tr('saveChanges'),
                  icon: Icon(Icons.save),
                  label: Text(AppLocalizations.of(context).tr("updatetodo")),
                  onPressed: () {
                    final form = formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _con.update(_todo.id, _title, _content);
                      Navigator.pop(context);
                    }
                  },
                ))),
          ],
        ),
      ),
    );
  }

  void pickTile(BuildContext context,
      {DatabaseActions action = DatabaseActions.insert}) {
    showTimePickerDialog(context, "Set Alarm", (dateTime) async {
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
}
