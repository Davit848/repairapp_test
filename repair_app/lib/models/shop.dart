class Shop {
  final int id;
  final int userId;
  final String name;
  final String phone;
  final String? description;
  final double latitude;
  final double longitude;
  final String address;
  final String? image;

  Shop({
    required this.id,
    required this.userId,
    required this.name,
    required this.phone,
    this.description,
    required this.latitude,
    required this.longitude,
    required this.address,
    this.image,
  });

  factory Shop.fromJson(Map<String, dynamic> json) {
    return Shop(
      id: json['id'],
      userId: json['user_id'],
      name: json['name'],
      phone: json['phone'],
      description: json['description'],
      latitude: double.parse(json['latitude'].toString()),
      longitude: double.parse(json['longitude'].toString()),
      address: json['address'],
      image: json['image'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'phone': phone,
      'description': description,
      'latitude': latitude,
      'longitude': longitude,
      'address': address,
      'image': image,
    };
  }
}