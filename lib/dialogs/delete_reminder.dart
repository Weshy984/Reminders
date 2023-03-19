import 'package:flutter/material.dart';
import 'package:sample/dialogs/generic_dialog.dart';

Future<bool> showDeleteReminderDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete reminder',
    content:
        'Are you sure you want to delete this reminder? the action cannot be undone?',
    optionsBuilder: () => {
      'cancel': false,
      'Delete Reminder': true,
    },
  ).then((value) => value ?? false);
}
