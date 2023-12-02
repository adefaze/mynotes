import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<bool> shouldDeleteDialog(BuildContext context) {
  return showGenericDialog<bool>(
    context: context,
    title: 'Delete note',
    content: 'Are you sure you want to delete note?',
    optionsBuilder: () => {
      'Cancel': false,
      'Delete': true,
    },
  ).then((value) => value ?? false);
}
