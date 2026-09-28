import 'shop.dart';

class OwnerProfile {
  const OwnerProfile({
    required this.name,
    required this.role,
    required this.ownerCode,
    required this.email,
    required this.avatar,
    required this.memberSince,
    required this.workingHours,
    required this.shop,
    required this.stats,
  });

  final String name;
  final String role;
  final String ownerCode;
  final String email;
  final String avatar;
  final String memberSince;
  final String workingHours;
  final Shop shop;
  final OwnerStats stats;
}

/// Dashboard telemetry for the provider portal.
class OwnerStats {
  const OwnerStats({
    required this.productsListed,
    required this.mapViewsToday,
    required this.inquiries,
    required this.jobsThisWeek,
    required this.laborRevenue,
  });

  final int productsListed;
  final int mapViewsToday;
  final int inquiries;
  final int jobsThisWeek;
  final double laborRevenue;
}
