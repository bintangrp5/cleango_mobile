import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';

class OrderHistoryController extends GetxController {
  final isLoading = true.obs;
  final orders = <OrderModel>[].obs;

  @override
  void onInit() {
    super.onInit();
    fetchOrderHistory();
  }

  Future<void> fetchOrderHistory() async {
    isLoading.value = true;
    final authService = Get.find<AuthService>();
    final user = authService.currentUser.value;

    if (user == null) {
      Get.snackbar('Error', 'Silakan login terlebih dahulu');
      isLoading.value = false;
      return;
    }

    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      final response = await GetConnect().get('$baseUrl/orders/user/${user.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        // The backend already returns sorted by created_at desc.
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        Get.snackbar('Error', 'Gagal memuat riwayat pesanan: ${response.statusText}');
      }
    } catch (e) {
      Get.snackbar('Error', 'Kesalahan jaringan saat memuat riwayat pesanan');
    } finally {
      isLoading.value = false;
    }
  }
}
