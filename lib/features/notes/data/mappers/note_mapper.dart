import '../../domain/entities/note.dart';
import '../dto/note_dto.dart';

extension NoteDtoMapper on NoteDto {
  Note toDomain() => toEntity();
}

extension NoteDomainMapper on Note {
  NoteDto toDto() => NoteDto.fromEntity(this);
}

