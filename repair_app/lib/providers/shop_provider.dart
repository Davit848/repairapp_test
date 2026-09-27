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
}