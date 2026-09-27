import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import '../services/api_service.dart';

class AuthProvider with ChangeNotifier {
  User? _user;
  String? _token;
  bool _isLoading = false;

  User? get user => _user;
  String? get token => _token;
  bool get isAuthenticated => _token != null;
  bool get isLoading => _isLoading;

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
  }

  // Fetch latest user profile (including shop data) without re-logging in
  Future<void> fetchUserProfile() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      _token = prefs.getString('auth_token');

      if (_token == null) return;

      final response = await http.get(
        Uri.parse('http://127.0.0.1:8000/api/user'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Accept': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data != null) {
          _user = User.fromJson(data);
          await prefs.setString('user_data', jsonEncode(data));
          notifyListeners();
        }
      }
    } catch (e) {
      debugPrint('Fetch User Profile Error: $e');
    }
  }

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('login', {
        'email': email,
        'password': password,
      });

      debugPrint('Login Status: ${response.statusCode}');
      debugPrint('Login Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      } else {
        debugPrint('Login Failed Message: ${data['message'] ?? response.body}');
      }
    } catch (e) {
      debugPrint('Login Exception: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<bool> register(
    String name,
    String email,
    String phone,
    String password,
  ) async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.post('register', {
        'name': name,
        'email': email,
        'phone': phone,
        'password': password,
      });

      debugPrint('Register Status: ${response.statusCode}');
      debugPrint('Register Body: ${response.body}');

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
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
      } else {
        debugPrint(
          'Register Failed Message: ${data['message'] ?? response.body}',
        );
      }
    } catch (e) {
      debugPrint('Register Exception: $e');
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  Future<void> logout() async {
    try {
      await ApiService.post('logout', {});
    } catch (_) {}

    _token = null;
    _user = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('auth_token');
    await prefs.remove('user_data');
    notifyListeners();
  }
}