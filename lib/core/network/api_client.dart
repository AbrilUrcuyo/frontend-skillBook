
/// Configuración centralizada del cliente HTTP para toda la aplicación.
///
/// En futuras versiones puede cambiar de `http` a `dio` sin necesidad
/// de modificar el código del rest de la app, ya que todas las operaciones
/// pasan por aquí.
class ApiClient {
  final String baseUrl;

  ApiClient({required this.baseUrl});

  String get baseUrlValue => baseUrl;
}





