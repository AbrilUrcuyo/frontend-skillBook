import '../dto/note_dto.dart';
import '../remote/note_service.dart';

abstract class NoteRemoteDataSource {
  Future<List<NoteDto>> findAll();
  Future<NoteDto> findByID(String id);
  Future<NoteDto> create(NoteDto note);
  Future<NoteDto> update(NoteDto note);
  Future<void> delete(String id);
}

class NoteRemoteDataSourceImpl implements NoteRemoteDataSource {
  final NoteService service;

  const NoteRemoteDataSourceImpl({required this.service});

  @override
  Future<List<NoteDto>> findAll() => service.findAll();

  @override
  Future<NoteDto> findByID(String id) => service.findByID(id);

  @override
  Future<NoteDto> create(NoteDto note) => service.create(note);

  @override
  Future<NoteDto> update(NoteDto note) => service.update(note);

  @override
  Future<void> delete(String id) => service.delete(id);
}

