import 'dart:convert';
import 'package:flutter/material.dart';
import '../models/product.dart';
import '../services/api_service.dart';

class ProductProvider with ChangeNotifier {
  List<Product> _products = [];
  bool _isLoading = false;
  String? _loadError;

  List<Product> get products => _products;
  bool get isLoading => _isLoading;
  String? get loadError => _loadError;

  List<Product> productsForShop(int shopId) =>
      _products.where((p) => p.shopId == shopId).toList();

  Future<void> fetchProducts() async {
    _isLoading = true;
    _loadError = null;
    notifyListeners();

    try {
      final response = await ApiService.get('products');
      if (response.statusCode == 200) {
        final List<dynamic> data = jsonDecode(response.body);
        _products = data.map((json) => Product.fromJson(json)).toList();
      } else {
        _loadError = ApiService.errorMessage(response);
      }
    } catch (e) {
      debugPrint('Error fetching products: $e');
      _loadError = 'Cannot connect to server. Check your internet connection.';
    }

    _isLoading = false;
    notifyListeners();
  }

  // The CRUD methods return null on success, or an error message to show.

  Future<String?> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await ApiService.post('products', data);
      if (response.statusCode == 201) {
        _products.insert(0, Product.fromJson(jsonDecode(response.body)));
        notifyListeners();
        return null;
      }
      return ApiService.errorMessage(response, 'Failed to create product');
    } catch (e) {
      debugPrint('Create Product Error: $e');
      return 'Cannot connect to server. Check your internet connection.';
    }
  }

  Future<String?> updateProduct(int id, Map<String, dynamic> data) async {
    try {
      final response = await ApiService.put('products/$id', data);
      if (response.statusCode == 200) {
        final updated = Product.fromJson(jsonDecode(response.body));
        final index = _products.indexWhere((p) => p.id == id);
        if (index != -1) _products[index] = updated;
        notifyListeners();
        return null;
      }
      return ApiService.errorMessage(response, 'Failed to update product');
    } catch (e) {
      debugPrint('Update Product Error: $e');
      return 'Cannot connect to server. Check your internet connection.';
    }
  }

  Future<String?> deleteProduct(int id) async {
    try {
      final response = await ApiService.delete('products/$id');
      if (response.statusCode == 200) {
        _products.removeWhere((p) => p.id == id);
        notifyListeners();
        return null;
      }
      return ApiService.errorMessage(response, 'Failed to delete product');
    } catch (e) {
      debugPrint('Delete Product Error: $e');
      return 'Cannot connect to server. Check your internet connection.';
    }
  }
}
