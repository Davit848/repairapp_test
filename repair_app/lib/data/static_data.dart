import 'package:flutter/material.dart';
import 'package:latlong2/latlong.dart';

import 'models/mechanic_service.dart';
import 'models/owner_profile.dart';
import 'models/shop.dart';
import 'models/spare_part.dart';

export 'models/mechanic_service.dart';
export 'models/owner_profile.dart';
export 'models/shop.dart';
export 'models/spare_part.dart';

/// Static demo dataset for the Phnom Penh pilot.
///
/// This is the single seam to replace with the Laravel REST API later —
/// screens only read from here (or from controllers seeded from here).
abstract final class StaticData {
  static const hotline = '1800 REPAIR';
  static const currentLocation = 'St. 271, Phnom Penh';

  /// Demo GPS fix for the motorist until live location is wired in.
  static const userLocation = LatLng(11.5478, 104.9122);

  // ---------------------------------------------------------------- Shops

  static const abcGarage = Shop(
    id: 'abc',
    name: 'ABC Motor Shop & Garage',
    shortName: 'ABC Garage',
    types: {ShopType.motorcycleRepair, ShopType.carGarage, ShopType.partsStore},
    rating: 4.8,
    reviewCount: 128,
    distanceKm: 2.5,
    address: 'No. 45, Street 182, Sangkat Teuk Laak II, Phnom Penh',
    phone: '012 345 678',
    closingTime: '8:00 PM',
    latitude: 11.5564,
    longitude: 104.9282,
    mapIcon: Icons.handyman,
    note: 'Free quote on diagnostic',
  );

  static const kiriromAuto = Shop(
    id: 'kirirom',
    name: 'Kirirom Auto Specialists',
    shortName: 'Kirirom Auto',
    types: {ShopType.carGarage, ShopType.partsStore},
    rating: 4.7,
    reviewCount: 89,
    distanceKm: 3.8,
    address: 'No. 12, Mao Tse Toung Blvd, Boeng Keng Kang, Phnom Penh',
    phone: '015 882 190',
    closingTime: '6:30 PM',
    latitude: 11.5489,
    longitude: 104.9214,
    mapIcon: Icons.car_repair,
  );

  static const revvedUp = Shop(
    id: 'revved',
    name: 'Revved Up Mobile Techs',
    shortName: 'Revved Up',
    types: {ShopType.motorcycleRepair, ShopType.partsStore},
    rating: 4.9,
    reviewCount: 340,
    distanceKm: 1.2,
    address: 'No. 88, Street 294, Boeng Keng Kang I, Phnom Penh',
    phone: '077 410 229',
    closingTime: '9:00 PM',
    latitude: 11.5532,
    longitude: 104.9249,
    mapIcon: Icons.two_wheeler,
    note: 'Mobile rescue within 15 km',
  );

  static const expressFix = Shop(
    id: 'express',
    name: 'Express Fix Quick Rescue',
    shortName: 'Express Fix',
    types: {ShopType.motorcycleRepair, ShopType.carGarage},
    rating: 4.8,
    reviewCount: 215,
    distanceKm: 0.8,
    address: 'No. 3, Street 432, Tuol Tom Poung, Phnom Penh',
    phone: '096 700 115',
    closingTime: '24/7',
    latitude: 11.5431,
    longitude: 104.9198,
    mapIcon: Icons.car_crash_outlined,
    note: '24/7 roadside dispatch',
  );

  static const shops = [abcGarage, kiriromAuto, revvedUp, expressFix];

  // ---------------------------------------------------------------- Parts

  static const parts = [
    SparePart(
      id: 'p-brake',
      name: 'Ceramic Brake Pad Set',
      category: PartCategory.brakePads,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Honda Click 125 / Scoopy',
      price: 25,
      priceNote: 'Fixed',
      stock: 10,
      shop: abcGarage,
      image: 'assets/images/part_brake_pads.jpg',
      description: 'Low-dust ceramic compound with copper backing plate and dual clips.',
    ),
    SparePart(
      id: 'p-oil',
      name: 'Fully Synthetic 10W-40 4T (1L)',
      category: PartCategory.engineOil,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Universal 4-Stroke',
      price: 12.5,
      priceNote: 'Per bottle',
      stock: 24,
      shop: revvedUp,
      image: 'assets/images/part_engine_oil.jpg',
      description: 'JASO MA2 certified full synthetic blend for wet-clutch motorcycles.',
    ),
    SparePart(
      id: 'p-agm',
      name: 'High-Performance AGM 12V',
      category: PartCategory.batteries,
      vehicleType: VehicleType.car,
      fitment: 'Toyota Prius & Vios',
      price: 68,
      priceNote: '1Y Wrnty',
      stock: 5,
      shop: kiriromAuto,
      image: 'assets/images/part_battery_agm.jpg',
      description: 'Sealed AGM battery with high cold-cranking amps and 1-year warranty.',
    ),
    SparePart(
      id: 'p-filter',
      name: 'OEM Air Filter Element',
      category: PartCategory.filters,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Yamaha Exciter 150',
      price: 8,
      priceNote: 'Genuine',
      stock: 15,
      shop: abcGarage,
      image: 'assets/images/part_air_filter.jpg',
      description: 'Genuine pleated intake filter with sealed rubber frame.',
    ),
    SparePart(
      id: 'p-spark',
      name: 'Iridium Spark Plug CR8EIX',
      category: PartCategory.sparkPlugs,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Honda / Yamaha',
      price: 14,
      priceNote: 'NGK Orig',
      stock: 30,
      shop: expressFix,
      image: 'assets/images/part_spark_plug.jpg',
      description: 'Laser-welded iridium tip for sharper ignition and longer service life.',
    ),
    SparePart(
      id: 'p-tire',
      name: 'Tubeless 90/90-14 Tire',
      category: PartCategory.tires,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Honda PCX / Vario',
      price: 32,
      priceNote: 'City Grip',
      stock: 8,
      shop: revvedUp,
      image: 'assets/images/part_tire.jpg',
      description: 'Wet-grip city tread compound, tubeless ready.',
    ),
  ];

  /// Placeholder photo for newly created listings.
  static const categoryImages = {
    PartCategory.brakePads: 'assets/images/part_brake_pads.jpg',
    PartCategory.engineOil: 'assets/images/part_engine_oil.jpg',
    PartCategory.filters: 'assets/images/part_air_filter.jpg',
    PartCategory.batteries: 'assets/images/part_battery_7ah.jpg',
    PartCategory.tires: 'assets/images/part_tire.jpg',
    PartCategory.sparkPlugs: 'assets/images/part_spark_plug.jpg',
  };

  /// Inventory owned by the signed-in shop (Manage tab).
  static const ownerInventory = [
    SparePart(
      id: 'm-brake',
      name: 'Ceramic Brake Pad Set',
      category: PartCategory.brakePads,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Honda Click 125 / Scoopy',
      price: 25,
      priceNote: 'Fixed',
      stock: 10,
      shop: abcGarage,
      image: 'assets/images/part_brake_pads.jpg',
    ),
    SparePart(
      id: 'm-oil',
      name: 'Fully Synthetic 10W-40 4T Oil',
      category: PartCategory.engineOil,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Universal 4-Stroke',
      price: 12.5,
      priceNote: 'Per bottle',
      stock: 24,
      shop: abcGarage,
      image: 'assets/images/part_engine_oil.jpg',
    ),
    SparePart(
      id: 'm-filter',
      name: 'OEM Air Filter Element',
      category: PartCategory.filters,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Yamaha Exciter 150',
      price: 8,
      priceNote: 'Genuine',
      stock: 15,
      shop: abcGarage,
      image: 'assets/images/part_air_filter.jpg',
    ),
    SparePart(
      id: 'm-battery',
      name: 'Heavy-Duty 12V 7Ah Battery',
      category: PartCategory.batteries,
      vehicleType: VehicleType.motorcycle,
      fitment: 'Universal scooters',
      price: 35,
      priceNote: 'Fixed',
      stock: 3,
      shop: abcGarage,
      image: 'assets/images/part_battery_7ah.jpg',
    ),
  ];

  // ------------------------------------------------------------- Services

  static const marketplaceServices = [
    MechanicService(
      id: 's-oil',
      title: 'Full Synthetic Engine Oil Change & 15-Point Safety Check',
      category: ServiceCategory.maintenance,
      delivery: ServiceDelivery.both,
      pricingModel: PricingModel.fixed,
      price: 15,
      estimatedMinutes: 30,
      shop: abcGarage,
      image: 'assets/images/svc_oil_change.jpg',
      priceCaption: 'All-inclusive',
      priceSuffix: 'labor+fluids',
      jobsLabel: '128 jobs',
      included: [
        'Includes high-grade Motul/Shell synthetic blend',
        'Oil filter replacement & drive-chain lubrication',
        'Brake pads tension & tire pressure diagnostic',
      ],
    ),
    MechanicService(
      id: 's-flat',
      title: 'Emergency Roadside Flat Tire & Puncture Repair',
      category: ServiceCategory.tires,
      delivery: ServiceDelivery.mobileRescue,
      pricingModel: PricingModel.baseCallout,
      price: 8,
      estimatedMinutes: 15,
      shop: revvedUp,
      image: 'assets/images/svc_flat_tire.jpg',
      priceCaption: 'Fixed standard',
      priceSuffix: 'trip included',
      jobsLabel: '340+ rescues',
      included: [
        'Tubeless plug patch or heavy-duty inner tube swap',
        'Digital PSI calibration & valve core inspection',
        'On-the-spot mobile compressor air top-up',
      ],
    ),
    MechanicService(
      id: 's-brake',
      title: 'Complete Brake System Overhaul & Caliper Service',
      category: ServiceCategory.brakes,
      delivery: ServiceDelivery.inShop,
      pricingModel: PricingModel.laborRate,
      price: 35,
      estimatedMinutes: 90,
      shop: kiriromAuto,
      image: 'assets/images/svc_brakes.jpg',
      priceCaption: 'Base overhaul',
      priceSuffix: 'parts excl.',
      jobsLabel: '89 reviews',
      included: [
        'Full caliper degrease, piston seals check & relube',
        'Ceramic pad installation & disc resurfacing labor',
        'DOT4 fluid complete flush & bubble purge',
      ],
    ),
    MechanicService(
      id: 's-battery',
      title: 'On-Site 12V Battery Jumpstart & Health Test',
      category: ServiceCategory.electrical,
      delivery: ServiceDelivery.mobileRescue,
      pricingModel: PricingModel.baseCallout,
      price: 5,
      estimatedMinutes: 10,
      shop: expressFix,
      image: 'assets/images/svc_battery.jpg',
      priceCaption: 'Free if replaced',
      priceSuffix: 'service fee',
      jobsLabel: '215 tests',
      included: [
        'High-output capacitor booster pack jumpstart',
        'Alternator charging voltage & CCA health printout',
        'Fee fully waived if you purchase a replacement battery',
      ],
    ),
  ];

  /// Labor catalog owned by the signed-in shop (Manage tab).
  static const ownerServices = [
    MechanicService(
      id: 'o-oil',
      title: 'Full Synthetic Oil Change',
      category: ServiceCategory.maintenance,
      delivery: ServiceDelivery.both,
      pricingModel: PricingModel.fixed,
      price: 15,
      estimatedMinutes: 30,
      shop: abcGarage,
    ),
    MechanicService(
      id: 'o-brake',
      title: 'Brake Pad Replacement',
      category: ServiceCategory.brakes,
      delivery: ServiceDelivery.inShop,
      pricingModel: PricingModel.laborRate,
      price: 10,
      estimatedMinutes: 45,
      shop: abcGarage,
    ),
    MechanicService(
      id: 'o-rescue',
      title: 'Emergency Bike / Scooter Rescue',
      category: ServiceCategory.tires,
      delivery: ServiceDelivery.mobileRescue,
      pricingModel: PricingModel.baseCallout,
      price: 18,
      estimatedMinutes: 20,
      shop: abcGarage,
    ),
    MechanicService(
      id: 'o-obd',
      title: 'Full OBD-II Diagnostic Scan',
      category: ServiceCategory.diagnostics,
      delivery: ServiceDelivery.inShop,
      pricingModel: PricingModel.diagnostic,
      price: 20,
      estimatedMinutes: 25,
      shop: abcGarage,
      isActive: false,
    ),
  ];

  // -------------------------------------------------------------- Profile

  static const owner = OwnerProfile(
    name: 'Davit',
    role: 'Verified Shop Owner & Mechanic',
    ownerCode: '#KH-PP-0982',
    email: 'davit.garage@gmail.com',
    avatar: 'assets/images/avatar.jpg',
    memberSince: 'Oct 2023',
    workingHours: 'Mon-Sat 07:30 - 18:30',
    shop: abcGarage,
    stats: OwnerStats(productsListed: 18, mapViewsToday: 142, inquiries: 19, jobsThisWeek: 28, laborRevenue: 420),
  );
}
