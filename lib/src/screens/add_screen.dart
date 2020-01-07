import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/todo_controller.dart';
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
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Form(
          key: formKey,
          autovalidate: false,
          onWillPop: () {
            return Future(() => true);
          },
          child: ListView(
            children: [
              TextFormField(
                initialValue: '',
                key: AppKeys.taskField,
                autofocus: isEditing ? false : true,
                style: Theme.of(context).textTheme.headline,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).tr('newTodoHint'),
                ),
                onSaved: (value) => _title = value,
                validator: (String arg) {
                  if (arg.length < 3)
                    return 'Title must be more than 2 charater';
                  else
                    return null;
                },
              ),
              TextFormField(
                initialValue: '',
                key: AppKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).tr('nothint'),
                ),
                onSaved: (value) => _content = value,
                validator: (String arg) {
                  if (arg.length < 3)
                    return 'Content must be more than 2 charater';
                  else
                    return null;
                },
              )
            ],
          ),
        ),
      ),
      floatingActionButton: Container(
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
    );
  }

  bool get isEditing => widget.todoId != null;
}
