import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;
  // Message from the last failed login/register, ready to show to the user
  String? get errorMessage => _errorMessage;

  AuthProvider() {
    _loadStoredAuth();
  }

  Future<void> _loadStoredAuth() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');
      final userJson = prefs.getString('user_data');
      if (userJson != null && userJson.isNotEmpty) {
        _user = User.fromJson(jsonDecode(userJson));
      }
    } catch (e) {
      debugPrint('Load Stored Auth Error: $e');
    }
    notifyListeners();
    // Sync with the server so cached user data (e.g. shop) is never stale
    if (_token != null) await fetchUserProfile();
  }

  // Fetch latest user profile (including shop data) without re-logging in
  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');

      if (_token == null) return;

      final response = await ApiService.get('user');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          _user = User.fromJson(data);
          await prefs.setString('user_data', jsonEncode(data));
          notifyListeners();
        }
      } else if (response.statusCode == 401) {
        // Token expired or revoked on the server
        await _clearSession();
      }
    } catch (e) {
      debugPrint('Fetch User Profile Error: $e');
    }
  }

  Future<bool> login(String email, String password) {
    return _authenticate('login', {
      'email': email,
      'password': password,
    });
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
    String passwordConfirmation,
  ) {
    return _authenticate('register', {
      'name': name,
      'email': email,
      'phone': phone,
      'password': password,
      'password_confirmation': passwordConfirmation,
    });
  }

  Future<bool> _authenticate(String endpoint, Map<String, dynamic> body) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await ApiService.post(endpoint, body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        final data = jsonDecode(response.body);
        _token = data['access_token'] ?? data['token'];
        if (data['user'] != null) {
          _user = User.fromJson(data['user']);
        }

        final prefs = await SharedPreferences.getInstance();
        if (_token != null) {
          await prefs.setString('auth_token', _token!);
        }
        if (data['user'] != null) {
          await prefs.setString('user_data', jsonEncode(data['user']));
        }

        _isLoading = false;
        notifyListeners();
        return true;
      }
      _errorMessage = ApiService.errorMessage(response);
    } catch (e) {
      debugPrint('$endpoint Exception: $e');
      _errorMessage = 'Cannot connect to server. Check your internet connection.';
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    try {
      await ApiService.post('logout', {});
    } catch (_) {}
    await _clearSession();
  }

  Future<void> _clearSession() async {
    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    notifyListeners();
  }
}
