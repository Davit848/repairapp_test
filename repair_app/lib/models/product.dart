import 'shop.dart';

class Product {
  final int id;
  final int shopId;
  final String name;
  final double price;
  final int stock;
  final String description;
  final String? image;
  final String vehicleType;
  final String category;
  final Shop? shop;

  Product({
    required this.id,
    required this.shopId,
    required this.name,
    required this.price,
    required this.stock,
    required this.description,
    this.image,
    required this.vehicleType,
    required this.category,
    this.shop,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'],
      shopId: json['shop_id'],
      name: json['name'],
      price: double.parse(json['price'].toString()),
      stock: int.parse(json['stock'].toString()),
      description: json['description'],
      image: json['image'],
      vehicleType: json['vehicle_type'],
      category: json['category'],
      shop: json['shop'] != null ? Shop.fromJson(json['shop']) : null,
    );
  }
}