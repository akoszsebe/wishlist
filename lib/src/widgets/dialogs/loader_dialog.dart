import 'package:flutter/material.dart';

class LoaderDialog extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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
  }
}
