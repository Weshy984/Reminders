import 'package:flutter/material.dart';
import 'package:sample/dialogs/generic_dialog.dart';

Future<bool> showDeleteAccountDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete Account!!!',
    content:
        'Are you sure you want to perform this action!! This operation cannot be undone!!',
    optionsBuilder: () => {
      'cancel': false,
      'Delete Account': true,
    },
  ).then((value) => value ?? false);
}
