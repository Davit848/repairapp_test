import 'package:flutter/material.dart';

enum ShopType {
  motorcycleRepair('Motorcycle Repair', Icons.two_wheeler),
  carGarage('Car Garages', Icons.directions_car),
  partsStore('Spare Parts', Icons.inventory_2_outlined);

  const ShopType(this.label, this.icon);

  final String label;
  final IconData icon;
}

class Shop {
  const Shop({
    required this.id,
    required this.name,
    required this.shortName,
    required this.types,
    required this.rating,
    required this.reviewCount,
    required this.distanceKm,
    required this.address,
    required this.phone,
    required this.closingTime,
    required this.latitude,
    required this.longitude,
    required this.mapPosition,
    required this.mapIcon,
    this.isOpen = true,
    this.isVerified = true,
    this.image = 'assets/images/garage.jpg',
    this.note,
  });

  final String id;
  final String name;
  final String shortName;
  final Set<ShopType> types;
  final double rating;
  final int reviewCount;
  final double distanceKm;
  final String address;
  final String phone;
  final String closingTime;
  final double latitude;
  final double longitude;

  /// Normalized (0–1) position on the static map illustration.
  final Offset mapPosition;
  final IconData mapIcon;
  final bool isOpen;
  final bool isVerified;
  final String image;
  final String? note;

  String get typeLabel {
    final hasBike = types.contains(ShopType.motorcycleRepair);
    final hasCar = types.contains(ShopType.carGarage);
    if (hasBike && hasCar) return 'Motorcycle & Car';
    if (hasBike) return 'Motorcycle';
    if (hasCar) return 'Car';
    return 'Spare Parts';
  }
}
