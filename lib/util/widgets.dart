import 'package:flutter/material.dart';

Widget buildLoader(BuildContext context) {
  return Center(
      child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(Theme.of(context).accentColor)));
}