import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:wishlist/src/Controller.dart';
import 'package:wishlist/util/AppKeys.dart';

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

  final Con _con = Con.con;
  String _task;
  String _note;

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
                  )),
              TextFormField(
                initialValue: '',
                key: AppKeys.noteField,
                maxLines: 10,
                style: Theme.of(context).textTheme.subhead,
                decoration: InputDecoration(
                  hintText: AppLocalizations.of(context).tr('nothint'),
                ),
                onSaved: (value) => _note = value,
              )
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        key: AppKeys.saveTodoFab,
        tooltip: AppLocalizations.of(context).tr('saveChanges'),
        child: Icon(isEditing ? Icons.check : Icons.add),
        onPressed: () {
          final form = formKey.currentState;
          if (form.validate()) {
            form.save();
            Navigator.pop(context);
          }
        },
      ),
    );
  }

  bool get isEditing => widget.todoId != null;
}
