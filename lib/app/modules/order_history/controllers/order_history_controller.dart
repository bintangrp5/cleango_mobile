import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/models/order_model.dart';
import '../../../data/services/auth_service.dart';
import '../../../utils/snackbar_util.dart';

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
      AppSnackbar.show('Error', 'Silakan login terlebih dahulu');
      isLoading.value = false;
      return;
    }

    try {
      final response = await authService.dio.get('/orders/user/${user.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        // The backend already returns sorted by created_at desc.
        orders.value = data.map((json) => OrderModel.fromJson(json)).toList();
      } else {
        AppSnackbar.show('Error', 'Gagal memuat riwayat pesanan: ${response.statusMessage}');
      }
    } catch (e) {
      AppSnackbar.show('Error', 'Kesalahan jaringan saat memuat riwayat pesanan');
    } finally {
      isLoading.value = false;
    }
  }
}
