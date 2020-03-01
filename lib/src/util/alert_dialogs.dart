import 'package:flutter/material.dart';
import 'package:wishlist/src/widgets/dialogs/loader_dialog.dart';
import 'package:wishlist/src/widgets/dialogs/timepicker_dialog.dart';

void showLoaderDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return LoaderDialog();
    },
  );
}

void showTimePickerDialog(BuildContext context, String title, bool showCancel,
    Function(DateTime) onOK, VoidCallback onCancel) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return TimePickerDialog(title,
          showCancel: showCancel, onOK: onOK, onCancel: onCancel);
    },
  );
}
