import 'package:flutter/material.dart';
import '../models/note.dart';
import '../services/note_service.dart';

class NoteProvider with ChangeNotifier {
  final NoteService _noteService = NoteService();
  List<Note> _notes = [];

  List<Note> get notes => _notes;

  NoteProvider() {
    fetchNotes();
  }

  // Listen to changes from Firestore
  void fetchNotes() {
    _noteService.getNotes().listen((notesData) {
      _notes = notesData;
      notifyListeners();
    });
  }

  Future<void> addNote(Note note) async {
    await _noteService.addNote(note);
  }

  Future<void> updateNote(Note note) async {
    await _noteService.updateNote(note);
  }

  Future<void> deleteNote(String id) async {
    await _noteService.deleteNote(id);
  }
}
