import 'dart:convert';

import 'package:http/http.dart' as http;

import '../dto/note_dto.dart';

/// Service HTTP para `Note` usando rutas REST/OpenAPI estándar.
///
/// Endpoints:
/// - GET    /notes
/// - GET    /notes/{id}
/// - POST   /notes
/// - PUT    /notes/{id}
/// - DELETE /notes/{id}
class NoteService {
  final String baseUrl;
  final http.Client _client;

  static const String _resourcePath = '/notes';

  NoteService({
    required this.baseUrl,
    http.Client? client,
  }) : _client = client ?? http.Client();

  Uri _collectionUri() => Uri.parse('$baseUrl$_resourcePath');

  Uri _itemUri(String id) => Uri.parse('$baseUrl$_resourcePath/$id');

  Future<List<NoteDto>> findAll() async {
    final response = await _client.get(
      _collectionUri(),
      headers: const {'Accept': 'application/json'},
    );

    _ensureSuccess(response, expected: 200);

    final decoded = jsonDecode(response.body);
    if (decoded is! List) {
      throw const FormatException('Se esperaba una lista JSON en findAll().');
    }

    return decoded
        .cast<Map<String, dynamic>>()
        .map(NoteDto.fromJson)
        .toList(growable: false);
  }

  Future<NoteDto> findByID(String id) async {
    final response = await _client.get(
      _itemUri(id),
      headers: const {'Accept': 'application/json'},
    );

    _ensureSuccess(response, expected: 200);

    return NoteDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<NoteDto> create(NoteDto note) async {
    final response = await _client.post(
      _collectionUri(),
      headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(_writeBody(note)),
    );

    // Accept 201 (created) but also 200 in case the backend returns 200 on create.
    _ensureSuccess(response, expected: [200, 201]);

    return NoteDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<NoteDto> update(NoteDto note) async {
    final response = await _client.put(
      _itemUri(note.id.toString()),
      headers: const {'Content-Type': 'application/json', 'Accept': 'application/json'},
      body: jsonEncode(_writeBody(note)),
    );

    _ensureSuccess(response, expected: 200);

    return NoteDto.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
  }

  Future<void> delete(String id) async {
    final response = await _client.delete(
      _itemUri(id),
      headers: const {'Accept': 'application/json'},
    );

    // Algunos backends responden 200 en DELETE exitoso; OpenAPI comúnmente usa 204.
    _ensureSuccess(response, expected: [200, 204]);
  }

  void _ensureSuccess(http.Response response, {required Object expected}) {
    // `expected` can be a single int (e.g. 200) or an Iterable<int> (e.g. [200, 201]).
    final List<int> expectedCodes = expected is Iterable<int>
        ? expected.cast<int>().toList()
        : <int>[expected as int];

    if (expectedCodes.contains(response.statusCode)) return;

    throw http.ClientException(
      'Error HTTP ${response.statusCode} en ${response.request?.method} ${response.request?.url}',
      response.request?.url,
    );
  }

  Map<String, dynamic> _writeBody(NoteDto note) {
    return {
      'title': note.title,
      'content': note.content,
    };
  }
}


