import 'package:flutter/material.dart';

import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';

class NoteDetailViewModel extends ChangeNotifier {
  final NoteRepository _repository;

  Note? note;
  bool isLoading = false;
  String? error;
  bool isSuccess = false;

  NoteDetailViewModel(this._repository);

  Future<void> loadNote(String id) async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      note = await _repository.findByID(id);
      if (note == null) {
        error = 'Nota no encontrada';
      }
      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try {
      await _repository.delete(id);
      isLoading = false;
      isSuccess = true;
      note = null;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> createNote({
    required String title,
    required String content,
  }) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try {
      final newNote = Note(
        id: '', // El backend asignará el ID
        title: title,
        content: content,
      );
      note = await _repository.create(newNote);
      isLoading = false;
      isSuccess = true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> updateNote({
    required String id,
    required String title,
    required String content,
  }) async {
    isLoading = true;
    error = null;
    isSuccess = false;
    notifyListeners();

    try {
      final updatedNote = Note(
        id: id,
        title: title,
        content: content,
      );
      await _repository.update(updatedNote);
      note = updatedNote;
      isLoading = false;
      isSuccess = true;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  void resetState() {
    note = null;
    isLoading = false;
    error = null;
    isSuccess = false;
    notifyListeners();
  }
}





