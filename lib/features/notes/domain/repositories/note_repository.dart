import '../entities/note.dart';

abstract class NoteRepository {
  /// Obtiene todas las notas
  Future<List<Note>> findAll();

  /// Obtiene una nota por su ID
  Future<Note?> findByID(String id);

  /// Crea una nueva nota
  /// Retorna la nota creada con su ID asignado
  Future<Note> create(Note note);

  /// Actualiza una nota existente
  Future<void> update(Note note);

  /// Elimina una nota por su ID
  Future<void> delete(String id);
}

