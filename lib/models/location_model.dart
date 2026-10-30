class LocationModel {
  final String id;
  final String name;
  final String type; // 'Kantor Dinas Sosial', 'Posko Penyaluran', 'Fasilitas Kesehatan'
  final String address;
  final String district;
  final String operatingHours;
  final String phone;
  final double distanceKm;
  final bool isOpen;

  const LocationModel({
    required this.id,
    required this.name,
    required this.type,
    required this.address,
    required this.district,
    required this.operatingHours,
    required this.phone,
    required this.distanceKm,
    this.isOpen = true,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'address': address,
        'district': district,
        'operatingHours': operatingHours,
        'phone': phone,
        'distanceKm': distanceKm,
        'isOpen': isOpen,
      };

  factory LocationModel.fromJson(Map<String, dynamic> json) => LocationModel(
        id: json['id'] as String,
        name: json['name'] as String,
        type: json['type'] as String,
        address: json['address'] as String,
        district: json['district'] as String,
        operatingHours: json['operatingHours'] as String,
        phone: json['phone'] as String,
        distanceKm: (json['distanceKm'] as num).toDouble(),
        isOpen: json['isOpen'] as bool? ?? true,
      );
}
