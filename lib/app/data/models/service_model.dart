class ServiceModel {
  final String id;
  final String name;
  final String? description;
  final double pricePerKg;
  final String estimatedDuration;
  final String? imageUrl;
  final bool isActive;
  final String? iconName;
  final String category;

  String get displayImageUrl {
    if (imageUrl != null && imageUrl!.trim().isNotEmpty) {
      return imageUrl!;
    }
    
    final nameLower = name.toLowerCase();
    if (nameLower.contains('sepatu')) {
      return 'https://images.unsplash.com/photo-1600185365926-3a2ce3cdb9eb?w=500&q=80'; // sepatu
    } else if (nameLower.contains('karpet') || nameLower.contains('ambal')) {
      return 'https://images.unsplash.com/photo-1558904541-efa843a96f09?w=500&q=80'; // karpet
    } else if (nameLower.contains('selimut') || nameLower.contains('bedcover')) {
      return 'https://images.unsplash.com/photo-1522771739844-6a9f6d5f14af?w=500&q=80'; // selimut
    } else if (nameLower.contains('setrika')) {
      return 'https://images.unsplash.com/photo-1517677208171-0bc6725a3e60?w=500&q=80'; // setrika
    }
    // Default keranjang laundry
    return 'https://images.unsplash.com/photo-1545173168-9f1947eebb7f?w=500&q=80';
  }

  ServiceModel({
    required this.id,
    required this.name,
    this.description,
    required this.pricePerKg,
    required this.estimatedDuration,
    this.imageUrl,
    required this.isActive,
    this.iconName,
    this.category = 'Reguler',
  });

  factory ServiceModel.fromJson(Map<String, dynamic> json) {
    return ServiceModel(
      id: json['id']?.toString() ?? '',
      name: json['name']?.toString() ?? 'Layanan Tanpa Nama',
      description: json['description']?.toString(),
      pricePerKg: (json['price_per_kg'] as num?)?.toDouble() ?? 0.0,
      estimatedDuration:
          json['estimated_duration']?.toString() ?? 'Tergantung Antrean',
      imageUrl: json['image_url']?.toString(),
      isActive: json['is_active'] ?? true,
      iconName: json['icon_name']?.toString(),
      category: json['category']?.toString() ?? 'Reguler',
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
      'category': category,
    };
  }
}
