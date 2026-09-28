import 'package:flutter/material.dart';

import 'shop.dart';

enum VehicleType {
  motorcycle('Motorcycle', Icons.two_wheeler),
  car('Car', Icons.directions_car),
  universal('Universal', Icons.bolt);

  const VehicleType(this.label, this.icon);

  final String label;
  final IconData icon;
}

enum PartCategory {
  brakePads('Brake Pads', 'Brake System'),
  engineOil('Engine Oil', 'Engine Oil'),
  filters('Air & Oil Filters', 'Air Filters'),
  batteries('Batteries', 'Electrical'),
  tires('Tires', 'Tires'),
  sparkPlugs('Spark Plugs', 'Ignition');

  const PartCategory(this.label, this.group);

  /// Filter pill label.
  final String label;

  /// Eyebrow label shown on part cards.
  final String group;
}

class SparePart {
  const SparePart({
    required this.id,
    required this.name,
    required this.category,
    required this.vehicleType,
    required this.fitment,
    required this.price,
    required this.priceNote,
    required this.stock,
    required this.shop,
    required this.image,
    this.description = '',
    this.isLive = true,
  });

  static const lowStockThreshold = 5;

  final String id;
  final String name;
  final PartCategory category;
  final VehicleType vehicleType;
  final String fitment;
  final double price;
  final String priceNote;
  final int stock;
  final Shop shop;
  final String image;
  final String description;
  final bool isLive;

  bool get isLowStock => stock <= lowStockThreshold;

  String get stockLabel => isLowStock ? 'Only $stock' : '$stock left';

  SparePart copyWith({
    String? name,
    PartCategory? category,
    VehicleType? vehicleType,
    String? fitment,
    double? price,
    int? stock,
    String? description,
  }) {
    return SparePart(
      id: id,
      name: name ?? this.name,
      category: category ?? this.category,
      vehicleType: vehicleType ?? this.vehicleType,
      fitment: fitment ?? this.fitment,
      price: price ?? this.price,
      priceNote: priceNote,
      stock: stock ?? this.stock,
      shop: shop,
      image: image,
      description: description ?? this.description,
      isLive: isLive,
    );
  }
}
