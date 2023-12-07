import 'package:flutter/material.dart';
import 'package:notesapp/utilities/dialogs/generic_dialog.dart';

Future<void> showCannotShareEmptyNoteDialog(BuildContext context) {
  return showGenericDialog(
      context: context,
      title: 'Sharing',
      content: 'Could not share empty note',
      optionsBuilder: () => {
            'OK': null,
          });
}
