import 'package:flutter/material.dart';
import 'package:sample/dialogs/generic_dialog.dart';

Future<bool> showLogOutDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Log Out',
    content: 'Are you sure you want to Log Out?',
    optionsBuilder: () => {
      'cancel': false,
      'Log out': true,
    },
  ).then((value) => value ?? false);
}
