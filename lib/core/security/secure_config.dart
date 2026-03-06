/// Utilidades de seguridad para red y configuración
/// Excepción cuando una URL no cumple requisitos de seguridad (ej. no es HTTPS).
class InsecureUrlException implements Exception {
  InsecureUrlException(this.url);
  final String url;
  @override
  String toString() => 'InsecureUrlException: URL debe usar HTTPS ($url)';
}

/// Valida que la [url] sea HTTPS. Si no lo es, lanza [InsecureUrlException].
/// Usar para baseUrl de APIs y evitar envío accidental por HTTP.
String ensureHttps(String url) {
  final trimmed = url.trim();
  if (trimmed.isEmpty) {
    throw ArgumentError('URL de API no puede estar vacía');
  }
  if (!trimmed.toLowerCase().startsWith('https://')) {
    throw InsecureUrlException(trimmed);
  }
  return trimmed;
}
