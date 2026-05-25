import 'package:get_it/get_it.dart';
import 'package:http/http.dart' as http;

import '../../features/notes/data/datasources/note_remote_datasource.dart';
import '../../features/notes/data/remote/note_service.dart';
import '../../features/notes/data/repositories/note_repository_impl.dart';
import '../../features/notes/domain/repositories/note_repository.dart';
import '../network/api_client.dart';

final getIt = GetIt.instance;

/// Inicializa todas las dependencias de la aplicación usando GetIt.
/// 
/// Llamar en main() antes de runApp():
/// ```dart
/// void main() {
///   setupInjection(apiBaseUrl: 'http://tu-backend.com');
///   runApp(const MyApp());
/// }
/// ```
void setupInjection({required String apiBaseUrl}) {
  // ========== Network ==========
  getIt.registerSingleton<ApiClient>(
    ApiClient(baseUrl: apiBaseUrl),
  );

  getIt.registerSingleton<http.Client>(
    http.Client(),
  );

  // ========== Services ==========
  getIt.registerSingleton<NoteService>(
    NoteService(
      baseUrl: getIt<ApiClient>().baseUrlValue,
      client: getIt<http.Client>(),
    ),
  );

  // ========== Data Sources ==========
  getIt.registerSingleton<NoteRemoteDataSource>(
    NoteRemoteDataSourceImpl(service: getIt<NoteService>()),
  );

  // ========== Repositories ==========
  getIt.registerSingleton<NoteRepository>(
    NoteRepositoryImpl(remoteDataSource: getIt<NoteRemoteDataSource>()),
  );
}




