import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/shop.dart';
import '../services/api_service.dart';

class ShopProvider with ChangeNotifier {
  List<Shop> _shops = [];
  bool _isLoading = false;

  List<Shop> get shops => _shops;
  bool get isLoading => _isLoading;

  Future<void> fetchShops() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await ApiService.get('shops');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _shops = data.map((json) => Shop.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint('Error fetching shops: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  // Returns null on success, or an error message to show.
  Future<String?> createShop(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('shops', data);
      if (response.statusCode == 201) {
        _shops.add(Shop.fromJson(jsonDecode(response.body)));
        notifyListeners();
        return null;
      }
      return ApiService.errorMessage(response, 'Failed to create shop');
    } catch (e) {
      debugPrint('Create Shop Error: $e');
      return 'Cannot connect to server. Check your internet connection.';
    }
  }

  // Returns null on success, or an error message to show.
  Future<String?> updateShop(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('shops/$id', data);
      if (response.statusCode == 200) {
        final updated = Shop.fromJson(jsonDecode(response.body));
        final index = _shops.indexWhere((s) => s.id == id);
        if (index != -1) _shops[index] = updated;
        notifyListeners();
        return null;
      }
      return ApiService.errorMessage(response, 'Failed to update shop');
    } catch (e) {
      debugPrint('Update Shop Error: $e');
      return 'Cannot connect to server. Check your internet connection.';
    }
  }
}
