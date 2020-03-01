import 'package:flutter/material.dart';
import 'package:flutter_cupertino_date_picker/flutter_cupertino_date_picker.dart';

class TimePickerDialog extends StatelessWidget {
  final String title;
  final bool showCancel;
  final Function(DateTime) onOK;
  final VoidCallback onCancel;

  TimePickerDialog(this.title,
      {this.showCancel = false, this.onOK, this.onCancel});

  @override
  Widget build(BuildContext context) {
    var _dateTime = DateTime.now();
    return AlertDialog(
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(32.0))),
      backgroundColor: Theme.of(context).primaryColor,
      content: Container(
        height: 220,
        child: DateTimePickerWidget(
          minDateTime: DateTime.parse(DateTime.now().toString()),
          maxDateTime:
              DateTime.parse(DateTime.now().add(Duration(days: 7)).toString()),
          initDateTime: _dateTime,
          dateFormat: 'yyyy-MM-dd HH:mm',
          pickerTheme: DateTimePickerTheme(
              backgroundColor: Colors.transparent,
              itemHeight: 50,
              title: Text(title),
              pickerHeight: 200,
              confirmTextStyle:
                  TextStyle(color: Theme.of(context).textTheme.display1.color),
              itemTextStyle:
                  TextStyle(color: Theme.of(context).textTheme.display1.color)),
          onChange: (dateTime, selectedIndex) {
            dateTime = DateTime(dateTime.year, dateTime.month, dateTime.day,
                dateTime.hour, dateTime.minute);
            print(dateTime);
            _dateTime = dateTime;
          },
        ),
      ),
      actions: <Widget>[
        Container(
          width: MediaQuery.of(context).size.width - 96,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: <Widget>[
              if (showCancel)
                new FlatButton(
                  textColor: Theme.of(context).primaryColorDark,
                  child: new Text("Delete Existing"),
                  onPressed: () {
                    Navigator.of(context).pop();
                    onCancel();
                  },
                ),
              new FlatButton(
                textColor: Theme.of(context).accentColor,
                child: new Text("Set New"),
                onPressed: () {
                  Navigator.of(context).pop();
                  onOK(_dateTime);
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
