class OrderItemModel {
  final String id;
  final String serviceName;
  final double pricePerKg;
  final double weightKg;
  final double subtotal;

  OrderItemModel({
    required this.id,
    required this.serviceName,
    required this.pricePerKg,
    required this.weightKg,
    required this.subtotal,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      id: json['id'],
      serviceName: json['service_name'] ?? 'Layanan',
      pricePerKg: (json['price_per_kg'] as num).toDouble(),
      weightKg: (json['weight_kg'] as num).toDouble(),
      subtotal: (json['subtotal'] as num).toDouble(),
    );
  }
}

class OrderModel {
  final String id;
  final String orderNumber;
  final String customerName;
  final String phoneNumber;
  final String address;
  final double totalPrice;
  final String status;
  final DateTime createdAt;
  final List<OrderItemModel> items;

  OrderModel({
    required this.id,
    required this.orderNumber,
    required this.customerName,
    required this.phoneNumber,
    required this.address,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
    required this.items,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    return OrderModel(
      id: json['id'],
      orderNumber: json['order_number'],
      customerName: json['customer_name'] ?? 'Pelanggan',
      phoneNumber: json['phone_number'] ?? '-',
      address: json['address'] ?? '-',
      totalPrice: (json['total_price'] as num?)?.toDouble() ?? 0.0,
      status: json['status'] ?? 'Baru',
      createdAt: json['created_at'] != null ? DateTime.parse(json['created_at']) : DateTime.now(),
      items: (json['order_items'] as List<dynamic>?)
              ?.map((e) => OrderItemModel.fromJson(e))
              .toList() ??
          [],
    );
  }
}
