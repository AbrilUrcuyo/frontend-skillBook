import '../../domain/entities/note.dart';

class NoteDto {
  final int id;
  final String title;
  final String content;

  const NoteDto({
    required this.id,
    required this.title,
    required this.content,
  });

  factory NoteDto.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'];
    return NoteDto(
      id: rawId is int ? rawId : int.tryParse(rawId?.toString() ?? '') ?? 0,
      title: json['title'] as String? ?? '',
      content: json['content'] as String? ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'content': content,
    };
  }

  NoteDto copyWith({
    int? id,
    String? title,
    String? content,
  }) {
    return NoteDto(
      id: id ?? this.id,
      title: title ?? this.title,
      content: content ?? this.content,
    );
  }

  Note toEntity() {
    return Note(
      id: id.toString(),
      title: title,
      content: content,
    );
  }

  factory NoteDto.fromEntity(Note note) {
    return NoteDto(
      id: int.tryParse(note.id) ?? 0,
      title: note.title,
      content: note.content,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        other is NoteDto &&
            runtimeType == other.runtimeType &&
            id == other.id &&
            title == other.title &&
            content == other.content;
  }

  @override
  int get hashCode => Object.hash(id, title, content);
}


