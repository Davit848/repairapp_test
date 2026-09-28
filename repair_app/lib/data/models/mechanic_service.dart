import 'package:flutter/material.dart';

import 'shop.dart';

enum ServiceDelivery {
  inShop('In-Shop', 'Workshop Only', Icons.warehouse_outlined),
  mobileRescue('Mobile Rescue', 'Mobile Dispatch', Icons.moped_outlined),
  both('In-Shop & On-Site', 'Garage or On-Site', Icons.garage_outlined);

  const ServiceDelivery(this.label, this.marketLabel, this.icon);

  /// Label used in the provider portal.
  final String label;

  /// Label used on the motorist-facing marketplace.
  final String marketLabel;
  final IconData icon;

  bool get isMobile => this != inShop;
  bool get isInShop => this != mobileRescue;
}

enum PricingModel {
  fixed('Fixed Fee'),
  laborRate('Labor Rate'),
  baseCallout('Base Callout'),
  diagnostic('Diagnostics');

  const PricingModel(this.label);

  final String label;
}

enum ServiceCategory {
  maintenance('Periodic Maintenance', Icons.oil_barrel_outlined),
  engine('Engine & Fuel', Icons.settings_outlined),
  brakes('Brakes', Icons.disc_full_outlined),
  tires('Tires & Wheels', Icons.tire_repair),
  electrical('Electrical', Icons.electric_bolt),
  diagnostics('Diagnostics', Icons.terminal);

  const ServiceCategory(this.label, this.icon);

  final String label;
  final IconData icon;
}

class MechanicService {
  const MechanicService({
    required this.id,
    required this.title,
    required this.category,
    required this.delivery,
    required this.pricingModel,
    required this.price,
    required this.estimatedMinutes,
    required this.shop,
    this.included = const [],
    this.isActive = true,
    this.image,
    this.priceCaption,
    this.priceSuffix,
    this.jobsLabel,
  });

  final String id;
  final String title;
  final ServiceCategory category;
  final ServiceDelivery delivery;
  final PricingModel pricingModel;
  final double price;
  final int estimatedMinutes;
  final Shop shop;
  final List<String> included;
  final bool isActive;
  final String? image;

  /// Marketplace-only copy, e.g. "ALL-INCLUSIVE" / "labor+fluids" / "128 jobs".
  final String? priceCaption;
  final String? priceSuffix;
  final String? jobsLabel;

  MechanicService copyWith({bool? isActive}) {
    return MechanicService(
      id: id,
      title: title,
      category: category,
      delivery: delivery,
      pricingModel: pricingModel,
      price: price,
      estimatedMinutes: estimatedMinutes,
      shop: shop,
      included: included,
      isActive: isActive ?? this.isActive,
      image: image,
      priceCaption: priceCaption,
      priceSuffix: priceSuffix,
      jobsLabel: jobsLabel,
    );
  }
}
