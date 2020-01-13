import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

void showAlertDialog(BuildContext context, String title, String content,
    VoidCallback onOK, VoidCallback onEdit) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: Theme.of(context).primaryColor,
        title: Center(
            child: new Text(
          title,
        )),
        content: new Text(
          content,
          textAlign: TextAlign.center,
        ),
        actions: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width - 96,
              child: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    new FlatButton(
                      child: new Text("Edit"),
                      onPressed: () {
                        onEdit();
                        Navigator.of(context).pop();
                      },
                    ),
                    Container(
                      height: 20.0,
                      width: 1.0,
                      color: Theme.of(context).primaryIconTheme.color,
                      margin: const EdgeInsets.only(left: 25.0, right: 15.0),
                    ),
                    new FlatButton(
                      child: new Text("Alert"),
                      onPressed: () {
                        onOK();
                        Navigator.of(context).pop();
                      },
                    ),
                  ])),
        ],
      );
    },
  );
}

void showLoaderDialog(BuildContext context) {
  // flutter defined function
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(32.0))),
          backgroundColor: Theme.of(context).primaryColor,
          content: Container(
              height: 50,
              child: Center(
                  child: SizedBox(
                      height: 40,
                      width: 40,
                      child: CircularProgressIndicator()))));
    },
  );
}

void showTimePickerDialog(
    BuildContext context, String title, Function(DateTime) onOK) {
      var _dateTime = DateTime.now();
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.all(Radius.circular(32.0))),
        backgroundColor: Theme.of(context).primaryColor,
        content: Container(
          height: 220,
          child: DateTimePickerWidget(
            minDateTime: DateTime.parse(DateTime.now().toString()),
                maxDateTime: DateTime.parse(DateTime.now().add(Duration(days: 7)).toString()),
                initDateTime: _dateTime,
                dateFormat: 'yyyy-MM-dd HH:mm',
                pickerTheme: DateTimePickerTheme(
                  backgroundColor: Colors.transparent,
                  itemHeight: 50,
                  title: Text(title),
                  pickerHeight: 200,
                  confirmTextStyle: TextStyle(color: Theme.of(context).textTheme.display1.color),
                  itemTextStyle: TextStyle(color: Theme.of(context).textTheme.display1.color)
                ),
            onChange: (dateTime, selectedIndex) {
                _dateTime = dateTime;
            },
          ),
        ),
        actions: <Widget>[
          Container(
              width: MediaQuery.of(context).size.width - 96,
              child: Center(child: 
                    new FlatButton(
                      child: new Text("Ok"),
                      onPressed: () {
                        onOK(_dateTime);
                        Navigator.of(context).pop();
                      },
                    ),
                  )),
        ],
      );
    },
  );
}
