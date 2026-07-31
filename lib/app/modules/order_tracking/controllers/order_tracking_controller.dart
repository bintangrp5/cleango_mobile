import 'package:get/get.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';

class OrderTrackingController extends GetxController {
  final authService = Get.find<AuthService>();
  final isLoading = true.obs;
  final order = Rx<OrderModel?>(null);
  
  final currentStep = 0.obs;

  @override
  void onInit() {
    super.onInit();
    fetchLatestOrder();
  }

  Future<void> fetchLatestOrder() async {
    isLoading.value = true;
    final user = authService.currentUser.value;

    if (user == null) {
      isLoading.value = false;
      return;
    }

    try {
      final baseUrl = dotenv.env['BACKEND_API_URL'] ?? 'http://10.0.2.2:8000/api/v1';
      final response = await GetConnect().get('$baseUrl/orders/user/${user.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.body;
        if (data.isNotEmpty) {
          // Ambil pesanan terbaru (index 0 jika tersortir, atau cari yg paling baru)
          order.value = OrderModel.fromJson(data.last); 
          _updateStepFromStatus(order.value!.status);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Gagal memuat pesanan');
    } finally {
      isLoading.value = false;
    }
  }

  void _updateStepFromStatus(String status) {
    switch (status) {
      case 'Menunggu Penjemputan':
        currentStep.value = 0;
        break;
      case 'Dijemput':
      case 'Diproses':
        currentStep.value = 1;
        break;
      case 'Diantar':
        currentStep.value = 2;
        break;
      case 'Selesai':
        currentStep.value = 3;
        break;
      default:
        currentStep.value = 0;
    }
  }

}
