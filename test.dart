import 'lib/app/data/models/order_model.dart';
void main() {
  final json = { 'id': '51bedca1-1af7-4b83-bdf1-eade6ce99228', 'order_number': 'ORD-20260731-0004', 'user_id': '4be530ac-28c7-4c1e-9dd8-476752240c39', 'customer_name': 'Bintang Rp', 'phone_number': '088866663333', 'address': 'Gg. Kantil Sari', 'latitude': -7.0661426, 'longitude': 110.4106803, 'total_price': 40000.00, 'status': 'Menunggu Penjemputan', 'payment_method': 'COD', 'payment_status': 'Belum Dibayar', 'created_at': '2026-07-31T20:16:46.425558Z', 'order_items': [{'id': 'fed9766b-5318-4d44-bfcc-adc287249602', 'order_id': '51bedca1-1af7-4b83-bdf1-eade6ce99228', 'service_id': '7dfc948c-915b-452d-9c0e-a74a2250c341', 'service_name': 'Setrika Saja', 'price_per_kg': 5000.00, 'weight_kg': 8.00, 'subtotal': 40000.00, 'created_at': '2026-07-31T20:16:46.425558Z'}] };
  try {
    final order = OrderModel.fromJson(json);
    print('Success: ' + order.id);
  } catch (e, stack) {
    print('Error: \ \n');
  }
}