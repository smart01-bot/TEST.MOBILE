import 'dart:convert';
import 'dart:typed_data';
import 'package:http/http.dart' as http;

import '../../config.dart';

class ApiService {
  static final _headers = {
    'x-ci-api-key': AppConfig.apiKey,
    'Content-Type': 'application/json',
  };

  static Future get(String endPoint, { String token = ''}) async {
    try {
      final response = await http.get(
        Uri.parse("${AppConfig.apiUrl}$endPoint"),
        headers: {
          ..._headers,
          'x-auth-token': token,
        },
      );

      if (response.body.isNotEmpty) {
        return json.decode(response.body); // Return the decoded JSON response
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future post(String endPoint,
      {required Map<String, dynamic> data, String token = ''}) async {
    try {
      final response = await http.post(
        Uri.parse("${AppConfig.apiUrl}$endPoint"),
        headers: {
          ..._headers,
          'x-auth-token': token,
        },
        body: json.encode(data), // Encode the data to JSON
      );

      if (response.body.isNotEmpty) {
        return json.decode(response.body); // Return the decoded JSON response
      } else {
        return null;
      }
    } catch (e) {
      return null;
    }
  }

  static Future<Uint8List?> fetchPdfBytes(String endPoint, {String token = ''}) async {
  try {
    final response = await http.get(
      Uri.parse("${AppConfig.apiUrl}$endPoint"),
      headers: {
        ..._headers,
        'x-auth-token': token,
        // Optional: omit 'Content-Type' if backend uses Accept headers
      },
    );

    if (response.statusCode == 200 &&
        response.headers['content-type'] == 'application/pdf') {
      return response.bodyBytes;
    } else {
      return null;
    }
  } catch (e) {
    return null;
  }
}

}
