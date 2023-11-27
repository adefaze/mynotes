import 'package:flutter/material.dart';
import 'package:notesapp/services/auth/auth_service.dart';
import 'package:notesapp/services/crud/notes_service.dart';

class NewNoteView extends StatefulWidget {
  const NewNoteView({super.key});

  @override
  State<NewNoteView> createState() => _NewNoteViewState();
}

class _NewNoteViewState extends State<NewNoteView> {
  DatabaseNote? _note;
  late final NotesService _notesService;
  late final TextEditingController _textController;

  // init state
  @override
  void initState() {
    _notesService = NotesService();
    _textController = TextEditingController();
    super.initState();
  }

  // update current note upon text changes
  void _textControllerListener() async {
    final note = _note;
    if (note == null) {
      return;
    }
    final text = _textController.text;
    await _notesService.updateNote(
      note: note,
      text: text,
    );
  }

  void _setupTextcontrollerListerner() {
    _textController.removeListener(_textControllerListener);
    _textController.addListener(_textControllerListener);
  }

  Future<DatabaseNote> createNewNote() async {
    // check if the note has been created
    final existingNote = _note;
    if (existingNote != null) {
      return existingNote;
    }

    // get current user
    final currentUser = AuthService.firebase().currentUser!;
    final email = currentUser.email!;
    final owner = await _notesService.getUser(email: email);
    return _notesService.createNote(owner: owner);
  }

  //  upon disposal, delete note is text is empty
  void _deleteNoteIfTextIsEmpty() {
    final note = _note;
    final text = _textController.text;
    if (text.isEmpty && note != null) {
      _notesService.deleteNote(id: note.id);
    }
  }

  // save note if text is not exmpty
  void _saveNoteIfTextNotEmpty() async {
    final note = _note;
    final text = _textController.text;
    if (note != null && text.isNotEmpty) {
      await _notesService.updateNote(
        note: note,
        text: text,
      );
    }
  }

  @override
  void dispose() {
    _deleteNoteIfTextIsEmpty();
    _saveNoteIfTextNotEmpty();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('New Note'),
        ),
        body: FutureBuilder(
            future: createNewNote(),
            builder: (context, snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.done:
                  // if (snapshot.hasError || snapshot.data == null) {
                  //   // Handle error or null data
                  //   return const Text('Error creating note');
                  // }
                  _note = snapshot.data as DatabaseNote?;
                  _setupTextcontrollerListerner();
                  return TextField(
                    controller: _textController,
                    keyboardType: TextInputType.multiline,
                    maxLines: null,
                    decoration: const InputDecoration(
                        hintText: 'Start typing your note'),
                  );
                default:
                  return const CircularProgressIndicator();
              }
            }));
  }
}
