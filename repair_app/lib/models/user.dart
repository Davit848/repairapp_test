import 'shop.dart';

class User {
  final int id;
  final String name;
  final String email;
  final String phone;
  final String? profilePhoto;
  final Shop? shop;

  User({
    required this.id,
    required this.name,
    required this.email,
    required this.phone,
    this.profilePhoto,
    this.shop,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      email: json['email'],
      phone: json['phone'] ?? '',
      profilePhoto: json['profile_photo'],
      shop: json['shop'] != null ? Shop.fromJson(json['shop']) : null,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'phone': phone,
      'profile_photo': profilePhoto,
    };
  }
}