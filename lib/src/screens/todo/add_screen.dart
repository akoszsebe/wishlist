import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/screens/todo/todo_controller.dart';
import 'package:wishlist/util/app_keys.dart';

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

  @override
  Widget build(BuildContext context) {
    /// Return the 'universally recognized' Map object.
    /// The data will only be known through the use of Map objects.

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context).tr('addtitle')),
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
                      color: Theme.of(context).cardColor,
                      borderRadius: new BorderRadius.circular(12.0)),
                  child: Column( children: <Widget>[buildTitleFormFieled(),buildContentFormFieled()])
                )),
            Container(
                margin: EdgeInsets.only(bottom: 16),
                height: 60,
                child: Center(
                    child: FloatingActionButton.extended(
                  key: AppKeys.saveTodoFab,
                  backgroundColor: Theme.of(context).accentColor,
                  tooltip: AppLocalizations.of(context).tr('saveChanges'),
                  icon: Icon(Icons.add),
                  label: Text(AppLocalizations.of(context).tr("addtodo")),
                  onPressed: () {
                    final form = formKey.currentState;
                    if (form.validate()) {
                      form.save();
                      _con.saveTodo(_title, _content);
                      Navigator.pop(context);
                    }
                  },
                ))),
          ],
        ),
      ),
    );
  }

  bool get isEditing => widget.todoId != null;

  Widget buildTitleFormFieled() {
    return TextFormField(
      initialValue: "",
      key: AppKeys.taskField,
      style: Theme.of(context).textTheme.headline,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('newTodotite'),
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
    );
  }

  Widget buildContentFormFieled() {
    return TextFormField(
      initialValue: '',
      key: AppKeys.noteField,
      maxLines: 15,
      style: Theme.of(context).textTheme.subhead,
      decoration: InputDecoration(
          border: InputBorder.none,
          hintText: AppLocalizations.of(context).tr('contenttext'),
          contentPadding: EdgeInsets.all(16),
          labelText: AppLocalizations.of(context).tr('content')),
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
}
