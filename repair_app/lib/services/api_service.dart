import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class ApiService {
  // Android emulator reaches your PC's localhost through 10.0.2.2.
  // On a physical phone, run with your PC's Wi-Fi IP, e.g.:
  //   flutter run --dart-define=API_URL=http://192.168.1.X:8000/api
  // (and start Laravel with: php artisan serve --host=0.0.0.0)
  static const String _apiUrlOverride = String.fromEnvironment('API_URL');
  static String get baseUrl {
    if (_apiUrlOverride.isNotEmpty) return _apiUrlOverride;
    if (!kIsWeb && defaultTargetPlatform == TargetPlatform.android) {
      return 'http://10.0.2.2:8000/api';
    }
    return 'http://127.0.0.1:8000/api';
  }
  // Helper method to get stored Sanctum token
  static Future<String?> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('auth_token');
  }

  // Generic GET request
  static Future<http.Response> get(String endpoint) async {
    final token = await _getToken();
    return await http.get(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }

  // Generic POST request
  static Future<http.Response> post(String endpoint, Map<String, dynamic> data) async {
    final token = await _getToken();
    return await http.post(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  // Generic PUT request
  static Future<http.Response> put(String endpoint, Map<String, dynamic> data) async {
    final token = await _getToken();
    return await http.put(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
      body: jsonEncode(data),
    );
  }

  // Turns a Laravel error response into a message the user can understand
  static String errorMessage(http.Response response, [String fallback = 'Something went wrong. Please try again.']) {
    try {
      final data = jsonDecode(response.body);
      final errors = data['errors'];
      if (errors is Map && errors.isNotEmpty) {
        final first = errors.values.first;
        if (first is List && first.isNotEmpty) return first.first.toString();
      }
      if (data['message'] != null) return data['message'].toString();
    } catch (_) {}
    if (response.statusCode >= 500) return 'Server error. Please try again later.';
    return fallback;
  }

  // Generic DELETE request
  static Future<http.Response> delete(String endpoint) async {
    final token = await _getToken();
    return await http.delete(
      Uri.parse('$baseUrl/$endpoint'),
      headers: {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
        if (token != null) 'Authorization': 'Bearer $token',
      },
    );
  }
}