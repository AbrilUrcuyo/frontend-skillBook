import 'package:flutter/material.dart';
import '../../../domain/entities/note.dart';
import '../../../domain/repositories/note_repository.dart';
// NOTE: DI (get_it) is configured in `core/di/injection.dart` and
// ViewModels should be retrieved via providers in the UI layer.

class NoteListViewModel extends ChangeNotifier {
  final NoteRepository _repository;

  List<Note> notes = [];
  bool isLoading = false;
  String? error;

  NoteListViewModel(this._repository);

  Future<void> loadNotes() async {
    isLoading = true;
    error = null;
    notifyListeners();

    try {
      notes = await _repository.findAll();
      // Debug log: mostrar en consola lo que nos llega del repositorio
      // Esto ayuda a verificar si los títulos/contendido vienen vacíos o con campos distintos.
      // Ejemplo de salida: "DEBUG: loaded 3 notes: [Note(id:1, title:..., content:...)]"
      try {
        // ignore: avoid_print
        print('DEBUG: loaded ${notes.length} notes: ${notes.map((n) => '{id:${n.id}, title:${n.title}, content:${n.content}}').toList()}');
      } catch (_) {}
      isLoading = false;
    } catch (e) {
      error = e.toString();
      isLoading = false;
    }
    notifyListeners();
  }

  Future<void> deleteNote(String id) async {
    try {
      await _repository.delete(id);
      notes.removeWhere((note) => note.id == id);
    } catch (e) {
      error = e.toString();
    }
    notifyListeners();
  }
}




