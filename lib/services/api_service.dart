import 'dart:typed_data';

/// Backend adapter for the standalone TEST demo app.
///
/// Network access is intentionally disabled. This class keeps the existing
/// screen interfaces compiling while making every former backend operation
/// a local no-op. Connect a new, separately owned backend before enabling
/// account, loan, document, or other server-backed features.
class ApiService {
  static Future<dynamic> get(String endPoint, {String token = ''}) async {
    return null;
  }

  static Future<dynamic> post(
    String endPoint, {
    required Map<String, dynamic> data,
    String token = '',
  }) async {
    return null;
  }

  static Future<Uint8List?> fetchPdfBytes(
    String endPoint, {
    String token = '',
  }) async {
    return null;
  }
}
