class ServiceModel {
  final String id;
  final String name;
  final String? description;
  final double pricePerKg;
  final String estimatedDuration;
  final String? imageUrl;
  final bool isActive;
  final String? iconName;

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerKg,
    required this.estimatedDuration,
    this.imageUrl,
    required this.isActive,
    this.iconName,
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Layanan Tanpa Nama',
      description: json['description']?.toString(),
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      estimatedDuration: json['estimated_duration']?.toString() ?? 'Tergantung Antrean',
      imageUrl: json['image_url']?.toString(),
      isActive: json['is_active'] ?? true,
      iconName: json['icon_name']?.toString(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'price_per_kg': pricePerKg,
      'estimated_duration': estimatedDuration,
      'image_url': imageUrl,
      'is_active': isActive,
      'icon_name': iconName,
    };
  }
}
