import 'package:http/http.dart' as http;

import '../../domain/entities/note.dart';
import '../../domain/repositories/note_repository.dart';
import '../datasources/note_remote_datasource.dart';
import '../mappers/note_mapper.dart';

class NoteRepositoryImpl implements NoteRepository {
  final NoteRemoteDataSource remoteDataSource;

  const NoteRepositoryImpl({required this.remoteDataSource});

  @override
  Future<List<Note>> findAll() async {
    final notes = await remoteDataSource.findAll();
    return notes.map((note) => note.toDomain()).toList(growable: false);
  }

  @override
  Future<Note?> findByID(String id) async {
    try {
      final note = await remoteDataSource.findByID(id);
      return note.toDomain();
    } on http.ClientException {
      return null;
    }
  }

  @override
  Future<Note> create(Note note) async {
    final created = await remoteDataSource.create(note.toDto());
    return created.toDomain();
  }

  @override
  Future<void> update(Note note) async {
    await remoteDataSource.update(note.toDto());
  }

  @override
  Future<void> delete(String id) async {
    await remoteDataSource.delete(id);
  }
}

