import 'package:get/get.dart';
import 'package:dio/dio.dart';
import '../../../data/services/auth_service.dart';
import '../../../data/models/order_model.dart';
import '../../../utils/snackbar_util.dart';

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
      final response = await authService.dio.get('/orders/user/${user.id}');

      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        if (data.isNotEmpty) {
          // Data disortir DESC dari backend, jadi index 0 adalah yang terbaru
          order.value = OrderModel.fromJson(data.first); 
          _updateStepFromStatus(order.value!.status);
        }
      }
    } on DioException catch (e) {
      AppSnackbar.show('Error', 'Gagal memuat pesanan: ${e.message}');
    } catch (e) {
      AppSnackbar.show('Error', 'Kesalahan sistem: $e');
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
        currentStep.value = 1;
        break;
      case 'Diproses':
        currentStep.value = 2;
        break;
      case 'Diantar':
        currentStep.value = 3;
        break;
      case 'Selesai':
        currentStep.value = 4;
        break;
      default:
        currentStep.value = 0;
    }
  }

}
